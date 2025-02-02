library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity absolute is
    generic (
        N: integer := 4
    );
    port (
        q: in signed(N-1 downto 0);
        y: out std_logic_vector(N-2 downto 0)
    );
end entity;

architecture rtl of absolute is
begin
    y <= std_logic_vector(abs(q))(N-2 downto 0);
end architecture;