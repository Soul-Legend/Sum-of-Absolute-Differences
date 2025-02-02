LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY multiplexer IS
generic(
    N :integer := 4
);
PORT ( s0, s1: in std_logic_vector(N-1 downto 0);
        sel: IN STD_LOGIC ;
        y : OUT std_logic_vector(N-1 downto 0) ) ;
END multiplexer;

ARCHITECTURE Behavior OF multiplexer IS
begin
with sel select
        y <=  s0 WHEN '0', s1 when others;
END Behavior;
