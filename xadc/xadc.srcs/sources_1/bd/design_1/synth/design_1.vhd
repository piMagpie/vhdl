--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
--Date        : Tue Nov 19 21:18:05 2019
--Host        : agazorPC running 64-bit major release  (build 9200)
--Command     : generate_target design_1.bd
--Design      : design_1
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1 is
  port (
    daddr_in_0 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    dclk_in_0 : in STD_LOGIC;
    do_out_0 : out STD_LOGIC_VECTOR ( 15 downto 0 );
    drdy_out_0 : out STD_LOGIC;
    vauxn14_0 : in STD_LOGIC;
    vauxp14_0 : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1 : entity is "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of design_1 : entity is "design_1.hwdef";
end design_1;

architecture STRUCTURE of design_1 is
  component design_1_xlconstant_0_1 is
  port (
    dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlconstant_0_1;
  component design_1_xlconstant_0_0 is
  port (
    dout : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  end component design_1_xlconstant_0_0;
  component design_1_xadc_wiz_0_0 is
  port (
    di_in : in STD_LOGIC_VECTOR ( 15 downto 0 );
    daddr_in : in STD_LOGIC_VECTOR ( 6 downto 0 );
    den_in : in STD_LOGIC;
    dwe_in : in STD_LOGIC;
    drdy_out : out STD_LOGIC;
    do_out : out STD_LOGIC_VECTOR ( 15 downto 0 );
    dclk_in : in STD_LOGIC;
    vp_in : in STD_LOGIC;
    vn_in : in STD_LOGIC;
    vauxp14 : in STD_LOGIC;
    vauxn14 : in STD_LOGIC;
    user_temp_alarm_out : out STD_LOGIC;
    vccint_alarm_out : out STD_LOGIC;
    vccaux_alarm_out : out STD_LOGIC;
    vccpint_alarm_out : out STD_LOGIC;
    vccpaux_alarm_out : out STD_LOGIC;
    vccddro_alarm_out : out STD_LOGIC;
    ot_out : out STD_LOGIC;
    channel_out : out STD_LOGIC_VECTOR ( 4 downto 0 );
    eoc_out : out STD_LOGIC;
    alarm_out : out STD_LOGIC;
    eos_out : out STD_LOGIC;
    busy_out : out STD_LOGIC
  );
  end component design_1_xadc_wiz_0_0;
  signal daddr_in_0_1 : STD_LOGIC_VECTOR ( 6 downto 0 );
  signal dclk_in_0_1 : STD_LOGIC;
  signal vauxn14_0_1 : STD_LOGIC;
  signal vauxp14_0_1 : STD_LOGIC;
  signal xadc_wiz_0_do_out : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal xadc_wiz_0_drdy_out : STD_LOGIC;
  signal xadc_wiz_0_eoc_out : STD_LOGIC;
  signal xlconstant_0_dout : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal xlconstant_1_dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_xadc_wiz_0_alarm_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_busy_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_eos_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_ot_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_user_temp_alarm_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_vccaux_alarm_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_vccddro_alarm_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_vccint_alarm_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_vccpaux_alarm_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_vccpint_alarm_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_channel_out_UNCONNECTED : STD_LOGIC_VECTOR ( 4 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of dclk_in_0 : signal is "xilinx.com:signal:clock:1.0 CLK.DCLK_IN_0 CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of dclk_in_0 : signal is "XIL_INTERFACENAME CLK.DCLK_IN_0, CLK_DOMAIN design_1_dclk_in_0, FREQ_HZ 100000000, PHASE 0.000";
begin
  daddr_in_0_1(6 downto 0) <= daddr_in_0(6 downto 0);
  dclk_in_0_1 <= dclk_in_0;
  do_out_0(15 downto 0) <= xadc_wiz_0_do_out(15 downto 0);
  drdy_out_0 <= xadc_wiz_0_drdy_out;
  vauxn14_0_1 <= vauxn14_0;
  vauxp14_0_1 <= vauxp14_0;
xadc_wiz_0: component design_1_xadc_wiz_0_0
     port map (
      alarm_out => NLW_xadc_wiz_0_alarm_out_UNCONNECTED,
      busy_out => NLW_xadc_wiz_0_busy_out_UNCONNECTED,
      channel_out(4 downto 0) => NLW_xadc_wiz_0_channel_out_UNCONNECTED(4 downto 0),
      daddr_in(6 downto 0) => daddr_in_0_1(6 downto 0),
      dclk_in => dclk_in_0_1,
      den_in => xadc_wiz_0_eoc_out,
      di_in(15 downto 0) => xlconstant_0_dout(15 downto 0),
      do_out(15 downto 0) => xadc_wiz_0_do_out(15 downto 0),
      drdy_out => xadc_wiz_0_drdy_out,
      dwe_in => xlconstant_1_dout(0),
      eoc_out => xadc_wiz_0_eoc_out,
      eos_out => NLW_xadc_wiz_0_eos_out_UNCONNECTED,
      ot_out => NLW_xadc_wiz_0_ot_out_UNCONNECTED,
      user_temp_alarm_out => NLW_xadc_wiz_0_user_temp_alarm_out_UNCONNECTED,
      vauxn14 => vauxn14_0_1,
      vauxp14 => vauxp14_0_1,
      vccaux_alarm_out => NLW_xadc_wiz_0_vccaux_alarm_out_UNCONNECTED,
      vccddro_alarm_out => NLW_xadc_wiz_0_vccddro_alarm_out_UNCONNECTED,
      vccint_alarm_out => NLW_xadc_wiz_0_vccint_alarm_out_UNCONNECTED,
      vccpaux_alarm_out => NLW_xadc_wiz_0_vccpaux_alarm_out_UNCONNECTED,
      vccpint_alarm_out => NLW_xadc_wiz_0_vccpint_alarm_out_UNCONNECTED,
      vn_in => '0',
      vp_in => '0'
    );
xlconstant_0: component design_1_xlconstant_0_0
     port map (
      dout(15 downto 0) => xlconstant_0_dout(15 downto 0)
    );
xlconstant_1: component design_1_xlconstant_0_1
     port map (
      dout(0) => xlconstant_1_dout(0)
    );
end STRUCTURE;
