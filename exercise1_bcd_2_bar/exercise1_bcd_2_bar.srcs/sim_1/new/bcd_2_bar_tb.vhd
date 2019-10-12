----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2019 10:37:46 AM
-- Design Name: 
-- Module Name: bcd_2_bar_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bcd_2_bar_tb is
--  Nothing here
end bcd_2_bar_tb;

architecture Behavioral of bcd_2_bar_tb is
	component bcd_2_bar
		port (
			bcd: IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- values from 0 to 9.
			bar_graph: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
	end component;
	
	signal input_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal output_tb : STD_LOGIC_VECTOR(8 DOWNTO 0);
    
begin
	

	DUT: bcd_2_bar port map( bcd => input_tb, bar_graph => output_tb);
	
	tb : process
	    variable expected_value : std_logic_vector(8 downto 0) := "000000000";
	    variable bcd_value : std_logic_vector(8 downto 0) := "000000000";

		function convert_to_ones(number : integer) return std_logic_vector is
            variable result : std_logic_vector(8 downto 0) := "000000000";
		begin
			for i in 0 to number loop
				result := std_logic_vector(unsigned(result) + 1);
			end loop;
			return result;
		end convert_to_ones;
	begin
		for i in 0 to 9 loop
		    input_tb <= STD_LOGIC_VECTOR(to_unsigned(i,4));
		    wait for 10NS;
		    expected_value := convert_to_ones(i);
		    assert (output_tb =  expected_value) report "ERROR" severity ERROR;

		end loop;
		
		for i in 9 to 15 loop
		    input_tb <= STD_LOGIC_VECTOR(to_unsigned(i,4));
		    wait for 10NS;
			assert output_tb = "000000000" report "ERROR" severity ERROR;
		end loop;
		
	end process;

end Behavioral;
