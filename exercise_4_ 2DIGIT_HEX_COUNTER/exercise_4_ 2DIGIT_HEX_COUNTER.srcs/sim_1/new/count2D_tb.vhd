
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity count2D_tb is
    
end count2D_tb;
 
architecture Behavioral of count2D_tb is
 
COMPONENT DIGIT_HEX_COUNTER is
port(
    CLK, enable, down, RESET, LOAD : in std_logic;
    D : in std_logic_vector(7 downto 0);
    Q1 : out std_logic_vector(3 downto 0);
    Q2 : out std_logic_vector(3 downto 0);
    over : out std_logic
);
END COMPONENT;
 
    signal CLK : std_logic := '0';
    signal enable: std_logic := '0';
    signal down: std_logic := '0';
    signal RESET:  std_logic := '0';
    signal LOAD:  std_logic := '0';
    signal D : std_logic_vector(7 downto 0) := "00000000";
    
    signal Q1: std_logic_vector(3 downto 0);
    signal Q2 : std_logic_vector(3 downto 0);
    signal over : std_logic;

    
    constant CLK_PERIOD : time := 500ps;
begin
 
dut: DIGIT_HEX_COUNTER PORT MAP(
    CLK => CLK,
    enable => enable,
    down => down,
    RESET => RESET,
    LOAD => LOAD,
    D => D,
    Q1 => Q1,
    Q2 => Q2,
    over => over
);
 
process

   function are_equal(a1,a2 : std_logic_vector(3 downto 0); b : std_logic_vector(7 downto 0)) return boolean is
   begin
       return b = ( a1 & a2);
   end are_equal;
    
     procedure check_reset is
       begin
          RESET <= '1';
          LOAD <= '0';
          wait for CLK_PERIOD;
          assert( Q1 = "0000") report "error Q1 - check reset";
          assert( Q2 = "0000") report "error Q2 - check reset";
          
          assert( over = '0') report "error OVER - check reset";

       end procedure check_reset;
       
       procedure check_load is
           variable temp : std_logic_vector(7 downto 0) := "00000000";
       begin
           check_reset;
           load <= '1';
           enable <= '1';
           reset <= '0';
           
          --  D <= "00001111";
          -- wait for CLK_PERIOD * 4;
           
          --  D <= "00001100";
          --  wait for CLK_PERIOD * 2;
           
           for i in 0 to 255 loop
               D <= temp;
               wait for CLK_PERIOD;
               
               assert(are_equal(Q1,Q2,temp)) report "error check load: firstDigit";
               
               temp := std_logic_vector(unsigned(temp)+1);
           end loop;
          
       end procedure check_load;
      
       procedure check_increment is
            variable temp : std_logic_vector(7 downto 0) := "00000000";
            variable flag : std_logic := '0';
       begin
                  wait for CLK_PERIOD * 4; 
                  check_reset;

                  enable <= '1';
                  load <= '0';
                  reset <= '0';
                  down <= '0';
                  d <= "00000000";
                  wait for CLK_PERIOD * 4; 

                  for i in 1 to 500 loop
                      wait for CLK_PERIOD;
                      if temp = "11111111" then
                           temp := "00000000";
                           flag := '1';
                      else
                           temp := std_logic_vector(unsigned(temp)+1);
                      end if;
       
                  end loop;
                 
         end procedure check_increment;
         
         procedure check_decrement is
                     variable temp : std_logic_vector(7 downto 0) := "00000000";
                     variable flag : std_logic := '0';
                begin
                           wait for CLK_PERIOD * 4; 
                           check_reset;
         
                           enable <= '1';
                           load <= '0';
                           reset <= '0';
                           down <= '1';
                           d <= "11111111";
                           wait for CLK_PERIOD * 4; 
         
                           for i in 1 to 500 loop
                               wait for CLK_PERIOD;
                               if temp = "11111111" then
                                    temp := "00000000";
                                    flag := '1';
                               else
                                    temp := std_logic_vector(unsigned(temp)-1);
                               end if;
                
                           end loop;
                          
                  end procedure check_decrement;     
begin
    -- check reset
    check_reset;
    
    -- check load
    check_load;   
     
    -- check icrement
    check_increment;
    --check_increment;
 
    check_reset;
    -- check decrement
    check_decrement; 
  
end process;
 
CLK_generation: process
begin
    CLK <='1';
    wait for CLK_PERIOD/2;
    CLK <= '0';
    wait for CLK_PERIOD/2;
end process CLK_generation;
 
 
end Behavioral;
