-------------------------------------------------------------------------------
-- Title      : carry-lookahead adder (cla) targeting jSIM standard cell
-- Project    : Unpipelined Beta CPU on FPGA
-------------------------------------------------------------------------------
-- File       : cla_stdcell.vhd
-- Author     : Pinit Kumhom (PK)  <pkumhom@gmail.com>
-- Company    : 
-- Created    : 2026-09-10
-- Last update: 2026-09-10
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
-- fa_gp module
-- Description:
--    full 1-bit adder for carry-look ahead adder (cla)
--    which does not require carry-out output but must generate G and P output
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity fa_gp is
  
  port (
    a, b : in  std_logic;
    ci   : in  std_logic;
    s    : out std_logic;
    g, p : out std_logic);

end entity fa_gp;
architecture stdcell of fa_gp is
  signal n1,n2,n3, n4, n5 : std_logic;
begin  -- architecture beh
  n1 <= nand2(a,b)      after tpd_nand2;
  n2 <= xor2(a, b)      after tpd_xor2;
  s <= xor2(n2,ci)      after tpd_xor2;
  g <= inv(n1)          after tpd_inv;
  p <= n2;
end architecture stdcell;
-------------------------------------------------------------------------------
-- fa_gp_co module
-- Description:
--    full 1-bit adder for MSB of the carry-look ahead adder (cla)
--    which also produce the carry-out output in addition to S, G, and P
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity fa_gp_co is
  
  port (
    a, b : in  std_logic;
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic;
    g, p : out std_logic);

end entity fa_gp_co;
architecture stdcell of fa_gp_co is
  signal n1,n2,n3, n4, n5 : std_logic;
begin  -- architecture beh
  n1 <= nand2(a,b)      after tpd_nand2;
  n2 <= xor2(a, b)      after tpd_xor2;
  s <= xor2(n2,ci)      after tpd_xor2;
  g <= inv(n1)          after tpd_inv;
  p <= n2;
  --
  n3 <= nand2(ci,n2)    after tpd_nand2;
  co <= nand2(n1,n3)    after tpd_nand2;
end architecture stdcell;
-------------------------------------------------------------------------------
-- gpc module
--   combining gh, ph, gl, pl to generate g, p in the higher level(ghl, phl) and
--   co gl, pl and ci from higher level to generate 2 carries (ch, cl)
--   of lower level of the tree structure (counting the level from the leaves)
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity gpc is
  
  port (
    gh, ph   : in  std_logic;
    gl, pl   : in  std_logic;
    ci       : in  std_logic;
    ch, cl   : out std_logic;
    ghl, phl : out std_logic);

end entity gpc;
architecture stdcell of gpc is
  signal n1,n2,n3, n4, n5 : std_logic;
begin  -- architecture beh
  n1 <= nand2(ph,gl)    after tpd_nand2;
  n2 <= inv(gh)         after tpd_inv;
  ghl <= nand2(n1, n2)  after tpd_nand2;
  n3 <= nand2(ph,pl)    after tpd_nand2;
  phl <= inv(n3)        after tpd_inv;
  --
  cl <= ci;
  n4 <= nand2(pl,ci)    after tpd_nand2;
  n5 <= inv(gl)         after tpd_inv;
  ch <= nand2(n4,n5)    after tpd_nand2;
end architecture stdcell;
-------------------------------------------------------------------------------
-- 2-bit Carry-lookahed Binary Adder (CLA2, CLA2_co)
-------------------------------------------------------------------------------
-- Description:
--    an 2-bit carry-lookahead unsigned adder targeting JSIM standard cells
------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- cla2: cla2 without co from MSB
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity cla2 is
  
  port (
    a, b : in  std_logic_vector(1 downto 0);
    ci   : in  std_logic;
    s    : out std_logic_vector(1 downto 0);
    g,p  : out std_logic);

