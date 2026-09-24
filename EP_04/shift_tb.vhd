-------------------------------------------------------------------------------
-- Title      : shift testench
-- Project    : 
-------------------------------------------------------------------------------
-- File       : shift_tb.vhd
-- Author     : Pinit Kumhom  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-08-29
-- Last update: 2026-09-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Functional verification of shift
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
entity shift_tb is
  
end entity shift_tb;

architecture test of shift_tb is
  component shift is
    port(sfn      : in std_logic_vector(1 downto 0);
         a       : in std_logic_vector(31 downto 0);
         b       : in std_logic_vector(4 downto 0);
         y       : out std_logic_vector(31 downto 0));
  end component;
  for all : shift
    use entity work.shift(stdcell);
  
  signal sfn   : std_logic_vector(1 downto 0);
  signal a    : std_logic_vector(31 downto 0);
  signal b    : std_logic_vector(4 downto 0);
  signal y_shift    : std_logic_vector(31 downto 0);
  signal y_ex : std_logic_vector(31 downto 0);
  --
  constant Tclk : time := 100 ns;
  constant SaT : time := 0.01*Tclk;
  signal TP : integer := 0;
  --
  -- function for reading expected result from the test vector file
  function LH_to_01 (a_in : std_logic_vector)
    return std_logic_vector is
    variable y : std_logic_vector(a_in'range);
  begin
    for j in a_in'range loop
      if a_in(j)='L' then
        y(j) := '0';
      elsif a_in(j)='H' then
        y(j) := '1';
      else
        y(j) := 'U';
      end if;
    end loop;
    return y;
  end function LH_to_01;
  
  --
  -- function for reading expected result from the test vector file
  function LH_to_01 (a_in : std_logic)
    return std_logic is
    variable y : std_logic;
  begin
      if a_in='L' then
        y := '0';
      elsif a_in='H' then
        y := '1';
      else
        y := 'U';
      end if;
    return y;
  end function LH_to_01;
  --
begin  -- architecture beh
  shift_1: shift
    port map (
      sfn => sfn,
      a   => a,
      b   => b,
      y   => y_shift);
  -- 
  process is
    variable ins : unsigned(4 downto 0);
    variable a_in, si : unsigned(31 downto 0);
    variable y_exp : unsigned(31 downto 0);
    file input_file  : text open read_mode is "shift_testvec.txt";
    variable input_line : line;
    variable sfn_v : std_logic_vector(1 downto 0);
    variable a_v, y_ex_v : std_logic_vector(31 downto 0);
    variable b_v : std_logic_vector(4 downto 0);
    variable ok : boolean;
  begin  -- process
    while (not endfile(input_file)) loop
      readline(input_file, input_line);
      if input_line.all'length=0 or input_line(1)='.' then
        next;
      end if;
      read(input_line,sfn_v, ok);
      assert ok report "Read afn failed for line" severity failure;
      sfn <= sfn_v;
      read(input_line,a_v, ok);
      assert ok report "Read a_v failed for line" severity failure;
      a <= a_v;
      read(input_line,b_v, ok);
      assert ok report "Read b_v failed for line" severity failure;
      b <= b_v;
      read(input_line,y_ex_v, ok);
      assert ok report "Read y_exp failed for line" severity failure;
      y_ex <= LH_to_01(y_ex_v);
      
      -- run for Tclk-SaT, and then check the result with expected value
      wait for Tclk-SaT;
      -- checking result 
      assert y_shift=y_ex report "Y of the shift module is wrong!" severity warning;
      wait for SaT;
      TP <= TP+1;
    end loop;
    for i in 0 to 2**5-1 loop
      ins := to_unsigned(i,5);
      b <= std_logic_vector(ins);
      --
      sfn <= "00";                       -- logical shift left
      a_in := X"AAAAAAAA";
      a <= std_logic_vector(a_in);
      y_exp := a_in sll i;
      y_ex <= std_logic_vector(y_exp);
      wait for Tclk-SaT;
      assert y_shift=std_logic_vector(y_exp) report "Wrong shift left logic at this TP!" severity warning;
      wait for SaT;
      --
      sfn <= "01";                       -- logical shift right
      a_in := X"AAAAAAAA";
      a <= std_logic_vector(a_in);
      y_exp := a_in srl i;
      y_ex <= std_logic_vector(y_exp);
      wait for Tclk-SaT;
      assert y_shift=std_logic_vector(y_exp) report "Wrong shift right logic at this TP!" severity warning;
      wait for SaT;
      --
      sfn <= "11";                       -- arith. shift right
      a_in := X"AAAAAAAA";
      a <= std_logic_vector(a_in);
      y_exp := a_in srl i;
      if i>0 then
        y_exp(31 downto 32-i) := (others => a_in(31));  -- sign extension
      end if;
      y_ex <= std_logic_vector(y_exp);
      wait for Tclk-SaT;
      assert y_shift=std_logic_vector(y_exp) report "Wrong shift right arith. at this TP!" severity warning;
      wait for SaT;
      --
      a_in := X"55555555";
      a <= std_logic_vector(a_in);
      y_exp := a_in srl i;
      if i>0 then
        y_exp(31 downto 32-i) := (others => a_in(31));  -- sign extension
      end if;
      y_ex <= std_logic_vector(y_exp);
      wait for Tclk-SaT;
      assert y_shift=std_logic_vector(y_exp) report "Wrong shift right logic at this TP!" severity warning;
      wait for SaT;
      --
      TP <= TP+1;
    end loop;  -- i    
    assert false report "The shift module is successfully verified." severity note;
    wait;
  end process;
end architecture test;

