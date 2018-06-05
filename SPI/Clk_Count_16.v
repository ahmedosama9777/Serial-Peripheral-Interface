

module Clk_Counter_16
#(parameter VAL = 15)
(
input clk,
input Reset, 
input Count_Enable,
input [1:0] SelectMode,
output integer Count
);

always @(posedge clk)
begin
     if(SelectMode == 0 || SelectMode == 3) begin
		if(Count_Enable == 1) begin
	  		Count = Count + 1;
		end
		else begin
			Count = 0;
		end
		if(Count > VAL) begin
			Count = 0;
		end 
     end
end  

always @(negedge clk,posedge Reset)
begin
     if (Reset == 1) begin
		Count = 0;
     end
     else if(SelectMode == 1 || SelectMode == 2) begin
		if(Count_Enable == 1) begin
	  		Count = Count + 1;
		end
		else begin
			Count = 0;
		end
		if(Count > VAL) begin
			Count = 0;
		end 
     end
end   
endmodule
