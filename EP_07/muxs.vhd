-------------------------------------------------------------------------------
-- Title      : 32-bit 32-input mux 
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : muxs.vhd
-- Author     : Pinit Kumhom (PK)  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-13
-- Last update: 2026-09-13
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
--   32-input mux of 32 bits data
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
entity mux32 is
  
  port (
    s  : in  std_logic_vector(4 downto 0);
    d0, d1, d2, d3, d4, d5, d6, d7         : in  std_logic_vector(31 downto 0);
    d8, d9, d10, d11, d12, d13, d14, d15   : in  std_logic_vector(31 downto 0);
    d16, d17, d18, d19, d20, d21, d22, d23 : in  std_logic_vector(31 downto 0);
    d24, d25, d26, d27, d28, d29, d30, d31 : in  std_logic_vector(31 downto 0);
    y  : out std_logic_vector(31 downto 0));

end entity mux32;
architecture stdcell of mux32 is
  constant width : natural := 32;
  type data_array is array (natural range<>) of std_logic_vector(width-1 downto 0);
  signal d : data_array(0 to 31);
  signal n0 : data_array(0 to 7);
  signal n1 : data_array(0 to 1);
begin  -- architecture stdcell
  -- connecting input data into data_array for indexing
  d(0) <= d0; d(1) <= d1; d(2) <= d2; d(3) <= d3; d(4) <= d4; d(5) <= d5; d(6) <= d6; d(7) <= d7;
  d(8) <= d8; d(9) <= d9; d(10) <= d10; d(11) <= d11; d(12) <= d12; d(13) <= d13; d(14) <= d14; d(15) <= d15;
  d(16) <= d16; d(17) <= d17; d(18) <= d18; d(19) <= d19; d(20) <= d20; d(21) <= d21; d(22) <= d22; d(23) <= d23;
  d(24) <= d24; d(25) <= d25; d(26) <= d26; d(27) <= d27; d(28) <= d28; d(29) <= d29; d(30) <= d30; d(31) <= d31;
  -- Level 0: 8 mux4
  L0: for i in 0 to 7 generate
    mux4_i: entity stdcell_lib.mux4xN(beh)
      generic map (n => 32)
      port map (s => s(1 downto 0), d0 => d(4*i), d1 => d(4*i+1), d2 => d(4*i+2), d3 => d(4*i+3), z => n0(i));
  end generate L0;
  -- Level 1: 2 mux4
  L1: for i in 0 to 1 generate
    mux4_i: entity stdcell_lib.mux4xN(beh)
      generic map (n => 32)
      port map (s => s(3 downto 2), d0 => n0(4*i), d1 => n0(4*i+1), d2 => n0(4*i+2), d3 => n0(4*i+3), z => n1(i));
  end generate L1;
  -----------------------------------------------------------------------------
  -- Level 2: use a mux2xN to select the 2 cases of level 1 to the output
  mux2_1: entity stdcell_lib.mux2xN(beh)
    generic map (n => 32)
    port map (s => s(4), d0 => n1(0), d1 => n1(1), z => y);
end architecture stdcell;
