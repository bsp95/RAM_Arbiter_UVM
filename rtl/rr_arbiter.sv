/* Module 	: rr_arbiter
 Description	: Parameterized Round Robin Arbiter
 Features :
 	- One Hot grant
	- Fair arbitration
	- Scalable to N requesers
	- Pointer based implementation
*/
import config_pkg::*;
module rr_arbiter(
input logic clk,
input logic rst,
input logic [NUM_MASTERS-1:0] req,
output logic [NUM_MASTERS-1:0] grant
);
localparam int PTR = $clog2(NUM_MASTERS);
// INTERNAL SIGNALS
logic [PTR-1:0] last_grant;	// last grant 
logic [PTR-1:0] next_grant;	// Next grant
logic grant_found;
integer i;
integer idx;

// Combinational arbitration logic
always_comb begin
grant = '0;
next_grant = last_grant;
grant_found = 1'b0;

for(i=0; i < NUM_MASTERS; i++) begin
idx = (last_grant + 1 + i) % NUM_MASTERS;
if(req[idx] && !grant_found) begin
grant[idx] = 1'b1;
next_grant = idx;
grant_found = 1'b1;
end
end
end

always_ff @(posedge clk or negedge rst) begin
if(rst)
last_grant <= 0;
else if(grant_found) begin 
last_grant  <= next_grant ;
end 
end
endmodule
