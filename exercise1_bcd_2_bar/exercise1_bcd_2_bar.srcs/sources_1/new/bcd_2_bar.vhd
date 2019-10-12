----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2019 10:14:31 AM
-- Design Name: 
-- Module Name: bcd_2_bar - Behavioral
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

-- Binary-coded to decimal. 
entity bcd_2_bar is
	Port ( 
		bcd: IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- values from 0 to 9.
		bar_graph: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
end bcd_2_bar;

architecture Behavioral of bcd_2_bar is

begin
	converter: process(bcd)
	-- declaration part
	
	begin
	-- sequential part
		case bcd is
			when "0000" => bar_graph <= "000000000"; -- 0
			when "0001" => bar_graph <= "000000001"; -- 1
			when "0010" => bar_graph <= "000000011"; -- 2
			when "0011" => bar_graph <= "000000111"; -- 3
			when "0100" => bar_graph <= "000001111"; -- 4
			when "0101" => bar_graph <= "000011111"; -- 5
			when "0110" => bar_graph <= "000111111"; -- 6
			when "0111" => bar_graph <= "001111111"; -- 7
			when "1000" => bar_graph <= "011111111"; -- 8
			when "1001" => bar_graph <= "111111111"; -- 9
			-- inputs from 1010 to 1111 are considered invalid
			when others => bar_graph <= "000000000";
		end case;
	end process;

	-- another ways is to convert the bct to an integer. And loop adding onest to bar_graph
end Behavioral;
