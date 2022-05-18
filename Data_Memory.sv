// Code your design here


module Data_Memory(
  input clk, 
  input [63:0] Mem_Addr, 
  input [63:0] Write_Data, 
  input MemWrite, 
  input MemRead, 
  output reg [63:0] Read_Data
  
);
  
  reg [7:0] data_memory [63:0];
  
  initial 
    begin
      data_memory[0] = 8'b10000011;
      data_memory[1] = 8'b00110100;
      data_memory[2] = 8'b00000101;
      data_memory[3] = 8'b00001111;
      data_memory[4] = 8'b10110011;
      data_memory[5] = 8'b10000100;
      data_memory[6] = 8'b10011010;
      data_memory[7] = 8'b00000000;
      data_memory[8] = 8'b10010011;
      data_memory[9] = 8'b10000100;
      data_memory[10] = 8'b00010100;
      data_memory[11] = 8'b00000000;
      data_memory[12] = 8'b00100011;
      data_memory[13] = 8'b00111000;
      data_memory[14] = 8'b10010101;
      data_memory[15] = 8'b00001110;
    end
  
  always@(posedge clk)
    begin 
      if (MemWrite)
        begin 
      data_memory[Mem_Addr] = Write_Data[7:0];
      data_memory[Mem_Addr+1] = Write_Data[15:8];
      data_memory[Mem_Addr+2] = Write_Data[23:16];
      data_memory[Mem_Addr+3] = Write_Data[31:23];
      data_memory[Mem_Addr+4] = Write_Data[39:32];
      data_memory[Mem_Addr+5] = Write_Data[47:40];
      data_memory[Mem_Addr+6] = Write_Data[55:48];
      data_memory[Mem_Addr+7] = Write_Data[63:56];
        end
    end
  
  always@(*)
    begin
      if (MemRead==1)
        begin 
      Read_Data = {data_memory[Mem_Addr+7], data_memory[Mem_Addr+6], data_memory[Mem_Addr+5], data_memory[Mem_Addr+4], data_memory[Mem_Addr+3], data_memory[Mem_Addr+2], data_memory[Mem_Addr+1], data_memory[Mem_Addr] }; 
        end
      
    end
  
endmodule 
