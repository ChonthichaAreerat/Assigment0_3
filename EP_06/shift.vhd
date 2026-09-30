-------------------------------------------------------------------------------
-- Title      : betaShift
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : betaShift.vhd
-- Author     : Pinit Kumhom  <pkumhom@Pinits-MacBook-Pro-2.local>
-- Company    : 
-- Created    : 2026-02-24
-- Last update: 2026-09-03
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-02-24  1.0      pkumhom	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
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
  with sfn select
    y <= sh_L when "00",
         sh_R when "01",
         a    when "10",
         sh_R when "11",
         a    when others;
end architecture beh;


library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
architecture struct_stdcell of shift is
  -- component mux2 is
  --   port (
  --     d0, d1 : in  std_logic;
  --     s      : in  std_logic;
  --     z      : out std_logic);
  -- end component mux2;
  -- component mux2xN is
  --   generic (
  --     n : natural);
  --   port (
  --     d0, d1 : in  std_logic_vector(n-1 downto 0);
  --     s              : in  std_logic;
  --     z              : out std_logic_vector(n-1 downto 0));
  -- end component mux2xN;
  -- component mux4xN is
  --   generic (
  --     n : natural);
  --   port (
  --     d0, d1, d2, d3 : in  std_logic_vector(n-1 downto 0);
  --     s              : in  std_logic_vector(1 downto 0);
  --     z              : out std_logic_vector(n-1 downto 0));
  -- end component mux4xN;

  signal shL0, shL1, sh_L, shL0_1, shL0_2, shL0_3, shL1_1, shL1_2, shL1_3, sh_L_1   : std_logic_vector(31 downto 0);
  signal shR0, shR1, sh_R, shR0_1, shR0_2, shR0_3, shR1_1, shR1_2, shR1_3, sh_R_1   : std_logic_vector(31 downto 0);
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
  
begin  -- architecture struct_stdcell
  si_gen: entity stdcell_lib.mux2(beh)
    port map (
      d0 => '0',
      d1 => a(31),
      s  => sfn(1),
      z  => si);
  si24 <= (others => si);
  si16 <= (others => si);
  si8  <= (others => si);
  si4  <= (others => si);
  si2  <= (others => si);
  -- shifting right structure
  shR0_3 <= si24&a(31 downto 24);
  shR0_2 <= si16&a(31 downto 16);
  shR0_1 <= si8&a(31 downto 8);
  shR1_3 <= si4&si2&shR0(31 downto 6);
  shR1_2 <= si4&shR0(31 downto 4);
  shR1_1 <= si2&shR0(31 downto 2);
  sh_R_1 <= si&shR1(31 downto 1);
  sr_0: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => a,
      d1 => shR0_1,
      d2 => shR0_2, 
      d3 => shR0_3,
      s => b(4 downto 3),
      z => shR0
      );
  sr_1: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => shR0,
      d1 => shR1_1,
      d2 => shR1_2,
      d3 => shR1_3,
      s => b(2 downto 1),
      z => shR1
      );
  sr_2: entity stdcell_lib.mux2xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => shR1,
      d1 => sh_R_1,
      s => b(0),
      z => sh_R
      );
  
  -- shifting left structure
  shL0_1 <= a(23 downto 0)&Z8;
  shL0_2 <= a(15 downto 0)&Z16;
  shL0_3 <= a(7 downto 0)&Z24;
  shL1_3 <= shL0(25 downto 0)&Z4&Z2;
  shL1_2 <= shL0(27 downto 0)&Z4;
  shL1_1 <= shL0(29 downto 0)&Z2;
  sh_L_1 <= shL1(30 downto 0)&'0';
  sl_0: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => a,
      d1 => shL0_1,
      d2 => shL0_2,
      d3 => shL0_3,
      s => b(4 downto 3),
      z => shL0
      );
  sl_1: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => shL0,
      d1 => shL1_1,
      d2 => shL1_2,
      d3 => shL1_3,
      s => b(2 downto 1),
      z => shL1
      );
  sl_2: entity stdcell_lib.mux2xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => shL1,
      d1 => sh_L_1,
      s => b(0),
      z => sh_L
      );
  -- selecting left, right, pass-through, or arithmetic right shift
  s_LR: entity stdcell_lib.mux4xN(beh)
    generic map (
      n => 32)
    port map (
      d0 => sh_L,
      d1 => sh_R,
      d2 => a,
      d3 => sh_R,
      s  => sfn,
      z => y
      );
end architecture struct_stdcell;
