library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm is
Port ( 
	clk:	in std_logic;
    value:    in std_logic_vector(7 downto 0);
    pwm:    out std_logic
);
end pwm;

architecture Behavioral of pwm is

begin
    process(clk, value)
        variable count: integer:=0;
    begin
    
        if rising_edge(clk) then
               count:=count+1;
                if count < to_integer(unsigned(value)) then
                    pwm <='1';
                else
                    pwm <='0';
                end if;
                if count = 255 then
                    count:=0;
                end if;
        end if; 
    end process;

end Behavioral;
