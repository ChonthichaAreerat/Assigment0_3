-------------------------------------------------------------------------------
-- Title      : iszero
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : adder.vhd
-- Author     : Pinit Kumhom (PK)  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-04
-- Last update: 2026-09-05
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
--    checking whether or not an 32-bit data is all zero
--    it uses network of nor-nand-nor for implementing 32-bit nor funtion
-------------------------------------------------------------------------------
-- Copyright (c) 2026 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author   Description     
-- 2026-09-04  1.0      PK	 Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity iszero32 is
  
  port (
    a : in  std_logic_vector(31 downto 0);
    z : out std_logic);

end entity iszero32;
architecture struct_stdcell of iszero32 is
  signal n1 : std_logic_vector(7 downto 0);
  signal n2 : std_logic_vector(1 downto 0);
begin  -- architecture beh
  -- Level 0: nor4 of a (the input)
  g0: for i in 0 to 7 generate
    L0_nor4: entity stdcell_lib.nor4(beh)
      port map (a => a(i*4), b => a(i*4+1), c => a(i*4+2), d => a(i*4+3), z => n1(i));
  end generate g0;
  -- Level 1: nand4 of n1 (output from level 0)
  g1: for i in 0 to 1 generate
    L1_nand4: entity stdcell_lib.nand4(beh)
      port map (a => n1(i*4), b => n1(i*4+1), c => n1(i*4+2), d => n1(i*4+3), z => n2(i));
  end generate g1;
  -- Level 2: nor2 of n2 (output of level 1)
  L2_nor2: entity stdcell_lib.nor2(beh)
    port map (a => n2(0), b => n2(1), z => z);
end architecture struct_stdcell;

library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
architecture fn_stdcell of iszero32 is
  signal n1 : std_logic_vector(7 downto 0);
  signal n2 : std_logic_vector(1 downto 0);
begin  -- architecture beh
  g0: for i in 0 to 7 generate
    n1(i) <= nor4(a(i*4),a(i*4+1),a(i*4+2),a(i*4+3)) after tpd_nor4;
  end generate g0;
  g1: for i in 0 to 1 generate
    n2(i) <= nand4(n1(i*4),n1(i*4+1),n1(i*4+2),n1(i*4+3)) after tpd_nand4;
  end generate g1;
  z <= nor2(n2(0),n2(1)) after tpd_nor2;
end architecture fn_stdcell;
