

module TriStateBuffer
#( parameter Size = 10) // 10-byte shift reg
(
input [2:0] Value,
input [2:0] Activate,
output Signal
);
wire High_Imp = 1'bz;
assign Signal = (Activate == Value) ? 0 : High_Imp;

endmodule
