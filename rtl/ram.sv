import config_pkg::*;
module ram_mem
(
    input  logic                  clk,
    input  logic                  rst,
    input  logic                  wrenable,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] wrdata,
    output logic [DATA_WIDTH-1:0] rdata
);

logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

//Preload memory at time 0

initial begin
$readmemh("../rtl/mem_init.hex",mem);
$display("RAM: Memory preloaded from mem_init.hex");
  end


always_ff @(posedge clk) begin

    if (rst)
        rdata <='0;

    else if (wrenable)
        mem[addr] <= wrdata;

    else
        rdata <= mem[addr];

end
endmodule
