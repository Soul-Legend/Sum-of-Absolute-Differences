LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY subtractor IS
GENERIC(N :INTEGER := 8);
PORT(sub1 :IN std_logic_vector(N-1 DOWNTO 0);
	  sub2 : IN std_logic_vector(N-1 DOWNTO 0);
	  sub : OUT signed(N DOWNTO 0));
END subtractor;

ARCHITECTURE rtl OF subtractor IS
BEGIN
sub <= signed('0' & sub1) - signed('0' & sub2);
END rtl;
