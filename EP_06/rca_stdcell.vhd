-------------------------------------------------------------------------------
-- Title      : ripple-carry binary adder targeting JSIM standard cell
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : rca_stdcell.vhd
-- Author     : Pinit Kumhom (PK)  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-10
-- Last update: 2026-09-11
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: n-bit ripple-carry binary (unsigned) adder (rca)
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- 2026-09-10  1.0      PK	 Created
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- fa module
-- Description:
--    full 1-bit binary adder
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity fa is  
  port (
    a, b : in  std_logic;
    ci   : in  std_logic;
    co,s : out std_logic);
end entity fa;
architecture stdcell of fa is
  signal n1,n2,n3 : std_logic;
begin  -- architecture beh
  n1 <= nand2(a,b)      after tpd_nand2;
  n2 <= xor2(a, b)      after tpd_xor2;
  n3 <= nand2(n2,ci)    after tpd_nand2;
  s  <= xor2(n2,ci)     after tpd_xor2;
  co <= nand2(n1,n3)    after tpd_nand2;
end architecture stdcell;
-------------------------------------------------------------------------------
-- rca module
-- Description: a parameterizable ripple-carry binary adder
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity rca is
  generic (
    width : natural);
  port(a,b     : in std_logic_vector(width-1 downto 0);
       ci      : in std_logic;
       co   : out std_logic;
       s       : out std_logic_vector(width-1 downto 0));
end entity rca;
architecture stdcell of rca is
--  constant width : natural := 32;
  signal c : std_logic_vector(width downto 0);
begin  -- architecture rca_stdcell
  fa_gen: for i in 0 to width-1 generate
    fa_i: entity work.fa(stdcell)
      port map (
        a  => a(i),
        b  => b(i),
        ci => c(i),
        s => s(i),
        co => c(i+1));
  end generate fa_gen;
  -- carry in
  c(0) <= ci;
  -- carry out
  co <= c(width);
end architecture stdcell;
