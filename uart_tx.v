`default_nettype none

module uart_tx #(parameter BAUD = 115200, CLK_HZ = 25000000) (
    input wire clk,
    input wire start,
    input wire [7:0] data,
    output wire tx,
    output reg busy = 0
);
    localparam CLKS_PER_BIT = CLK_HZ / BAUD;
    localparam CTR_WIDTH = $clog2(CLKS_PER_BIT);

    reg [CTR_WIDTH-1:0] clk_cnt = 0;
    reg [3:0] bit_idx = 0;
    reg [9:0] shift = 10'b1111111111;
    reg tx_reg = 1;

    assign tx = tx_reg;

    always @(posedge clk) begin
        if (!busy && start) begin
            shift <= {1'b1, data, 1'b0};
            busy <= 1;
            clk_cnt <= 0;
            bit_idx <= 0;
        end else if (busy) begin
            if (clk_cnt == CLKS_PER_BIT - 1) begin
                clk_cnt <= 0;
                tx_reg <= shift[bit_idx];
                bit_idx <= bit_idx + 1;
                if (bit_idx == 9) busy <= 0;
            end else begin
                clk_cnt <= clk_cnt + 1;
            end
        end
    end
endmodule
