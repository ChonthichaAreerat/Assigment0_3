-------------------------------------------------------------------------------
-- Title      : betaBoole
-- Project    : Unpipelined Beta CPU of FPGA
-------------------------------------------------------------------------------
-- File       : betaBoole.vhd
-- Author     : Pinit Kumhom  <pkumhom@Pinits-MacBook-Pro-2.local>
-- Company    : 
-- Created    : 2026-02-24
-- Last update: 2026-09-03
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2026-02-24  1.0      pkumhom	Created
-------------------------------------------------------------------------------

library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
-- use ieee.numeric_std.all;
entity bool is
  port(bfn      : in std_logic_vector(3 downto 0);
       a,b     : in std_logic_vector(31 downto 0);
       y       : out std_logic_vector(31 downto 0));
end entity bool;

architecture beh of bool is
  signal yL   : std_logic_vector(31 downto 0);
begin  -- architecture beh
  g0: for i in 0 to 31 generate
    yL(i) <= bfn(3) when b(i)='1' and a(i)='1' else
             bfn(2) when b(i)='1' and a(i)='0' else
             bfn(1) when b(i)='0' and a(i)='1' else
             bfn(0);
  end generate g0;
  y <= yL after tpd_mux4;
end architecture beh;

library ieee, stdcell_lib;
use ieee.std_logic_1164.all;

architecture struct_stdcell of bool is
  
begin  -- architecture beh
  g0: for i in 0 to 31 generate
    mux4_i: entity stdcell_lib.mux4(beh)
      port map (
        s0 => a(i), s1 => b(i),
        d0 => bfn(0), d1 => bfn(1), d2 => bfn(2), d3 => bfn(3),
        z => y(i)
        );
  end generate g0;
end architecture struct_stdcell;


library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
architecture fn_stdcell of bool is
  
begin  -- architecture beh
  g0: for i in 0 to 31 generate
    y(i) <= mux4(a(i),b(i),bfn(0),bfn(1),bfn(2),bfn(3)) after tpd_mux4;
  end generate g0;
end architecture fn_stdcell;
