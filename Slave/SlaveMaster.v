module SlaveMaster(
  input reset,
  input ss1,
  input ss2,
  input ss3,
  input ss4,
  input sck,
  input cpol,
  input cpoh,
  input MOSI, 
  //input [7:0] Address,
  output MISO 
  );
  
  slave1 s1(reset,ss1,sck,cpol,cpoh,MOSI,MISO);
  slave2 s2(reset,ss2,sck,cpol,cpoh,MOSI,MISO);
  slave3 s3(reset,ss3,sck,cpol,cpoh,MOSI,MISO);
  slave4 s4(reset,ss4,sck,cpol,cpoh,MOSI,MISO);
  
endmodule