end entity cla2;
architecture stdcell of cla2 is
  signal gh, ph, gl, pl : std_logic;
  signal ch, cl : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.fa_gp(stdcell)
      port map (
        a  => a(0),
        b  => b(0),
        ci => cl,
        s => s(0),
        g  => gl,
        p  => pl);
    adder_H: entity work.fa_gp(stdcell)
      port map (
        a  => a(1),
        b  => b(1),
        ci => ch,
        s => s(1),
        g  => gh,
        p  => ph);
  -- generating ch, cl, g, h using gpc
  gpc_0: entity work.gpc(stdcell)
    port map (
      gh  => gh, ph => ph,
      gl  => gl, pl => pl,
      ci => ci,
      ghl  => g, phl => p,
      ch => ch, cl => cl
      );
end architecture stdcell;
-------------------------------------------------------------------------------
-- cla2_co: cla2 with co from MSB
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity cla2_co is
  
  port (
    a, b : in  std_logic_vector(1 downto 0);
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic_vector(1 downto 0);
    g,p  : out std_logic);

end entity cla2_co;
architecture stdcell of cla2_co is
  signal gh, ph, gl, pl : std_logic;
  signal ch, cl : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.fa_gp(stdcell)
      port map (
        a  => a(0),
        b  => b(0),
        ci => cl,
        s => s(0),
        g  => gl,
        p  => pl);
    adder_H: entity work.fa_gp_co(stdcell)
      port map (
        a  => a(1),
        b  => b(1),
        ci => ch,
        co => co,
        s => s(1),
        g  => gh,
        p  => ph);
  -- generating ch, cl, g, h using gpc
  gpc_0: entity work.gpc(stdcell)
    port map (
      gh  => gh, ph => ph,
      gl  => gl, pl => pl,
      ci => ci,
      ghl  => g, phl => p,
      ch => ch, cl => cl
      );
end architecture stdcell;

-------------------------------------------------------------------------------
-- 4-bit Carry-lookahed Binary Adder
-------------------------------------------------------------------------------
-- Description:
--    an 4-bit carry-lookahead unsigned adder targeting JSIM standard cells
------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- cla4: cla4 witout co from MSB
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity cla4 is
  
  port (
    a, b : in  std_logic_vector(3 downto 0);
    ci   : in  std_logic;
    s    : out std_logic_vector(3 downto 0);
    g,p  : out std_logic);

end entity cla4;
architecture stdcell of cla4 is
  signal gh, ph, gl, pl : std_logic;
  signal ch, cl : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.cla2(stdcell)
      port map (
        a  => a(1 downto 0),
        b  => b(1 downto 0),
        ci => cl,
        s => s(1 downto 0),
        g  => gl,
        p  => pl);
    adder_H: entity work.cla2(stdcell)
      port map (
        a  => a(3 downto 2),
        b  => b(3 downto 2),
        ci => ch,
        s => s(3 downto 2),
        g  => gh,
        p  => ph);
  -- generating ch, cl, g, h using gpc
  gpc_0: entity work.gpc(stdcell)
    port map (
      gh  => gh, ph => ph,
      gl  => gl, pl => pl,
      ci => ci,
      ghl  => g, phl => p,
      ch => ch, cl => cl
      );
end architecture stdcell;
-------------------------------------------------------------------------------
-- cla4_co: cla4 with co from MSB
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity cla4_co is
  
  port (
    a, b : in  std_logic_vector(3 downto 0);
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic_vector(3 downto 0);
    g,p  : out std_logic);

end entity cla4_co;
architecture stdcell of cla4_co is
  signal gh, ph, gl, pl : std_logic;
  signal ch, cl : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.cla2(stdcell)
      port map (
        a  => a(1 downto 0),
        b  => b(1 downto 0),
        ci => cl,
        s => s(1 downto 0),
        g  => gl,
        p  => pl);
    adder_H: entity work.cla2_co(stdcell)
      port map (
        a  => a(3 downto 2),
        b  => b(3 downto 2),
        ci => ch,
        co => co,
        s => s(3 downto 2),
        g  => gh,
        p  => ph);
  -- generating ch, cl, g, h using gpc
  gpc_0: entity work.gpc(stdcell)
    port map (
      gh  => gh, ph => ph,
      gl  => gl, pl => pl,
      ci => ci,
      ghl  => g, phl => p,
      ch => ch, cl => cl
      );
