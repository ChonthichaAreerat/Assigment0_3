-------------------------------------------------------------------------------
-- Title      : binadder (binary adder)
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : binadder_rtl.vhd
-- Author     : Pinit Kumhom (PK)  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-10
-- Last update: 2026-09-10
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: RTL synthesizable n-bit binary (unsigned) adder
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- 2026-09-10  1.0      PK	 Created
-------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity binadder is
  generic (
    width : natural);
  port(a,b     : in std_logic_vector(width-1 downto 0);
       ci      : in std_logic;
       co   : out std_logic;
       s       : out std_logic_vector(width-1 downto 0));
end entity binadder;
-------------------------------------------------------------------------------
-- n-bit RTL binary adder: work.binadder(rtl)
-------------------------------------------------------------------------------
architecture rtl of binadder is
  signal a_u, b_u, s_u   : unsigned(width+1 downto 0);
-- 
begin  -- architecture rtl
  a_u <= unsigned('0'&a&'1');
  b_u <= unsigned('0'&b&ci);
  s_u <= a_u + b_u;
  s <= std_logic_vector(s_u(width downto 1));
  co <= s_u(width+1);
end architecture rtl;
