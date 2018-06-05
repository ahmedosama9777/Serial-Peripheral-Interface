

module Master(
input clk,
input RST,
input [15:0] AddressSelect, //10-bits 1024.
input [2:0] SelectSlave, // 000 no sending.
input [1:0] SelectMode,
input MISO,
output wire SCK,
output MOSI,
output SS0,
output SS1,
output SS2,
output SS3
);

reg [15:0] Master_Data = 16'hAAAA;//
wire [15:0] Data_Transfered; //

//localparam PERIOD = 10;//
reg Shift_Enable = 0;//
integer Addresses_Issued = 0; //
reg Count_Enable = 0;//
reg Count_Enable_16 = 0;
reg Gated_Clk = 1;//
wire SCK_IDLE;
wire CLK_Type;

reg Flag_Dec = 0;
integer Clk_Count;//
integer Count_2Bytes;//
reg [1:0] StateReg = 0; //intial.
reg [1:0] NextStateReg;//
parameter IDLE =  2'd0,Send_Address_Listen = 2'd1,Recieve_Data_Only = 2'd2 ;//

always @(posedge clk, posedge RST)
begin
     if(RST == 1) begin
     		StateReg <= IDLE;
     end
     else begin
     		StateReg <= NextStateReg;
     end
end  

Clk_Counter Count(Gated_Clk,RST,Count_Enable,SelectMode,Clk_Count);
Clk_Counter_16 Count_16(Gated_Clk,RST,Count_Enable_16,SelectMode,Count_2Bytes);
Shift_Reg Reg (Gated_Clk,RST, 2'b10,SelectMode,MISO,Data_Transfered); // 2'b01 bits for control (shift right) could be internally removed left if needed.
Parallel_In_Serial_Out Reg2 (Gated_Clk,RST,Shift_Enable,SelectMode,AddressSelect,MOSI);

always @(StateReg,SelectSlave,Clk_Count,Flag_Dec)
begin
     case(StateReg) 
      IDLE :  begin
		 Shift_Enable = 0;
		 Count_Enable = 0;

		 Count_Enable_16 = 0;
		 if (SelectSlave ==  0) begin
			NextStateReg <= IDLE;	
		 end
		 else begin
			NextStateReg <= Send_Address_Listen;
		 end
	      end
 Send_Address_Listen :  begin 

		   Shift_Enable = 1;
	           Count_Enable = 1;

		 if(Clk_Count == 15) begin 
			Count_Enable_16 = 1;
			 if(SelectSlave == 0) begin // check here for Addresses_Issued = Addresses_Issued - 1;	
				NextStateReg <= Recieve_Data_Only;
				//Addresses_Issued = Addresses_Issued - 1;
			 end
		 end
	      end
	Recieve_Data_Only :  begin 

		        Count_Enable = 0;
			Shift_Enable = 0;
			if(SelectSlave != 0) begin
				NextStateReg <= Send_Address_Listen;
		 	end
		 	else if(Addresses_Issued == 0) begin
				NextStateReg <= IDLE;
		 	end
		end
 	default : begin
		      NextStateReg <= IDLE; // Default state.		
	     end
	endcase
end

//Questions:
// lw ana fadelt meda5el al address we menzel al select hay3ood yeb3at al addresses ?.
// lazem a handle ano may3'yersh al address 2la ba3d 8 clock cycles 3shan may3mlesh overwrite.
always @(Count_2Bytes,Data_Transfered)
begin
	if(Count_2Bytes == 15) begin
		Master_Data = Data_Transfered;
	end
end

always @(Clk_Count)
begin
	if(Clk_Count == 15) begin 
		   Addresses_Issued = Addresses_Issued + 1;
	end
end

always @(Count_2Bytes)
begin
	 if(Count_2Bytes == 15) begin
	       	   Addresses_Issued = Addresses_Issued - 1;	
	           Flag_Dec = 1;			
	 end
	 else begin
		   Flag_Dec = 0;
	 end
end

assign SCK_IDLE = (SelectMode[1] == 1'b0) ? 1'b0 : (SelectMode[1] == 1'b1) ? 1'b1 : 1'b0;
// inverted clock here ....
always @(clk,StateReg,SCK_IDLE)
begin
if(StateReg == IDLE) begin
	Gated_Clk = SCK_IDLE;
end
else begin
     if(SelectMode == 2) begin
	Gated_Clk = clk;
     end
     else begin
	Gated_Clk = ~clk;
     end
end

end
assign SCK = Gated_Clk;
// Clock Part.
//always # ((PERIOD)/2) clk=~clk ;

TriStateBuffer Tri1 (1,SelectSlave,SS0);
TriStateBuffer Tri2 (2,SelectSlave,SS1);
TriStateBuffer Tri3 (3,SelectSlave,SS2);
TriStateBuffer Tri4 (4,SelectSlave,SS3);

endmodule