-------------------------------------------------------------------------------
-- Behavioral VHDL Models of 180nm CMOS Standard Cells
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
-------------------------------------------------------------------------------
-- Inverter and buffer
-------------------------------------------------------------------------------
-- inverter
entity inverter is
  port (
    a : in  std_logic;
    z    : out std_logic);
end inverter;
architecture beh of inverter is
  constant tpd : time := tpd_inv;
begin  -- architecture beh
  z <= not a after tpd;
end beh;
-------------------------------------------------------------------------------
-- buffer
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
-------------------------------------------------------------------------------
entity buf is
  port (
    a : in  std_logic;
    z    : out std_logic);
end buf;
architecture beh of buf is
  constant tpd : time := tpd_buf;
begin  -- architecture beh
  z <= a after tpd;
end beh;
-------------------------------------------------------------------------------
-- tristate
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
-------------------------------------------------------------------------------
entity tristate is
  port (
    a : in std_logic;
    e : in std_logic;
    z    : out std_logic);
end tristate;
architecture beh of tristate is
  constant tpd : time := tpd_tri;
begin  -- architecture beh
  z <= a   after tpd when e='1' else
       'Z' after tpd;
end beh;
-------------------------------------------------------------------------------
-- AND gates
-------------------------------------------------------------------------------
-- and2
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity and2 is
  port (
    a, b : in  std_logic;
    z    : out std_logic);
end entity and2;
architecture beh of and2 is
  constant tpd : time := tpd_and2;
begin  -- architecture beh
  z <= a and b after tpd;
end architecture beh;
-------------------------------------------------------------------------------
-- and3
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity and3 is
  port (
    a, b, c : in  std_logic;
    z       : out std_logic);
end entity and3;
architecture beh of and3 is
  constant tpd : time := tpd_and3;
begin  -- architecture beh
  z <= (a and b and c) after tpd;
end architecture beh;
-------------------------------------------------------------------------------
-- and4
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity and4 is
  port (
    a, b, c, d : in  std_logic;
    z          : out std_logic);
end entity and4;
architecture beh of and4 is
  constant tpd : time := tpd_and4;
begin  -- architecture beh
  z <= (a and b and c and d) after tpd;
end architecture beh;

-------------------------------------------------------------------------------
-- NAND gates
-------------------------------------------------------------------------------
-- nand2
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity nand2 is
  port (
    a, b : in  std_logic;
    z    : out std_logic);
end entity nand2;
architecture beh of nand2 is
  constant tpd : time := tpd_nand2;
begin  -- architecture beh
  z <= not (a and b) after tpd;
end architecture beh;
-------------------------------------------------------------------------------
-- nand3
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity nand3 is
  port (
    a, b, c : in  std_logic;
    z       : out std_logic);
end entity nand3;
architecture beh of nand3 is
  constant tpd : time := tpd_nand3;
begin  -- architecture beh
  z <= not (a and b and c) after tpd;
end architecture beh;
-------------------------------------------------------------------------------
-- nand4
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity nand4 is
  port (
    a, b, c, d : in  std_logic;
    z          : out std_logic);
end entity nand4;
architecture beh of nand4 is
  constant tpd : time := tpd_nand4;
begin  -- architecture beh
  z <= not (a and b and c and d) after tpd;
end architecture beh;

-------------------------------------------------------------------------------
-- OR gates
-------------------------------------------------------------------------------
-- or2
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity or2 is
  port (
    a, b : in  std_logic;
    z    : out std_logic);
end entity or2;
architecture beh of or2 is
  constant tpd : time := tpd_or2;
begin  -- architecture beh
  
  z <= a or b after tpd;

end architecture beh;
-------------------------------------------------------------------------------
-- or3
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity or3 is
  port (
    a, b, c : in  std_logic;
    z       : out std_logic);
end entity or3;
architecture beh of or3 is
  constant tpd : time := tpd_or3;
begin  -- architecture beh
  z <= (a or b or c) after tpd;
end architecture beh;
-------------------------------------------------------------------------------
-- or4
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity or4 is
  port (
    a, b, c, d : in  std_logic;
    z          : out std_logic);
end entity or4;
architecture beh of or4 is
  constant tpd : time := tpd_or4;
begin  -- architecture beh
  z <= (a or b or c or d) after tpd;
end architecture beh;

-------------------------------------------------------------------------------
-- NOR gates
-------------------------------------------------------------------------------
-- nor2
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity nor2 is
  port (
    a, b : in  std_logic;
    z    : out std_logic);
end entity nor2;
architecture beh of nor2 is
  constant tpd : time := tpd_nor2;
begin  -- architecture beh
  z <= not (a or b) after tpd;
