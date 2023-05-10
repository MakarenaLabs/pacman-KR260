--
-- A simulation model of Pacman hardware
-- VHDL conversion by MikeJ - October 2002
--
-- FPGA PACMAN video scan doubler
--
-- based on a design by Tatsuyuki Satoh
--
--
-- All rights reserved
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS CODE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- You are responsible for any legal issues arising from your use of this code.
--
-- The latest version of this file can be found at: www.fpgaarcade.com
--
-- Email pacman@fpgaarcade.com
--
-- Revision list
--
-- version 004 spartan3e release
-- version 003 Jan 2006 release, general tidy up
-- version 002 initial release
--
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;
Library UNISIM;
  use UNISIM.vcomponents.all;
library UNIMACRO;
  use unimacro.vcomponents.all;

use work.pkg_pacman.all;

entity PACMAN_DBLSCAN is
  port (
	I_R               : in    std_logic_vector( 2 downto 0);
	I_G               : in    std_logic_vector( 2 downto 0);
	I_B               : in    std_logic_vector( 1 downto 0);
	I_HSYNC           : in    std_logic;
	I_VSYNC           : in    std_logic;
	--
	O_R               : out   std_logic_vector( 2 downto 0);
	O_G               : out   std_logic_vector( 2 downto 0);
	O_B               : out   std_logic_vector( 1 downto 0);
	O_HSYNC           : out   std_logic;
	O_VSYNC           : out   std_logic;
	--
	ENA_6             : in    std_logic;
	ENA_12            : in    std_logic;
	CLK               : in    std_logic
	);
end;

architecture RTL of PACMAN_DBLSCAN is
  signal ram_ena_12  : std_logic;
  signal ram_ena_6   : std_logic;
  --
  -- input timing
  --
  signal hsync_in_t1 : std_logic;
  signal vsync_in_t1 : std_logic;
  -- Adressbreite geändert von 9b auf 11b wg. größerer RAM Primitives
  signal hpos_i      : std_logic_vector(10 downto 0) := (others => '0');    -- input capture postion
  signal ibank       : std_logic_vector(0 downto 0);
  signal we_a        : std_logic_vector(0 downto 0);
  signal we_b        : std_logic_vector(0 downto 0);
  signal rgb_in      : std_logic_vector(7 downto 0);
  --
  -- output timing
  --
  signal hpos_o      : std_logic_vector(10 downto 0) := (others => '0');
  -- Adressbreite geändert von 9b auf 11b wg. größerer RAM Primitives
  signal ohs         : std_logic;
  signal ohs_t1      : std_logic;
  signal ovs         : std_logic;
  signal ovs_t1      : std_logic;
  signal obank       : std_logic;
  signal obank_t1    : std_logic;
  --
  signal vs_cnt      : std_logic_vector(2 downto 0);
  signal rgb_out_a   : std_logic_vector(7 downto 0);
  signal rgb_out_b   : std_logic_vector(7 downto 0);
begin

  p_input_timing : process
	variable rising_h : boolean;
	variable rising_v : boolean;
  begin
	wait until rising_edge (CLK);
	if (ENA_6 = '1') then
	  hsync_in_t1 <= I_HSYNC;
	  vsync_in_t1 <= I_VSYNC;

	  rising_h := (I_HSYNC = '1') and (hsync_in_t1 = '0');
	  rising_v := (I_VSYNC = '1') and (vsync_in_t1 = '0');

	  if rising_v then
		ibank(0) <= '0';
	  elsif rising_h then
		ibank <= not ibank;
	  end if;

	  if rising_h then
		hpos_i <= (others => '0');
	  else
		hpos_i <= hpos_i + "1";
	  end if;
	end if;
  end process;

  we_a <=     ibank;
  we_b <= not ibank;
  rgb_in <= I_B & I_G & I_R;
  
  

  
