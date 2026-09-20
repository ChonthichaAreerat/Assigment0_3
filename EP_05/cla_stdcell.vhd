-- fa_gp_co module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity fa_gp_co is
    port (
        a, b : in std_logic;
        ci   : in std_logic;
        co   : out std_logic;
        s    : out std_logic;
        g, p : out std_logic
    );
end entity fa_gp_co;

architecture stdcell of fa_gp_co is
    signal n1, n2, n3 : std_logic;
begin
    n1 <= nand2(a, b) after tpd_nand2;
    n2 <= xor2(a, b)  after tpd_xor2;
    s  <= xor2(n2, ci) after tpd_xor2;
    n3 <= nand2(ci, n2) after tpd_nand2;
    co <= nand2(n1, n3) after tpd_nand2;
    g  <= inv(n1) after tpd_inv;
    p  <= n2;
end architecture stdcell;

-- cla2 module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity cla2 is
    port (
        a, b : in std_logic_vector(1 downto 0);
        ci   : in std_logic;
        s    : out std_logic_vector(1 downto 0);
        g, p : out std_logic
    );
end entity cla2;

architecture stdcell of cla2 is
    signal gh, ph, gl, pl : std_logic;
    signal ch, cl : std_logic;
begin
    adder_L: entity work.fa_gp(stdcell)
        port map ( a => a(0), b => b(0), ci => cl, s => s(0), g => gl, p => pl );
    adder_H: entity work.fa_gp(stdcell)
        port map ( a => a(1), b => b(1), ci => ch, s => s(1), g => gh, p => ph );
    gpc_0: entity work.gpc(stdcell)
        port map ( gh => gh, ph => ph, gl => gl, pl => pl, ci => ci, ghl => g, phl => p, ch => ch, cl => cl );
end architecture stdcell;

-- cla2_co module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity cla2_co is
    port (
        a, b : in std_logic_vector(1 downto 0);
        ci   : in std_logic;
        co   : out std_logic;
        s    : out std_logic_vector(1 downto 0);
        g, p : out std_logic
    );
end entity cla2_co;

architecture stdcell of cla2_co is
    signal gh, ph, gl, pl : std_logic;
    signal ch, cl : std_logic;
begin
    adder_L: entity work.fa_gp(stdcell)
        port map ( a => a(0), b => b(0), ci => cl, s => s(0), g => gl, p => pl );
    adder_H: entity work.fa_gp_co(stdcell)
        port map ( a => a(1), b => b(1), ci => ch, co => co, s => s(1), g => gh, p => ph );
    gpc_0: entity work.gpc(stdcell)
        port map ( gh => gh, ph => ph, gl => gl, pl => pl, ci => ci, ghl => g, phl => p, ch => ch, cl => cl );
end architecture stdcell;

-- cla4 module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity cla4 is
    port (
        a, b : in std_logic_vector(3 downto 0);
        ci   : in std_logic;
        s    : out std_logic_vector(3 downto 0);
        g, p : out std_logic
    );
end entity cla4;

architecture stdcell of cla4 is
    signal gh, ph, gl, pl : std_logic;
    signal ch, cl : std_logic;
begin
    adder_L: entity work.cla2(stdcell)
        port map ( a => a(1 downto 0), b => b(1 downto 0), ci => cl, s => s(1 downto 0), g => gl, p => pl );
    adder_H: entity work.cla2(stdcell)
        port map ( a => a(3 downto 2), b => b(3 downto 2), ci => ch, s => s(3 downto 2), g => gh, p => ph );
    gpc_0: entity work.gpc(stdcell)
        port map ( gh => gh, ph => ph, gl => gl, pl => pl, ci => ci, ghl => g, phl => p, ch => ch, cl => cl );
end architecture stdcell;

-- cla4_co module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity cla4_co is
    port (
        a, b : in std_logic_vector(3 downto 0);
        ci   : in std_logic;
        co   : out std_logic;
        s    : out std_logic_vector(3 downto 0);
        g, p : out std_logic
    );
end entity cla4_co;

architecture stdcell of cla4_co is
    signal gh, ph, gl, pl : std_logic;
    signal ch, cl : std_logic;
begin
    adder_L: entity work.cla2(stdcell)
        port map ( a => a(1 downto 0), b => b(1 downto 0), ci => cl, s => s(1 downto 0), g => gl, p => pl );
    adder_H: entity work.cla2_co(stdcell)
        port map ( a => a(3 downto 2), b => b(3 downto 2), ci => ch, co => co, s => s(3 downto 2), g => gh, p => ph );
    gpc_0: entity work.gpc(stdcell)
        port map ( gh => gh, ph => ph, gl => gl, pl => pl, ci => ci, ghl => g, phl => p, ch => ch, cl => cl );
end architecture stdcell;

-- cla8 module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity cla8 is
    port (
        a, b : in std_logic_vector(7 downto 0);
        ci   : in std_logic;
        s    : out std_logic_vector(7 downto 0);
        g, p : out std_logic
    );
end entity cla8;

architecture stdcell of cla8 is
    signal gh, ph, gl, pl : std_logic;
    signal ch, cl : std_logic;
