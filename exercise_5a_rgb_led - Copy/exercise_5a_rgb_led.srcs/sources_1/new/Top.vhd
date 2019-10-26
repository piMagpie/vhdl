library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Top is 

    Port
    (sysclk:      in std_logic;
     sw:           in std_logic_vector(3 downto 0); -- speed 1
     -- speed 3
     -- speed 5
     -- alarm
     led5_r:      out std_logic;
     led5_g:      out std_logic;
     led5_b:      out std_logic
     );
end Top;

architecture Behavioral of Top is

component RGB_LED
  Port (
  	CLK, RESET, BACKWARDS_LOOP, ALARM: in std_logic;
  	SPEED : in std_logic_vector(2 downto 0);
  	R, G, B : out std_logic_vector(7 downto 0)
  );
  end component;

  signal r, g, b : std_logic_vector(7 downto 0) := (others => '0');
  signal speed_t : std_logic_vector(2 downto 0) := "001";
begin       
       uut_t: RGB_LED port map ( CLK            => sysclk,
                                 RESET          => sw(0),
                                 BACKWARDS_LOOP => sw(1),
                                 ALARM          => sw(2),
                                 SPEED          => speed_t,
                                 R              => R,
                                 G              => G,
                                 B              => B );
               
process(sysclk,r,g,b)
variable count: integer:=0;
begin

if rising_edge(sysclk) then
       count:=count+1;
        if count<to_integer(unsigned(r)) then
            led5_r<='1';
        else
            led5_r<='0';
        end if;
        if count<to_integer(unsigned(g)) then
            led5_g<='1';
        else
            led5_g<='0';
        end if;
        if count<to_integer(unsigned(b)) then
            led5_b<='1';
        else
            led5_b<='0';
        end if;
        if count<255 then
            count:=0;
        end if;
end if; 
end process;
end Behavioral;
