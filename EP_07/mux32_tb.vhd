-------------------------------------------------------------------------------
-- Title      : dec5to32 testbenh
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : dec5to32_tb.vhd
-- Author     : Pinit Kumhom  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-13
-- Last update: 2026-09-13
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: function verification of mux32
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-09-13  1.0      PK	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- packages for managing text files
use std.textio.all;
use ieee.std_logic_textio.all;

entity mux32_tb is
  
end entity mux32_tb;

architecture test of mux32_tb is
  constant width : natural := 32;
  type data_array is array (natural range<>) of std_logic_vector(width-1 downto 0);
  -- generic constants
  constant n : natural := 5;            -- no. of. bits of depth
  constant m : natural := 2**n;         -- depth
  -- inputs
  signal s  : std_logic_vector(n-1 downto 0);
  signal d : data_array(0 to m-1);
  -- outputs
  signal y    : std_logic_vector(m-1 downto 0);
  
  -- Timing constants
  constant Tclk : time := 10 ns;
  constant SaT : time := 0.01*Tclk;
  -- Test Pattern #
  signal TP : integer := 0;
begin
  mux32_1: entity work.mux32(stdcell)
    port map (
      s => s,
      d0 => d(0),d1 => d(1),d2 => d(2),d3 => d(3),d4 => d(4),d5 => d(5),d6 => d(6),d7 => d(7),
      d8 => d(8),d9 => d(9),d10 => d(10),d11 => d(11),d12 => d(12),d13 => d(13),d14 => d(14),d15 => d(15),
      d16 => d(16),d17 => d(17),d18 => d(18),d19 => d(19),d20 => d(20),d21 => d(21),d22 => d(22),d23 => d(23),
      d24 => d(24),d25 => d(25),d26 => d(26),d27 => d(27),d28 => d(28),d29 => d(29),d30 => d(30),d31 => d(31),
      y  => y);

  dgen: for i in 0 to m-1 generate
    d(i) <= std_logic_vector(to_unsigned(i,m));
  end generate dgen;
  -- clock generation
  -- process
  -- begin  -- process
  --   clk <= '1';
  --   wait for Tclk/2;
  --   clk <= '0';
  --   wait for Tclk/2;
  -- end process;

  process
  begin  -- process
    for i in 0 to m-1 loop
      TP <= i;
      s <= std_logic_vector(to_unsigned(i,n));
      -- run for Tclk-SaT, and then check the result with expected value
      wait for Tclk-SaT;
      assert y=d(i) report "Y is wrong!" severity warning; 
      wait for SaT;
    end loop;
    assert false report "The function verification of mux32 module is successful." severity note;
    wait;
  end process;
end architecture test;