end architecture stdcell;
-------------------------------------------------------------------------------
-- 8-bit Carry-lookahed Binary Adder
-------------------------------------------------------------------------------
-- Description:
--    an 8-bit carry-lookahead unsigned adder targeting JSIM standard cells
------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- cla8: cla8 without co from MSB
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity cla8 is
  
  port (
    a, b : in  std_logic_vector(7 downto 0);
    ci   : in  std_logic;
    s    : out std_logic_vector(7 downto 0);
    g,p  : out std_logic);

end entity cla8;
architecture stdcell of cla8 is
  signal gh, ph, gl, pl : std_logic;
  signal ch, cl : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.cla4(stdcell)
      port map (
        a  => a(3 downto 0),
        b  => b(3 downto 0),
        ci => cl,
        s => s(3 downto 0),
        g  => gl,
        p  => pl);
    adder_H: entity work.cla4(stdcell)
      port map (
        a  => a(7 downto 4),
        b  => b(7 downto 4),
        ci => ch,
        s => s(7 downto 4),
        g  => gh,
        p  => ph);
  -- generating ch, cl, g, h using gpc
  gpc_0: entity work.gpc(stdcell)
    port map (
      gh  => gh, ph => ph,
      gl  => gl, pl => pl,
      ci => ci,
      ghl  => g, phl => p,
      ch => ch, cl => cl
      );
end architecture stdcell;
------------------------------------------------------------------------------
-- cla8_co: cla8 with co from MSB
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity cla8_co is
  
  port (
    a, b : in  std_logic_vector(7 downto 0);
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic_vector(7 downto 0);
    g,p  : out std_logic);

end entity cla8_co;
architecture stdcell of cla8_co is
  signal gh, ph, gl, pl : std_logic;
  signal ch, cl : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.cla4(stdcell)
      port map (
        a  => a(3 downto 0),
        b  => b(3 downto 0),
        ci => cl,
        s => s(3 downto 0),
        g  => gl,
        p  => pl);
    adder_H: entity work.cla4_co(stdcell)
      port map (
        a  => a(7 downto 4),
        b  => b(7 downto 4),
        ci => ch,
        co => co,
        s => s(7 downto 4),
        g  => gh,
        p  => ph);
  -- generating ch, cl, g, h using gpc
  gpc_0: entity work.gpc(stdcell)
    port map (
      gh  => gh, ph => ph,
      gl  => gl, pl => pl,
      ci => ci,
      ghl  => g, phl => p,
      ch => ch, cl => cl
      );
end architecture stdcell;
-------------------------------------------------------------------------------
-- 16-bit Carry-lookahed Binary Adder
-------------------------------------------------------------------------------
-- Description:
--    an 16-bit carry-lookahead unsigned adder targeting JSIM standard cells
------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- cla16: cla16 without co from MSB
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity cla16 is
  
  port (
    a, b : in  std_logic_vector(15 downto 0);
    ci   : in  std_logic;
    s    : out std_logic_vector(15 downto 0);
    g,p  : out std_logic);

end entity cla16;
architecture stdcell of cla16 is
  signal gh, ph, gl, pl : std_logic;
  signal ch, cl : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.cla8(stdcell)
      port map (
        a  => a(7 downto 0),
        b  => b(7 downto 0),
        ci => cl,
        s => s(7 downto 0),
        g  => gl,
        p  => pl);
    adder_H: entity work.cla8(stdcell)
      port map (
        a  => a(15 downto 8),
        b  => b(15 downto 8),
        ci => ch,
        s => s(15 downto 8),
        g  => gh,
        p  => ph);
  -- generating ch, cl, g, h using gpc
  gpc_0: entity work.gpc(stdcell)
    port map (
      gh  => gh, ph => ph,
      gl  => gl, pl => pl,
      ci => ci,
      ghl  => g, phl => p,
      ch => ch, cl => cl
      );
