module instruction_fetch_datapath(
  input clk, 
  input reset, 
  output reg [31:0] instruction
);
  wire [63:0] PC_in; 
  wire [63:0] PC_out; 
  reg [63:0] PC_next;
  
  initial 
    begin
      PC_next = 4; 
    end
  
  adder Add(.a(PC_out), .b(64'd4), .out(PC_in));

  
  Program_Counter PC(.clk(clk), .reset(reset), .PC_in(PC_in), .PC_out(PC_out)) ; 
  
  
  Instruction_Memory Inst_Addr(.inst_address(PC_out), .instruction(instruction));
  
  
endmodule 
