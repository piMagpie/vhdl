library IEEE;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
-- use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;               -- Needed for shifts

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Temperature_Controller is
Port ( 
	-- inputs
	CLK 				: in std_logic;
	
	on_off_switch				: in std_logic; -- todo
	CALIBRATION 		: in std_logic;
	DISABLE_ALARM 		: in std_logic;
	DISABLE_BUZZER		: in std_logic; -- todo
	
	ANALOG_TEMP			: in std_logic_vector(7 downto 0);
	
	
	-- outputs
	R, G, B : out std_logic_vector(7 downto 0);
	BUZZER : out std_logic
);
end Temperature_Controller;

architecture Behavioral of Temperature_Controller is
	type STATE is (STANDBY_STATE, CALIBRATION_STATE, ORANGE_STATE, GREEN_STATE, RED_STATE);
	type COLOR is (RED, ORANGE, GREEN, BLUE, NONE);
		
	function getColor(s: STATE) return COLOR is
		variable c : COLOR;
	begin
		case s is
		  when STANDBY_STATE =>  c := NONE;
		  when CALIBRATION_STATE =>  c := BLUE;
		  when ORANGE_STATE =>    c := ORANGE;
		  when GREEN_STATE =>    c := GREEN;
		  when RED_STATE =>    c := RED;
		  when others => c := NONE;
		end case;
		return c;
	end function getColor;
    
    component Timer is
        generic (
            MS_TICKS:    natural;
            MS_TRIGGER_COUNT:    natural
        );
        port (
            CLK:        in      std_logic;
            RESET:      in      std_logic;
            INTERRUPTION:      OUT  std_logic
        );
    end component;
    
	-- Initially a calibration is performed taking 42 measurements and calculating the mean
	constant CALIBRATION_MEASUREMENTS : natural := 16;
	
	-- TEMPERATURES SIGNALS
	signal p_REFERENCE_TEMP : natural := 0;
	signal p_WARNING_TEMP : natural := 0;
	signal p_DANGER_TEMP : natural := 0;

	
	-- FREQUENCES
	constant ticks_in_ms : natural := 125000;
	
	constant CALIBRATION_FREQ : natural := 500; -- 500 ms
	
	-----------------------------------------------
	-- Warning temperature frequency
	constant WARN_TEMP_FREQ : natural := 5000; -- 5000 ms 5 sec
	-- Cool temperature frequency
	constant COOL_TEMP_FREQ : natural := 10000; -- 10000 ms 10 sec
	 -- When the alarm is turnoff the temperature will not be measured for 30 sec
	constant NO_MEASURE_TEMP_FREQ : natural := 30000; -- 30000 ms 30 sec
	constant CALIBRATION_BLINK_FREQ : natural := 500; -- 500 ms
	-----------------------------------------------

	
	signal p_CALIBRATION_INTERRUPTION : std_logic := '0';
	signal p_WARM_INTERRUPTION : std_logic := '0';
	signal p_COOL_INTERRUPTION : std_logic := '0';
	signal p_NO_MEASURE_TEMP_INTERRUPTION : std_logic := '0';

	
	signal p_CURRENT_STATE : STATE := STANDBY_STATE;
	signal p_NEW_STATE : STATE := STANDBY_STATE;
	signal p_PREVIOUS_STATE : STATE := STANDBY_STATE;
		
	signal p_CALIBRATION_TIMER_RESET : std_logic := '0';
	signal p_WARM_TIMER_RESET : std_logic := '0';
	signal p_COOL_TIMER_RESET : std_logic := '0';
	signal p_NO_MEASURE_TIMER_RESET : std_logic := '0';

	
	-- signal p_TIMER_CALIBRATION_INTERRUPTION : std_logic := '0';
	signal p_CALIBRATION_DONE_ALERT : std_logic := '0';
	signal p_DANGER_ALERT : std_logic := '0';
	signal p_WARM_ALERT : std_logic := '0';
	signal p_COOL_ALERT : std_logic := '0';
	signal p_NO_MEASURE_ALERT : std_logic := '0';
	signal p_CALIBRATION_ALERT : std_logic := '0';
	-- signal p_NO_MEASURE_TEMP_ALERT : std_logic := '0';
	
    
	signal p_CALIBRAITON_BLINK_RESET : std_logic := '0';
	signal p_TIME_CALIBRATION_BLINK_ENDED : std_logic := '0';