u_ram_a : BRAM_TDP_MACRO
generic map(
BRAM_SIZE => "18Kb",--TargetBRAM,"18Kb"or"36Kb"
DEVICE => "7SERIES",--TargetDevice:"VIRTEX5","VIRTEX6","7SERIES","SPARTAN6"
DOA_REG =>0,--OptionalportAoutputregister(0or1)
DOB_REG =>0,--OptionalportBoutputregister(0or1)
INIT_A => X"00000000",--InitialvaluesonAoutputport
INIT_B => X"00000000",--InitialvaluesonBoutputport
INIT_FILE => "NONE",
READ_WIDTH_A => 8,--Validvaluesare1-36(19-36onlyvalidwhenBRAM_SIZE="36Kb")
READ_WIDTH_B => 8,--Validvaluesare1-36(19-36onlyvalidwhenBRAM_SIZE="36Kb")
SIM_COLLISION_CHECK => "ALL",--Collisioncheckenable"ALL","WARNING_ONLY",
--"GENERATE_X_ONLY"or"NONE"
SRVAL_A => X"00000000",--Set/ResetvalueforAportoutput
SRVAL_B => X"00000000",--Set/ResetvalueforBportoutput
WRITE_MODE_A => "WRITE_FIRST",--"WRITE_FIRST","READ_FIRST"or"NO_CHANGE"
WRITE_MODE_B => "WRITE_FIRST",--"WRITE_FIRST","READ_FIRST"or"NO_CHANGE"
WRITE_WIDTH_A => 8,--Validvaluesare1-36(19-36onlyvalidwhenBRAM_SIZE="36Kb")
WRITE_WIDTH_B => 8--Validvaluesare1-36(19-36onlyvalidwhenBRAM_SIZE="36Kb")
)
port map(
--DOA=>DOA,--Outputport-Adata,widthdefinedbyREAD_WIDTH_Aparameter
DOB => rgb_out_a,--Outputport-Bdata,widthdefinedbyREAD_WIDTH_Bparameter
ADDRA => hpos_i,--Inputport-Aaddress,widthdefinedbyPortAdepth
ADDRB => hpos_o,--Inputport-Baddress,widthdefinedbyPortBdepth
CLKA => CLK,--1-bitinputport-Aclock
CLKB => CLK,--1-bitinputport-Bclock
DIA => rgb_in,--Inputport-Adata,widthdefinedbyWRITE_WIDTH_Aparameter
DIB => x"00",--Inputport-Bdata,widthdefinedbyWRITE_WIDTH_Bparameter
ENA => ENA_6,--1-bitinputport-Aenable
ENB => ENA_12,--1-bitinputport-Benable
REGCEA => '0',--1-bitinputport-Aoutputregisterenable
REGCEB => '0',--1-bitinputport-Boutputregisterenable
RSTA => '0',--1-bitinputport-Areset
RSTB => '0',--1-bitinputport-Breset
WEA => we_a,--Inputport-Awriteenable,widthdefinedbyPortAdepth
WEB(0) => '0' --Inputport-Bwriteenable,widthdefinedbyPortBdepth
);
--
--  u_ram_a : RAMB4_S8_S8
-- urspr+ngliche BRAM primitive
--	port map (
	  -- output
--	  DOB   => rgb_out_a,
--	  DIB   => x"00",
--	  ADDRB => hpos_o,
--	  WEB   => '0',
--	  ENB   => ENA_12,
--	  RSTB  => '0',
--	  CLKB  => CLK,

	  -- input
	  --DOA   =>
--	  DIA   => rgb_in,
--	  ADDRA => hpos_i,
--	  WEA   => we_a,
--	  ENA   => ENA_6,
--	  RSTA  => '0',
--	  CLKA  => CLK
--	  );

u_ram_b  : BRAM_TDP_MACRO

generic map(
BRAM_SIZE => "18Kb",--TargetBRAM,"18Kb"or"36Kb"
DEVICE => "7SERIES",--TargetDevice:"VIRTEX5","VIRTEX6","7SERIES","SPARTAN6"
DOA_REG =>0,--OptionalportAoutputregister(0or1)
DOB_REG =>0,--OptionalportBoutputregister(0or1)
INIT_A => X"00000000",--InitialvaluesonAoutputport
INIT_B => X"00000000",--InitialvaluesonBoutputport
INIT_FILE => "NONE",
READ_WIDTH_A => 8,--Validvaluesare1-36(19-36onlyvalidwhenBRAM_SIZE="36Kb")
READ_WIDTH_B => 8,--Validvaluesare1-36(19-36onlyvalidwhenBRAM_SIZE="36Kb")
SIM_COLLISION_CHECK => "ALL",--Collisioncheckenable"ALL","WARNING_ONLY",
--"GENERATE_X_ONLY"or"NONE"
SRVAL_A => X"00000000",--Set/ResetvalueforAportoutput
SRVAL_B => X"00000000",--Set/ResetvalueforBportoutput
WRITE_MODE_A => "WRITE_FIRST",--"WRITE_FIRST","READ_FIRST"or"NO_CHANGE"
WRITE_MODE_B => "WRITE_FIRST",--"WRITE_FIRST","READ_FIRST"or"NO_CHANGE"
WRITE_WIDTH_A => 8,--Validvaluesare1-36(19-36onlyvalidwhenBRAM_SIZE="36Kb")
WRITE_WIDTH_B => 8--Validvaluesare1-36(19-36onlyvalidwhenBRAM_SIZE="36Kb")
)

