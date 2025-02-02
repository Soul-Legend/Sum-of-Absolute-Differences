library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
    generic (
        N: integer := 4
    );
    port (
        clk   : in std_logic;
        enable : in std_logic;
        q: in std_logic_vector(N-1 downto 0);
        y: out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture comportamento of Reg is
begin
    process(clk)
	 begin
		if(rising_edge(clk)) then
			if (enable = '1') then
				y <= q;
			end if;
		end if;
    end process;
end architecture;