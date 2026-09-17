-------------------------------------------------------------------------------
-- Title      : adder testbenh (32-bit signed adder)
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : adder_tb.vhd
-- Author     : Pinit Kumhom  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-08-29
-- Last update: 2026-09-03
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: function verification of adder32
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-08-29  1.0      pkumhom	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- For using the standard cells
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

-- packages for managing text files
-- use std.textio.all;
-- use ieee.std_logic_textio.all;

entity stdcell_tb is
  
end entity stdcell_tb;

architecture test of stdcell_tb is
  signal clk : std_logic;
  signal a, b, c, d, s0, s1 : std_logic;
  signal ins, q : std_logic_vector(5 downto 0);
  signal z_inv, z_buf, z_tri : std_logic;
  signal z_and2, z_and3, z_and4 : std_logic;
  signal z_nand2, z_nand3, z_nand4 : std_logic;
  signal z_or2, z_or3, z_or4 : std_logic;
  signal z_nor2, z_nor3, z_nor4 : std_logic;
  signal z_xor2, z_xnor2 : std_logic;
  signal z_mux2, z_mux4 : std_logic;
  --
  signal z_inv_2, z_buf_2, z_tri_2 : std_logic;
  signal z_and2_2, z_and3_2, z_and4_2 : std_logic;
  signal z_nand2_2, z_nand3_2, z_nand4_2 : std_logic;
  signal z_or2_2, z_or3_2, z_or4_2 : std_logic;
  signal z_nor2_2, z_nor3_2, z_nor4_2 : std_logic;
  signal z_xor2_2, z_xnor2_2 : std_logic;
  signal z_mux2_2, z_mux4_2 : std_logic;
  signal z_mux2xN_2 : std_logic_vector(1 downto 0);
  signal z_mux4xN_2 : std_logic_vector(1 downto 0);
  --
  constant Tclk : time := 10 ns;
  constant SaT : time := 0.01*Tclk;
  constant Clk0Delay : time := ts_dreg+SaT;
  signal TP : integer := 0;
  signal check : boolean;
  --
