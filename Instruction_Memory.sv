module Instruction_Memory(
  input [63:0] inst_address, 
  output reg [31:0] instruction
);
  
  reg [7:0] instruction_memory [15:0];
  
  initial 
    begin
      instruction_memory[0] = 8'b10000011;
      instruction_memory[1] = 8'b00110100;
      instruction_memory[2] = 8'b10000101;
      instruction_memory[3] = 8'b00000010;
      instruction_memory[4] = 8'b10110011;
      instruction_memory[5] = 8'b10000100;
      instruction_memory[6] = 8'b10011010;
      instruction_memory[7] = 8'b00000000;
      instruction_memory[8] = 8'b10010011;
      instruction_memory[9] = 8'b10000100;
      instruction_memory[10] = 8'b00010100;
      instruction_memory[11] = 8'b00000000;
      instruction_memory[12] = 8'b00100011;
      instruction_memory[13] = 8'b00110100;
      instruction_memory[14] = 8'b10010101;
      instruction_memory[15] = 8'b00000010;
    end
  
  always@(inst_address)
    begin 
      
      instruction = {instruction_memory[inst_address+3], instruction_memory[inst_address+2], instruction_memory[inst_address+1], instruction_memory[inst_address] }; 
      
    end
  
endmodule 
