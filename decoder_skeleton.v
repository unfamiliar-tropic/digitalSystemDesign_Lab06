`timescale 1ns / 100ps
module decoder(

    input [15:0] instruction,
    input [4:0] flcnz,
	
	//register control signal
    output reg [4:0] tri_sel,	// select din : alu, shifter, mem, reg, etc...
	output reg register_we,		// write_enable to register  

	//alu control signal
	output reg [5:0] alu_sel,	// select alu ops
	output reg mux_sel0,		// select alu input : immediate or register file?	
    
	
	//signal to shifter
	output reg shift_imm,		// select shift amount : immediate or register?
	output reg mux_sel1,		// select shiftee : immediate or register file?
	output reg lui,				// lui op?

	//control flow signal
	output reg jmp,
	output reg br,

	//memory signal
	output reg memory_we,		//write_enable to memory
	
	//immediate extenstion signal
	output reg imm_ex_sel		// immediate extension : signed or unsigned?
	);

	//====================================
	//									//
	//	decoder is combinational logic  //
	//    	   do not make latch		//
	//									//
	//====================================

	always@( instruction, flcnz) begin
		//write code below
		//code needed here?
		//initialization (NOP 0x0020) & set other control signals to zero
		tri_sel = 5'b00010;		// din <- 2
		alu_sel = 6'b000010;	// alu or
		register_we = 0;		// register write enabled
		jmp = 0;				// jump
		br = 0;					// branch
		mux_sel0 = 0;			// alu <- reg
		shift_imm = 0;			// shift amount <- reg
		mux_sel1 = 0;			// shiftee <- reg
		lui = 0;				// lui
		memory_we = 0;			// memory write disabled
		imm_ex_sel = 0;			// unsigned
		//
		if( instruction[15:12]==4'b0000 && instruction[7:4] == 4'b0101) begin  //add
       		tri_sel = 5'b00010;		// din <- 2
       		alu_sel = 6'b100000;	// alu add
       		register_we = 1;		// register write enabled
			jmp = 0;
			br = 0;
       		mux_sel0 = 0;			// alu <- reg
       		memory_we = 0;			// memory write disabled
		end
		else if( instruction[15:12]==4'b0101) begin//addi
			tri_sel = 5'b00010;		// din <- 2
       		alu_sel = 6'b100000;	// alu add
       		register_we = 1;		// register write enabled
       		jmp = 0;				// jump
       		br = 0;					// branch
       		mux_sel0 = 1;			// alu <- imm
       		memory_we = 0;			// memory write disabled
			imm_ex_sel = 1;			// signed
		end
		else if( instruction[15:12]==4'b0000 && instruction[7:4] == 4'b1001) begin //sub
    		tri_sel = 5'b00010;		// din <- 2
			alu_sel = 6'b010000;	// alu sub
			register_we = 1;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 0;			// alu <- reg
			memory_we = 0;			// memory write disabled
   		end
		else if( instruction[15:12]==4'b1001) begin  //subi
			tri_sel = 5'b00010;		// din <- 2
			alu_sel = 6'b010000;	// alu sub
			register_we = 1;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 1;			// alu <- imm
			memory_we = 0;			// memory write disabled
			imm_ex_sel = 1;			// signed
		end
		else if( instruction[15:12]==4'b0000 && instruction[7:4] == 4'b1011) begin//cmp
 			tri_sel = 5'b00010;		// din <- 2
			alu_sel = 6'b001000;	// alu cmp
			register_we = 0;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 0;			// alu <- reg
			memory_we = 0;			// memory write disabled
    	end        
		else if( instruction[15:12]==4'b1011) begin      //cmpi
			tri_sel = 5'b00010;		// din <- 2
			alu_sel = 6'b001000;	// alu cmp
			register_we = 0;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 1;			// alu <- imm
			memory_we = 0;			// memory write disabled
			imm_ex_sel = 1;			// signed
   		end
		else if( instruction[15:12]==4'b0000 && instruction[7:4] == 4'b0001) begin //and
			tri_sel = 5'b00010;		// din <- 2
			alu_sel = 6'b000100;	// alu and
			register_we = 1;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 0;			// alu <- reg
			memory_we = 0;			// memory write disabled
		end
		else if( instruction[15:12]==4'b0001) begin // andi 
			tri_sel = 5'b00010;		// din <- 2
			alu_sel = 6'b000100;	// alu and
			register_we = 1;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 1;			// alu <- imm
			memory_we = 0;			// memory write disabled
			imm_ex_sel = 0;			// unsigned
		end
		else if( instruction[15:12]==4'b0000 && instruction[7:4] == 4'b0010) begin //or
			tri_sel = 5'b00010;		// din <- 2
			alu_sel = 6'b000010;	// alu or
			register_we = 1;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 0;			// alu <- reg
			memory_we = 0;			// memory write disabled
		end
		else if( instruction[15:12]==4'b0010) begin  //ori    
			tri_sel = 5'b00010;		// din <- 2
			alu_sel = 6'b000010;	// alu or
			register_we = 1;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 1;			// alu <- imm
			memory_we = 0;			// memory write disabled
			imm_ex_sel = 0;			// unsigned
		end
		else if( instruction[15:12]==4'b0000 && instruction[7:4] == 4'b0011) begin      //xor
			tri_sel = 5'b00010;		// din <- 2
			alu_sel = 6'b000001;	// alu xor
			register_we = 1;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 0;			// alu <- reg
			memory_we = 0;			// memory write disabled
		end
		else if( instruction[15:12]==4'b0011) begin        //xori
			tri_sel = 5'b00010;		// din <- 2
			alu_sel = 6'b000001;	// alu xor
			register_we = 1;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 1;			// alu <- imm
			memory_we = 0;			// memory write disabled
			imm_ex_sel = 0;			// unsigned
		end
		else if( instruction[15:12]==4'b0000 && instruction[7:4] == 4'b1101) begin      //mov 
			tri_sel = 5'b00100;		// din <- 4
			register_we = 1;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 0;
			memory_we = 0;			// memory write disabled
		end
		else if( instruction[15:12]==4'b1101) begin     //movi
			tri_sel = 5'b00100;		// din <- 4
			register_we = 1;		// register write enabled
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel0 = 1;			// alu <- imm
			memory_we = 0;			// memory write disabled
			imm_ex_sel = 0;			// unsigned
		end
		else if( instruction[15:12]==4'b1000 && instruction[7:4] == 4'b0100) begin      //lsh 
			tri_sel = 5'b00001;		// din <- 1
			register_we = 1;		// register write enable
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel1 = 0;			// shiftee <- reg
			shift_imm = 0;			// shift amount <- reg
			lui = 0;				// lui
			memory_we = 0;			// memory write disable
		end
		else if( instruction[15:12]==4'b1000 && instruction[7:5] == 3'b000) begin      //lshi 
			tri_sel = 5'b00001;		// din <- 1
			register_we = 1;		// register write enable
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel1 = 0;			// shiftee <- reg
			shift_imm = 1;			// shift amount <- imm
			lui = 0;				// lui
			memory_we = 0;			// memory write disable
		end
		else if( instruction[15:12]==4'b1111) begin      //lui
			tri_sel = 5'b00001;		// din <- 1
			register_we = 1;		// register write enable
			jmp = 0;				// jump
			br = 0;					// branch
			mux_sel1 = 1;			// shiftee <- imm
			lui = 1;				// lui
			memory_we = 0;			// memory write disable
		end 
		else if( instruction[15:12]==4'b0100 && instruction[7:4] == 4'b0000) begin     //load
			tri_sel = 5'b10000;		// din <- 16
			register_we = 1;		// register write enable
			jmp = 0;				// jump
			br = 0;					// branch
			memory_we = 0;			// memory write disable
		end
		else if( instruction[15:12]==4'b0100 && instruction[7:4] == 4'b0100) begin      //store
			tri_sel = 5'b00000;		// din <- 0
			register_we = 0;		// register write disabled
			jmp = 0;				// jump
			br = 0;					// branch
			memory_we = 1;			// memory write enabled
		end        
		else if( instruction[15:12]==4'b0100 && instruction[7:4] == 4'b1000) begin      //jal
			tri_sel = 5'b01000;		// din <- 8
			register_we = 1;		// register write enabled
			jmp = 1;				// jump
			br = 0;					// branch
			memory_we = 0;			// memory write disabled
		end 
		else if( instruction[15:12]==4'b1100) begin      //Bcond 
			tri_sel = 5'b00000;		// din <- 0
			register_we = 0;		// register write enabled
			jmp = 0;				// jump
			memory_we = 0;			// memory write disabled
			
       		if ( instruction[11:8] == 4'b0000 && flcnz[0] == 1) br = 1;
       		else if ( instruction[11:8] == 4'b0001 && flcnz[0] == 0) br = 1;
       		else if ( instruction[11:8] == 4'b1101 && (flcnz[1] == 1 || flcnz[0] == 1)) br = 1;
       		else if ( instruction[11:8] == 4'b0010 && flcnz[2] == 1) br = 1;
       		else if ( instruction[11:8] == 4'b0011 && flcnz[2] == 0) br = 1;
       		else if ( instruction[11:8] == 4'b0100 && flcnz[3] == 1) br = 1;
       		else if ( instruction[11:8] == 4'b0101 && flcnz[3] == 0) br = 1;
       		else if ( instruction[11:8] == 4'b1010 && (flcnz[3] == 0 && flcnz[0] == 0)) br = 1;
       		else if ( instruction[11:8] == 4'b1011 && (flcnz[3] == 1 || flcnz[0] == 1)) br = 1;
       		else if ( instruction[11:8] == 4'b0110 && flcnz[1] == 1) br = 1;
       		else if ( instruction[11:8] == 4'b0111 && flcnz[1] == 0) br = 1;
       		else if ( instruction[11:8] == 4'b1000 && flcnz[4] == 1) br = 1;
       		else if ( instruction[11:8] == 4'b1001 && flcnz[4] == 0) br = 1;
       		else if ( instruction[11:8] == 4'b1100 && (flcnz[1] == 0 &&flcnz[0] == 0)) br = 1;
       		else if ( instruction[11:8] == 4'b1110) br = 1;
       		else if ( instruction[11:8] == 4'b1111) br = 0;
       		else ;
       
   		end 
		else if( instruction[15:12]== 4'b0100 && instruction[7:4] == 4'b1100) begin     //Jcond
			tri_sel = 5'b00000;		// din <- 0
			register_we = 0;		// register write enabled
			br = 0;					// branch
			memory_we = 0;			// memory write disabled
			
			if ( instruction[11:8] == 4'b0000 && flcnz[0] == 1) jmp = 1;
       		else if ( instruction[11:8] == 4'b0001 && flcnz[0] == 0) jmp = 1;
       		else if ( instruction[11:8] == 4'b1101 && (flcnz[1] == 1 || flcnz[0] == 1)) jmp = 1;
       		else if ( instruction[11:8] == 4'b0010 && flcnz[2] == 1) jmp = 1;
       		else if ( instruction[11:8] == 4'b0011 && flcnz[2] == 0) jmp = 1;
       		else if ( instruction[11:8] == 4'b0100 && flcnz[3] == 1) jmp = 1;
       		else if ( instruction[11:8] == 4'b0101 && flcnz[3] == 0) jmp = 1;
       		else if ( instruction[11:8] == 4'b1010 && (flcnz[3] == 0 && flcnz[0] == 0)) jmp = 1;
       		else if ( instruction[11:8] == 4'b1011 && (flcnz[3] == 1 || flcnz[0] == 1)) jmp = 1;
       		else if ( instruction[11:8] == 4'b0110 && flcnz[1] == 1) jmp = 1;
       		else if ( instruction[11:8] == 4'b0111 && flcnz[1] == 0) jmp = 1;
       		else if ( instruction[11:8] == 4'b1000 && flcnz[4] == 1) jmp = 1;
       		else if ( instruction[11:8] == 4'b1001 && flcnz[4] == 0) jmp = 1;
       		else if ( instruction[11:8] == 4'b1100 && (flcnz[1] == 0 &&flcnz[0] == 0)) jmp = 1;
       		else if ( instruction[11:8] == 4'b1110) jmp = 1;
       		else if ( instruction[11:8] == 4'b1111) jmp = 0;
       		else ;
   		end 
	end
endmodule