end architecture stdcell;
------------------------------------------------------------------------------
-- cla16_co: cla16 with co from MSB
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity cla16_co is
  
  port (
    a, b : in  std_logic_vector(15 downto 0);
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic_vector(15 downto 0);
    g,p  : out std_logic);

end entity cla16_co;
architecture stdcell of cla16_co is
  signal gh, ph, gl, pl : std_logic;
  signal ch, cl : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.cla8(stdcell)
      port map (
        a  => a(7 downto 0),
        b  => b(7 downto 0),
        ci => cl,
        s => s(7 downto 0),
        g  => gl,
        p  => pl);
    adder_H: entity work.cla8_co(stdcell)
      port map (
        a  => a(15 downto 8),
        b  => b(15 downto 8),
        ci => ch,
        co => co,
        s => s(15 downto 8),
        g  => gh,
        p  => ph);
  -- generating ch, cl, g, h using gpc
  gpc_0: entity work.gpc(stdcell)
    port map (
      gh  => gh, ph => ph,
      gl  => gl, pl => pl,
      ci => ci,
      ghl  => g, phl => p,
      ch => ch, cl => cl
      );
end architecture stdcell;
-------------------------------------------------------------------------------
-- 32-bit Carry-lookahed Binary Adder
-------------------------------------------------------------------------------
-- Description:
--    an 32-bit carry-lookahead unsigned adder targeting JSIM standard cells
------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- cla32: cla32 without co from MSB
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity cla32 is
  
  port (
    a, b : in  std_logic_vector(31 downto 0);
    ci   : in  std_logic;
    s    : out std_logic_vector(31 downto 0);
    g,p  : out std_logic);

end entity cla32;
architecture stdcell of cla32 is
  signal gh, ph, gl, pl : std_logic;
  signal ch, cl : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.cla16(stdcell)
      port map (
        a  => a(15 downto 0),
        b  => b(15 downto 0),
        ci => cl,
        s => s(15 downto 0),
        g  => gl,
        p  => pl);
    adder_H: entity work.cla16(stdcell)
      port map (
        a  => a(31 downto 16),
        b  => b(31 downto 16),
        ci => ch,
        s => s(31 downto 16),
        g  => gh,
        p  => ph);
  -- generating ch, cl, g, h using gpc
  gpc_0: entity work.gpc(stdcell)
    port map (
      gh  => gh, ph => ph,
      gl  => gl, pl => pl,
      ci => ci,
      ghl  => g, phl => p,
      ch => ch, cl => cl
      );
end architecture stdcell;
------------------------------------------------------------------------------
-- cla32_co: cla32 with co from MSB
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;
entity cla32_co is
  
  port (
    a, b : in  std_logic_vector(31 downto 0);
    ci   : in  std_logic;
    co   : out std_logic;
    s    : out std_logic_vector(31 downto 0);
    g,p  : out std_logic);

end entity cla32_co;
architecture stdcell of cla32_co is
  signal gh, ph, gl, pl : std_logic;
  signal ch, cl : std_logic;
begin  -- architecture cla_stdcell
    adder_L: entity work.cla16(stdcell)
      port map (
        a  => a(15 downto 0),
        b  => b(15 downto 0),
        ci => cl,
        s => s(15 downto 0),
        g  => gl,
        p  => pl);
    adder_H: entity work.cla16_co(stdcell)
      port map (
        a  => a(31 downto 16),
        b  => b(31 downto 16),
        ci => ch,
        co => co,
        s => s(31 downto 16),
        g  => gh,
        p  => ph);
  -- generating ch, cl, g, h using gpc
  gpc_0: entity work.gpc(stdcell)
    port map (
      gh  => gh, ph => ph,
      gl  => gl, pl => pl,
      ci => ci,
      ghl  => g, phl => p,
      ch => ch, cl => cl
      );
end architecture stdcell;
-------------------------------------------------------------------------------

