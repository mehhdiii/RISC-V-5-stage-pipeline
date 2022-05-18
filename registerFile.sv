module registerFile(
  input [4:0] rs1, 
  input [4:0] rs2, 
  input [4:0] rd, 
  input [63:0] WriteData, 
  input RegWrite, 
  input clk, 
  input reset, 
  
  output reg [63:0] ReadData1, 
  output reg [63:0] ReadData2

);
  
  reg [63:0] Registers [31:0];
  
  initial
    begin 
      
      for (int i = 0; i<32; i++)
        begin
          Registers[i] = 32-i; 
        end
    end
  
  always @(posedge clk)
    begin
      case (RegWrite)
        1'b1: 
          begin 
            Registers[rd] = WriteData; 
          end
      endcase 
    end
  
  always @(*)
    begin
      
      ReadData1 = Registers[rs1]; 
      ReadData2 = Registers[rs2]; 

      
      if (reset==1)
        begin
          ReadData1 = 0; 
          ReadData2 = 0; 
        end
      
     
    
    end
  
endmodule
