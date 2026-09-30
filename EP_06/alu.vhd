-------------------------------------------------------------------------------
-- Title      : alu (32-bit ALU)
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : alu.vhd
-- Author     : Pinit Kumhom  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-03
-- Last update: 2026-09-12
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: function verification of ALU for unpipelined beta CPU
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-09-12           pkumhom fn --> alufn, adder --> arith
-- 2026-09-03  1.0      pkumhom	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity alu is
  
  port(alufn  : in std_logic_vector(5 downto 0);
       a,b    : in std_logic_vector(31 downto 0);
       y      : out std_logic_vector(31 downto 0);
       zvn    : out std_logic_vector(2 downto 0));
  
end entity alu;

architecture struct_rtl_arith of alu is  
  -- generic constants
  constant width : natural := 32;
  -- module's result
  signal y_arith  : std_logic_vector(width-1 downto 0);
  signal y_cmp    : std_logic_vector(width-1 downto 0);
  signal y_bool   : std_logic_vector(width-1 downto 0);
  signal y_shift  : std_logic_vector(width-1 downto 0);
  signal z, v, n : std_logic;
begin  -- architecture struct_rtl_arith
  zvn <= z&v&n;
  arith_1: entity work.arith32(rtl)
    port map (
      afn => alufn(0),
      a   => a,
      b   => b,
      y   => y_arith,
      z   => z, v => v, n => n);
  
  cmp_1: entity work.cmp(stdcell)
    port map (
      cfn => alufn(2 downto 1),
      z   => z, v => v, n => n,
      y   => y_cmp);
  
  bool_1: entity work.bool(struct_stdcell)
    port map (
      bfn => alufn(3 downto 0),
      a   => a,
      b   => b,
      y   => y_bool);
 
  shift_1: entity work.shift(struct_stdcell)
    port map (
      sfn => alufn(1 downto 0),
      a   => a,
      b   => b(4 downto 0),
      y   => y_shift);
  
  mux_1: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => width)
    port map (
      s  => alufn(5 downto 4),
      d0 => y_cmp,
      d1 => y_arith,
      d2 => y_bool,
      d3 => y_shift,
      z => y);
  
end architecture struct_rtl_arith;

library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
architecture struct_rca_arith of alu is  
  -- generic constants
  constant width : natural := 32;
  -- module's result
  signal y_arith  : std_logic_vector(width-1 downto 0);
  signal y_cmp    : std_logic_vector(width-1 downto 0);
  signal y_bool   : std_logic_vector(width-1 downto 0);
  signal y_shift  : std_logic_vector(width-1 downto 0);
  signal z, v, n : std_logic;
begin  -- architecture struct_rca_arith
  zvn <= z&v&n;
  arith_1: entity work.arith32(rca_stdcell)
    port map (
      afn => alufn(0),
      a   => a,
      b   => b,
      y   => y_arith,
      z   => z, v => v, n => n);
  
  cmp_1: entity work.cmp(stdcell)
    port map (
      cfn => alufn(2 downto 1),
      z   => z, v => v, n => n,
      y   => y_cmp);
  
  bool_1: entity work.bool(struct_stdcell)
    port map (
      bfn => alufn(3 downto 0),
      a   => a,
      b   => b,
      y   => y_bool);
 
  shift_1: entity work.shift(struct_stdcell)
    port map (
      sfn => alufn(1 downto 0),
      a   => a,
      b   => b(4 downto 0),
      y   => y_shift);
  
  mux_1: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => width)
    port map (
      s  => alufn(5 downto 4),
      d0 => y_cmp,
      d1 => y_arith,
      d2 => y_bool,
      d3 => y_shift,
      z => y);
  
end architecture struct_rca_arith;


library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
architecture struct_csa_arith of alu is  
  -- generic constants
  constant width : natural := 32;
  -- module's result
  signal y_arith  : std_logic_vector(width-1 downto 0);
  signal y_cmp    : std_logic_vector(width-1 downto 0);
  signal y_bool   : std_logic_vector(width-1 downto 0);
  signal y_shift  : std_logic_vector(width-1 downto 0);
  signal z, v, n : std_logic;
begin  -- architecture struct_csa_arith
  zvn <= z&v&n;
  arith_1: entity work.arith32(csa_stdcell)
    port map (
      afn => alufn(0),
      a   => a,
      b   => b,
      y   => y_arith,
      z   => z, v => v, n => n);
  
  cmp_1: entity work.cmp(stdcell)
    port map (
      cfn => alufn(2 downto 1),
      z   => z, v => v, n => n,
      y   => y_cmp);
  
  bool_1: entity work.bool(struct_stdcell)
    port map (
      bfn => alufn(3 downto 0),
      a   => a,
      b   => b,
      y   => y_bool);
 
  shift_1: entity work.shift(struct_stdcell)
    port map (
      sfn => alufn(1 downto 0),
      a   => a,
      b   => b(4 downto 0),
      y   => y_shift);
  
  mux_1: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => width)
    port map (
      s  => alufn(5 downto 4),
      d0 => y_cmp,
      d1 => y_arith,
      d2 => y_bool,
      d3 => y_shift,
      z => y);
  
end architecture struct_csa_arith;


library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
architecture struct_cla_arith of alu is  
  -- generic constants
  constant width : natural := 32;
  -- module's result
  signal y_arith  : std_logic_vector(width-1 downto 0);
  signal y_cmp    : std_logic_vector(width-1 downto 0);
  signal y_bool   : std_logic_vector(width-1 downto 0);
  signal y_shift  : std_logic_vector(width-1 downto 0);
  signal z, v, n : std_logic;
begin  -- architecture struct_cla_arith
  zvn <= z&v&n;
  arith_1: entity work.arith32(cla_stdcell)
    port map (
      afn => alufn(0),
      a   => a,
      b   => b,
      y   => y_arith,
      z   => z, v => v, n => n);
  
  cmp_1: entity work.cmp(stdcell)
    port map (
      cfn => alufn(2 downto 1),
      z   => z, v => v, n => n,
      y   => y_cmp);
  
  bool_1: entity work.bool(struct_stdcell)
    port map (
      bfn => alufn(3 downto 0),
      a   => a,
      b   => b,
      y   => y_bool);
 
  shift_1: entity work.shift(struct_stdcell)
    port map (
      sfn => alufn(1 downto 0),
      a   => a,
      b   => b(4 downto 0),
      y   => y_shift);
  
  mux_1: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => width)
    port map (
      s  => alufn(5 downto 4),
      d0 => y_cmp,
      d1 => y_arith,
      d2 => y_bool,
      d3 => y_shift,
      z  => y);
  
end architecture struct_cla_arith;