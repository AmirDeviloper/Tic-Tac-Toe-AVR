#include <mega64.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>
#include <stdbool.h>

int player_turn = 1;

const int player_green = 1;
const int player_red = -1;

const int red_color_bit1 = 1;
const int red_color_bit2 = 0;

const int green_color_bit1 = 0;
const int green_color_bit2 = 1;

bool is_started = false;
                    
int game_board [] = { 0, 0, 0,
                      0, 0, 0,
                      0, 0, 0 };



bool check_win(int player) {
    // Check rows 
    int i = 0;
    for (i = 0; i < 3; i++) 
    {
        if (game_board[i * 3] == player &&
             game_board[i * 3 + 1] == player &&
              game_board[i * 3 + 2] == player) 
        {
            return true;
        }
    }

    // Check columns
    for (i = 0; i < 3; i++) 
    {
        if (game_board[i] == player &&
             game_board[i+3] == player &&
              game_board[i+6] == player) 
              {
                    return true;
              }
    }

    // Check diagonals
    if ((game_board[0] == player &&
         game_board[4] == player &&
         game_board[8] == player) 
         ||
        (game_board[2] == player &&
         game_board[4] == player &&
         game_board[6] == player)) 
         {
            return true;
         }

    return false;
}

bool is_draw()
{
    int i = 0;
    for (i = 0; i < 9; i++) 
    {
        if (game_board[i] == 0) 
        {   
            return false;
        }
    } 
    
    return true;
}

void work(int key)
{
    if(!is_started && key == 0)
    {   
        lcd_clear();
        lcd_puts("Green's Turn");
        delay_ms(2000);
        is_started = true;
    }
    else if (is_started && key != 0)
    {  
        int index = key - 1;

        if(index >= 0 && game_board[index] == 0)
        {
            game_board[index] = player_turn;
            
            player_turn *= -1;
            
            if(player_turn == player_red)
            {   
                lcd_clear();
                lcd_puts("Red's Turn");
            }   
            else
            {   
                lcd_clear();
                lcd_puts("Green's Turn");
            }
            delay_ms(50);
            
        }
        else
        {   
            lcd_clear();
            lcd_puts("Try Again");
            delay_ms(2000);
            lcd_clear();
            
            if(player_turn == player_red)
            {   
                lcd_clear();
                lcd_puts("Red's Turn");
            }   
            else
            {   
                lcd_clear();
                lcd_puts("Green's Turn");
            } 
        }
        
    }
}


void keyboard(void)
{   
    // ---- ROW1 ----
    PORTE.4 = 0;
    //delay_ms(1);
    if(PINE.0==0) work(1);
    if(PINE.1==0) work(4);
    if(PINE.2==0) work(7);
    PORTE.4=1;
    // ---- ROW2 ----
    PORTE.5 = 0;
    //delay_ms(1);
    if(PINE.0==0) work(2);
    if(PINE.1==0) work(5);
    if(PINE.2==0) work(8);
    if(PINE.3==0) work(0);
    PORTE.5 = 1;
    // ---- ROW3 ----
    PORTE.6 = 0;
    //delay_ms(1);
    if(PINE.0==0) work(3); 
    if(PINE.1==0) work(6); 
    if(PINE.2==0) work(9);
    PORTE.6 = 1;
}

int get_bit1_value(int index)
{
    if(game_board[index] == 0)
        return 0;
        
    return game_board[index] == player_red ?
             red_color_bit1 : green_color_bit1;
}

int get_bit2_value(int index)
{
    if(game_board[index] == 0)
        return 0;
        
    return game_board[index] == player_red ? 
             red_color_bit2 : green_color_bit2;
}

void main(void)
{
    PORTD=0x00;
    DDRD=0xF7;
    PORTE=0xFF;
    DDRE=0xF0;
    
    DDRB = 0XFF;
    DDRA = 0XFF;
    DDRC = 0XFF;
    
    PORTA = 0XFF;
    PORTB = 0XFF;
    PORTC = 0XFF;
    
    lcd_init(16);
    lcd_clear();
    lcd_puts("Press 0 To Start");
    
    while (1)
    {   
        keyboard();
        
        PORTA.0 = get_bit1_value(0);
        PORTA.1 = get_bit2_value(0);
        
        PORTA.2 = get_bit1_value(1);
        PORTA.3 = get_bit2_value(1);
        
        PORTA.4 = get_bit1_value(2);
        PORTA.5 = get_bit2_value(2);
        
        PORTA.6 = get_bit1_value(3);
        PORTA.7 = get_bit2_value(3);
        
        PORTB.0 = get_bit1_value(4);
        PORTB.1 = get_bit2_value(4);
        
        PORTB.2 = get_bit1_value(5);
        PORTB.3 = get_bit2_value(5);
        
        PORTB.4 = get_bit1_value(6);
        PORTB.5 = get_bit2_value(6);
        
        PORTB.6 = get_bit1_value(7);
        PORTB.7 = get_bit2_value(7);
        
        PORTC.0 = get_bit1_value(8);
        PORTC.1 = get_bit2_value(8);
        
        
        
        if(check_win(player_green))
        {   
            lcd_clear();
            lcd_puts("Green Win");
            delay_ms(999999999);
        }
        else if (check_win(player_red))
        {   
            lcd_clear();
            lcd_puts("Red  Win");
            delay_ms(999999999);
        }
        else if (is_draw())
        {
            lcd_clear();
            lcd_puts("DRAW!");
            delay_ms(999999999);
        }
        
        delay_ms(250);
    }
}