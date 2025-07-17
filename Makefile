all: uart_echo.bit

uart_echo.json: uart_echo.v uart_tx.v uart_rx.v
	yosys -p "synth_ecp5 -json uart_echo.json -top uart_echo" uart_echo.v uart_tx.v uart_rx.v

uart_echo.config: uart_echo.json uart_echo.lpf
	nextpnr-ecp5 --json uart_echo.json --lpf uart_echo.lpf --textcfg uart_echo.config --85k --package CABGA381

uart_echo.bit: uart_echo.config
	ecppack uart_echo.config uart_echo.bit

flash: uart_echo.bit
	openFPGALoader -b ulx3s uart_echo.bit