begin

    CALIBRATION_TIMER: Timer
        generic map (   MS_TICKS   =>  ticks_in_ms, -- 1 ms is X
                        MS_TRIGGER_COUNT => CALIBRATION_FREQ) -- number of ms
        port map    (   CLK             =>  CLK,
                        RESET           =>  p_CALIBRATION_TIMER_RESET,
                        INTERRUPTION    =>  p_CALIBRATION_INTERRUPTION
                     );
					 
	WARM_TIMER: Timer
		generic map (     MS_TICKS   =>  ticks_in_ms, -- 1 ms is X
                          MS_TRIGGER_COUNT =>  WARN_TEMP_FREQ)
		port map    (   CLK             =>  CLK,
						RESET           =>  p_WARM_TIMER_RESET,
						INTERRUPTION    =>  p_WARM_INTERRUPTION
					 );
	
	COOL_TIMER: Timer
		generic map (    MS_TICKS   =>  ticks_in_ms, -- 1 ms is X
                         MS_TRIGGER_COUNT =>  COOL_TEMP_FREQ)
		port map    (   CLK             =>  CLK,
						RESET           =>  p_COOL_TIMER_RESET,
						INTERRUPTION    =>  p_COOL_INTERRUPTION
					 );
					 
	ALARM_OFF_TIMER: Timer
         generic map (    MS_TICKS   =>  ticks_in_ms, -- 1 ms is X
                          MS_TRIGGER_COUNT =>  NO_MEASURE_TEMP_FREQ)
         port map    (   CLK             =>  CLK,
                         RESET           =>  p_NO_MEASURE_TIMER_RESET,
                         INTERRUPTION    =>  p_NO_MEASURE_TEMP_INTERRUPTION
                      );
                      
    -- BLINKING
    CALIBRATION_BLINKING_TIMER: Timer
             generic map (   MS_TICKS   =>  ticks_in_ms, -- 1 ms is X
                             MS_TRIGGER_COUNT => CALIBRATION_BLINK_FREQ)
             port map    (   CLK             =>  CLK,
                             RESET           =>  p_CALIBRAITON_BLINK_RESET,
                             INTERRUPTION    =>  p_TIME_CALIBRATION_BLINK_ENDED
                          );
                                          
	
	-- contains the current state and assigns the new state
	registers_process: process(CLK) is
	begin
		if rising_edge(CLK) then
			p_CURRENT_STATE <= p_NEW_STATE;
		end if;
	end process;
	
	
	calibration_process: process(CLK)
		variable counter : natural := 0;
		variable sum_temp : std_logic_vector(11 downto 0) := (others => '0'); -- "000000001111";
		variable avg_temp : std_logic_vector(7 downto 0) := (others => '0');

	begin
		if rising_edge(CLK) then
			p_CALIBRATION_DONE_ALERT <= '0';
			
			if p_CURRENT_STATE = CALIBRATION_STATE then
				-- scan the temperature
				if p_CALIBRATION_INTERRUPTION = '1' then
					counter := counter + 1;
					sum_temp := std_logic_vector(unsigned(sum_temp) + unsigned(ANALOG_TEMP));
					if counter = CALIBRATION_MEASUREMENTS then
						p_CALIBRATION_DONE_ALERT <= '1';
						sum_temp := std_logic_vector(SHIFT_RIGHT (unsigned(sum_temp), 4)); -- "000000111111";--
						avg_temp := sum_temp(7 downto 0);
						sum_temp := (others => '0');
						counter := 0;
					end if;
				end if;
			else
				counter := 0;
				sum_temp := (others => '0');
			end if;
			p_REFERENCE_TEMP <= to_integer(unsigned(avg_temp));
			p_WARNING_TEMP <= to_integer(unsigned(avg_temp )) + 50;
			p_DANGER_TEMP <= to_integer(unsigned(avg_temp)) + 100;
			if p_WARNING_TEMP < to_integer(unsigned(avg_temp )) then
			 p_WARNING_TEMP <= 255;
			end if;
			
			if p_DANGER_TEMP < to_integer(unsigned(avg_temp)) then
                p_DANGER_TEMP <= 255;
            end if;
		end if;
	end process;
	
	-- 	type STATE is (STANDBY_STATE, CALIBRATION_STATE, ORANGE_STATE, GREEN_STATE, RED_STATE);
	change_state: process(CLK) -- p_DANGER_ALERT, p_WARM_ALERT, p_COOL_ALERT, p_CALIBRATION_DONE_ALERT

	begin
		if rising_edge(CLK) then
			if p_CALIBRATION_ALERT = '1' 
			         or p_CURRENT_STATE = STANDBY_STATE then -- INITIAL STATE
				p_NEW_STATE <= CALIBRATION_STATE;
			elsif p_CURRENT_STATE = CALIBRATION_STATE then -- CALIBRATION
				if p_CALIBRATION_DONE_ALERT = '1' then
					p_NEW_STATE <= ORANGE_STATE;
				end if;
			elsif p_CURRENT_STATE = ORANGE_STATE then
			    if p_NO_MEASURE_ALERT = '1' then
			         p_NEW_STATE <= GREEN_STATE;
				elsif p_DANGER_ALERT = '1' or p_WARM_ALERT = '1' then
					p_NEW_STATE <= RED_STATE;
				elsif p_COOL_ALERT = '1'then
					p_NEW_STATE <= GREEN_STATE;
				end if;
			elsif p_CURRENT_STATE = GREEN_STATE then
				if p_DANGER_ALERT = '1' or p_WARM_ALERT = '1' then
					p_NEW_STATE <= RED_STATE;
				end if;
			elsif p_CURRENT_STATE = RED_STATE then
			    if p_NO_MEASURE_ALERT = '1' then
                    p_NEW_STATE <= GREEN_STATE;
				elsif p_COOL_ALERT = '1' then
					p_NEW_STATE <= ORANGE_STATE;
				end if;
			end if;
		end if;
	end process;
	
	-- Generates the following alerts:
	-- p_DANGER_ALERT, p_WARM_ALERT, p_COOL_ALERT, p_CALIBRATION_DONE_ALERT
	generate_temp_alerts: process(CLK)
	   variable no_measure_temp : std_logic := '0';
	begin
		if rising_edge(CLK) then
		    p_CALIBRATION_ALERT <= '0';
		    p_NO_MEASURE_TIMER_RESET <= '0';
            p_NO_MEASURE_ALERT <= '0';
		    if CALIBRATION = '1' then
		        p_CALIBRATION_ALERT <= '1';
		        p_NO_MEASURE_TIMER_RESET <= '0';
                p_NO_MEASURE_ALERT <= '0';
		    elsif DISABLE_ALARM = '1' and no_measure_temp = '0' then
		        no_measure_temp :=  '1';
		        -- reset time to count 30 seconds
		        p_NO_MEASURE_TIMER_RESET <= '1';
		        p_NO_MEASURE_ALERT <= '1';
		    end if;
		    
			p_WARM_TIMER_RESET <= '0';
			p_COOL_TIMER_RESET <= '0';
			p_WARM_ALERT <= '0';
			p_COOL_ALERT <= '0';
			p_DANGER_ALERT <= '0';
			
			if no_measure_temp = '0' then
                if p_CURRENT_STATE = ORANGE_STATE then -- ORANGE
                    if unsigned(ANALOG_TEMP) > p_DANGER_TEMP then
                        p_WARM_TIMER_RESET <= '1';
                        p_COOL_TIMER_RESET <= '1';
                        p_DANGER_ALERT <= '1';
                    elsif unsigned(ANALOG_TEMP) > p_WARNING_TEMP then
                        p_COOL_TIMER_RESET <= '1';
                        if p_WARM_INTERRUPTION = '1' then
                            p_WARM_ALERT <= '1';
                        end if;
                    else
                        p_WARM_TIMER_RESET <= '1';
                        if p_COOL_INTERRUPTION = '1' then
                            p_COOL_ALERT <= '1';
                        end if;
                    end if;
                elsif p_CURRENT_STATE = GREEN_STATE then -- GREEN
                    if unsigned(ANALOG_TEMP) > p_DANGER_TEMP then
                        p_WARM_TIMER_RESET <= '1';
                        p_COOL_TIMER_RESET <= '1';
                        p_DANGER_ALERT <= '1';
                    elsif unsigned(ANALOG_TEMP) > p_WARNING_TEMP then
                        p_COOL_TIMER_RESET <= '1';
                        if p_WARM_INTERRUPTION = '1' then
                            p_WARM_ALERT <= '1';
                        end if;
                    else
                        p_WARM_TIMER_RESET <= '1';
                    end if;
                elsif p_CURRENT_STATE = RED_STATE then -- RED
                    if unsigned(ANALOG_TEMP) > p_DANGER_TEMP then
                        p_WARM_TIMER_RESET <= '1';
                        p_COOL_TIMER_RESET <= '1';
                    elsif unsigned(ANALOG_TEMP) > p_WARNING_TEMP then
                        p_COOL_TIMER_RESET <= '1';
                        if p_WARM_INTERRUPTION = '1' then
                            p_WARM_ALERT <= '1';
                        end if;
                    else
                        p_WARM_TIMER_RESET <= '1';
                        if p_COOL_INTERRUPTION = '1' then
                            p_COOL_ALERT <= '1';
                        end if;
                    end if;
                else
                    p_WARM_TIMER_RESET <= '1';
                    p_COOL_TIMER_RESET <= '1';
                end if;
            else --  -- no_measure_temp = '1' -- if the alarm is off
                if p_NO_MEASURE_TEMP_INTERRUPTION = '1' then -- check that the 30 secons have expired
                    no_measure_temp := '0';
                end if;
            end if;
		end if;
	end process;
	
	
	-- shows the color associated with an state
	led_process: process(p_CURRENT_STATE, p_TIME_CALIBRATION_BLINK_ENDED)
	    procedure showColor(c: color) is
	    begin
	       case c is
                  when RED            =>        R <= (others => '1'); G <= (others => '0'); B  <= (others => '0'); -- R/RED (255, 0, 0)
                  when GREEN        =>        R <= (others => '0'); G <= (others => '1'); B  <= (others => '0'); -- G/GREEN (0, 255, 0)
                  when BLUE            =>        R <= (others => '0'); G <= "10111111"; B  <= (others => '1'); -- â€" B/BLUE (0, 191, 255)
                  when ORANGE        =>        R <= (others => '1'); G <= "10000000"; B  <= (others => '0'); -- O/ORANGE (255, 128, 0)
                  when NONE         =>        R <= (others => '0'); G <= (others => '0'); B  <= (others => '0');
                  when others         =>        R <= (others => '0'); G <= (others => '0'); B  <= (others => '0');
                end case;
	    end procedure showColor;
		
		variable c : COLOR;
		variable calibration_blinkFlag : std_logic := '1';
		variable alarm_blinkFlag : std_logic := '1';
	begin
		c := getColor(p_CURRENT_STATE);
		if p_CURRENT_STATE = CALIBRATION_STATE then
              if p_TIME_CALIBRATION_BLINK_ENDED = '1' then
                calibration_blinkFlag := not calibration_blinkFlag;
              end if;
              if calibration_blinkFlag = '0' then
                c:= NONE;
              end if;            
        end if;
		showColor(c);
		
		-- ALARM LED
		BUZZER <= '0';
		if p_CURRENT_STATE = RED_STATE then
            if p_TIME_CALIBRATION_BLINK_ENDED = '1' then
                alarm_blinkFlag := not alarm_blinkFlag;
            end if;
              if alarm_blinkFlag = '1' then
                BUZZER <= '1';
              end if;             
        end if;
		
	end process;
end Behavioral;
