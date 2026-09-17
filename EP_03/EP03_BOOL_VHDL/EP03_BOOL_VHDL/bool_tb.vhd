-------------------------------------------------------------------------------
-- Title      : BOOL testbench
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : bool_tb.vhd
-- Author     : Pinit Kumhom  <pkumhom@Pinits-MacBook-Pro-2.local>
-- Company    : 
-- Created    : 2026-08-25
-- Last update: 2026-09-03
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Functional verification of beta ALU
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-08-29  1.0      pkumhom	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- packages for managing text files
use std.textio.all;
use ieee.std_logic_textio.all;

entity bool_tb is
  
end entity bool_tb;

architecture test of bool_tb is
  component bool is
    port(bfn     : in std_logic_vector(3 downto 0);
         a,b     : in std_logic_vector(31 downto 0);
         y       : out std_logic_vector(31 downto 0));
  end component;
  for bool_1 : bool
    use entity work.bool(beh);
  for bool_2 : bool
    use entity work.bool(struct_stdcell);
  for bool_3 : bool
    use entity work.bool(fn_stdcell);
  
  -- inputs
--  signal clk, reset : std_logic;
  signal bfn : std_logic_vector(3 downto 0);
  signal a, b : std_logic_vector(31 downto 0);
  -- outputs
  signal y_ex    : std_logic_vector(31 downto 0);
  signal y_1, y_2, y_3 : std_logic_vector(31 downto 0);
  
  constant Tclk : time := 10 ns;
  constant SaT : time := 0.01*Tclk;
  signal TP : integer := 0;
  signal check : boolean;
  
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

  
begin  -- architecture beh
  bool_1: bool
    port map (bfn => bfn, a => a, b => b, y => y_1);
  bool_2: bool
    port map (bfn => bfn, a => a, b => b, y => y_2);
  bool_3: bool
    port map (bfn => bfn, a => a, b => b, y => y_3);

  process is
    file input_file  : text open read_mode is "bool_testvec.txt";
    variable input_line : line;
    variable bfn_v : std_logic_vector(3 downto 0);
    variable a_v, b_v, y_v : std_logic_vector(31 downto 0);
    variable y_string : string(33 downto 1);
    variable y_exp : std_logic_vector(31 downto 0);
    variable ok : boolean;
  begin  -- process
    while (not endfile(input_file)) loop
      TP <= TP+1;
      readline(input_file, input_line);
      if input_line.all'length=0 or input_line(1)='.' then
        next;
      end if;
      read(input_line,bfn_v, ok);
      assert ok report "Read bfn failed for line" severity failure;
      bfn <= bfn_v;
      read(input_line,a_v, ok);
      assert ok report "Read a_v failed for line" severity failure;
      a <= a_v;
      read(input_line,b_v, ok);
      assert ok report "Read b_v failed for line" severity failure;
      b <= b_v;
      read(input_line,y_exp, ok);
      assert ok report "Read y_exp failed for line" severity failure;
      y_ex <= LH_to_01(y_exp);
      
      -- run for Tclk-SaT, and then check the result with expected value
      wait for Tclk-SaT;
      assert y_1=y_ex report "Y from design#1 is wrong!" severity warning;
      assert y_2=y_ex report "Y from design#2 is wrong!" severity warning;
      assert y_3=y_ex report "Y from design#3 is wrong!" severity warning;
      
      wait for SaT;
    end loop;
    assert false report "The function verification of BOOL module is successful!" severity note;
    wait;
  end process;
end architecture test;

