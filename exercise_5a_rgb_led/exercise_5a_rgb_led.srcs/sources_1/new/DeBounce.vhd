library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DeBounce is
    port(   Clock : in std_logic;
            button_in : in std_logic;
            pulse_out : out std_logic
        );
end DeBounce;

architecture behav of DeBounce is

type state_type is (idle,wait_time); --state machine
signal state : state_type := idle;
signal count : integer := 0;

begin
  
process(Clock)
begin
 if(rising_edge(Clock)) then
        case (state) is
            when idle =>
                if(button_in = '1') then  
                    state <= wait_time;
                else
                    state <= idle; --wait until button is pressed.
                end if;
                pulse_out <= '0';
            when wait_time =>
                if(count = 100) then--the higher this is, the longer time the user has to press the button.
                    count <= 0;
                    if(button_in = '1') then
                        pulse_out <= '1';
                    else
                        pulse_out <= '0';
                    end if;
                    state <= idle;  
                else
                    count <= count + 1;
                    pulse_out <= '0';
                end if; 
        end case;       
    end if;        
end process;                  
                                                                                
end architecture behav;