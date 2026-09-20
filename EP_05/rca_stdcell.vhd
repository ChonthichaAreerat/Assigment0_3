-- rca module
library ieee;
use ieee.std_logic_1164.all;
library stdcell_lib;
use stdcell_lib.stdcell_pkg.all;

entity rca is
    generic (
        width : natural := 32
    );
    port(
        a,b : in  std_logic_vector(width-1 downto 0);
        ci  : in  std_logic;
        co  : out std_logic;
        s   : out std_logic_vector(width-1 downto 0)
    );
end entity rca;

architecture stdcell of rca is
    signal c: std_logic_vector(width downto 0);
begin
    fa_gen: for i in 0 to width-1 generate
        fa_i: entity work.fa(stdcell)
        port map (
            a  => a(i),
            b  => b(i),
            ci => c(i),
            s  => s(i),
            co => c(i+1)
        );
    end generate fa_gen;
    
    -- carry in
    c(0) <= ci;
    -- carry out
    co <= c(width);
end architecture stdcell;