begin  -- architecture beh
  
  -- clock generator
  process
  begin  -- process
    wait for Clk0Delay;
    clk <= '1';
    wait for Tclk/2;
    clk <= '0';
    wait for Tclk/2;
  end process;
  --
  
  -- input waveform generator
  process
    variable ins_v : std_logic_vector(5 downto 0) := (others => '0');
  begin  -- process
    for i in 0 to 63 loop
      TP <= TP+1;
      ins_v := std_logic_vector(to_unsigned(i,6));
      ins <= ins_v;
      wait for Tclk;
    end loop;
    
    assert false
      report "The function verification of primitive gates from JSIM standard cell is done!" severity note;
    wait;
  end process;
  
  a <= ins(0); b <= ins(1); c <= ins(2); d <= ins(3);
  s0 <= ins(4); s1 <= ins(5);

  --
  -- Coding Technique#2: Instantiating the VHDL model (entity+architecture)
  -- from stdcell_lib
  dreg_ut: entity stdcell_lib.dreg(beh)
    generic map (n => 6)
    port map (clk => clk, d => ins, q => q);

  mux2xN_ut: entity stdcell_lib.mux2xN(beh)
    generic map (n => 2)
    port map (s => s0,
              d0 => ins(1 downto 0), d1 => ins(3 downto 2),
              z => z_mux2xN_2);
  mux4xN_ut: entity stdcell_lib.mux4xN(beh)
    generic map (n => 2)
    port map (s => ins(5 downto 4),
              d0 => ins(1 downto 0), d1 => ins(2 downto 1), d2 => ins(3 downto 2), d3 => ins(4 downto 3),
              z => z_mux4xN_2);
  
  inv_ut: entity stdcell_lib.inverter(beh)
    port map (a => a, z => z_inv_2);
  buf_ut: entity stdcell_lib.buf(beh)
    port map (a => a, z => z_buf_2);
  tri_ut: entity stdcell_lib.tristate(beh)
    port map (a => a, e => s0, z => z_tri_2);
  and2_ut: entity stdcell_lib.and2(beh)
    port map (a => a, b => b, z => z_and2_2);
  and3_ut: entity stdcell_lib.and3(beh)
    port map (a => a, b => b, c => c, z => z_and3_2);
  and4_ut: entity stdcell_lib.and4(beh)
    port map (a => a, b => b, c => c, d => d, z => z_and4_2);
  nand2_ut: entity stdcell_lib.nand2(beh)
    port map (a => a, b => b, z => z_nand2_2);
  nand3_ut: entity stdcell_lib.nand3(beh)
    port map (a => a, b => b, c => c, z => z_nand3_2);
  nand4_ut: entity stdcell_lib.nand4(beh)
    port map (a => a, b => b, c => c, d => d, z => z_nand4_2);
  or2_ut: entity stdcell_lib.or2(beh)
    port map (a => a, b => b, z => z_or2_2);
  or3_ut: entity stdcell_lib.or3(beh)
    port map (a => a, b => b, c => c, z => z_or3_2);
  or4_ut: entity stdcell_lib.or4(beh)
    port map (a => a, b => b, c => c, d => d, z => z_or4_2);
  nor2_ut: entity stdcell_lib.nor2(beh)
    port map (a => a, b => b, z => z_nor2_2);
  nor3_ut: entity stdcell_lib.nor3(beh)
    port map (a => a, b => b, c => c, z => z_nor3_2);
  nor4_ut: entity stdcell_lib.nor4(beh)
    port map (a => a, b => b, c => c, d => d, z => z_nor4_2);
  xor2_ut: entity stdcell_lib.xor2(beh)
    port map (a => a, b => b, z => z_xor2_2);
  xnor2_ut: entity stdcell_lib.xnor2(beh)
    port map (a => a, b => b, z => z_xnor2_2);

  mux2_ut: entity stdcell_lib.mux2(beh)
    port map (s => s0, d0 => a, d1 => b, z => z_mux2_2);
  mux4_ut: entity stdcell_lib.mux4(beh)
    port map (s0 => s0, s1 => s1,
              d0 => a, d1 => b, d2 => c, d3 => d,
              z => z_mux4_2);
  -- Coding Technique #3: Using function() to generate waveform of the cell's output
  -- testing inv, buf, tri gates
  z_inv <= inv(a) after tpd_inv;
  z_buf <= buf(a) after tpd_inv;
  z_tri <= tri(a,s0) after tpd_tri;
  -- and, nand gates
  z_and2 <= and2(a,b) after tpd_and2;
  z_and3 <= and3(a,b,c) after tpd_and3;
  z_and4 <= and4(a,b,c,d) after tpd_and4;
  z_nand2 <= nand2(a,b) after tpd_nand2;
  z_nand3 <= nand3(a,b,c) after tpd_nand3;
  z_nand4 <= nand4(a,b,c,d) after tpd_nand4;
  -- or, nor gates
  z_or2 <= or2(a,b) after tpd_or2;
  z_or3 <= or3(a,b,c) after tpd_or3;
  z_or4 <= or4(a,b,c,d) after tpd_or4;
  z_nor2 <= nor2(a,b) after tpd_nor2;
  z_nor3 <= nor3(a,b,c) after tpd_nor3;
  z_nor4 <= nor4(a,b,c,d) after tpd_nor4;
  -- xor, xnor gates
  z_xor2 <= xor2(a,b) after tpd_xor2;
  z_xnor2 <= xnor2(a,b) after tpd_xnor2;
  -- mux2, mux4
  z_mux2 <= mux2(s0, a,b) after tpd_mux2;
  z_mux4 <= mux4(s0, s1, a,b,c,d) after tpd_mux4;
  
end architecture test;

