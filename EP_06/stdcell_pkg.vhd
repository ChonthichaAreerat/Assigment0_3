-------------------------------------------------------------------------------
-- Behavioral VHDL Models of 180nm CMOS Standard Cells
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
package stdcell_pkg is
  -- Timing specification of the primitive standard cells
  constant tpd_inv : time := 0.02 ns;
  constant tpd_buf : time := 0.08 ns;
  constant tpd_buf_h : time := 0.07 ns;
  constant tpd_tri : time := 0.15 ns;
  constant tpd_and2 : time := 0.12 ns;
  constant tpd_and3 : time := 0.15 ns;
  constant tpd_and4 : time := 0.16 ns;
  constant tpd_nand2 : time := 0.03 ns;
  constant tpd_nand3 : time := 0.05 ns;
  constant tpd_nand4 : time := 0.07 ns;
  constant tpd_or2 : time := 0.15 ns;
  constant tpd_or3 : time := 0.21 ns;
  constant tpd_or4 : time := 0.29 ns;
  constant tpd_nor2 : time := 0.05 ns;
  constant tpd_nor3 : time := 0.08 ns;
  constant tpd_nor4 : time := 0.12 ns;
  constant tpd_xor2 : time := 0.14 ns;
  constant tpd_xnor2 : time := 0.14 ns;
  constant tpd_mux2 : time := 0.12 ns;
  constant tpd_mux4 : time := 0.19 ns;
  constant tpd_dreg : time := 0.19 ns;
  constant ts_dreg : time := 0.15 ns;
  constant th_dreg : time := 0 ns;
  
  -- Combinational standard cells are declared as funtion
  -- for generating waveform to a 1 bit signal
  --   <target signal> <= <function's (module's) name> (inputs) after <tpd of module>;
  -- e.g. y <= inv(a) after tpd_inv;
  --      y <= mux4(s0, s1, d0, d1, d2, d3) after tpd_mux4;

  function inv (signal a : std_logic) return std_logic;
  function buf (signal a : std_logic) return std_logic;
  function buf_h (signal a : std_logic) return std_logic;
  function tri (signal a : std_logic; signal e : std_logic) return std_logic;
--
  function and2 (signal a : std_logic; signal b : std_logic) return std_logic;
  function and3 (signal a : std_logic; signal b : std_logic; signal c : std_logic) return std_logic;
  function and4 (signal a : std_logic; signal b : std_logic; signal c : std_logic; signal d : std_logic) return std_logic;
  function nand2 (signal a : std_logic; signal b : std_logic) return std_logic; 
  function nand3 (signal a : std_logic; signal b : std_logic; signal c : std_logic) return std_logic;
  function nand4 (signal a : std_logic; signal b : std_logic; signal c : std_logic; signal d : std_logic) return std_logic;
  -- or, nor
  function or2 (signal a : std_logic; signal b : std_logic) return std_logic;
  function or3 (signal a : std_logic; signal b : std_logic; signal c : std_logic) return std_logic;
  function or4 (signal a : std_logic; signal b : std_logic; signal c : std_logic; signal d : std_logic) return std_logic;
  function nor2 (signal a : std_logic; signal b : std_logic) return std_logic;
  function nor3 (signal a : std_logic; signal b : std_logic; signal c : std_logic) return std_logic;
  function nor4 (signal a : std_logic; signal b : std_logic; signal c : std_logic; signal d : std_logic) return std_logic;
  -- xor, xnor
  function xor2 (signal a : std_logic;signal b : std_logic) return std_logic;
  function xnor2 (signal a : std_logic;signal b : std_logic) return std_logic;
  -- mux2, mux4
  function mux2 (signal s : std_logic; signal d0 : std_logic; signal d1 : std_logic) return std_logic;
  function mux4 (signal s0 : std_logic; signal s1 : std_logic;
    signal d0 : std_logic; signal d1 : std_logic; signal d2 : std_logic; signal d3 : std_logic) return std_logic;
  
