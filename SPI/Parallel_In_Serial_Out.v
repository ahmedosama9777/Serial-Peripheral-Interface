

module Parallel_In_Serial_Out
#( parameter Size = 16) // 10-byte shift reg. 
(
input CLK,
input Reset,
input Shift_Enable,
input [1:0] SelectMode,
input [Size-1:0] d,
output q
);

reg [Size-1:0] Shift_Reg = 0; 
reg [Size-1:0] Value_Will_BeShifted = 0;
wire [Size-1:0] Shifted;
wire Zero = 0;

always @(posedge CLK, posedge Reset)
begin
    if(SelectMode == 0 || SelectMode == 3) begin
	     if(Reset == 1) begin
	     	       Shift_Reg <= 0;
	     end
	     else begin
			if (Shift_Enable == 1) begin
	     			Shift_Reg <= Shifted;
			end
	     end
      end
end 

always @(negedge CLK, posedge Reset)
begin
      if(SelectMode == 2 || SelectMode == 1) begin
    	     if(Reset == 1) begin
	     	       Shift_Reg <= 0;
	     end
	     else begin
			if (Shift_Enable == 1) begin
	     			Shift_Reg <= Shifted;
			end
	     end
	end
end 

always @(d) // to make it assign automatically to the value that is going to be shifted without load signal.
begin
	if (Value_Will_BeShifted != d) begin
     		Shift_Reg = d;
		Value_Will_BeShifted = d;
	end
end 

assign Shifted = (Shift_Enable == 1 ) ? {Zero,Shift_Reg[Size-1:1]} : 0;

assign q = (Shift_Enable == 1 ) ? Shift_Reg[0] : 0;

endmodule
