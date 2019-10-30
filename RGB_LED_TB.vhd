-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity RGB_LED_tb is
end;

architecture bench of RGB_LED_tb is

  component RGB_LED
  Port (
  	CLK, RESET, BACKWARDS_LOOP, ALARM: in std_logic;
  	SPEED : in std_logic_vector(2 downto 0);
  	R, G, B : out std_logic_vector(7 downto 0)
  );
  end component;

  signal CLK, RESET, BACKWARDS_LOOP, ALARM: std_logic;
  signal SPEED: std_logic_vector(2 downto 0);
  signal R, G, B: std_logic_vector(7 downto 0) ;

  constant CLK_PERIOD: time := 1 ns;
  signal stop_the_clock: boolean := false;

begin

  uut: RGB_LED port map ( CLK            => CLK,
                          RESET          => RESET,
                          BACKWARDS_LOOP => BACKWARDS_LOOP,
                          ALARM          => ALARM,
                          SPEED          => SPEED,
                          R              => R,
                          G              => G,
                          B              => B );

  stimulus: process
  begin
  
    -- Put initialisation code here

    --RESET <= '1';
    --wait for 5 ns;
    RESET <= '0';
    BACKWARDS_LOOP <= '0';
    SPEED <= "001";
    ALARM <= '0';
    
    wait for 100 ns;
    alarm <= '1';
    --SPEED <= "011";
        
    wait for 100 ns;
    alarm <= '0';
    --SPEED <= "101";
     wait for 100 ns;

    -- Put test bench stimulus code here

    -- stop_the_clock <= true;
    -- wait;
  end process;

  CLK_generation: process
    begin
        CLK <='1';
        wait for CLK_PERIOD/2;
        CLK <= '0';
        wait for CLK_PERIOD/2;
    end process CLK_generation;

end;