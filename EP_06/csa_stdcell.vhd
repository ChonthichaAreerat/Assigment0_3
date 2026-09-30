-------------------------------------------------------------------------------
-- Title      : carry-select adder (csa) targeting jSIM standard cell
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : csa_stdcell.vhd
-- Author     : Pinit Kumhom (PK)  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-10
-- Last update: 2026-09-11
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
--   synthesizable n-bit binary (unsigned) adders with
--   carry-lookahead design conept
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- 2026-09-10  1.0      PK	 Created
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- fa_csa module
-- Description:
--   full 1-bit binary adder
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity fa_csa is
  
  port (
    a, b : in  std_logic;
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic);

end entity fa_csa;
architecture stdcell of fa_csa is
  signal n1,n2,n3, n4, n5 : std_logic;
begin  -- architecture beh
  n1 <= nand2(a,b)      after tpd_nand2;
  n2 <= xor2(a, b)      after tpd_xor2;
  s <= xor2(n2,ci)      after tpd_xor2;
  --
  n3 <= nand2(ci,n2)    after tpd_nand2;
  co <= nand2(n1,n3)    after tpd_nand2;
end architecture stdcell;
-------------------------------------------------------------------------------
-- 2-bit Carry-select Binary Adder (CSA2)
-------------------------------------------------------------------------------
-- Description:
--    an 2-bit carry-select unsigned adder targeting JSIM standard cells
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity csa2 is
  
  port (
    a, b : in  std_logic_vector(1 downto 0);
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic_vector(1 downto 0));

end entity csa2;
architecture stdcell of csa2 is
  constant width : natural := 2;
  signal h0, h1 : std_logic;
  signal csel, ch0, ch1 : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.fa_csa(stdcell)
      port map (
        a  => a(0),
        b  => b(0),
        ci => ci,
        co => csel,
        s => s(0));
    adder_H0: entity work.fa_csa(stdcell)
      port map (
        a  => a(1),
        b  => b(1),
        ci => '0',
        co => ch0,
        s => h0);
    adder_H1: entity work.fa_csa(stdcell)
      port map (
        a  => a(1),
        b  => b(1),
        ci => '1',
        co => ch1,
        s => h1);
    -- selecting correct sum of the high bits
    hbits_sel: entity stdcell_lib.mux2(beh)
      port map (s => csel, d0 => h0, d1 => h1, z => s(1));
    -- selecting correct MSB carry out (co)
    ch_sel: entity stdcell_lib.mux2(beh)
      port map (s => csel, d0 => ch0, d1 => ch1, z => co);
    
end architecture stdcell;
-------------------------------------------------------------------------------
-- 4-bit Carry-select Binary Adder (CSA4)
-------------------------------------------------------------------------------
-- Description:
--    an 4-bit carry-select unsigned adder targeting JSIM standard cells
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity csa4 is
  
  port (
    a, b : in  std_logic_vector(3 downto 0);
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic_vector(3 downto 0));

end entity csa4;
architecture stdcell of csa4 is
  constant width : natural := 4;
  signal h0, h1 : std_logic_vector(width/2-1 downto 0);
  signal csel, ch0, ch1 : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.csa2(stdcell)
      port map (
        a  => a(width/2-1 downto 0),
        b  => b(width/2-1 downto 0),
        ci => ci,
        co => csel,
        s => s(width/2-1 downto 0));
    adder_H0: entity work.csa2(stdcell)
      port map (
        a  => a(width-1 downto width/2),
        b  => b(width-1 downto width/2),
        ci => '0',
        co => ch0,
        s => h0(width/2-1 downto 0));
    adder_H1: entity work.csa2(stdcell)
      port map (
        a  => a(width-1 downto width/2),
        b  => b(width-1 downto width/2),
        ci => '1',
        co => ch1,
        s => h1(width/2-1 downto 0));
    -- selecting correct sum of the high bits using mux2xN
    hbits_sel: entity stdcell_lib.mux2xN(beh)
      generic map (n => width/2)
      port map (s => csel, d0 => h0, d1 => h1, z => s(width-1 downto width/2));
    -- selecting correct MSB carry out (co)
    ch_sel: entity stdcell_lib.mux2(beh)
      port map (s => csel, d0 => ch0, d1 => ch1, z => co);
end architecture stdcell;
-------------------------------------------------------------------------------
-- 8-bit Carry-select Binary Adder (CSA8)
-------------------------------------------------------------------------------
-- Description:
--    an 8-bit carry-select unsigned adder targeting JSIM standard cells
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity csa8 is
  
  port (
    a, b : in  std_logic_vector(7 downto 0);
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic_vector(7 downto 0));

end entity csa8;
architecture stdcell of csa8 is
  constant width : natural := 8;
  signal h0, h1 : std_logic_vector(width/2-1 downto 0);
  signal csel, ch0, ch1 : std_logic;