end architecture beh;
-------------------------------------------------------------------------------
-- nor3
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity nor3 is
  port (
    a, b, c : in  std_logic;
    z       : out std_logic);
end entity nor3;
architecture beh of nor3 is
  constant tpd : time := tpd_nor3;
begin  -- architecture beh
  z <= not (a or b or c) after tpd;
end architecture beh;
-------------------------------------------------------------------------------
-- nor4
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity nor4 is
  port (
    a, b, c, d : in  std_logic;
    z          : out std_logic);
end entity nor4;
architecture beh of nor4 is
  constant tpd : time := tpd_nor4;
begin  -- architecture beh
  z <= not (a or b or c or d) after tpd;
end architecture beh;

-------------------------------------------------------------------------------
-- XOR,XNOR gates
-------------------------------------------------------------------------------
-- xor2
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity xor2 is
  port (
    a, b : in  std_logic;
    z    : out std_logic);
end entity xor2;
architecture beh of xor2 is
  constant tpd : time := tpd_xor2;
begin  -- architecture beh
  z <= a xor b after tpd;
end architecture beh;
-------------------------------------------------------------------------------
-- xnor2
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity xnor2 is
  port (
    a, b : in  std_logic;
    z    : out std_logic);
end entity xnor2;
architecture beh of xnor2 is
  constant tpd : time := tpd_xnor2;
begin  -- architecture beh
  z <= a xor b after tpd;
end architecture beh;
-------------------------------------------------------------------------------
-- MUXs
-------------------------------------------------------------------------------
-- mux2
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity mux2 is
  port (
    s      : in std_logic;
    d0, d1 : in std_logic;
    z    : out std_logic);
end entity mux2;
architecture beh of mux2 is
  constant tpd : time := tpd_mux2;
begin  -- architecture beh
  z <= d0 after tpd  when s='0' else
       d1 after tpd;
end architecture beh;
-------------------------------------------------------------------------------
-- mux2xN -- n-bit mux2
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity mux2xN is
  generic (
    n : natural);
  port (
    s : in std_logic;
    d0, d1 : in  std_logic_vector(n-1 downto 0);
    z    : out std_logic_vector(n-1 downto 0));
end entity mux2xN;
architecture beh of mux2xN is
  constant tpd : time := tpd_mux2;
begin  -- architecture beh
  z <= d0 after tpd  when s='0' else
       d1 after tpd;
end architecture beh;
-------------------------------------------------------------------------------
-- mux4
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity mux4 is
  port (
    s0, s1 : in std_logic;
    d0, d1, d2, d3 : in  std_logic;
    z    : out std_logic);
end entity mux4;
architecture beh of mux4 is
  constant tpd : time := tpd_mux4;
  signal s : std_logic_vector(1 downto 0);
begin  -- architecture beh
  s <= s1&s0;
  with s select
    z <=
    d0 after tpd when "00",
    d1 after tpd when "01",
    d2 after tpd when "10",
    d3 after tpd when others;
end architecture beh;
-------------------------------------------------------------------------------
-- mux4xN -- n-bit mux4
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity mux4xN is
  generic (
    n : natural);
  port (
    s : in std_logic_vector(1 downto 0);
    d0, d1, d2, d3 : in  std_logic_vector(n-1 downto 0);
    z    : out std_logic_vector(n-1 downto 0));

end entity mux4xN;
architecture beh of mux4xN is
  constant tpd : time := tpd_mux4;
begin  -- architecture beh
  with s select
    z <=
    d0 after tpd when "00",
    d1 after tpd when "01",
    d2 after tpd when "10",
    d3 after tpd when others;
end architecture beh;
-------------------------------------------------------------------------------
-- D Flip-Flop (dff) and D-Register (dreg)
-------------------------------------------------------------------------------
-- dff
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity dff is
  port (
    d : in std_logic;
    clk  : in std_logic;
    q    : out std_logic);

end entity dff;
architecture beh of dff is
  constant tpd : time := tpd_dreg;
begin  -- architecture beh
  process (clk) is
  begin  -- process
    if clk'event and clk = '1' then  -- rising clock edge
      q <= d after tpd;
    end if;
  end process;

end architecture beh;
-------------------------------------------------------------------------------
-- n-bit D-Register
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.stdcell_pkg.all;
entity dreg is
  generic (
    n : natural := 1);
  port (
    d : in std_logic_vector(n-1 downto 0);
    clk  : in std_logic;
    q    : out std_logic_vector(n-1 downto 0));
end entity dreg;
architecture beh of dreg is
  constant tpd : time := tpd_dreg;
begin  -- architecture beh
  process (clk) is
  begin  -- process
    if clk'event and clk = '1' then  -- rising clock edge
      q <= d after tpd;
    end if;
  end process;

end architecture beh;
-------------------------------------------------------------------------------
