module ALU_64(input [63:0] a, 
        input [63:0] b, 
        input [3:0] ALUOp, 
        output reg [63:0] Result, 
        output reg zero, 
        output reg le_flag, 
        output reg ge_flag
             ); 
  always @(*)
    begin
      case(ALUOp)
        4'b0000: Result = a&b; //and 
        4'b0001: Result = a|b; // OR operation
        4'b0010: Result = a+b; //Addition operation
        4'b0110: Result = a-b; // subtraction operation
        4'b1100: Result = ~(a|b); // nor operation
      endcase
      case (Result)
      	0: zero = 1;
        default: zero = 0 ;
      endcase
      if (a>=b)
        ge_flag = 1; 
      else
        ge_flag = 0; 
      
      if (a<=b)
        le_flag = 1; 
      else
        le_flag = 0;
    end
  
endmodule
