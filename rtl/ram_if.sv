import config_pkg::*;
interface ram_if; 

logic clk;
logic rst;
logic valid;
logic wrenable;
logic [ADDR_WIDTH-1:0] addr;
logic [DATA_WIDTH-1:0] wrdata;
logic [DATA_WIDTH-1:0] rdata;

endinterface
