library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Temperature_Controller_tb is
end;

architecture bench of Temperature_Controller_tb is

  component Temperature_Controller
  Port (
  	CLK 				: in std_logic;
  	RESET				: in std_logic;
  	CALIBRATION 		: in std_logic;
  	DISABLE_ALARM 		: in std_logic;
  	DISABLE_BUZZER		: in std_logic;
  	ANALOG_TEMP			: in std_logic_vector(7 downto 0);
  	
  	R, G, B : out std_logic_vector(7 downto 0);
  	BUZZER : out std_logic
  );
  end component;

  signal CLK: std_logic;
  signal RESET: std_logic;
  signal CALIBRATION: std_logic;
  signal DISABLE_ALARM: std_logic;
  signal DISABLE_BUZZER: std_logic;
  signal ANALOG_TEMP: std_logic_vector(7 downto 0);
  signal R, G, B: std_logic_vector(7 downto 0);
  signal BUZZER: std_logic ;

  constant CLK_PERIOD: time := 1 ns;
begin

  uut: Temperature_Controller port map ( CLK             => CLK,
                                         RESET           => RESET,
                                         CALIBRATION     => CALIBRATION,
                                         DISABLE_ALARM   => DISABLE_ALARM,
                                         DISABLE_BUZZER  => DISABLE_BUZZER,
                                         ANALOG_TEMP     => ANALOG_TEMP,
                                         R               => R,
                                         G               => G,
                                         B               => B,
                                         BUZZER          => BUZZER );

  stimulus: process
  begin
    RESET <= '0';
    CALIBRATION <= '0';
    DISABLE_ALARM <= '0';
    DISABLE_BUZZER <= '0';
    DISABLE_BUZZER <= '0';
    
    ANALOG_TEMP <= "00100001"; -- 33 "00011111"; -- 31
    -- Put initialisation code here
    wait for CLK_PERIOD * 350;
    
    -- danger warning
    ANALOG_TEMP <= "00100100"; -- 36
    wait for CLK_PERIOD * 60;

    -- check the alarm
    DISABLE_ALARM <= '1';
    wait for CLK_PERIOD;
    DISABLE_ALARM <= '0';
    
    -- cool down
    --ANALOG_TEMP <= "00000000"; -- 33
    --wait for CLK_PERIOD * 100;
    
    -- danger
    --ANALOG_TEMP <= "11111111"; -- 40
    -- wait for CLK_PERIOD * 10;
    
    -- cool down
    -- ANALOG_TEMP <= "00000000"; -- 33
    -- wait for CLK_PERIOD * 1000;
            
    -- Put test bench stimulus code here
    
    wait for CLK_PERIOD * 500;
  end process;

  clocking: process
    begin
        CLK <='1';
        wait for CLK_PERIOD/2;
        CLK <= '0';
        wait for CLK_PERIOD/2;
    end process;

end;