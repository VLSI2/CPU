module regfile (
		input  wire          clock,
		input  wire          reset,

		input  wire          read1_valid,
		input  wire [ 4 : 0] read1_addr,
		output reg  [31 : 0] read1_data,

		input  wire          read2_valid,
		input  wire [ 4 : 0] read2_addr,
		output reg  [31 : 0] read2_data,

		input  wire          write_valid,
		input  wire [ 4 : 0] write_addr,
		input  wire [31 : 0] write_data
	);

	reg [31 : 0] regbank [1 : 31];

	always @(posedge clock) begin
		if (reset) begin
			read1_data <= 32'b0;
			read2_data <= 32'h0;
		end
		else begin
			if (write_valid & write_addr != 5'h0) regbank[write_addr] <= write_data;

			if (read1_valid) begin
				if      (read1_addr == 5'h0                    ) read1_data <= 32'h0;
				else if (read1_addr == write_addr & write_valid) read1_data <= write_data;
				else                                             read1_data <= regbank[read1_addr];
			end

			if (read2_valid) begin
				if      (read2_addr == 5'h0                    ) read2_data <= 32'h0;
				else if (read2_addr == write_addr & write_valid) read2_data <= write_data;
				else                                             read2_data <= regbank[read2_addr];
			end
		end
	end
endmodule