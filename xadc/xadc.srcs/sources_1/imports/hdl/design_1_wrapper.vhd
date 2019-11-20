--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
--Date        : Tue Nov 19 21:02:00 2019
--Host        : agazorPC running 64-bit major release  (build 9200)
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    daddr_in_0 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    dclk_in_0 : in STD_LOGIC;
    do_out_0 : out STD_LOGIC_VECTOR ( 15 downto 0 );
    drdy_out_0 : out STD_LOGIC;
    vauxn14_0 : in STD_LOGIC;
    vauxp14_0 : in STD_LOGIC
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    daddr_in_0 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    do_out_0 : out STD_LOGIC_VECTOR ( 15 downto 0 );
    dclk_in_0 : in STD_LOGIC;
    drdy_out_0 : out STD_LOGIC;
    vauxn14_0 : in STD_LOGIC;
    vauxp14_0 : in STD_LOGIC
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      daddr_in_0(6 downto 0) => daddr_in_0(6 downto 0),
      dclk_in_0 => dclk_in_0,
      do_out_0(15 downto 0) => do_out_0(15 downto 0),
      drdy_out_0 => drdy_out_0,
      vauxn14_0 => vauxn14_0,
      vauxp14_0 => vauxp14_0
    );
end STRUCTURE;
