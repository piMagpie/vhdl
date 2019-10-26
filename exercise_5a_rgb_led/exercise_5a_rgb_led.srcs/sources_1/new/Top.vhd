library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Top is 

    Port
    (sysclk:      in std_logic;
     btn:         in std_logic_vector(3 downto 0); -- speed 1
     -- speed 3
     -- speed 5
     -- alarm
     led5_r:      out std_logic;
     led5_g:      out std_logic;
     led5_b:      out std_logic;
     led6_r:      out std_logic;
      led6_g:      out std_logic;
      led6_b:      out std_logic
     );
end Top;

architecture Behavioral of Top is

component RGB_LED
  Port (
  	CLK, RESET, BACKWARDS_LOOP, ALARM: in std_logic;
  	SPEED : in std_logic_vector(2 downto 0);
  	R, G, B : out std_logic_vector(7 downto 0)
  );
  end component;
  
  component DeBounce is
      port(   Clock : in std_logic;
              button_in : in std_logic;
              pulse_out : out std_logic
          );
  end component;


  signal r, g, b : std_logic_vector(7 downto 0) := (others => '0');
  signal d_reset, d_backward_loop, d_alarm, d_speed : std_logic := '0';
  signal speed_t : std_logic_vector(2 downto 0) := "001";
  signal backward_loop : std_logic := '0';
begin       
       uut_t: RGB_LED port map ( CLK            => sysclk,
                                 RESET          => d_reset,
                                 BACKWARDS_LOOP => backward_loop,
                                 ALARM          => d_alarm,
                                 SPEED          => speed_t,
                                 R              => R,
                                 G              => G,
                                 B              => B );
       
       reset_debounce: DeBounce port map (  Clock       =>      sysclk,
                                            button_in   =>      btn(0),
                                            pulse_out   =>      d_reset);
       
       loop_debounce:  DeBounce port map (  Clock       =>      sysclk,
                                            button_in   =>      btn(1),
                                            pulse_out   =>      d_backward_loop);
                                            
       alarm_debounce: DeBounce port map (  Clock       =>     sysclk,
                                            button_in   =>      btn(2),
                                            pulse_out   =>      d_alarm);
                                            
        speed_debounce: DeBounce port map (  Clock       =>     sysclk,
                                             button_in   =>      btn(3),
                                             pulse_out   =>      d_speed);
    
    speed_process: process(sysclk)
    begin                               
        led6_r <=  btn(0);
        led6_g <=  btn(1);
        led6_b <=  btn(3);
    end process;
    
       
    test_process: process(d_speed)
        variable  current_speed : std_logic_vector(2 downto 0) := "001";
    begin
        if d_speed = '1' then
            if current_speed = "001" then -- 1 sec
               current_speed := "011"; -- 3 sec
            elsif current_speed = "011" then -- 3 sec
                current_speed := "101"; -- 5 sec
            elsif current_speed = "101" then -- 3 sec
                current_speed := "001"; -- 1 sec
            end if;
            speed_t <= current_speed;
        end if;
    end process;   
    
    backward_process: process(d_backward_loop)
            variable backward : std_logic := '0';
        begin
            if d_backward_loop = '1' then
                if backward = '0' then
                   backward := '1';
                else
                    backward := '0';
                end if;
                backward_loop <= backward;
            end if;
        end process; 
             
    process(sysclk,r,g,b)
        variable count: integer:=0;
    begin
    
        if rising_edge(sysclk) then
               count:=count+1;
                if count<to_integer(unsigned(r)) then
                    led5_r<='1';
                else
                    led5_r<='0';
                end if;
                if count<to_integer(unsigned(g)) then
                    led5_g<='1';
                else
                    led5_g<='0';
                end if;
                if count<to_integer(unsigned(b)) then
                    led5_b<='1';
                else
                    led5_b<='0';
                end if;
                if count<255 then
                    count:=0;
                end if;
        end if; 
    end process;
    
    
end Behavioral;
