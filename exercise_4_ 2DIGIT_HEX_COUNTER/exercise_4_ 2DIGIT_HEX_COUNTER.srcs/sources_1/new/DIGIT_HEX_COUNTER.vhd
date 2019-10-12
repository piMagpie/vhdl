library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity DIGIT_HEX_COUNTER is 
port(
    CLK, enable, down, RESET, LOAD : in std_logic;
    D : in std_logic_vector(7 downto 0);
    Q1 : out std_logic_vector(3 downto 0);
    Q2 : out std_logic_vector(3 downto 0);
    over : out std_logic);
end DIGIT_HEX_COUNTER;
 
architecture archcount2D of DIGIT_HEX_COUNTER is
    signal p_COUNTER: std_logic_vector(7 downto 0) := (others => '0');
    signal p_MODIFIED_COUNTER: std_logic_vector(7 downto 0) := (others => '0');

    signal p_CARRY: std_logic := '0';
        
begin
    
	-- THIS PROCESS IS SYNCHRONOUS
    registers_process: process(CLK)
    begin
		if rising_edge(CLK) then
			if RESET = '1' then
				-- output signals
				Q1 <= (others => '0');       
				Q2 <= (others => '0');
				over <= '0';
				
				-- inner module signals
				p_MODIFIED_COUNTER <= (others => '0');
			else
			    -- output signals
				Q1 <= p_COUNTER(7 downto 4);
				Q2 <= p_COUNTER(3 downto 0);
				over <= p_CARRY;
				
				-- inner module signals
				p_MODIFIED_COUNTER <= p_COUNTER;
			end if;
        end if;
    end process registers_process;
    
	-- THIS PROCESS IS ASYNCHRONOUS
    cbl_process : process(enable, down, LOAD,D,p_MODIFIED_COUNTER) 
    begin
        if ( enable = '1') then
           if LOAD = '1' then
                p_COUNTER <= D;
                p_CARRY <= '0';
           else
            if ( down = '0' ) then
                if ( p_MODIFIED_COUNTER = "11111111") then
                    p_COUNTER <= (others => '0');
                    p_CARRY <= '1';
                else
                    p_COUNTER <= p_MODIFIED_COUNTER + 1;
                    p_CARRY <= '0';    
                end if;
            else
                if ( p_MODIFIED_COUNTER = "00000000") then
                    p_COUNTER <= (others => '1');
                    p_CARRY <= '1';
                else
                    p_COUNTER <= p_MODIFIED_COUNTER - 1;
                    p_CARRY <= '0';    
                end if;
            end if;
            
           end if;
        end if;
    end process cbl_process;
 
end archcount2D;