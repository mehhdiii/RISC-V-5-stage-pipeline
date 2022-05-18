// Code your design here


module imm_data_extractor (input [31:0] inst, 
                           output reg [63:0] imm_data);
  
  reg [1:0] sel; 
  
  always @(*)
    begin
      sel = inst[6:5];
      
      case(sel)
        
        
        2'b00 : 
          begin
          imm_data[11:0] = inst[31:20]; //I type
            imm_data[63:12] = {52 {imm_data[11]}};
          end
        
        2'b01 :  //S type
          begin
            imm_data[4:0] = inst[11:7];
            imm_data[11:5] = inst[31:25];
            imm_data[63:12] = {52{imm_data[11]}};
          end
        2'b11 : 
          begin 
            imm_data[3:0] = inst[11:8];
            imm_data[9:4] = inst[30:25];
            imm_data[10] = inst[7];
            imm_data[11] = inst[31];
            imm_data[63:12] = {52{imm_data[11]}};
          end   
        endcase 
    end
  

endmodule 
