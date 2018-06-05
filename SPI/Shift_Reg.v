


module Shift_Reg
#( parameter Size = 16) // 16-byte shift reg. 
(
input CLK,
input Reset,
input [1:0] Control,
input [1:0] SelectMode,
input d,
output [Size-1:0] q
);

reg [Size-1:0] Shift_Reg; 
wire [Size-1:0] Shifted;

always @(posedge CLK, posedge Reset)
begin
      if(SelectMode == 0 || SelectMode == 3) begin
	     if(Reset == 1) begin
	     		Shift_Reg <= 0;
	     end
	     else begin
	     		Shift_Reg <= Shifted;
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
	     		Shift_Reg <= Shifted;
	     end
      end
end  

assign Shifted = (Control==2'b10) ? {d,Shift_Reg[Size-1:1]} : (Control==2'b01) ? {Shift_Reg[Size-2:0],d} :
(Control==2'b00) ? Shift_Reg : 0;

assign q = Shifted;
endmodule