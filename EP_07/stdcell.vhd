-------------------------------------------------------------------------------
-- Behavioral VHDL Models of 180nm CMOS Standard Cells
-------------------------------------------------------------------------------
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use stdcell_lib.stdcell_pkg.all;
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
-- ROM block
-------------------------------------------------------------------------------
-- 
-- library ieee, stdcell_lib;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
-- use stdcell_lib.stdcell_pkg.all;
-- -- packages for managing text files
-- use std.textio.all;
-- use ieee.std_logic_textio.all;
-- entity rom_dxw is
  
--   generic (
--     dbit   : natural := 2;              -- depth=2^dbit (dbit < 8)
--     width  : natural := 2;
--     fname : string  := "rom_data.txt");
--   port (
--     a    : in std_logic_vector(dbit-1 downto 0);
--     oe   : in std_logic;
--     d    : out std_logic_vector(width-1 downto 0));

-- end entity rom_dxw;
-- architecture beh of rom_dxw is
--   type data_array is array (natural range <>) of std_logic_vector(width-1 downto 0);
--   signal rom_data : data_array(0 to 2**dbit-1) := (others => (others => '0'));
--   signal rom_o : std_logic_vector(width-1 downto 0);
-- begin  -- architecture beh
--   process is
--     file input_file  : text open read_mode is fname;
--     variable input_line : line;
--     variable rom_v : std_logic_vector(width-1 downto 0);
--     variable rom_dat : data_array(0 to 2**dbit-1) := (others => (others => '0'));
--     variable data_string : string(7 downto 1);
--     variable ok, first : boolean := true;
--     variable j : integer := 0;
--   begin  -- process
--  --   if first then
--       j := 0;
--       while (not endfile(input_file)) loop 
--         readline(input_file, input_line);
--         if input_line.all'length=0 or input_line(1)/= '+' then
--           next;
--         end if;
--         --     read(input_line, plus_string, ok);
--         read(input_line,data_string, ok);
--         assert ok report "Read ROM data failed for line" severity failure;
--         -- instr := instr_read(11*8 downto 1);
--         report data_string severity note;
--         rom_data(j) <= rom_v;
--         wait for 10 ps;
--         j := j+1;               
--       end loop;
--       first := false;
--       wait;
--  --   end if;
--   end process;
--   rom_o <= rom_data(to_integer(unsigned(a)));
--   d <= rom_o            after tpd_rom    when oe='1' else
--        (others => 'Z')  after tpd_rom;
-- end architecture beh;
-------------------------------------------------------------------------------

library ieee, stdcell_lib;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use stdcell_lib.stdcell_pkg.all;
-- packages for managing text files
use std.textio.all;
use ieee.std_logic_textio.all;
entity rom_dxw is
  generic(fname: string := "ubeta_ver_prog.coe";
          depth : natural := 5;
          width : natural := 32);
    port(a  : in std_logic_vector(depth-1 downto 0);
         d  : out std_logic_vector(width-1 downto 0));
end entity rom_dxw;

architecture beh of rom_dxw is
  -- constant depth : natural := 5;
  -- constant width : natural := 32;
  type data_array is array (natural range <>) of std_logic_vector(width-1 downto 0);  
  signal rom_data : data_array(0 to 2**depth-1);
--  signal addr : unsigned(31 downto 0);
  --
  function hex2bin (d_str : string; n: natural)
    return std_logic_vector is
--    variable cinstr : string(11 downto 1);
    variable d_o : std_logic_vector(n*4-1 downto 0);
    variable d4: std_logic_vector(3 downto 0);
    variable j : natural;
  begin
    j := n;
    for i in n downto 1 loop
      case d_str(j) is
        when '0' => d4 := "0000";
        when '1' => d4 := "0001";
        when '2' => d4 := "0010";
        when '3' => d4 := "0011";
        when '4' => d4 := "0100";
        when '5' => d4 := "0101";
        when '6' => d4 := "0110";
        when '7' => d4 := "0111";
        when '8' => d4 := "1000";
        when '9' => d4 := "1001";
        when 'a'|'A' => d4 := "1010";
        when 'b'|'B' => d4 := "1011";
        when 'c'|'C' => d4 := "1100";
        when 'd'|'D' => d4 := "1101";
        when 'e'|'E' => d4 := "1110";
        when 'f'|'F' => d4 := "1111";
        when others => d4 := "UUUU";
      end case;
      d_o(i*4-1 downto (i-1)*4) := d4;
      j := j-1;
    end loop;  -- i
    return d_o;
  end function hex2bin;
  --
begin  -- architecture sim
  --
  d <= rom_data(to_integer(unsigned(a)));
  --
  process is
    file input_file  : text open read_mode is fname;
    variable input_line : line;
    variable base_string : string(28 downto 1);
    variable ini_string : string(29 downto 1);
    variable instr_read : string(11*8+1 downto 1);
    variable d_str : string(width/4+1 downto 1);
    variable dword : std_logic_vector(width-1 downto 0);
    variable ok : boolean;
    variable romd : data_array(0 to 2**depth-1) := (others => (others => '0'));
    variable j, radix : integer;
  begin
    readline(input_file, input_line);
    assert input_line.all'length /= 0 report "The program file is empty." severity FAILURE;
    read(input_line, base_string, ok);
    assert ok report "Read base string failed for line" severity failure;
    report base_string severity note;
    read(input_line, radix, ok);
    assert ok report "Read base string failed for line" severity failure;
    
    -- radix := 16;
    -- if base_string(2)='2' then
    --   radix := 2;
    -- end if;
    readline(input_file, input_line);
    assert input_line.all'length /= 0 report "Expecting a line of inital text." severity FAILURE;
    read(input_line, ini_string, ok);
    assert ok report "Read initial string failed for line" severity failure;
--    report ini_string severity note;      
    j := 0;
    while (not endfile(input_file)) loop 
      readline(input_file, input_line);
      assert input_line.all'length /= 0 report "An empty line." severity FAILURE;
      if radix=2 then
        read(input_line, dword, ok);
        assert ok report "Read a memory data failed for line" severity failure;
        romd(j) := dword;
      else        
        read(input_line, d_str, ok);
        assert ok report "Read a memory data failed for line" severity failure;
--      report instr severity note;
        romd(j) := hex2bin(d_str,width/4+1);
      end if;
      j := j+1;               
    end loop;
    rom_data <= romd;
    assert false report "Finish setting ROM's data." severity note;
    wait;
  end process;
end architecture beh;
