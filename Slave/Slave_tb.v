module Slave_tb();
  reg reset;
  reg ss1;
  reg ss2;
  reg ss3;
  reg ss4;
  reg sck;
  reg cpol;
  reg cpoh;
  reg MOSI;
  //reg [7:0] Address;
  wire MISO;
  
  reg [15:0] data;
  localparam period=10;
  always 
    begin 
      #(period/2) sck=~sck;
    end
    
  
SlaveMaster S(reset,ss1,ss2,ss3,ss4,sck,cpol,cpoh,MOSI,MISO);
	
    initial begin
     

	
	data=16'b0000000000000010; //Address that will be sent from Master to Slave to call data from certain register
	sck=0;
	MOSI=1;
	reset=1'b1;
	cpol=1'b0;
	cpoh=1'b0;	
	ss1=1'b1;
	ss2=1'b1;
	ss3=1'b1;
	ss4=1'b1;
		

	#(period*3.5)
    reset=1'b0;
    ss2=1'b0;

	MOSI=data[0];
	#(period*1)
	MOSI=data[1];
	#(period*1)
	MOSI=data[2];
	#(period*1)
	MOSI=data[3];
	#(period*1)
	MOSI=data[4];
	#(period*1)
	MOSI=data[5];
	#(period*1)
	MOSI=data[6];
	#(period*1)
	MOSI=data[7];
		#(period*1)
	MOSI=data[8];
		#(period*1)
	MOSI=data[9];
		#(period*1)
	MOSI=data[10];
		#(period*1)
	MOSI=data[11];
		#(period*1)
	MOSI=data[12];
		#(period*1)
	MOSI=data[13];
		#(period*1)
	MOSI=data[14];
		#(period*1)
	MOSI=data[15];
	
    ss2=1'b1;
	
	#(period*1)
	MOSI=1;

	

//end of mode 00
	
	#(period*17)
	sck=0;
	reset=1'b1;
	cpol=1'b0;
	cpoh=1'b1;
	data=16'b0000000000011110;

	#(period*3.5)
    reset=1'b0;
    ss2=1'b0;

		MOSI=data[0];
	#(period*1)
	MOSI=data[1];
	#(period*1)
	MOSI=data[2];
	#(period*1)
	MOSI=data[3];
	#(period*1)
	MOSI=data[4];
	#(period*1)
	MOSI=data[5];
	#(period*1)
	MOSI=data[6];
	#(period*1)
	MOSI=data[7];
		#(period*1)
	MOSI=data[8];
		#(period*1)
	MOSI=data[9];
		#(period*1)
	MOSI=data[10];
		#(period*1)
	MOSI=data[11];
		#(period*1)
	MOSI=data[12];
		#(period*1)
	MOSI=data[13];
		#(period*1)
	MOSI=data[14];
		#(period*1)
	MOSI=data[15];
    ss2=1'b1;
	
	#(period*1)
	MOSI=1;

//end of mode 01
	#(period*17)
	reset=1'b1;
	sck=0;
	cpol=1'b1;
	cpoh=1'b0;

	data=16'b00110010;

	#(period*3.5)
    reset=1'b0;
    ss2=1'b0;

		MOSI=data[0];
	#(period*1)
	MOSI=data[1];
	#(period*1)
	MOSI=data[2];
	#(period*1)
	MOSI=data[3];
	#(period*1)
	MOSI=data[4];
	#(period*1)
	MOSI=data[5];
	#(period*1)
	MOSI=data[6];
	#(period*1)
	MOSI=data[7];
		#(period*1)
	MOSI=data[8];
		#(period*1)
	MOSI=data[9];
		#(period*1)
	MOSI=data[10];
		#(period*1)
	MOSI=data[11];
		#(period*1)
	MOSI=data[12];
		#(period*1)
	MOSI=data[13];
		#(period*1)
	MOSI=data[14];
		#(period*1)
	MOSI=data[15];
	
     ss2=1'b1;
	#(period*1)
	MOSI=1;


//end of mode 10
	#(period*17)
	reset=1'b1;
	sck=1;
	cpol=1'b1;
	cpoh=1'b1;

	data=16'h0005;

	#(period*3.5)
        reset=1'b0;
        ss2=1'b0;

		MOSI=data[0];
	#(period*1)
	MOSI=data[1];
	#(period*1)
	MOSI=data[2];
	#(period*1)
	MOSI=data[3];
	#(period*1)
	MOSI=data[4];
	#(period*1)
	MOSI=data[5];
	#(period*1)
	MOSI=data[6];
	#(period*1)
	MOSI=data[7];
		#(period*1)
	MOSI=data[8];
		#(period*1)
	MOSI=data[9];
		#(period*1)
	MOSI=data[10];
		#(period*1)
	MOSI=data[11];
		#(period*1)
	MOSI=data[12];
		#(period*1)
	MOSI=data[13];
		#(period*1)
	MOSI=data[14];
		#(period*1)
	MOSI=data[15];
        ss2=1'b1;
	#(period*1)
	MOSI=1;
      
//end of mode 11

      


	
    end
       initial begin
        $display ("time\t reset\t ss2\t sck\t  cpol\t cpoh\t MOSI\t  MISO");	
        $monitor ("%g\t   %h\t    %h\t %h\t    %h\t  %h\t   %h\t   %h\t", 
  	         $time,reset,ss2,sck,cpol,cpoh,MOSI,MISO);
      
     end
       
  endmodule