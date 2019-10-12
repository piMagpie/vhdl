----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/27/2018 02:47:07 PM
-- Design Name: 
-- Module Name: tally - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tally is
    Port ( scoresA : in std_logic_vector(2 downto 0);
           scoresB : in std_logic_vector(2 downto 0);
           winner : out std_logic_vector(1 downto 0)
           );
end tally;

architecture Behavioral of tally is
 function count_ones(s : std_logic_vector) return integer is
       variable temp : natural := 0;
       begin
         for i in s'range loop
           if s(i) = '1' then temp := temp + 1; 
           end if;
         end loop;
         
         return temp;
       end function count_ones;
begin
    process(scoresA,scoresB)
    variable numberOnesA : natural;
    variable numberOnesB : natural;
    begin
       numberOnesA := count_ones(scoresA);
       numberOnesB := count_ones(scoresB);
      
       if( numberOnesA < numberOnesB) then
            winner <= "10"; -- b win
       elsif(numberOnesA > numberOnesB) then
            winner <= "01"; -- a win
       else
            if ( numberOnesA > 0) then
                winner <= "11"; -- both win
            else
                winner <= "00";  -- both lose
            end if;
       end if;
    end process;

end Behavioral;