port map(
--DOA=>DOA,--Outputport-Adata,widthdefinedbyREAD_WIDTH_Aparameter
DOB => rgb_out_b, --Outputport-Bdata,widthdefinedbyREAD_WIDTH_Bparameter
ADDRA => hpos_i,--Inputport-Aaddress,widthdefinedbyPortAdepth
ADDRB => hpos_o,--Inputport-Baddress,widthdefinedbyPortBdepth
CLKA => CLK,--1-bitinputport-Aclock
CLKB => CLK,--1-bitinputport-Bclock
DIA => rgb_in,--Inputport-Adata,widthdefinedbyWRITE_WIDTH_Aparameter
DIB => x"00",--Inputport-Bdata,widthdefinedbyWRITE_WIDTH_Bparameter
ENA => ENA_6,--1-bitinputport-Aenable
ENB => ENA_12,--1-bitinputport-Benable
REGCEA => '0',--1-bitinputport-Aoutputregisterenable
REGCEB => '0',--1-bitinputport-Boutputregisterenable
RSTA => '0',--1-bitinputport-Areset
RSTB => '0',--1-bitinputport-Breset
WEA => we_b,--Inputport-Awriteenable,widthdefinedbyPortAdepth
WEB(0) => '0' --Inputport-Bwriteenable,widthdefinedbyPortBdepth
);

--u_ram_b : RAMB4_S8_S8
--	port map (
	  -- output
--	  DOB   => rgb_out_b,
--	  DIB   => x"00",
--	  ADDRB => hpos_o,
--	  WEB   => '0',
--	  ENB   => ENA_12,
--	  RSTB  => '0',
--	  CLKB  => CLK,

	  -- input
	  --DOA   =>
--	  DIA   => rgb_in,
--	  ADDRA => hpos_i,
--	  WEA   => we_b,
--	  ENA   => ENA_6,
--	  RSTA  => '0',
--	  CLKA  => CLK
--	  );

  p_output_timing : process
	variable rising_h : boolean;
  begin
	wait until rising_edge (CLK);
	if  (ENA_12 = '1') then
	  rising_h := ((ohs = '1') and (ohs_t1 = '0'));

	  if rising_h or (hpos_o = "101111111") then
		hpos_o <= (others => '0');
	  else
		hpos_o <= hpos_o + "1";
	  end if;

	  if (ovs = '1') and (ovs_t1 = '0') then -- rising_v
		obank <= '0';
		vs_cnt <= "000";
	  elsif rising_h then
		obank <= not obank;
		if (vs_cnt(2) = '0') then
		  vs_cnt <= vs_cnt + "1";
		end if;
	  end if;

	  ohs <= I_HSYNC; -- reg on clk_12
	  ohs_t1 <= ohs;

	  ovs <= I_VSYNC; -- reg on clk_12
	  ovs_t1 <= ovs;
	end if;
  end process;

  p_op : process
  begin
	wait until rising_edge (CLK);
	if (ENA_12 = '1') then
	  O_HSYNC <= '0';
	  if (hpos_o < 32) then -- may need tweaking !
		O_HSYNC <= '1';
	  end if;

	  obank_t1 <= obank;
	  if (obank_t1 = '1') then
		O_B <= rgb_out_b(7 downto 6);
		O_G <= rgb_out_b(5 downto 3);
		O_R <= rgb_out_b(2 downto 0);
	  else
		O_B <= rgb_out_a(7 downto 6);
		O_G <= rgb_out_a(5 downto 3);
		O_R <= rgb_out_a(2 downto 0);
	  end if;

	  O_VSYNC <= not vs_cnt(2);
	end if;
  end process;

end architecture RTL;