begin
    adder_L: entity work.cla4(stdcell)
        port map ( a => a(3 downto 0), b => b(3 downto 0), ci => cl, s => s(3 downto 0), g => gl, p => pl );
    adder_H: entity work.cla4(stdcell)
        port map ( a => a(7 downto 4), b => b(7 downto 4), ci => ch, s => s(7 downto 4), g => gh, p => ph );
    gpc_0: entity work.gpc(stdcell)
        port map ( gh => gh, ph => ph, gl => gl, pl => pl, ci => ci, ghl => g, phl => p, ch => ch, cl => cl );
end architecture stdcell;

-- cla8_co module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity cla8_co is
    port (
        a, b : in std_logic_vector(7 downto 0);
        ci   : in std_logic;
        co   : out std_logic;
        s    : out std_logic_vector(7 downto 0);
        g, p : out std_logic
    );
end entity cla8_co;

architecture stdcell of cla8_co is
    signal gh, ph, gl, pl : std_logic;
    signal ch, cl : std_logic;
begin
    adder_L: entity work.cla4(stdcell)
        port map ( a => a(3 downto 0), b => b(3 downto 0), ci => cl, s => s(3 downto 0), g => gl, p => pl );
    adder_H: entity work.cla4_co(stdcell)
        port map ( a => a(7 downto 4), b => b(7 downto 4), ci => ch, co => co, s => s(7 downto 4), g => gh, p => ph );
    gpc_0: entity work.gpc(stdcell)
        port map ( gh => gh, ph => ph, gl => gl, pl => pl, ci => ci, ghl => g, phl => p, ch => ch, cl => cl );
end architecture stdcell;

-- cla16 module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity cla16 is
    port (
        a, b : in std_logic_vector(15 downto 0);
        ci   : in std_logic;
        s    : out std_logic_vector(15 downto 0);
        g, p : out std_logic
    );
end entity cla16;

architecture stdcell of cla16 is
    signal gh, ph, gl, pl : std_logic;
    signal ch, cl : std_logic;
begin
    adder_L: entity work.cla8(stdcell)
        port map ( a => a(7 downto 0), b => b(7 downto 0), ci => cl, s => s(7 downto 0), g => gl, p => pl );
    adder_H: entity work.cla8(stdcell)
        port map ( a => a(15 downto 8), b => b(15 downto 8), ci => ch, s => s(15 downto 8), g => gh, p => ph );
    gpc_0: entity work.gpc(stdcell)
        port map ( gh => gh, ph => ph, gl => gl, pl => pl, ci => ci, ghl => g, phl => p, ch => ch, cl => cl );
end architecture stdcell;

-- cla16_co module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity cla16_co is
    port (
        a, b : in std_logic_vector(15 downto 0);
        ci   : in std_logic;
        co   : out std_logic;
        s    : out std_logic_vector(15 downto 0);
        g, p : out std_logic
    );
end entity cla16_co;

architecture stdcell of cla16_co is
    signal gh, ph, gl, pl : std_logic;
    signal ch, cl : std_logic;
begin
    adder_L: entity work.cla8(stdcell)
        port map ( a => a(7 downto 0), b => b(7 downto 0), ci => cl, s => s(7 downto 0), g => gl, p => pl );
    adder_H: entity work.cla8_co(stdcell)
        port map ( a => a(15 downto 8), b => b(15 downto 8), ci => ch, co => co, s => s(15 downto 8), g => gh, p => ph );
    gpc_0: entity work.gpc(stdcell)
        port map ( gh => gh, ph => ph, gl => gl, pl => pl, ci => ci, ghl => g, phl => p, ch => ch, cl => cl );
end architecture stdcell;

-- cla32 module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity cla32 is
    port (
        a, b : in std_logic_vector(31 downto 0);
        ci   : in std_logic;
        s    : out std_logic_vector(31 downto 0);
        g, p : out std_logic
    );
end entity cla32;

architecture stdcell of cla32 is
    signal gh, ph, gl, pl : std_logic;
    signal ch, cl : std_logic;
begin
    adder_L: entity work.cla16(stdcell)
        port map ( a => a(15 downto 0), b => b(15 downto 0), ci => cl, s => s(15 downto 0), g => gl, p => pl );
    adder_H: entity work.cla16(stdcell)
        port map ( a => a(31 downto 16), b => b(31 downto 16), ci => ch, s => s(31 downto 16), g => gh, p => ph );
    gpc_0: entity work.gpc(stdcell)
        port map ( gh => gh, ph => ph, gl => gl, pl => pl, ci => ci, ghl => g, phl => p, ch => ch, cl => cl );
end architecture stdcell;

-- cla32_co module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity cla32_co is
    port (
        a, b : in std_logic_vector(31 downto 0);
        ci   : in std_logic;
        co   : out std_logic;
        s    : out std_logic_vector(31 downto 0);
        g, p : out std_logic
    );
end entity cla32_co;

architecture stdcell of cla32_co is
    signal gh, ph, gl, pl : std_logic;
    signal ch, cl : std_logic;
begin
    adder_L: entity work.cla16(stdcell)
        port map ( a => a(15 downto 0), b => b(15 downto 0), ci => cl, s => s(15 downto 0), g => gl, p => pl );
    adder_H: entity work.cla16_co(stdcell)
        port map ( a => a(31 downto 16), b => b(31 downto 16), ci => ch, co => co, s => s(31 downto 16), g => gh, p => ph );
    gpc_0: entity work.gpc(stdcell)
        port map ( gh => gh, ph => ph, gl => gl, pl => pl, ci => ci, ghl => g, phl => p, ch => ch, cl => cl );
end architecture stdcell;