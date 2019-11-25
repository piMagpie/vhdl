library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Timer is
    generic (
        MS_TICKS:    natural;
        MS_TRIGGER_COUNT:    natural
    );
    port (
        CLK:        in      std_logic;
        RESET:      in      std_logic;
        INTERRUPTION:      OUT  std_logic
    );
end entity Timer;


architecture behavioural of Timer is

begin
o0: process (CLK) IS
    variable counter : natural range 0 to MS_TICKS;
    variable counter_milis : natural range 0 to MS_TRIGGER_COUNT;
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                counter := 0;
                INTERRUPTION <= '0';
            else
                if counter = MS_TICKS then
                    counter := 0;
                    counter_milis := counter_milis + 1;
                end if;
                 
                if counter_milis = MS_TRIGGER_COUNT then
                    counter_milis := 0;
                    INTERRUPTION <= '1';
                else
                    counter := counter + 1;
                    INTERRUPTION <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture;