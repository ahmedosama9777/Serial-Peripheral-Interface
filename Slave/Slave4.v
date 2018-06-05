module slave4(
  input reset,
  input ss,
  input sck,
  input cpol,
  input cpoh,
  input MOSI, 
  //input [7:0] Address,
  output MISO 

  );
  
//The slave has 3 states: 
localparam idle=2'b00;
localparam receive=2'b01; 
localparam  send=2'b10;
//////////////////////////////////////////////// 
   
//Generic number of registers that each slave has (Max 256 registers)
integer i;
reg [7:0] SlaveRegister [127:0];
//always @(posedge sck)	//end
 

/////////////////////////////////////////////////////// 
//Mode 0 & 3  
reg [4:0] CountSend1;
wire [4:0] CountSend_next1; 

reg [4:0] CountRecieve1;
wire [4:0] CountRecieve_next1;

reg [15:0] DataRecieve1;
wire  DataRecieve_next1;

reg [1:0] state_reg11; //This toggles between idle & receiving 
wire [1:0] state_next11;

reg [1:0] state_reg12; //This toggles between idle & sending
wire [1:0] state_next12;
////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//Mode 1 & 2
reg [4:0] CountSend2;
wire [4:0] CountSend_next2; 

reg [4:0] CountRecieve2;
wire [4:0] CountRecieve_next2;

reg [15:0] DataRecieve2;
wire  DataRecieve_next2;

reg [1:0] state_reg21; //This toggles between idle & receiving 
wire [1:0] state_next21;

reg [1:0] state_reg22; //This toggles between idle & sending
wire [1:0] state_next22;
/////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//Parameters used in sending 
wire [15:0] ds1;
wire [15:0] ds2; 

wire [15:0] dtosend1;
wire [15:0] dtosend2;

wire MISO1; //Two internal MISO lines for the two modes
wire MISO2;
/////////////////////////////////////////////////////
integer init;

initial 
begin
  for(init=0;init<128;init=init+1)
  begin
    SlaveRegister[init]=init;
end
end


  always @(posedge sck, posedge reset) //Mode 0 & 4
  begin
     if(reset) begin
      state_reg11<=idle;
      state_reg12<=idle;
       CountSend1<=0;
       CountRecieve1<=0;
       DataRecieve2<=16'bz; //High impedance to make sure the other 2 modes will not disturb
     
      
      
   end
     else
       begin
         state_reg11<=state_next11;
         state_reg12<=state_next12;
         CountSend1<=CountSend_next1;
         DataRecieve2[CountRecieve2]<=DataRecieve_next2; //Keeping it with high impedance
         CountRecieve1<=CountRecieve_next1;
        
        
         
       end
 end 
 
 
 
 ///////
  always @(negedge sck, posedge reset) //Mode 2 & 3
  begin
     if(reset) 
       begin
       state_reg21<=idle;
       state_reg22<=idle;
       CountSend2<=0;
       CountRecieve2<=0;
       DataRecieve1<=16'bz; //High impedance to make sure the other 2 modes will not disturb
       end
     
	 else
         begin
         state_reg21<=state_next21;
         state_reg22<=state_next22;
         CountSend2<=CountSend_next2;
         DataRecieve1[CountRecieve1]<=DataRecieve_next1; //Keeping it with high impedance
         CountRecieve2<=CountRecieve_next2;
         end
  end 
 
 

    /////////////////////////////////////////////////////////
   //Assigning the next states of mode 0 & 4
   assign state_next11=(state_reg11==idle & ss==1'b1)?idle: //If the slave wasn't selected (SS=1)
                        (state_reg11==idle & ss==1'b0)?receive: //Slave is selected and will start recieving
                        (state_reg11==receive & CountRecieve1<15)?receive:idle; //Slave still receiving one byte from Master       
                
                    
            
   assign state_next12= (state_reg12==idle & CountRecieve1==16)?send: //After receiving a full address, start sending data
		                    (state_reg12==send & CountRecieve1==16)? send: 
                        (state_reg12==send & CountSend1<16'b00001111)?send:idle;
    

	////////////////////////////////////////////////////////////////////////
   //Assigning the next states of mode 2 & 3  
   assign state_next21= (state_reg21==idle & ss==1'b1)?idle:
                        (state_reg21==idle & ss==1'b0)?receive:
                        (state_reg21==receive & CountRecieve2<15)?receive:idle;                    
                       
   assign state_next22=(state_reg22==idle & CountRecieve2==16)?send:
 			                  (state_reg22==send & CountRecieve2==16)? send:
                        (state_reg22==send & CountSend2<16'b00001111)?send:idle;                       
                       
    //count_next assignement
    assign CountSend_next1=((state_reg12==send & CountSend1<8'b00010000))?CountSend1+1:4'b0000;
    assign CountRecieve_next1=((state_reg11==receive & CountRecieve1<16))?CountRecieve1+1:4'b0;
    
    assign CountSend_next2=(state_reg22==send & CountSend2<8'b00010000)?CountSend2+1:4'b0000;
    assign CountRecieve_next2=((state_reg21==receive & CountRecieve2<16))?CountRecieve2+1:4'b0 ;
    
      
    
    /////////////////////
    
    assign DataRecieve_next1=(state_reg11==receive || (state_reg11==idle & ss==1'b0))?MOSI:DataRecieve1[CountRecieve1];
    assign DataRecieve_next2=(state_reg21==receive || (state_reg21==idle & ss==1'b0))?MOSI:DataRecieve2[CountRecieve2];
    
    
    
                          
  assign ds1=(DataRecieve1[7:0]>=16'b0000000000000000 && DataRecieve1[7:0]<=16'b1111111111111110)?{SlaveRegister[DataRecieve1[7:0]],SlaveRegister[DataRecieve1[7:0]+1'b1]}:ds1;  //El moshkela f el condition dh         
  assign ds2=(DataRecieve2[7:0]>=16'b0000000000000000 && DataRecieve2[7:0]<=16'b1111111111111110)?{SlaveRegister[DataRecieve2[7:0]],SlaveRegister[DataRecieve2[7:0]+1'b1]}:ds2;           

    
  
    assign dtosend1=(CountRecieve1==16)?ds1:dtosend1;
    assign dtosend2=(CountRecieve2==16)?ds2:dtosend2;
    
    
     
     
     
     assign MISO1=(state_reg12==idle)?1'bz: 
                  (state_reg12==send && CountSend1<8'b00010000)?dtosend1[CountSend1]:1'bz;
                  
     assign MISO2=(state_reg22==idle)?1'bz: 
                  (state_reg22==send & CountSend2<8'b00010000)?dtosend2[CountSend2]:1'bz;
  
     assign MISO=((~cpol & ~cpoh))? MISO1:((cpol & cpoh))?MISO1:MISO2;
         
    
endmodule



