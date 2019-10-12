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

entity tally_test is
-- it must be empty
end tally_test;

architecture Behavioral of tally_test is
   component tally
         Port ( scoresA : in std_logic_vector(2 downto 0);
               scoresB : in std_logic_vector(2 downto 0);
               winner : out std_logic_vector(1 downto 0)
               );
    end component;
    
    signal test_scoresA : std_logic_vector(2 downto 0);
    signal test_scoresB : std_logic_vector(2 downto 0);
    signal test_winner : std_logic_vector(1 downto 0);

    CONSTANT period : time := 10 ns;
    
    function result(scoresA: std_logic_vector; scoresB: std_logic_vector) return std_logic_vector is
        variable winner : std_logic_vector(1 downto 0);
        variable countA,countB : natural := 0;
        variable winnnerIndicator : natural := 0;
    begin
    
        for i in scoresA'range loop
            if scoresA(i) = '1' then
                winnnerIndicator := winnnerIndicator + 1;
            end if;
            if scoresB(i) = '1' then
                winnnerIndicator := winnnerIndicator - 1;
            end if;
        end loop;
        
        if( winnnerIndicator < 0 ) then
            winner := "10"; -- b wins
        elsif(winnnerIndicator > 0) then
            winner := "01"; -- a wins
        else
            if unsigned(scoresA) > 0 then
                winner := "11"; -- both win
            else
                winner := "00";  -- both lose
            end if;
        end if;
               
        return winner;
    end function result;
    
begin
    DUT: tally port map( scoresA => test_scoresA, scoresB => test_scoresB,
                                winner => test_winner);
    process
    begin
        assert (test_scoresA'Length = test_scoresB'Length);
        test_scoresA <=  "000";
        test_scoresB <= "000"; 

        for a in 0 to 7 loop -- from 000 to 111
            for b in 0 to 7 loop -- from 000 to 111
                assert (test_winner = result(test_scoresA, test_scoresB));
                WAIT FOR period;
                test_scoresB <= std_logic_vector(unsigned(test_scoresB)+1); 
            end loop;
             test_scoresA <=  std_logic_vector(unsigned(test_scoresA)+1); 
        end loop;   
    end process;
end Behavioral;
