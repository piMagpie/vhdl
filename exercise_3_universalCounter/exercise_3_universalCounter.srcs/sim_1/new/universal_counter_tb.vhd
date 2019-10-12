library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity universal_counter_tb is
    
end universal_counter_tb;
 
architecture Behavioral of universal_counter_tb is
 
COMPONENT UniversalCounter
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
END COMPONENT;
	
    signal CLK : std_logic := '0';
    signal enable: std_logic := '0';
    signal down: std_logic := '0';
    signal RESET:  std_logic := '0';
    signal LOAD:  std_logic := '0';
    signal D : std_logic_vector(3 downto 0) := "0000";
    
    signal Q : std_logic_vector(3 downto 0);
    signal over : std_logic;

    
    
    constant CLK_PERIOD : time := 10 ns;
begin
 
dut: UniversalCounter PORT MAP(
    clock => CLK,
    enable => enable,
    up => down,
    RESET => RESET,
    LOAD => LOAD,
    DATA => D,
    COUNT => Q,
    over => over
);
 
process
    
     procedure check_reset is
       begin
          RESET <= '1';
          wait for CLK_PERIOD;
          assert( Q = "0000") report "error Q - check reset";
          assert( over = '0') report "error OVER - check reset";

       end procedure check_reset;
       
       procedure check_load is
           variable temp : std_logic_vector(3 downto 0) := "0000";
       begin
           check_reset;
           load <= '1';
           enable <= '1';
           reset <= '0';
            
           for i in 0 to 15 loop
               D <= temp;
               wait for CLK_PERIOD;
               assert(Q = temp) report "error check load";
               temp := std_logic_vector(unsigned(temp)+1);
           end loop;
          
       end procedure check_load;
        
       procedure check_increment is
           variable temp : std_logic_vector(3 downto 0) := "0000";
           variable flag : std_logic := '0';
       begin
           check_reset;
           enable <= '1';
           load <= '0';
           reset <= '0';
           down <= '0';
           d <= "0000";

           for i in 1 to 31 loop
               wait for CLK_PERIOD;
               if temp = "1111" then
                    temp := "0000";
                    flag := '1';
               else
                    temp := std_logic_vector(unsigned(temp)+1);
               end if;
               assert(Q = temp) report "error temp check increment";
               assert(flag = over) report "error flag";

           end loop;
          
       end procedure check_increment;
     
        procedure check_decrement is
            variable temp : std_logic_vector(3 downto 0) := "1111";
            variable flag : std_logic := '0';
        begin
            check_reset;
            
            enable <= '1';
            load <= '1';
            d <= temp;
            reset <= '0';
            
            wait for CLK_PERIOD;
            
            load <= '0';
            d <= "0000";
            down <= '1';
            
            for i in 1 to 31 loop
               if temp = "0000" then
                    temp := "1111";
                    flag := '1';
                else
                    temp := std_logic_vector(unsigned(temp)-1);
                end if;
                wait for CLK_PERIOD;
                assert(Q = temp and flag = over) report "error check decrement";

            end loop;
              
        end procedure check_decrement;
begin
    -- check reset
    check_reset;
    
    -- check load
    check_load;   
     
     -- check icrement
    check_increment;
 
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

