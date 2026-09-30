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
-- Description: function verification of adder32
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

entity dec5to32_tb is
  
end entity dec5to32_tb;

architecture test of dec5to32_tb is
  -- generic constants
  constant n : natural := 5;
  constant m : natural := 2**n;
  -- inputs
  signal en : std_logic;
  signal a  : std_logic_vector(n-1 downto 0);
  -- outputs
  signal y    : std_logic_vector(m-1 downto 0);
  
  -- Timing constants
  constant Tclk : time := 10 ns;
  constant SaT : time := 0.01*Tclk;
  -- Test Pattern #
  signal TP : integer := 0;
begin
  dec5to32_1: entity work.dec5to32(stdcell)
    port map (
      en => en,
      a  => a,
      y  => y);

  
  -- clock generation
  -- process
  -- begin  -- process
  --   clk <= '1';
  --   wait for Tclk/2;
  --   clk <= '0';
  --   wait for Tclk/2;
  -- end process;

  process
    variable a_v : std_logic_vector(n-1 downto 0);
    variable y_exp : std_logic_vector(m-1 downto 0);
    constant zeros : std_logic_vector(m-1 downto 0) := (others => '0');
  begin  -- process
    en <= '1';
    for i in 0 to m-1 loop
      TP <= i;
      a <= std_logic_vector(to_unsigned(i,n));
      y_exp := (others => '0');
      y_exp(i) := '1';
      -- run for Tclk-SaT, and then check the result with expected value
      wait for Tclk-SaT;
      assert y=y_exp report "Some bit of Y is wrong!" severity warning; 
      wait for SaT;
    end loop;
    en <= '0';
    for i in 0 to m-1 loop
      TP <= i+m;
      a <= std_logic_vector(to_unsigned(i,n));
      -- run for Tclk-SaT, and then check the result with expected value
      wait for Tclk-SaT;
      -- checking the result
      assert y=zeros report "all Y(i) should NOT active!" severity warning; 
      wait for SaT;
    end loop;
    assert false report "The function verification of dec5to32 module is successful" severity note;
    wait;
  end process;
end architecture test;

