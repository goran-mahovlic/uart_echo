yosys -p "synth_ecp5 -top uart_echo -json uart_echo.json" uart_echo.v uart_tx.v uart_rx.v
nextpnr-ecp5 --json uart_echo.json --lpf uart_echo.lpf --textcfg uart_echo.config --85k --package CABGA381 --freq 25
ecppack uart_echo.config uart_echo.bit
openFPGALoader -b ulx3s uart_echo.bit
