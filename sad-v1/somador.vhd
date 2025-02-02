LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY somador IS
GENERIC(N :INTEGER := 14);
PORT(add1 :IN std_logic_vector(N-1 DOWNTO 0);
	  add2 : IN std_logic_vector(N-1 DOWNTO 0);
	  sum : OUT std_logic_vector (N-1 DOWNTO 0));
END somador;

ARCHITECTURE rtl OF somador IS
BEGIN
sum <= std_logic_vector(unsigned(add1) + unsigned(add2));
END rtl;
