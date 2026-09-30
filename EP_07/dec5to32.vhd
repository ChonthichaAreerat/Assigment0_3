-------------------------------------------------------------------------------
-- Title      : 5-to-32 binary decoder 
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : dec5to32.vhd
-- Author     : Pinit Kumhom (PK)  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-13
-- Last update: 2026-09-22
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
--    Decoding 5-bit input (address) to 32 enable signal
--    disable all output when input enable is 0
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author   Description     
-- 2026-09-13  1.0      PK	 Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity dec5to32 is
  
  port (
    a  : in  std_logic_vector(4 downto 0);
    en : in  std_logic;
    y  : out std_logic_vector(31 downto 0));

end entity dec5to32;
architecture stdcell of dec5to32 is
  signal en_n: std_logic; 
  signal a_n : std_logic_vector(4 downto 0);
  signal n0 : std_logic_vector(15 downto 0);
begin  -- architecture stdcell
  -- getting active-0 of all inputs
  inv_g: for i in 0 to 4 generate
    inv_i: entity stdcell_lib.inverter(beh)
      port map (a => a(i), z => a_n(i));
  end generate inv_g;
  inv_we: entity stdcell_lib.inverter(beh)
    port map (a => en, z => en_n);
  -- level 0: use 16 nand4 to decode the a[3:0] into 16-bit output
  L00: entity stdcell_lib.nand4(beh)
    port map (a => a_n(3), b => a_n(2), c => a_n(1), d => a_n(0), z => n0(0)); --0000
  L01: entity stdcell_lib.nand4(beh)
    port map (a => a_n(3), b => a_n(2), c => a_n(1), d => a(0),   z => n0(1)); --0001
  L02: entity stdcell_lib.nand4(beh)
    port map (a => a_n(3), b => a_n(2), c => a(1),   d => a_n(0), z => n0(2)); --0010
  L03: entity stdcell_lib.nand4(beh)
    port map (a => a_n(3), b => a_n(2), c => a(1),   d => a(0),   z => n0(3)); --0011
  L04: entity stdcell_lib.nand4(beh)
    port map (a => a_n(3), b => a(2),   c => a_n(1), d => a_n(0), z => n0(4)); --0100
  L05: entity stdcell_lib.nand4(beh)
    port map (a => a_n(3), b => a(2),   c => a_n(1), d => a(0),   z => n0(5)); --0101
  L06: entity stdcell_lib.nand4(beh)
    port map (a => a_n(3), b => a(2),   c => a(1),   d => a_n(0), z => n0(6)); --0110
  L07: entity stdcell_lib.nand4(beh)
    port map (a => a_n(3), b => a(2),   c => a(1),   d => a(0),   z => n0(7)); --0111
  L08: entity stdcell_lib.nand4(beh)
    port map (a => a(3),  b => a_n(2), c => a_n(1), d => a_n(0), z => n0(8)); --1000
  L09: entity stdcell_lib.nand4(beh)
    port map (a => a(3),  b => a_n(2), c => a_n(1), d => a(0),   z => n0(9)); --1001
  L010: entity stdcell_lib.nand4(beh)
    port map (a => a(3),  b => a_n(2), c => a(1),   d => a_n(0), z => n0(10)); --1010
  L011: entity stdcell_lib.nand4(beh)
    port map (a => a(3),  b => a_n(2), c => a(1),   d => a(0),   z => n0(11)); --1011
  L012: entity stdcell_lib.nand4(beh)
    port map (a => a(3),  b => a(2),   c => a_n(1), d => a_n(0), z => n0(12)); --1100
  L013: entity stdcell_lib.nand4(beh)
    port map (a => a(3),  b => a(2),   c => a_n(1), d => a(0),   z => n0(13)); --1101
  L014: entity stdcell_lib.nand4(beh)
    port map (a => a(3),  b => a(2),   c => a(1),   d => a_n(0), z => n0(14)); --1110
  L015: entity stdcell_lib.nand4(beh)
    port map (a => a(3),  b => a(2),   c => a(1),   d => a(0),   z => n0(15)); --1111  
  -----------------------------------------------------------------------------
  -- Level 1: use 16 nor3 to combine the outputs of level 0, en_n, and a4
  L1: for i in 0 to 15 generate
    L1_1: entity stdcell_lib.nor3(beh)
      port map (a => en_n, b => a(4),   c => n0(i), z => y(i));  -- 0,n0(i)
    L1_2: entity stdcell_lib.nor3(beh)
      port map (a => en_n, b => a_n(4), c => n0(i), z => y(i+16));  -- 1,n0(i)
  end generate L1;
end architecture stdcell;

