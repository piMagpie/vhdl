library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
	Port ( 
		CLK : in STD_LOGIC;
		switch_red : in STD_LOGIC;
		switch_green : in STD_LOGIC;
		switch_blue	: in STD_LOGIC;
		adc_input	: in STD_LOGIC;
		led5_r : out STD_LOGIC;
		led5_g : out STD_LOGIC;
		led5_b : out STD_LOGIC
	);
end top;

architecture top_arch of top is

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

  signal RESET: std_logic;
  signal CALIBRATION: std_logic;
  signal DISABLE_ALARM: std_logic;
  signal DISABLE_BUZZER: std_logic;
  signal ANALOG_TEMP: std_logic_vector(7 downto 0);
  signal R, G, B: std_logic_vector(7 downto 0);
  signal BUZZER: std_logic ;



	-- Load the PWM generator component
	component pwm is
		Port (
			clk:	in std_logic;
			value:	in std_logic_vector(7 downto 0);
			pwm:	out std_logic
		);
	end component pwm;
	
	-- load the XADC IP Wrapper
	component design_1_wrapper is
		port (
			daddr_in_0 : in STD_LOGIC_VECTOR ( 6 downto 0 );
			dclk_in_0 : in STD_LOGIC;
			do_out_0 : out STD_LOGIC_VECTOR ( 15 downto 0 );
			drdy_out_0 : out STD_LOGIC;
			vauxn14_0 : in STD_LOGIC;
			vauxp14_0 : in STD_LOGIC
		);
	end component design_1_wrapper;
	
	-- Intensity comes from XADC value
	-- and corresponds to all three colors (R,G,B)
	signal intensity : std_logic_vector(7 downto 0) := "11111111";
	signal intensity_std_logic : std_logic;
	
	-- XADC signals (data ready, data)
	signal drdy: std_logic := '0';
	signal xadc_val: std_logic_vector(15 downto 0);
begin

      temp_controller: Temperature_Controller port map ( CLK             => CLK,
                                         RESET           => RESET,
                                         CALIBRATION     => CALIBRATION,
                                         DISABLE_ALARM   => DISABLE_ALARM,
                                         DISABLE_BUZZER  => DISABLE_BUZZER,
                                         ANALOG_TEMP     => ANALOG_TEMP,
                                         R               => R,
                                         G               => G,
                                         B               => B,
                                         BUZZER          => BUZZER );
                                         
	-- Each color equals intensity unless the switch is set to 0
	led5_r <= intensity_std_logic when switch_red = '1' else '0';
	led5_g <= intensity_std_logic when switch_green = '1' else '0';
	led5_b <= intensity_std_logic when switch_blue = '1' else '0';

	-- ADC Output
	intensity <= xadc_val(15 downto 8) when drdy='1' else intensity;
	
	-- components
	pwm_red: pwm port map(
		clk=>clk,
		value=>intensity,
		pwm=>intensity_std_logic
	);
	
	xadc: design_1_wrapper port map(
			daddr_in_0 => "0011110",
			dclk_in_0 => clk,
			do_out_0 => xadc_val,
			drdy_out_0 => drdy,
			vauxn14_0 => 'Z',
			vauxp14_0 => adc_input
		);
end top_arch;
