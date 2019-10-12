library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UniversalCounter is
Port ( 
	clock: in std_logic;
	enable: in std_logic;
	reset: in std_logic;
	up: in std_logic;
	load: in std_logic;
	data: in std_logic_vector(3 downto 0);
	
	count: out std_logic_vector(3 downto 0);
	over: out std_logic
);
end UniversalCounter;

architecture Behavioral of UniversalCounter is

begin

	process is
		variable n : std_logic_vector(3 downto 0);
		variable reset_n : std_logic := '0';
	begin
		wait on clock until clock = '1';
		
			reset_n := '0';
			if reset = '1' then -- the counter is reset
				n := "0000";
			elsif enable = '1' then -- the counter is enable
				if load = '1' then
					n := data;
				else
					if up = '1' then -- positive increment
						if n = "1111" then
							n := "0000";
							reset_n := '1';
						else
							n := std_logic_vector(unsigned(n) + 1);
						end if;
					else -- negative increment
						if n = "0000" then
							n := "1111";
							reset_n := '1';
						else
							n := std_logic_vector(unsigned(n) - 1);
						end if;
					end if;
				end if;
			end if;
		
		count <= n; -- counter
		over <= reset_n; -- overflow/underflow
	end process;

end Behavioral;
