`timescale 1ns/1ns
`include "uvm_macros.svh"
import uvm_pkg::*;
import tb_pkg::*;
import config_pkg::*;

module tb_top;

  // ── Clock and Reset ──────────────────────────
  logic clk;
  logic rst;

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst = 1'b1;
    repeat(10) @(posedge clk);
    rst = 1'b0;
  end

  // ── Internal Signals ─────────────────────────
  logic [NUM_MASTERS-1:0] req;
  logic [NUM_MASTERS-1:0] grant;
  logic [ADDR_WIDTH-1:0]  ram_addr;
  logic [DATA_WIDTH-1:0]  ram_wrdata;
  logic                   ram_wrenable;
  logic [DATA_WIDTH-1:0]  ram_rdata;
  logic [NUM_MASTERS-1:0] grant_d;
logic [DATA_WIDTH-1:0] rdata_reg [NUM_MASTERS];

  // ── Intermediate Arrays for MUX ──────────────
  logic [ADDR_WIDTH-1:0]  addr_mux    [NUM_MASTERS];
  logic [DATA_WIDTH-1:0]  wrdata_mux  [NUM_MASTERS];
  logic                   wrenable_mux[NUM_MASTERS];

  // ── Interface Instances ──────────────────────
  master_if m_if[NUM_MASTERS]();
  ram_if    r_if();

  // ── Connect clk/rst to Interfaces ────────────
  generate
    for(genvar i = 0; i < NUM_MASTERS; i++) begin
      assign m_if[i].clk = clk;
      assign m_if[i].rst = rst;
    end
  endgenerate

  assign r_if.clk = clk;
  assign r_if.rst = rst;

  // ── Pack req ──────────────────────────────────
  generate
    for(genvar i = 0; i < NUM_MASTERS; i++) begin
      assign req[i] = m_if[i].req;
    end
  endgenerate

always_ff @(posedge clk or posedge rst) begin
  if (rst)
    grant_d <= '0;
  else
    grant_d <= grant;
end
// use delayed grant for rdata routing
generate
  for(genvar i = 0; i < NUM_MASTERS; i++) begin
    assign m_if[i].rdata = grant_d[i] ? ram_rdata : '0; 
    assign m_if[i].grant = grant[i];
  end
endgenerate  // ── MUX: tap interface signals into logic arrays
  generate
    for(genvar i = 0; i < NUM_MASTERS; i++) begin : gen_mux
      assign addr_mux[i]     = grant[i] ? m_if[i].addr     : '0;
      assign wrdata_mux[i]   = grant[i] ? m_if[i].wrdata   : '0;
      assign wrenable_mux[i] = grant[i] ? m_if[i].wrenable : 1'b0;
    end
  endgenerate

  // ── OR reduce into RAM inputs ─────────────────
  always_comb begin
    ram_addr     = '0;
    ram_wrdata   = '0;
    ram_wrenable = 1'b0;
    for(int i = 0; i < NUM_MASTERS; i++) begin
      ram_addr     |= addr_mux[i];
      ram_wrdata   |= wrdata_mux[i];
      ram_wrenable |= wrenable_mux[i];
    end
  end

  
  // ── DUT Instantiations ────────────────────────
  rr_arbiter u_arbiter (
    .clk   (clk),
    .rst   (rst),
    .req   (req),
    .grant (grant)
  );

  ram_mem u_ram (
    .clk      (clk),
    .rst      (rst),
    .wrenable (ram_wrenable),
    .addr     (ram_addr),
    .wrdata   (ram_wrdata),
    .rdata    (ram_rdata)
  );

  // ── Mirror ram_if ─────────────────────────────
  assign r_if.wrenable = ram_wrenable;
  assign r_if.addr     = ram_addr;
  assign r_if.wrdata   = ram_wrdata;
  assign r_if.rdata    = ram_rdata;

  // ── config_db — manually unrolled ────────────
generate
for(genvar i = 0; i< NUM_MASTERS;i++) 
 initial begin
   uvm_config_db #(virtual master_if)::set(
      null, $sformatf("uvm_test_top.e.m_agent_%0d.*",i), "vif", m_if[i]);
end
endgenerate
initial begin
    uvm_config_db #(virtual ram_if)::set(
      null, "uvm_test_top.e.ram_mon", "ram_vif", r_if);

    run_test("directed_test");
  //  run_test("write_read_test");
  end

endmodule
