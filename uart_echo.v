`default_nettype none

module uart_echo (
    input wire clk_25mhz,
    input wire ftdi_txd,
    output wire ftdi_rxd,
    output wire [7:0] led
);
    wire rx_ready;
    wire [7:0] rx_data;
    reg tx_start = 0;
    reg [7:0] tx_data = 0;
    wire tx_busy;

    reg [7:0] last_rx = 0;
    assign led = last_rx;

    uart_rx #(.BAUD(115200), .CLK_HZ(25000000)) rx (
        .clk(clk_25mhz),
        .rx(ftdi_txd),
        .data(rx_data),
        .ready(rx_ready)
    );

    uart_tx #(.BAUD(115200), .CLK_HZ(25000000)) tx (
        .clk(clk_25mhz),
        .start(tx_start),
        .data(tx_data),
        .tx(ftdi_rxd),
        .busy(tx_busy)
    );

    always @(posedge clk_25mhz) begin
        tx_start <= 0;
        if (rx_ready && !tx_busy) begin
            tx_data <= rx_data;
            last_rx <= rx_data;
            tx_start <= 1;
        end
    end
endmodule
