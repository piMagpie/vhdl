library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RGB_LED is
Port ( 
	-- inputs
	CLK, RESET, BACKWARDS_LOOP, ALARM: in std_logic;
	SPEED : in std_logic_vector(3 downto 0);
	
	-- outputs
	R, G, B : out std_logic_vector(7 downto 0);
);
end RGB_LED;

architecture Behavioral of RGB_LED is
	type STATE is (ALARM_STATE, STANDBY_STATE, RED_STATE, YELLOW_STATE, GREEN_STATE, BLUE_STATE, PURPLE_STATE);
	type COLOR is (WHITE, RED, YELLOW, GREEN, BLUE, PURPLE, NONE);
		
	function getColor(s: STATE) return COLOR is
		variable c : COLOR;
	begin
		case s is
		  when ALARM_STATE | STANDBY_STATE =>  c := WHITE;
		  when RED_STATE =>    c := RED;
		  when YELLOW_STATE =>    c := YELLOW;
		  when GREEN_STATE =>    c := GREEN;
		  when BLUE_STATE =>    c := BLUE;
		  when PURPLE_STATE =>    c := PURPLE;
		  when others => c := NONE;
		end case;
	end function getColor;

	signal p_CURRENT_STATE : STATE := STANDBY_STATE;
	signal p_NEW_STATE : STATE := STANDBY_STATE;
		
	signal p_TIMER_INTERRUPTION std_logic := '0';
begin

	registers_process: process(CLK) is
	begin
		if rising_edge(CLK) then
			if RESET then
				p_CURRENT_STATE <= STANDBY_STATE;
			else
				
					p_CURRENT_STATE <= p_NEW_STATE;
				end if;
			end if;
		end if;
	end process;
	
	cbl_process : process(p_TIMER_INTERRUPTION)
		variable p_UP  : std_logic := '1';
	begin
		if p_TIMER_INTERRUPTION = '1' then
			if p_CURRENT_STATE = STANDBY_STATE then
				p_UP := '1';
			end if;
			if ( BACKWARDS_LOOP = '0' ) then -- A B C -> A B C
				if p_CURRENT_STATE = PURPLE then
					p_NEW_STATE := RED;
				else
					p_NEW_STATE := STATE'SUCC(p_CURRENT_STATE);    
				end if;
			else -- A B C -> B A -> B C
				if ( p_UP = '1' ) then
					if p_CURRENT_STATE = PURPLE then
						p_NEW_STATE := BLUE;
						p_UP := '0';
					else
						p_NEW_STATE := STATE'SUCC(p_CURRENT_STATE);    
					end if;
				else
					if p_CURRENT_STATE = RED then
						p_NEW_STATE := YELLOW;
						p_UP := '1';
					else
						p_NEW_STATE := STATE'PRED(p_CURRENT_STATE);    
					end if;
				end if;
			end if;
		end if;
	end process;
	
	led_process: process(p_CURRENT_STATE)
		variable c : COLOR;
	begin
		c := getColor(p_CURRENT_STATE);
		case c is
		  when WHITE 		=>  	R <= (others => '1'); G <= (others => '1'); B  <= (others => '1');
		  when RED			=>    	R <= (others => '1'); G <= (others => '0'); B  <= (others => '0');
		  when YELLOW		=>    	R <= (others => '1'); G <= (others => '1'); B  <= (others => '0');
		  when GREEN		=>    	R <= (others => '0'); G <= (others => '1'); B  <= (others => '0');
		  when BLUE			=>    	R <= (others => '0'); G <= (others => '0'); B  <= (others => '1');
		  when PURPLE		=>		R <= "10000000"; G <= (others => '0'); B  <= "10000000";
		  when NONE|others 	=>		R <= (others => '0'); G <= (others => '0'); B  <= (others => '0');
		end case;
	end process;
end Behavioral;
