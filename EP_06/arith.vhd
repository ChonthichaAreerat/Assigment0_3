-------------------------------------------------------------------------------
-- Title      : arith32 module
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : arith.vhd
-- Author     : Pinit Kumhom (PK)  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-06
-- Last update: 2026-09-10
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: synthesizable 32-bit signed adder for ubeta CPU with different design arch.
--    Design      Architecture  Description
--    design#1    RTL           RTL descripton
--    design#2    rca_stdcell   ripple-carry adder using JSIM stardard cells
--    design#3    csa_stdcell   carry-select adder using JSIM standard cells
--    design#4    cla_stdcell   carry-look-ahead adder using JSIM standard cells
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author   Description
-- 2026-09-06  1.0      PK	 Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity arith32 is
  port(afn      : in std_logic;
       a,b     : in std_logic_vector(31 downto 0);
       y       : out std_logic_vector(31 downto 0);
       z,v,n   : out std_logic);
end entity arith32;
-------------------------------------------------------------------------------
-- arith(rtl)
-------------------------------------------------------------------------------
architecture rtl of arith32 is
  constant width : natural := 32;
  signal a_u, b_u, s_u   : unsigned(width downto 0);
  signal bx, fnxn   : std_logic_vector(width-1 downto 0);
-- 
begin  -- architecture rtl
  a_u <= unsigned(a&'1');
  b_u <= unsigned(bx&afn);
--  bx <= (not b) when afn='1' else b;
  bx <= b xor fnxn;
  fnxn <= (others => afn);
  s_u <= a_u + b_u;
  y <= std_logic_vector(s_u(width downto 1));
  -- flags
  z <= '1' when s_u(width downto 1)=0 else '0';
  v <= '1' when a_u(width)=b_u(width) and s_u(width) /= a_u(width) else '0';
  n <= s_u(width);
end architecture rtl;
-------------------------------------------------------------------------------
-- arith(rca_stdcell): Using binadder32(rca_stdcell) as binary adder
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
architecture rca_stdcell of arith32 is
  constant width : natural := 32;
  signal s, bx, afnxN   : std_logic_vector(width-1 downto 0);
  signal signA_n, signBx_n, signS_n, n1, n2 : std_logic;
-- 
begin  -- architecture rca_stdcell
  binadder_1: entity work.rca(stdcell)
    generic map (width => width)
    port map (
      a  => a,
      b  => bx,
      ci => afn,
      s  => s,
      co => open);
  --
  afnxN <= (others => afn);
  bx_gen: for i in 0 to width-1 generate
    xor_1: entity stdcell_lib.xor2(beh)
      port map (a => afnxN(i), b => b(i), z => bx(i));
  end generate bx_gen;
  --
  -- Z flag
  z_flag: entity work.iszero32(struct_stdcell)
    port map (a => s, z => z);
  -- V flag
  inv_1: entity stdcell_lib.inverter(beh)
    port map (a => a(width-1), z => signA_n);
  inv_2: entity stdcell_lib.inverter(beh)
    port map (a => bx(width-1), z => signBx_n);
  inv_3: entity stdcell_lib.inverter(beh)
    port map (a => s(width-1), z => signS_n);
  nand1_1: entity stdcell_lib.nand3(beh)
    port map (a => a(width-1), b => bx(width-1), c => signS_n, z => n1);
  nand1_2: entity stdcell_lib.nand3(beh)
    port map (a => signA_n, b => signBx_n, c => s(width-1), z => n2);
  nand2_1: entity stdcell_lib.nand2(beh)
    port map (a => n1, b => n2, z => v);
  -- N flag
  n <= s(31);
  --
  -- output
  y <= s;
end architecture rca_stdcell;
-------------------------------------------------------------------------------
-- arith(rca_stdcell): Using binadder32(rca_stdcell) as binary adder
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
architecture csa_stdcell of arith32 is
  constant width : natural := 32;
  signal s, bx, afnxN   : std_logic_vector(width-1 downto 0);
  signal signA_n, signBx_n, signS_n, n1, n2 : std_logic;
-- 
begin  -- architecture rca_stdcell
  binadder_1: entity work.csa32(stdcell)
    port map (
      a  => a,
      b  => bx,
      ci => afn,
      s  => s,
      co => open);
  --
  afnxN <= (others => afn);
  bx_gen: for i in 0 to width-1 generate
    xor_1: entity stdcell_lib.xor2(beh)
      port map (a => afnxN(i), b => b(i), z => bx(i));
  end generate bx_gen;
  --
  -- Z flag
  z_flag: entity work.iszero32(struct_stdcell)
    port map (a => s, z => z);
  -- V flag
  inv_1: entity stdcell_lib.inverter(beh)
    port map (a => a(width-1), z => signA_n);
  inv_2: entity stdcell_lib.inverter(beh)
    port map (a => bx(width-1), z => signBx_n);
  inv_3: entity stdcell_lib.inverter(beh)
    port map (a => s(width-1), z => signS_n);
  nand1_1: entity stdcell_lib.nand3(beh)
    port map (a => a(width-1), b => bx(width-1), c => signS_n, z => n1);
  nand1_2: entity stdcell_lib.nand3(beh)
    port map (a => signA_n, b => signBx_n, c => s(width-1), z => n2);
  nand2_1: entity stdcell_lib.nand2(beh)
    port map (a => n1, b => n2, z => v);
  -- N flag
  n <= s(31);
  --
  -- output
  y <= s;
end architecture csa_stdcell;
-------------------------------------------------------------------------------
-- arith(rca_stdcell): Using binadder32(rca_stdcell) as binary adder
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
architecture cla_stdcell of arith32 is
  constant width : natural := 32;
  signal s, bx, afnxN   : std_logic_vector(width-1 downto 0);
  signal signA_n, signBx_n, signS_n, n1, n2 : std_logic;
-- 
begin  -- architecture rca_stdcell
  -- binary adder with ci=afn, afn=0 <-> ADD, afn=1<--> SUB
  binadder_1: entity work.cla32(stdcell)
    port map (
      a  => a,
      b  => bx,
      ci => afn,
      s  => s,
      g  => open,
      p  => open);
  -- inverting B when afn='1'
  afnxN <= (others => afn);
  bx_gen: for i in 0 to width-1 generate
    xor_1: entity stdcell_lib.xor2(beh)
      port map (a => afnxN(i), b => b(i), z => bx(i));
  end generate bx_gen;
  --
  -- Z flag
  z_flag: entity work.iszero32(struct_stdcell)
    port map (a => s, z => z);
  -- V flag
  inv_1: entity stdcell_lib.inverter(beh)
    port map (a => a(width-1), z => signA_n);
  inv_2: entity stdcell_lib.inverter(beh)
    port map (a => bx(width-1), z => signBx_n);
  inv_3: entity stdcell_lib.inverter(beh)
    port map (a => s(width-1), z => signS_n);
  nand1_1: entity stdcell_lib.nand3(beh)
    port map (a => a(width-1), b => bx(width-1), c => signS_n, z => n1);
  nand1_2: entity stdcell_lib.nand3(beh)
    port map (a => signA_n, b => signBx_n, c => s(width-1), z => n2);
  nand2_1: entity stdcell_lib.nand2(beh)
    port map (a => n1, b => n2, z => v);
  -- N flag
  n <= s(width-1);
  --
  -- output
  y <= s;
end architecture cla_stdcell;
