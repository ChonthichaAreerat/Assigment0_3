-------------------------------------------------------------------------------
-- Title      : CMP
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : CMP.vhd
-- Author     : Pinit Kumhom (PK)  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-02-24
-- Last update: 2026-09-07
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: RTL synthesiable comparators for beta ISA
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-09-07           PK      Add "stdcell" archiecture
-- 2026-02-24  1.0      PK	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
entity CMP is
  port(cfn      : in std_logic_vector(1 downto 0);
       z,v,n   : in std_logic;
       y       : out std_logic_vector(31 downto 0));
end entity CMP;

architecture beh of CMP is
  signal a_lt_b   : std_logic;
begin  -- architecture beh
  a_lt_b <= v xor n;
  with cfn select
    y(0) <=
    (a_lt_b or z) when "11",
    a_lt_b        when "10",
    z             when "01",
    '0'           when others;
  y(31 downto 1) <= (others => '0');
end architecture beh;

library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
architecture stdcell of CMP is
  signal lt, le, lt_n, z_n, z0 : std_logic;
begin  -- architecture stdcell
  
  lt <= xor2(n,v) after tpd_xor2;
  z_n <= inv(z) after tpd_inv;
  lt_n <= inv(lt) after tpd_inv;
  le <= nand2(z_n,lt_n) after tpd_nand2;
  y(0) <= mux4(cfn(0), cfn(1), z0, z, lt, le) after tpd_mux4;
  z0 <= '0';
  y(31 downto 1) <= (others => '0');
  
end architecture stdcell;
