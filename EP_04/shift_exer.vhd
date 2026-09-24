-------------------------------------------------------------------------------
-- Title      : shift
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : shift.vhd
-- Author     : Pinit Kumhom  <pkumhom@Pinits-MacBook-Pro-2.local>
-- Company    : 
-- Created    : 2026-02-24
-- Last update: 2026-09-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-09-19           pkumhom Add the stdcell archiecture
-- 2026-02-24  1.0      pkumhom	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity shift is
  port(sfn    : in std_logic_vector(1 downto 0);
       a     : in std_logic_vector(31 downto 0);
       b     : in std_logic_vector(4 downto 0);
       y     : out std_logic_vector(31 downto 0));
end entity shift;

architecture beh of shift is
  signal shL0, shL1, sh_L   : std_logic_vector(31 downto 0);
  signal shR0, shR1, sh_R   : std_logic_vector(31 downto 0);
  -- constants for logic shift left
  constant Z24   : std_logic_vector(23 downto 0) := (others => '0');
  constant Z16   : std_logic_vector(15 downto 0) := (others => '0');
  constant Z8   : std_logic_vector(7 downto 0) := (others => '0');
  constant Z4   : std_logic_vector(3 downto 0) := (others => '0');
  constant Z2   : std_logic_vector(1 downto 0) := (others => '0');
  -- signals for shifting right
  signal si   : std_logic;
  signal si24   : std_logic_vector(23 downto 0);
  signal si16   : std_logic_vector(15 downto 0);
  signal si8   : std_logic_vector(7 downto 0);
  signal si4   : std_logic_vector(3 downto 0);
  signal si2   : std_logic_vector(1 downto 0);
begin  -- architecture beh
  si24 <= (others => si);
  si16 <= (others => si);
  si8  <= (others => si);
  si4  <= (others => si);
  si2  <= (others => si);
  -- setting up serial in for shifting right
  si <= a(31) when sfn(1)='1' else '0';
  -- shifting right
  with b(4 downto 3) select
    shR0 <=
    si24&a(31 downto 24) when "11",
    si16&a(31 downto 16) when "10",
    si8&a(31 downto 8)   when "01",
    a                    when others;
  with b(2 downto 1) select
    shR1 <=
    si4&si2&shR0(31 downto 6) when "11",
    si4&shR0(31 downto 4)     when "10",
    si2&shR0(31 downto 2)     when "01",
    shR0                      when others;
  sh_R <= si&shR1(31 downto 1) when b(0)='1' else shR1;
  -- shifting left
  with b(4 downto 3) select
    shL0 <=
    a(7  downto 0)&Z24 when "11",
    a(15 downto 0)&Z16 when "10",
    a(23 downto 0)&Z8  when "01",
    a                  when others;
  with b(2 downto 1) select
    shL1 <=
    shL0(25 downto 0)&Z4&Z2 when "11",
    shL0(27 downto 0)&Z4    when "10",
    shL0(29 downto 0)&Z2    when "01",
    shL0                      when others;
  sh_L <= shL1(30 downto 0)&'0' when b(0)='1' else shL1;
  y <= sh_R when sfn(0)='1' else sh_L;
end architecture beh;

library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
architecture stdcell of shift is
  -- signals and constants for logic shift left
  signal shL0, shL8b, shL16b, shL24b : std_logic_vector(31 downto 0);
  signal shL1, shL2b, shL4b, shL6b, shL1b, YL   : std_logic_vector(31 downto 0);
  constant Z24   : std_logic_vector(23 downto 0) := (others => '0');
  constant Z16   : std_logic_vector(15 downto 0) := (others => '0');
  constant Z8   : std_logic_vector(7 downto 0) := (others => '0');
  constant Z4   : std_logic_vector(3 downto 0) := (others => '0');
  constant Z2   : std_logic_vector(1 downto 0) := (others => '0');
  -- signals for shifting right
  signal shR0, shR8b, shR16b, shR24b : std_logic_vector(31 downto 0);
  signal shR1, shR2b, shR4b, shR6b, shR1b, YR   : std_logic_vector(31 downto 0);
  signal msb_in   : std_logic;
  signal msb24   : std_logic_vector(23 downto 0);
  signal msb16   : std_logic_vector(15 downto 0);
  signal msb8   : std_logic_vector(7 downto 0);
  signal msb4   : std_logic_vector(3 downto 0);
  signal msb2   : std_logic_vector(1 downto 0);
  
begin  -- architecture stdcell
  -- selecting msb_in
  si_gen: entity stdcell_lib.mux2(beh)
    port map (
      d0 => '0',
      d1 => a(31),
      s  => sfn(1),
      z  => msb_in);
  msb24 <= (others => msb_in);
  msb16 <= (others => msb_in);
  msb8  <= (others => msb_in);
  msb4  <= (others => msb_in);
  msb2  <= (others => msb_in);
  -- shifting right structure
  shR24b <= msb24&a(31 downto 24);
  shR16b <= msb16&a(31 downto 16);
  shR8b  <= msb8&a(31 downto 8);
  shR6b  <= msb4&msb2&shR0(31 downto 6);
  shR4b  <= msb4&shR0(31 downto 4);
  shR2b  <= msb2&shR0(31 downto 2);
  shR1b <= msb_in&shR1(31 downto 1);
  sr_0: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => a,
      d1 => shR8b,
      d2 => shR16b, 
      d3 => shR24b,
      s => b(4 downto 3),
      z => shR0
      );
  sr_1: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => shR0,
      d1 => shR2b,
      d2 => shR4b,
      d3 => shR6b,
      s => b(2 downto 1),
      z => shR1
      );
  sr_2: entity stdcell_lib.mux2xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => shR1,
      d1 => shR1b,
      s => b(0),
      z => YR
      );
  
  -- shifting left structure
  shL8b <= a(23 downto 0)&Z8;
  shL16b <= a(15 downto 0)&Z16;
  shL24b <= a(7 downto 0)&Z24;
  shL6b <= shL0(25 downto 0)&Z4&Z2;
  shL4b <= shL0(27 downto 0)&Z4;
  shL2b <= shL0(29 downto 0)&Z2;
  shL1b <= shL1(30 downto 0)&'0';
  sl_0: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => a,
      d1 => shL8b,
      d2 => shL16b,
      d3 => shL24b,
      s => b(4 downto 3),
      z => shL0
      );
  sl_1: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => shL0,
      d1 => shL2b,
      d2 => shL4b,
      d3 => shL6b,
      s => b(2 downto 1),
      z => shL1
      );
  sl_2: entity stdcell_lib.mux2xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => shL1,
      d1 => shL1b,
      s => b(0),
      z => YL
      );
  -- selecting left or right
  s_LR: entity stdcell_lib.mux2xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => YL,
      d1 => YR,
      s => sfn(0),
      z => y
      );
end architecture stdcell;
