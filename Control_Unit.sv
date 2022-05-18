module Control_Unit(
  input [6:0] Opcode,
  
  //addition for ble and bge instruction support
  input [2:0] func, 
  output reg ble, 
  output reg bge, 
  
  output reg Branch, 
  output reg MemRead, 
  output reg MemtoReg, 
  output reg [1:0] ALUOp, 
  output reg MemWrite, 
  output reg ALUSrc, 
  output reg RegWrite
); 
  
  always @(*) 
    begin 
      case (Opcode)
        
        
        7'b0110011: 
          begin 
            ALUSrc = 0; 
            MemtoReg = 0; 
            RegWrite = 1; 
            MemRead = 0; 
            MemWrite = 0; 
            Branch = 0; 
            ALUOp = 2'b10; 
          end 
        
        7'b0000011:  
          begin 
            ALUSrc = 1; 
            MemtoReg = 1; 
            RegWrite = 1; 
            MemRead = 1; 
            MemWrite = 0; 
            Branch = 0; 
            ALUOp = 2'b00; 
          end
        
        7'b0100011: 
          begin 
            ALUSrc = 1; 
//             MemtoReg = 0; 
            RegWrite = 0; 
            MemRead = 0; 
            MemWrite = 1; 
            Branch = 0; 
            ALUOp = 2'b00; 
          end
        
        7'b1100011: 
          begin 
            if (func == 3'b101) //bge
              begin 
                ALUSrc = 0; 
            	MemtoReg = 0; 
                RegWrite = 0; 
                MemRead = 0; 
                MemWrite = 0; 
                Branch = 0; 
                ALUOp = 2'b01; 
              	bge = 1; 
                ble = 0; 
              end
            else if (func == 3'b100) //ble 
              begin 
                ALUSrc = 0; 
            	MemtoReg = 0; 
                RegWrite = 0; 
                MemRead = 0; 
                MemWrite = 0; 
                Branch = 0; 
                ALUOp = 2'b01; 
              	bge = 0; 
                ble = 1;  
              end
            
            else //beq 
              begin
                ALUSrc = 0; 
                MemtoReg = 0; 
                RegWrite = 0; 
                MemRead = 0; 
                MemWrite = 0; 
                Branch = 0; 
                ALUOp = 2'b01; 
                bge = 0; 
                ble = 0; 
              end
          end
        
        7'b0010011:  //write case for addi instruction 

          begin 
              ALUSrc = 1;
              MemtoReg = 0; 
              RegWrite = 1; 
              MemRead = 0; 
              MemWrite = 0; 
              Branch = 0; 
              ALUOp = 2'b10;
            end
        
        default: //initialize all values to zero
          begin 
            ALUSrc = 0;
            MemtoReg = 0; 
            RegWrite = 0; 
            MemRead = 0; 
            MemWrite = 0; 
            Branch = 0; 
            ALUOp = 2'b00;
            ble = 0; 
            bge = 0; 
          end
        
      endcase 
      
    end
  
endmodule 
