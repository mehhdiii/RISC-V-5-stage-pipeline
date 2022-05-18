// Code your design here
`include "Program_Counter.sv"
`include "adder.sv"
`include "MUX.sv"
`include "Instruction_Memory.sv"
`include "instruction_parser.sv"
`include "Control_Unit.sv"
`include "registerFile.sv"
`include "imm_data_extractor.sv"
`include "ALU_Control.sv"
`include "Data_Memory.sv"
`include "ALU_64.sv"



module top (
	input clk, 
  	input reset
);
  
  //PC --------------------

  wire [63:0] PC_out;
  
  //initialize PC_in: 
  wire [63:0] PC_in;
  
  
  Program_Counter PC_RISC(.clk(clk), .reset(reset), .PC_in(PC_in), //add mux output at PC_in
                          .PC_out(PC_out));
  
  wire [63:0] PC_incrementer_out; 
  
  //PC incrementer: -----------------
  
  adder AddPC1(.a(PC_out), .b(64'd4), .out(PC_incrementer_out));
  
  //PC incrementer: -----------------
  
  
  //PC jumper code implemented later in the file
  
  
  //PC --------------------
  
  
  
  
  
  
  
  
  //instruction memory: ------------------
  wire [31:0] ins_mem_to_ins_parser; 
  
  Instruction_Memory ins_mem(.inst_address( PC_out ), .instruction(ins_mem_to_ins_parser) );
  
  
  //instruction memory: ------------------
  
  
  
  //IF-ID --------------------------------
  wire [31:0] instruction_out; 
  wire [63:0] PC_out_out; 
  IF_ID if_id(
    .clk(clk), 
    .PC_out_in(PC_out), 
    .instruction_in(ins_mem_to_ins_parser), 
    .instruction_out(instruction_out), 
    .PC_out_out(PC_out_out)
  	
); 
  
  //IF-ID --------------------------------
  

  
  
  
  //Instruction parsing -----------------------
  wire [6:0] opcode; 
  wire [4:0] rs1; 
  wire [4:0] rs2; 
  wire [4:0] rd; 
  wire [2:0] funct3; 
  wire [6:0] funct7; 
  
  instruction_parser ins_parser(
    .inst(instruction_out), 
    .opcode(opcode), 
    .rd(rd), 
    .funct3(funct3), 
    .rs1(rs1), 
    .rs2(rs2), 
    .funct7(funct7)
  );
  
  //Instruction parsing -----------------------
  
  
  
  
  //Control Unit: -----------------------------
  
  wire Branch; 
  wire MemRead; 
  wire MemtoReg; 
  wire [1:0] ALUOp; 
  wire MemWrite; 
  wire ALUSrc; 
  wire RegWrite; 
  
  Control_Unit control_unit(
    .Opcode(opcode), 
    .Branch(Branch), 
    .MemRead(MemRead), 
    .MemtoReg(MemtoReg), 
    .ALUOp(ALUOp), 
    .MemWrite(MemWrite), 
    .ALUSrc(ALUSrc), 
    .RegWrite(RegWrite)
);
  
  
  //Control Unit: -----------------------------
  
  
  
  
  
  
  //Registers: ---------------------
  wire [63:0] ReadData1; 
  wire [63:0] ReadData2; 
  registerFile reg_file(
    .rs1(rs1), 
    .rs2(rs2), 
    .rd(rd), 
    .WriteData(), 
    .RegWrite(RegWrite), 
    .clk(clk), 
    .reset(reset), 
    .ReadData1(ReadData1), 
    .ReadData2(ReadData2) 
  );
  //Registers ----------------------
  
  
  
  
  
  
  //Immediate Data Extractor: --------------
  wire [63:0] imm_data; 
  imm_data_extractor imm_data_ext(
    .inst(ins_mem_to_ins_parser), 
    .imm_data(imm_data)
  ); 
  
  //Immediate Data Extractor: --------------
  
  
  
  
  
  //ID_EX: ---------------------------------
  wire [63:0] ReadData1_out; 
  wire [63:0] ReadData2_out; 
  wire [63:0] imm_data_out; 
  wire Branch_out; 
  wire MemRead_out;  
  wire MemtoReg_out;  
  wire [1:0] ALUOp_out;  
  wire MemWrite_out; 
  wire ALUSrc_out; 
  wire RegWrite_out;  
  wire PC_in_out; 
  wire [4:0] rd_out;  
  wire [4:0] rs1_out;  
  wire [4:0] rs2_out; 
  wire [4:0] funct_out; 

  
  ID_EX id_ex(
    .clk(clk), 
  
  	//inputs from registers
    .ReadData1(ReadData1), 
    .ReadData2(ReadData2), 
    .imm_data(imm_data), 
  
    //inputs from control_unit
    .Branch(Branch), 
    .MemRead(MemRead), 
    .MemtoReg(MemtoReg), 
    .ALUOp(ALUOp), 
    .MemWrite(MemWrite), 
    .ALUSrc(ALUSrc), 
    .RegWrite(RegWrite), 

    //inputs from PC: 

    .PC_out_in(PC_out_out), 

    //input parsed instruction:  
    .rd(rd), 
    .rs1(rs1), 
    .rs2(rs2), 
    .funct(), 


    //outputs register:
    .ReadData1_out(ReadData1_out),
    .ReadData2_out(ReadData2_out),
    .imm_data_out(imm_data_out), 


    //outputs control_unit: 
    .Branch_out(Branch_out), 
    .MemRead_out(MemRead_out), 
    .MemtoReg_out(MemtoReg_out), 
    .ALUOp_out(ALUOp_out), 
    .MemWrite_out(MemWrite_out), 
    .ALUSrc_out(ALUSrc_out), 
    .RegWrite_out(RegWrite_out), 

    //outputs PC: 
    .PC_in_out(PC_in_out), 

    //output parsed instructions: 
    .rd_out(rd_out), 
    .rs1_out(rs1_out), 
    .rs2_out(rs2_out), 
    .funct_out(funct_out)

    
); 
  
  
  
  
  
  //Reg2ALU: ------------------
  //Mux: 
  wire [63:0] reg2alu_data_out; 
  MUX reg2alu_mux(
    .a(ReadData2), 
    .b(imm_data), 
    .sel(ALUSrc), //missing??
    .data_out(reg2alu_data_out)
  );
  //Reg2ALU: ------------------
  
  
  
  //ALU control: --------------
  wire [3:0] Funct; 
  wire [1:0] ALUOperation; 
  wire [3:0] Operation; 
  ALU_Control alu_control(
    .Funct(Funct), 
    .ALUOp(ALUOperation), 
    .Operation(Operation)
	); 
  //ALU control: --------------
  
  
  
  
  
  //ALU: ----------------------
  wire alu_zero;
  wire [63:0] Result; 
  ALU_64 alu(.a(ReadData1), 
         .b(reg2alu_data_out), 
         .ALUOp(Operation), 
         .Result(Result), 
         .zero(alu_zero)
        
        );
  
  //ALU: ----------------------
  
  //EX_MEM: -------------------
  
  wire Branch_out_3; 
  wire MemRead_out_3; 
  wire MemtoReg_out_3; 
  wire MemWrite_out_3;  
  wire RegWrite_out_3; 
  wire [63:0] adder_out_out_3;
  wire alu_zero_out_3; 
  wire [63:0] result_out_3; 
  wire [63:0] mux_out_out_3; 
  wire [4:0] rd_out_3;
  
  EX_MEM ex_mem(
    .clk(clk), 

    //inputs from control_unit: 
    .Branch(Branch_out), 
    .MemRead(MemRead_out), 
    .MemtoReg(MemtoReg_out), 
    .MemWrite(MemWrite_out),  
    .RegWrite(RegWrite_out), 


    // inputs from adder:  
    .adder_out_in(), 


    //inputs from ALU: 
    .alu_zero(alu_zero), 
    .result(Result),

    //input MUX: 
    .mux_out_in(), 


    //inputs register address:
    .rd(rd_out), 


    //register output: 
    .Branch_out(Branch_out_3), 
    .MemRead_out(MemRead_out_3), 
    .MemtoReg_out(MemtoReg_out_3), 
    .MemWrite_out(MemWrite_out_3),  
    .RegWrite_out(RegWrite_out_3), 

    //adder output: 
    .adder_out_out(adder_out_out_3),

    //ALU output: 
    .alu_zero_out(alu_zero_out_3), 
    .result_out(result_out_3), 

    //mux output: 
    .mux_out_out(mux_out_out_3), 

    //register address output: 
    .rd_out(rd_out_3) 


); 
  
  
  
  //PC: ------------------------------------
  
  //immediate_data PC jumper: ------ 
  wire [63:0] imm_data_adder_out; 
  
  adder AddPC2(.a(PC_out), .b(imm_data<<1), .out(imm_data_adder_out)); 
  
  //immediate_data PC jumper: ------ 
  
  
  //selector between regular PC and imm_data Jump:
  MUX muxPC(.a(adder_to_mux_PC), .b(adder_to_mux_PC2), .sel(Branch & alu_zero), .data_out(PC_in)); 
  
  //PC -------------------------------------
  
  
  
  
  
  //Data Memory: --------------
  wire [63:0] Read_Data;
  Data_Memory data_memory(
    .clk(clk), 
    .Mem_Addr(Result), 
    .Write_Data(ReadData2), 
    .MemWrite(MemWrite), //From Control_unit
    .MemRead(MemRead), //From Control_unit
    .Read_Data(Read_Data) 
	);
  //Data Memory: --------------
  
  
  
  //Mem_WB: -------------------
  
  wire MemtoReg_out_4;   
  wire RegWrite_out_4;
  wire [63:0] Read_Data_out_4;
  wire [63:0] Mem_Addr_out_4;
  wire [4:0] rd_out_4;
  
  EX_MEM ex_mem(
    .clk(clk), 

    //inputs from control_unit: 
    .MemtoReg(MemtoReg_out_3),   
    .RegWrite(RegWrite_out_3),

    //inputs Data Memory: 
    .Read_Data(Read_Data), 

    //inputs from ALU: 
    .Mem_Addr(result_out_3), 

    //inputs register address:
    .rd(rd_out_3),


    // ---------------------------


    //output from control_unit: 
    .MemtoReg_out(MemtoReg_out_4),   
    .RegWrite_out(RegWrite_out_4),


    //output Data Memory: 
    .Read_Data_out(Read_Data_out_4),

    //output from ALU: 
    .Mem_Addr_out(Mem_Addr_out_4),

    //output register address:
    .rd_out(rd_out_4)

  ); 
  //Mem_WB: -------------------
  
  
  //mem2reg: ------------------
  
  //Mux: 
  wire [63:0] mem2reg_data_out; 
  MUX mem2reg_mux(
    .a(Read_Data), 
    .b(Result), 
    .sel(MemtoReg), //Control unit
    .data_out(mem2reg_data_out)
  );
  
  //mem2reg: ------------------
  
  
  
  
  
  
  
endmodule 
