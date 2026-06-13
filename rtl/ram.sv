import config_pkg::*;
module ram_mem #(
    parameter ADDR_WIDTH = config_pkg::ADDR_WIDTH,
    parameter DATA_WIDTH = config_pkg::DATA_WIDTH
)(
    input  logic                  clk,
    input  logic                  rst,
    input  logic                  wrenable,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] wrdata,
    output logic [DATA_WIDTH-1:0] rdata
);

logic [DATA_WIDTH-1:0] mem [0:config_pkg::DEPTH-1];

always_ff @(posedge clk) begin

    if (rst)
        rdata <='0;

    else if (wrenable)
        mem[addr] <= wrdata;

    else
        rdata <= mem[addr];

end
endmodule
