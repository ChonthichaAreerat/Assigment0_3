-------------------------------------------------------------------------------
-- Title      : 32x32 register file 
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : rf32x32.vhd
-- Author     : Pinit Kumhom (PK)  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-13
-- Last update: 2026-09-23
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
--    register file with depth=32, width=32, and read channel = 2
--    archiecture #1: RTL
--    archiecture #2: it targets the JSIM standard cell
--       sub-modules: dec5to32 (5-to-32 binary decoder), mux32 (32-input mux)
--       stdcell    : dreg, nand4, nor4, nand2, nor2, inverter, mux2, mux4
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
entity rf32x32 is
  
  port (
    clk       : in std_logic;
    werf      : in std_logic;
    wa        : in  std_logic_vector(4 downto 0);
    wd        : in  std_logic_vector(31 downto 0);
    ra1, ra2  : in  std_logic_vector(4 downto 0);
    rd1, rd2  : out std_logic_vector(31 downto 0));

end entity rf32x32;
-------------------------------------------------------------------------------
-- rf32x32(stdcell)
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
architecture stdcell of rf32x32 is
  constant width : natural := 32;
  constant depth : natural := 32;
  type data_array is array (0 to depth-1) of std_logic_vector(width-1 downto 0);
  signal rf_q, rf_d : data_array;
  signal en : std_logic_vector(depth-1 downto 0);
begin  -- architecture stdcell
  dec_1: entity work.dec5to32(stdcell)
    port map (a => wa, en => werf, y => en);
  -- register with enable control
  g0: for i in 0 to depth-2 generate
    dreg_i: entity stdcell_lib.dreg(beh)
      generic map (n => width)
      port map (clk => clk, d => rf_d(i), q => rf_q(i));
    mux2_i: entity stdcell_lib.mux2xN(beh)  -- rf_d(i) <= wd when ren(i)='1' else rf_q(i)
      generic map (n => width)
      port map (s => en(i), d0 => rf_q(i), d1 => wd, z => rf_d(i));
  end generate g0;
  rf_q(depth-1) <= (others => '0');     -- bits of r31(rf_q(depth-1)) is hardwired to all zeros
  
  -- use mux32 for reading data
  mux32_1: entity work.mux32(stdcell)
    port map (s => ra1,
              d0 => rf_q(0), d1 => rf_q(1), d2 => rf_q(2), d3 => rf_q(3),
              d4 => rf_q(4), d5 => rf_q(5), d6 => rf_q(6), d7 => rf_q(7),
              d8 => rf_q(8), d9 => rf_q(9), d10 => rf_q(10), d11 => rf_q(11),
              d12 => rf_q(12), d13 => rf_q(13), d14 => rf_q(14), d15 => rf_q(15),
              d16 => rf_q(16), d17 => rf_q(17), d18 => rf_q(18), d19 => rf_q(19),
              d20 => rf_q(20), d21 => rf_q(21), d22 => rf_q(22), d23 => rf_q(23),
              d24 => rf_q(24), d25 => rf_q(25), d26 => rf_q(26), d27 => rf_q(27),
              d28 => rf_q(28), d29 => rf_q(29), d30 => rf_q(30), d31 => rf_q(31),
              y => rd1
              );
  -- 
  mux32_2: entity work.mux32(stdcell)
    port map (s => ra2,
              d0 => rf_q(0), d1 => rf_q(1), d2 => rf_q(2), d3 => rf_q(3),
              d4 => rf_q(4), d5 => rf_q(5), d6 => rf_q(6), d7 => rf_q(7),
              d8 => rf_q(8), d9 => rf_q(9), d10 => rf_q(10), d11 => rf_q(11),
              d12 => rf_q(12), d13 => rf_q(13), d14 => rf_q(14), d15 => rf_q(15),
              d16 => rf_q(16), d17 => rf_q(17), d18 => rf_q(18), d19 => rf_q(19),
              d20 => rf_q(20), d21 => rf_q(21), d22 => rf_q(22), d23 => rf_q(23),
              d24 => rf_q(24), d25 => rf_q(25), d26 => rf_q(26), d27 => rf_q(27),
              d28 => rf_q(28), d29 => rf_q(29), d30 => rf_q(30), d31 => rf_q(31),
              y => rd2
              );

end architecture stdcell;

-------------------------------------------------------------------------------
-- rf32x32(rtl)
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of rf32x32 is
  constant width : natural := 32;
  type data_array is array (0 to 30) of std_logic_vector(width-1 downto 0);
  signal registers : data_array;
begin
  process (clk)
  begin
    if rising_edge(clk) then
      if werf = '1' and wa /= "11111" then
        registers(to_integer(unsigned(wa))) <= wd;
      end if;
    end if;
  end process;

  process (ra1, ra2, registers)
  begin
    if ra1 = "11111" then
      rd1 <= (others => '0');
    else
      rd1 <= registers(to_integer(unsigned(ra1)));
    end if;

    if ra2 = "11111" then
      rd2 <= (others => '0');
    else
      rd2 <= registers(to_integer(unsigned(ra2)));
    end if;
  end process;
end architecture rtl;