end package stdcell_pkg;

package body stdcell_pkg is

  -- purpose: inverter
  function inv (signal a : std_logic) return std_logic is
  begin  -- function inv
    return (not a);
  end function inv;
  function buf (signal a : std_logic) return std_logic is
  begin  -- function inv
    return a;
  end function buf;
  function buf_h (signal a : std_logic) return std_logic is
  begin  -- function inv
    return a;
  end function buf_h;
  function tri (signal a : std_logic; signal e : std_logic) return std_logic is
  begin  -- function tri
    if e='1' then
      return a;
    else
      return 'Z';
    end if;
  end function tri;
  
-- and, nand
  function and2 (signal a : std_logic; signal b : std_logic) return std_logic is
  begin  -- function and2
    return a and b;
  end function and2;
  function and3 (signal a : std_logic; signal b : std_logic; signal c : std_logic) return std_logic is
  begin  -- function and3
    return a and b and c;
  end function and3;
  function and4 (signal a : std_logic; signal b : std_logic; signal c : std_logic; signal d : std_logic) return std_logic is
  begin  -- function and4
    return a and b and c and d;
  end function and4;
  function nand2 (signal a : std_logic; signal b : std_logic) return std_logic is
  begin  -- function nand2
    return not (a and b);
  end function nand2;
  function nand3 (signal a : std_logic; signal b : std_logic; signal c : std_logic) return std_logic is
  begin  -- function nand3
    return not (a and b and c);
  end function nand3;
  function nand4 (signal a : std_logic; signal b : std_logic; signal c : std_logic; signal d : std_logic) return std_logic is
  begin  -- function nand4
    return not (a and b and c and d);
  end function nand4;
  
  -- or, nor
  function or2 (signal a : std_logic; signal b : std_logic) return std_logic is
  begin  -- function or2
    return a or b;
  end function or2;
  function or3 (signal a : std_logic; signal b : std_logic; signal c : std_logic) return std_logic is
  begin  -- function or3
    return a or b or c;
  end function or3;
  function or4 (signal a : std_logic; signal b : std_logic; signal c : std_logic; signal d : std_logic) return std_logic is
  begin  -- function or4
    return a or b or c or d;
  end function or4;
  function nor2 (signal a : std_logic; signal b : std_logic) return std_logic is
  begin  -- function nor2
    return not (a or b);
  end function nor2;
  function nor3 (signal a : std_logic; signal b : std_logic; signal c : std_logic) return std_logic is
  begin  -- function nor3
    return not (a or b or c);
  end function nor3;
  
  function nor4 (signal a : std_logic; signal b : std_logic; signal c : std_logic; signal d : std_logic) return std_logic is
  begin  -- function nor4
    return not (a or b or c or d);
  end function nor4;
  -- xor, xnor
  function xor2 (signal a : std_logic; signal b : std_logic) return std_logic is
  begin  -- function xor2
    return a xor b;
  end function xor2;
  function xnor2 (signal a : std_logic; signal b : std_logic) return std_logic is
  begin  -- function xnor2
    return not (a xor b);
  end function xnor2;
  
  -- mux2, mux4
  function mux2 (signal s : std_logic; signal d0 : std_logic; signal d1 : std_logic) return std_logic is
  begin  -- function or2
    if s='1' then
      return d1;
    else
      return d0;
    end if;
  end function mux2;
  function mux4 (signal s0 : std_logic; signal s1 : std_logic;
                 signal d0 : std_logic;signal d1 : std_logic; signal d2 : std_logic; signal d3 : std_logic)
    return std_logic is
  begin  -- function or2
    if s1='1' and s0='1' then
      return d3;
    elsif s1='1' and s0='0' then
      return d2;
    elsif s1='0' and s0='1' then
      return d1;
    else
      return d0;
    end if;
  end function mux4;
end package body stdcell_pkg;