begin  -- architecture stdcell
    adder_L: entity work.csa4(stdcell)
      port map (
        a  => a(width/2-1 downto 0),
        b  => b(width/2-1 downto 0),
        ci => ci,
        co => csel,
        s => s(width/2-1 downto 0));
    adder_H0: entity work.csa4(stdcell)
      port map (
        a  => a(width-1 downto width/2),
        b  => b(width-1 downto width/2),
        ci => '0',
        co => ch0,
        s => h0(width/2-1 downto 0));
    adder_H1: entity work.csa4(stdcell)
      port map (
        a  => a(width-1 downto width/2),
        b  => b(width-1 downto width/2),
        ci => '1',
        co => ch1,
        s => h1(width/2-1 downto 0));
    -- selecting correct sum of the high bits using mux2xN
    hbits_sel: entity stdcell_lib.mux2xN(beh)
      generic map (n => width/2)
      port map (s => csel, d0 => h0, d1 => h1, z => s(width-1 downto width/2));
    -- selecting correct MSB carry out (co)
    ch_sel: entity stdcell_lib.mux2(beh)
      port map (s => csel, d0 => ch0, d1 => ch1, z => co);
end architecture stdcell;
-------------------------------------------------------------------------------
-- 16-bit Carry-select Binary Adder (CSA16)
-------------------------------------------------------------------------------
-- Description:
--    an 16-bit carry-select unsigned adder targeting JSIM standard cells
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity csa16 is
  
  port (
    a, b : in  std_logic_vector(15 downto 0);
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic_vector(15 downto 0));

end entity csa16;
architecture stdcell of csa16 is
  constant width : natural := 16;
  signal h0, h1 : std_logic_vector(width/2-1 downto 0);
  signal csel, ch0, ch1 : std_logic;
begin  -- architecture stdcell
    adder_L: entity work.csa8(stdcell)
      port map (
        a  => a(width/2-1 downto 0),
        b  => b(width/2-1 downto 0),
        ci => ci,
        co => csel,
        s => s(width/2-1 downto 0));
    adder_H0: entity work.csa8(stdcell)
      port map (
        a  => a(width-1 downto width/2),
        b  => b(width-1 downto width/2),
        ci => '0',
        co => ch0,
        s => h0(width/2-1 downto 0));
    adder_H1: entity work.csa8(stdcell)
      port map (
        a  => a(width-1 downto width/2),
        b  => b(width-1 downto width/2),
        ci => '1',
        co => ch1,
        s => h1(width/2-1 downto 0));
    -- selecting correct sum of the high bits using mux2xN
    hbits_sel: entity stdcell_lib.mux2xN(beh)
      generic map (n => width/2)
      port map (s => csel, d0 => h0, d1 => h1, z => s(width-1 downto width/2));
    -- selecting correct MSB carry out (co)
    ch_sel: entity stdcell_lib.mux2(beh)
      port map (s => csel, d0 => ch0, d1 => ch1, z => co);
end architecture stdcell;

-------------------------------------------------------------------------------
-- 32-bit Carry-select Binary Adder (CSA32)
-------------------------------------------------------------------------------
-- Description:
--    an 32-bit carry-select unsigned adder targeting JSIM standard cells
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity csa32 is
  
  port (
    a, b : in  std_logic_vector(31 downto 0);
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic_vector(31 downto 0));

end entity csa32;
architecture stdcell of csa32 is
  constant width : natural := 32;
  signal h0, h1 : std_logic_vector(width/2-1 downto 0);
  signal csel, ch0, ch1 : std_logic;
begin  -- architecture stdcell
    adder_L: entity work.csa16(stdcell)
      port map (
        a  => a(width/2-1 downto 0),
        b  => b(width/2-1 downto 0),
        ci => ci,
        co => csel,
        s => s(width/2-1 downto 0));
    adder_H0: entity work.csa16(stdcell)
      port map (
        a  => a(width-1 downto width/2),
        b  => b(width-1 downto width/2),
        ci => '0',
        co => ch0,
        s => h0(width/2-1 downto 0));
    adder_H1: entity work.csa16(stdcell)
      port map (
        a  => a(width-1 downto width/2),
        b  => b(width-1 downto width/2),
        ci => '1',
        co => ch1,
        s => h1(width/2-1 downto 0));
    -- selecting correct sum of the high bits using mux2xN
    hbits_sel: entity stdcell_lib.mux2xN(beh)
      generic map (n => width/2)
      port map (s => csel, d0 => h0, d1 => h1, z => s(width-1 downto width/2));
    -- selecting correct MSB carry out (co)
    ch_sel: entity stdcell_lib.mux2(beh)
      port map (s => csel, d0 => ch0, d1 => ch1, z => co);
end architecture stdcell;

