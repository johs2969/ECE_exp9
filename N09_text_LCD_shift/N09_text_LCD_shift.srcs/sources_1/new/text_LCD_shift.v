`timescale 1ns / 1ps

module text_LCD_shift(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_OUT);

input rst,clk;

output LCD_E;
output reg LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA, LED_OUT;

reg [2:0] state;
parameter DELAY =4'b0000,
          FUNCTION_SET =4'b0001,
          ENTRY_MODE =4'b0010,
          DISP_ONOFF =4'b0011,
          LINE1 =4'b0100,
          LINE2 =4'b0101,
          DISP_SHIFT =4'b0110,// SHIFT Parameter 추가 선언
          DELAY_T =4'b0111,
          CLEAR_DISP =4'b1000;
          
 integer cnt;         
          
always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        state <= DELAY;
        cnt <=0;
        end
    else
    begin
        case(state)
        DELAY :begin
            if(cnt >=70) cnt <= 0;
            else cnt <= cnt+1;
            LED_OUT <= 8'b1000_0000;
            if(cnt == 70) state = FUNCTION_SET;
        end
        FUNCTION_SET :begin
            if(cnt >=30) cnt <= 0;
            else cnt <= cnt+1;
            LED_OUT <= 8'b0100_0000;
            if(cnt == 30) state <= DISP_ONOFF;
        end
        DISP_ONOFF :begin
            if(cnt >=30) cnt <= 0;
            else cnt <= cnt+1;
            LED_OUT <= 8'b0010_0000;
            if(cnt == 30) state <= ENTRY_MODE;
        end
        ENTRY_MODE :begin
            if(cnt >=30) cnt <= 0;
            else cnt <= cnt+1;
            LED_OUT <= 8'b0001_0000;
            if(cnt == 30) state <= LINE1;
        end
        LINE1 :begin
            if(cnt >=20) cnt <= 0;
            else cnt <= cnt+1;
            LED_OUT <= 8'b0000_1000;
            if(cnt == 20) state <= LINE2;
        end
        LINE2 :begin
            if(cnt >=20) cnt <= 0;
            else cnt <= cnt+1;
            LED_OUT <= 8'b0000_0100;
            if(cnt == 20) state <= DISP_SHIFT;
        end
        DISP_SHIFT :begin
            if(cnt >=5) cnt <= 0;
            else cnt <= cnt+1;
            if(cnt == 5) state <= DELAY_T;// LINE2 까지 표시되고, SHIFT가 일어나야 하므로 이 부분에 첨가한다.
        end
        DELAY_T :begin
            if(cnt >= 5) cnt <= 0;
            else cnt <= cnt+1;
            LED_OUT <= 8'b0000_0010;
            if(cnt == 5) state <= CLEAR_DISP;
        end
        CLEAR_DISP :begin 
            if(cnt >=5) cnt <= 0;
            else cnt <= cnt+1;
            LED_OUT <= 8'b0000_0001;
            if(cnt == 5) state <= LINE1;
        end
        default : state = DELAY;
     endcase
  end
end
                              
always @(posedge clk or negedge rst)
begin
    if(!rst)
        {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_00000000;
    else begin
        case(state)
            FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} =10'b0_0_0011_1000;
            DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} =10'b0_0_0000_1100;
            ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} =10'b0_0_0000_0111; //S=1로 설정하여 화면을 SHIFT할 것이라고 결정한다.  
            LINE1 : begin
                case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} =10'b0_0_1000_0000; //        
                    01 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0010_0000; // 
                    02 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0100_1000; // H
                    03 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0100_0101; // E
                    04 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0100_1100; // L
                    05 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0100_1100; // L
                    06 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0100_1111; // O
                    07 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0010_0000; // 
                    08 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0101_0111; // W
                    09 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0100_1111; // O
                    10 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0101_0010; // R
                    11 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0100_1100; // L
                    12 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0100_0100; // D
                    13 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0010_0001; // !
                    14 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0010_0000; // 
                    15 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0010_0000; // 
                    16 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0010_0000; // 
                    default : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0010_0000; // 
                 endcase
              end
             LINE2 : begin
                case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} =10'b0_0_1100_0000; //        
                    01 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0011_0010; // 2
                    02 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0011_0000; // 0
                    03 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0011_0001; // 1
                    04 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0011_1001; // 9
                    05 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0011_0100; // 4
                    06 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0011_0100; // 4
                    07 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0011_0000; // 0
                    08 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0011_0001; // 1
                    09 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0011_0010; // 2
                    10 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0011_0110; // 6
                    11 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0010_0000; // 
                    12 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0100_1010; // J
                    13 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0100_1000; // H
                    14 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0101_0011; // S
                    15 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0010_0000; // 
                    16 : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0010_0000; // 
                    default : {LCD_RS, LCD_RW, LCD_DATA} =10'b1_0_0010_0000; // 
                 endcase
              end 
            DISP_SHIFT :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0001_1100;  // DISP_SHIFT 명령, S/C=1, R/L=1로 하여 화면을 오른쪽으로 SHIFT
            DELAY_T :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010;
            CLEAR_DISP :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0001;
            default :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0000_0000;              
          endcase
      end
  end
  
  assign LCD_E = clk;                  

endmodule
