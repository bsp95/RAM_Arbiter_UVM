import config_pkg::*;
interface master_if;
// clock and reset
  logic clk;
  logic rst;

  logic req;
  logic grant;
  logic	 wrenable;
  
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] wrdata;
  logic [DATA_WIDTH-1:0] rdata;
// Modports  	
modport DRIVER (
output req,
output addr,
output wrdata,
output wrenable,

input grant,
input rdata,

input clk,
input rst
);

modport MONITOR (
input req,
input grant,
input addr,
input wrdata,
input wrenable,
input rdata,
input clk,
input rst
);
endinterface
