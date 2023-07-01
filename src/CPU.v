`default_nettype none

module yannickreiss_cpu(
  input [0:7] io_in,
  output reg [0:7] io_out
);
   
   wire clk;
   wire reset;
   wire	halt;
   wire	mode;
   wire [0:3] databus;
   wire [0:3] dbus_out;
   wire [0:3] addr_bus;

   // Control signals
   wire [0:2] cpu_control;
   wire	      software_rst;
   wire [0:2] alt_state;	      

   // Bus signals
   wire [0:3] instruction;
   wire [0:3] immediate;
   wire [0:3] alu_result;
   wire [0:3] op1;
   wire [0:3] op2;

   // Register
   //   TODO: Add 16x4 Register
   

   // Here is the connection to input and output
   assign clk = io_in[0];
   assign reset = io_in[1] or software_rst;
   assign halt = io_in[2];
   assign mode = io_in[3];
   assign databus = io_in[4:7];

   assign io_out[4:7] = dbus_out;
   assign io_out[0:3] = addr_bus;

   // RESET
   always @(posedge reset) begin
      cpu_control = 3'b001;
      software_rst = 1'b0;
      
   end

   // HALT (put mpu to sleep)
   always @(halt) begin
      alt_state = cpu_control;
      cpu_control = 3'b111; // let CPU halt in current state
   end

   always @(negedge halt) begin
      cpu_control = alt_state;
   end

   // Clock (regular mode)
   always @(posedge clk) begin
      case (cpu_control)
	3'b000: begin
	   cpu_control = 3'b001;

	   // Fetch instruction
	   instruction = databus;
	   
	end
	3'b001: begin

	   // Decode (jump according to number of operands)
     case (instruction)
      2'b00: cpu_control = 3'b100; // nonary
      2'b01: cpu_control = 3'b011; // unary
      2'b10: cpu_control = 3'b010; // binary
      default: cpu_control = 3'b111; // TODO: Implement misc commands
     endcase
	   
	end
	3'b010: begin
	   cpu_control = 3'b011;
	   
     // Fetch to input 1

	end
	3'b011: begin
	   cpu_control = 3'b100;

	   // Fetch to input 2

	end
	3'b100: begin
	   cpu_control = 3'b101;
	   
     // Execute opcode

	end
	3'b101: begin
	    cpu_control = 3'b001;

      // write to register
                  
	end
	3'b110: begin
	   software_rst = 1'b1; // Reset cpu with instruction
	end
	default: begin
	   // IDLE / ERROR
	end
      endcase
   end

  always @(io_in) begin
    if (op_code) begin
      io_out[0:2] = quotient;
      io_out[3:5] = reminder;
    end else begin
      io_out[0:5] = product;
    end
     io_out[6:7] = 2'b00;
  end

  // Here is the logic
  assign  product = op1 * op2;

  always @(*) begin
    
    // check middle axis
    if (op1 == op2) begin
      quotient = 3'b001;
      reminder =  3'b000;
    end else if ((op1 == 3'b000) | (op2 == 3'b000)) begin
      quotient = 3'b000;
      reminder = 3'b000;
    end else if (op2 == 3'b001) begin
      quotient = op1;
      reminder = 3'b000;
    end else if (op2 == 3'b010) begin
      reminder = {2'b00, op1[2]};
      quotient = {1'b0, op1[0:1]};
    end else if (op2 > op1) begin
      quotient = 3'b000;
      reminder = op1;
    end else if (((op2 == 3'b011) && (op1 > 3'b101))) begin
       quotient = 3'b010;
       reminder = {2'b00, op1[2]};
    end else begin       
      quotient = 3'b001;
      if (op1[2] ^ op2[2]) begin
        reminder = 3'b001;
      end else if (op1[1] ^ op2[1]) begin
        reminder = 3'b010;
      end else reminder = 3'b011;
    end
  end
endmodule
