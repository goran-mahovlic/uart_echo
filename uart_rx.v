`default_nettype none

module uart_rx #(parameter BAUD = 115200, CLK_HZ = 25000000) (
    input wire clk,
    input wire rx,
    output reg [7:0] data = 0,
    output reg ready = 0
);
    localparam CLKS_PER_BIT = CLK_HZ / BAUD;
    localparam HALF_BIT = CLKS_PER_BIT / 2;
    localparam CTR_WIDTH = $clog2(CLKS_PER_BIT);

    reg [CTR_WIDTH-1:0] clk_cnt = 0;
    reg [3:0] bit_idx = 0;
    reg [7:0] rx_shift = 0;
    reg busy = 0;
    reg rx_sync = 1;

    always @(posedge clk) begin
        rx_sync <= rx;
        ready <= 0;

        if (!busy && !rx_sync) begin
            busy <= 1;
            clk_cnt <= HALF_BIT;
            bit_idx <= 0;
        end else if (busy) begin
            if (clk_cnt == CLKS_PER_BIT - 1) begin
                clk_cnt <= 0;
                rx_shift[bit_idx] <= rx_sync;
                bit_idx <= bit_idx + 1;
                if (bit_idx == 7) begin
                    data <= {rx_sync, rx_shift[6:0]};
                    ready <= 1;
                    busy <= 0;
                end
            end else begin
                clk_cnt <= clk_cnt + 1;
            end
        end
    end
endmodule
