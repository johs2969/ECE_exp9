`timescale 1us / 1ps

module text_LCD_basic_tb();
    reg rst,clk;
    
    wire LCD_E, LCD_RS, LCD_RW;
    wire [7:0] LCD_DATA;

    text_LCD_basic uut (.rst(rst), .clk(clk), .LCD_E(LCD_E), .LCD_RS(LCD_RS), .LCD_RW(LCD_RW), .LCD_DATA(LCD_DATA), .LED_OUT(LED_OUT));

    initial 
        begin
        clk = 0;
        rst = 0; #200 
        rst = 1;
        end
    always
        begin
        clk <= ~clk; #50;
        end
      
endmodule
