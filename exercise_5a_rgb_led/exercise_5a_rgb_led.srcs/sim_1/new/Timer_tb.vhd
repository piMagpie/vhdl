-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Timer_tb is
end;

architecture bench of Timer_tb is

  component Timer
      generic (
          TRIGGER_COUNT:    natural
      );
      port (
          CLK:        in      std_logic;
          RESET:      in      std_logic;
          INTERRUPTION:      OUT  std_logic
      );
  end component;

  signal CLK: std_logic;
  signal RESET: std_logic;
  signal INTERRUPTION: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;
  constant CLK_PERIOD: time := 10 ns;

begin

  -- Insert values for generic parameters !!
  uut: Timer generic map ( TRIGGER_COUNT =>  10)
                port map ( CLK           => CLK,
                           RESET         => RESET,
                           INTERRUPTION  => INTERRUPTION );

  stimulus: process
  begin
  
    -- Put initialisation code here
    RESET <= '0';
    wait for CLK_PERIOD * 15;
    RESET <= '1';
    wait for CLK_PERIOD;
  end process;

   CLK_generation: process
    begin
        CLK <='1';
        wait for CLK_PERIOD/2;
        CLK <= '0';
        wait for CLK_PERIOD/2;
    end process CLK_generation;
end;
  