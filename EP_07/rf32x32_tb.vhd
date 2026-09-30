-------------------------------------------------------------------------------
-- Title      : rf32x32 testbench
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : rf32x32_tb.vhd
-- Author     : Pinit Kumhom  <pkumhom@Pinits-MacBook-Pro-2.local>
-- Company    : 
-- Created    : 2026-03-04
-- Last update: 2026-09-24
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-09-13  1.0      pkumhom	Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- packages for managing text files
use std.textio.all;
use ieee.std_logic_textio.all;

entity rf32x32_tb is
  
end entity rf32x32_tb;

architecture test of rf32x32_tb is
  -- inputs
  signal clk, we : std_logic;
  signal ra1, ra2, wa : std_logic_vector(4 downto 0) := (others => '0');
  signal wd : std_logic_vector(31 downto 0) := (others => '0');
  -- outputs
  signal rd1, rd2 : std_logic_vector(31 downto 0);
  signal rd1_rtl, rd2_rtl : std_logic_vector(31 downto 0);
  -- simulation
  constant Tclk : time := 2 ns;
  constant SaT : time := Tclk/100;
  signal TP : integer := 0;
  signal check : boolean;
  
begin  -- architecture beh
  rf32x32_1: entity work.rf32x32(stdcell)
    port map (
      clk => clk, werf => we,
      ra1 => ra1, ra2 => ra2, wa => wa,
      wd => wd, rd1 => rd1, rd2 => rd2);

  rf32x32_rtl: entity work.rf32x32(rtl)
    port map (
      clk => clk, werf => we,
      ra1 => ra1, ra2 => ra2, wa => wa,
      wd => wd, rd1 => rd1_rtl, rd2 => rd2_rtl);
  
--  clock generation
  process
  begin  -- process
    clk <= '0';
    wait for Tclk/2;
    clk <= '1';
    wait for Tclk/2;
  end process;

  -- 
  process is
    variable i : integer := 0;
    variable ok : boolean;
  begin  -- process
    we <= '1';
    ra1 <= std_logic_vector(to_unsigned(0,5));
    ra2 <= std_logic_vector(to_unsigned(0,5));
    wa <= std_logic_vector(to_unsigned(0,5));
    wd <= std_logic_vector(to_unsigned(0,32));
    TP <= 0;
    wait for Tclk;
    for j in 0 to 30 loop
      TP <= j;
      ra1 <= std_logic_vector(to_unsigned(j,5));
      ra2 <= std_logic_vector(to_unsigned(j,5));
      wa <= std_logic_vector(to_unsigned(j+1,5));
      wd <= std_logic_vector(to_unsigned(j+1,32));
      wait for Tclk-SaT;
      assert unsigned(rd1)=j report "Read data rd1 is wrong!" severity warning;
      assert unsigned(rd2)=j report "Read data rd2 is wrong!" severity warning;
      assert rd1_rtl=rd1 and rd2_rtl=rd2 report "RTL and stdcell implementations differ!" severity error;
      wait for SaT;
 --     i := (i+1) mod 32;
    end loop;  -- i
    ra1 <= std_logic_vector(to_unsigned(1,5));
    ra2 <= std_logic_vector(to_unsigned(30,5));
    wait for Tclk-SaT;
    assert unsigned(rd1)=1 report "Read data rd1 is wrong!" severity warning;
    assert unsigned(rd2)=30 report "Read data rd2 is wrong!" severity warning;
    assert rd1_rtl=rd1 and rd2_rtl=rd2 report "RTL and stdcell implementations differ!" severity error;
    wait for SaT;
    TP <= 31;
    we <= '0';
    ra1 <= std_logic_vector(to_unsigned(31,5));
    ra2 <= std_logic_vector(to_unsigned(31,5));
    wa <= std_logic_vector(to_unsigned(0,5));
    wd <= std_logic_vector(to_unsigned(0,32));
    wait for Tclk-SaT;
    assert unsigned(rd1)=0 report "Read data rd1 is wrong!" severity warning;
    assert unsigned(rd2)=0 report "Read data rd2 is wrong!" severity warning;
    assert rd1_rtl=rd1 and rd2_rtl=rd2 report "RTL and stdcell implementations differ!" severity error;
    wait for SaT;
    TP <= 32;
    we <= '0';
    ra1 <= std_logic_vector(to_unsigned(0,5));
    ra2 <= std_logic_vector(to_unsigned(0,5));
    wa <= std_logic_vector(to_unsigned(0,5));
    wd <= std_logic_vector(to_unsigned(0,32));
    wait for Tclk-SaT;
    assert unsigned(rd1)=0 report "Read data rd1 is wrong!" severity warning;
    assert unsigned(rd2)=0 report "Read data rd2 is wrong!" severity warning;
    assert rd1_rtl=rd1 and rd2_rtl=rd2 report "RTL and stdcell implementations differ!" severity error;
    wait for SaT;
    -- done
    assert false report "The verification of rf32x32 is successful!" severity note;
    wait;
  end process;
end architecture test;

