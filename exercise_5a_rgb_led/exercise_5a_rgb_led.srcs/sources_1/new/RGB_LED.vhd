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
	SPEED : in std_logic_vector(2 downto 0);
	
	-- outputs
	R, G, B : out std_logic_vector(7 downto 0)
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
		return c;
	end function getColor;
    
    component Timer is
        generic (
            TRIGGER_COUNT:    natural
        );
        port (
            CLK:        in      std_logic;
            RESET:      in      std_logic;
            INTERRUPTION:      OUT  std_logic
        );
    end component;
    
	signal p_CURRENT_STATE : STATE := STANDBY_STATE;
	signal p_NEW_STATE : STATE := STANDBY_STATE;
		
	signal p_TIMER_RESET : std_logic := '0';

	signal p_TIMER1_INTERRUPTION : std_logic := '0';
	signal p_TIMER01_INTERRUPTION : std_logic := '0';
	signal p_TIMER3_INTERRUPTION : std_logic := '0';
	signal p_TIMER03_INTERRUPTION : std_logic := '0';
	signal p_TIMER5_INTERRUPTION : std_logic := '0';
	signal p_TIMER05_INTERRUPTION : std_logic := '0';
	signal p_TIMER4_INTERRUPTION : std_logic := '0';
	signal p_TIMER7_INTERRUPTION : std_logic := '0';
	
	constant Frequency : natural := 125000000;
	constant Frequency1 : natural := Frequency * 1;
	constant Frequency3 : natural := Frequency * 3;
	constant Frequency5 : natural := Frequency * 5;
	constant Frequency4 : natural := Frequency * 4;
	constant Frequency7 : natural := Frequency * 7;

    constant Frequency01 : natural := 125000000; -- 1 second
	constant Frequency03 : natural := Frequency01 * 3; -- 3 seconds
	constant Frequency05 : natural := Frequency01 * 5; -- 5 seconds
	
	signal p_TIME_STATE_ENDED : std_logic := '0';--p_TIMER4_INTERRUPTION;
begin

    U1: Timer
        generic map (   TRIGGER_COUNT   =>  Frequency1)
        port map    (   CLK             =>  CLK,
                        RESET           =>  p_TIMER_RESET,
                        INTERRUPTION    =>  p_TIMER1_INTERRUPTION
                     );
					 
	U01: Timer
        generic map (   TRIGGER_COUNT   =>  Frequency01)
        port map    (   CLK             =>  CLK,
                        RESET           =>  p_TIMER_RESET,
                        INTERRUPTION    =>  p_TIMER01_INTERRUPTION
                     );
    
	U3: Timer
        generic map (   TRIGGER_COUNT   =>  Frequency3)
        port map    (   CLK             =>  CLK,
                        RESET           =>  p_TIMER_RESET,
                        INTERRUPTION    =>  p_TIMER3_INTERRUPTION
                     );
					 
	U03: Timer
        generic map (   TRIGGER_COUNT   =>  Frequency03)
        port map    (   CLK             =>  CLK,
                        RESET           =>  p_TIMER_RESET,
                        INTERRUPTION    =>  p_TIMER03_INTERRUPTION
                     );
	
	U5: Timer
        generic map (   TRIGGER_COUNT   =>  Frequency5)
        port map    (   CLK             =>  CLK,
                        RESET           =>  p_TIMER_RESET,
                        INTERRUPTION    =>  p_TIMER5_INTERRUPTION
                     );
	U05: Timer
        generic map (   TRIGGER_COUNT   =>  Frequency05)
        port map    (   CLK             =>  CLK,
                        RESET           =>  p_TIMER_RESET,
                        INTERRUPTION    =>  p_TIMER05_INTERRUPTION
                     );
	
	U4: Timer
        generic map (   TRIGGER_COUNT   =>  Frequency4)
        port map    (   CLK             =>  CLK,
                        RESET           =>  p_TIMER_RESET,
                        INTERRUPTION    =>  p_TIMER4_INTERRUPTION
					);
					
	U7: Timer
        generic map (   TRIGGER_COUNT   =>  Frequency7)
        port map    (   CLK             =>  CLK,
                        RESET           =>  p_TIMER_RESET,
                        INTERRUPTION    =>  p_TIMER7_INTERRUPTION
					);
	
	-- contains the current state and assigns the new state
	registers_process: process(CLK) is
	begin
		if rising_edge(CLK) then
			if RESET = '1' then
				p_CURRENT_STATE <= STANDBY_STATE;
			else
				p_CURRENT_STATE <= p_NEW_STATE;
			end if;
		end if;
	end process;
	
	-- selects the correct timer interruption
	timer_selector: process(CLK)
	begin
		if rising_edge(CLK) then
			if p_CURRENT_STATE = STANDBY_STATE then
				p_TIME_STATE_ENDED  <= p_TIMER4_INTERRUPTION;		
			elsif p_CURRENT_STATE = ALARM_STATE then
				p_TIME_STATE_ENDED  <= p_TIMER7_INTERRUPTION; -- todo
			else
				if SPEED = "001" then
					p_TIME_STATE_ENDED  <= p_TIMER1_INTERRUPTION;
				elsif SPEED = "011" then
					p_TIME_STATE_ENDED  <= p_TIMER3_INTERRUPTION;
				elsif SPEED = "101" then
                    p_TIME_STATE_ENDED  <= p_TIMER5_INTERRUPTION;
				else
					p_TIME_STATE_ENDED  <= p_TIMER1_INTERRUPTION; -- by the fault 1
				end if;
			end if;
		end if;
	end process;
	
	-- reset all the timers when the current state or the speed changes.
	timer_reseter: process(CLK, p_CURRENT_STATE)
		variable previous_state : STATE;
	begin
		if rising_edge(CLK) then
			if previous_state = p_CURRENT_STATE then
				p_TIMER_RESET <= '0';
			else
			    previous_state := p_CURRENT_STATE;
				p_TIMER_RESET <= '1';
			end if;
		
		end if;
    end process;
    	
	-- changes the state when there is a timer interruption
	cbl_process : process(p_TIME_STATE_ENDED, RESET)
		variable p_UP  : std_logic := '1';
	begin
	    if reset = '1' then
	       p_NEW_STATE <= STANDBY_STATE;
		elsif p_TIME_STATE_ENDED = '1' then
			if p_CURRENT_STATE = STANDBY_STATE then
				p_UP := '1';
			end if;
			if ( BACKWARDS_LOOP = '0' ) then -- A B C -> A B C
				if p_CURRENT_STATE = PURPLE_STATE then
					p_NEW_STATE <= RED_STATE;
				else
					p_NEW_STATE <= STATE'SUCC(p_CURRENT_STATE);    
				end if;
			else -- A B C -> B A -> B C
				if ( p_UP = '1' ) then
					if p_CURRENT_STATE = PURPLE_STATE then
						p_NEW_STATE <= BLUE_STATE;
						p_UP := '0';
					else
						p_NEW_STATE <= STATE'SUCC(p_CURRENT_STATE);    
					end if;
				else
					if p_CURRENT_STATE = RED_STATE then
						p_NEW_STATE <= YELLOW_STATE;
						p_UP := '1';
					else
						p_NEW_STATE <= STATE'PRED(p_CURRENT_STATE);    
					end if;
				end if;
			end if;
		end if;
	end process;
	
	-- shows the color associated with an state
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
		  when NONE 	    =>		R <= (others => '0'); G <= (others => '0'); B  <= (others => '0');
		  when others 	    =>		R <= (others => '0'); G <= (others => '0'); B  <= (others => '0');
		end case;
	end process;
end Behavioral;
