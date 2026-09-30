-------------------------------------------------------------------------------
-- Title      : alu testbenh
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : alu_tb.vhd
-- Author     : Pinit Kumhom  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-12
-- Last update: 2026-09-12
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: function verification of adder32
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-09-12  1.0      PK	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- packages for managing text files
use std.textio.all;
use ieee.std_logic_textio.all;

entity alu_tb is
  
end entity alu_tb;

architecture test of alu_tb is
  -- generic constants
  constant width : natural := 32;
  -- inputs
  signal alufn : std_logic_vector(5 downto 0);
  signal a, b : std_logic_vector(width-1 downto 0);
  -- outputs
  signal y_ex    : std_logic_vector(width-1 downto 0);
  signal zvn_ex : std_logic_vector(2 downto 0);
  signal y_1, y_2, y_3, y_4    : std_logic_vector(width-1 downto 0);
  signal zvn_1, zvn_2, zvn_3, zvn_4 : std_logic_vector(2 downto 0);
  -- Timing constants
  constant Tclk : time := 100 ns;
  constant SaT : time := 0.01*Tclk;
  -- Test Pattern #
  signal TP : integer := 0;
  --
  -- function for reading expected result from the test vector file
  function LH_to_01 (a : std_logic_vector)
    return std_logic_vector is
    variable y : std_logic_vector(a'range);
  begin
    for j in a'range loop
      if a(j)='L' then
        y(j) := '0';
      elsif a(j)='H' then
        y(j) := '1';
      else
        y(j) := 'U';
      end if;
    end loop;
    return y;
  end function LH_to_01;
  
  --
  -- function for reading expected result from the test vector file
  function LH_to_01 (a : std_logic)
    return std_logic is
    variable y : std_logic;
  begin
      if a='L' then
        y := '0';
      elsif a='H' then
        y := '1';
      else
        y := 'U';
      end if;
    return y;
  end function LH_to_01;
  
begin  -- architecture beh
  alu_1: entity work.alu(struct_rtl_arith)
    port map (
      alufn => alufn,
      a  => a,
      b  => b,
      y  => y_1,
      zvn => zvn_1);
  alu_2: entity work.alu(struct_rca_arith)
    port map (
      alufn => alufn,
      a  => a,
      b  => b,
      y  => y_2,
      zvn => zvn_2);
  alu_3: entity work.alu(struct_csa_arith)
    port map (
      alufn => alufn,
      a  => a,
      b  => b,
      y  => y_3,
      zvn => zvn_3);
  alu_4: entity work.alu(struct_cla_arith)
    port map (
      alufn => alufn,
      a  => a,
      b  => b,
      y  => y_4,
      zvn => zvn_4);

  
  -- clock generation
  -- process
  -- begin  -- process
  --   clk <= '1';
  --   wait for Tclk/2;
  --   clk <= '0';
  --   wait for Tclk/2;
  -- end process;

  process
    file input_file  : text open read_mode is "alu_testvec.txt";
    variable input_line : line;
    variable alufn_v : std_logic_vector(5 downto 0);
    variable a_v, b_v : std_logic_vector(width-1 downto 0);
    variable y_exp : std_logic_vector(width-1 downto 0);
    variable zvn_exp : std_logic_vector(2 downto 0);
    variable ok : boolean;
  begin  -- process
    while (not endfile(input_file)) loop
      TP <= TP+1;
      readline(input_file, input_line);
      if input_line.all'length=0 or input_line(1)='.' then
        next;
      end if;
      read(input_line,alufn_v, ok);
      assert ok report "Read afn failed for line" severity failure;
      alufn <= alufn_v;
      read(input_line,a_v, ok);
      assert ok report "Read a_v failed for line" severity failure;
      a <= a_v;
      read(input_line,b_v, ok);
      assert ok report "Read b_v failed for line" severity failure;
      b <= b_v;
      read(input_line,y_exp, ok);
      assert ok report "Read y_exp failed for line" severity failure;
      y_ex <= LH_to_01(y_exp);
      read(input_line,zvn_exp, ok);
      assert ok report "Read zvn_exp failed for line" severity failure;
      zvn_ex <=  LH_to_01(zvn_exp);
      
      -- run for Tclk-SaT, and then check the result with expected value
      wait for Tclk-SaT;
      -- checking result of design#1 (RTL)
      assert y_1=y_ex report "Y of alu(RTL) design! is wrong!" severity warning;
      assert zvn_1 = zvn_ex report "zvn flags of alu(RTL) design is wrong!" severity warning;
      -- checking result of design#2 (rca_stdcell)
      assert y_2=y_ex report "Y of alu(RCA) design! is wrong!" severity warning;
      assert zvn_2 = zvn_ex report "zvn flags of alu(RCA design is wrong!" severity warning;
      -- checking result of design#3 (csa_stdcell)
      assert y_3=y_ex report "Y of alu(CSA) design! is wrong!" severity warning;
      assert zvn_3 = zvn_ex report "zvn flags of alu(CSA) design is wrong!" severity warning;
      -- checking result of design#4 (cla_stdcell)
      assert y_4=y_ex report "Y of alu(CLA) design! is wrong!" severity warning;
      assert zvn_4 = zvn_ex report "zvn flags of alu(CLA) design is wrong!" severity warning;
      -- progessing to the next clock
      wait for SaT;
    end loop;
    assert false report "The function verification of alu module is successful" severity note;
    wait;
  end process;
end architecture test;

