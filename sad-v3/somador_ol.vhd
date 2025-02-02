
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY somador_ol IS
GENERIC(N :INTEGER := 14);
PORT(add1 :IN std_logic_vector(N-1 DOWNTO 0);
	  add2 : IN std_logic_vector(N-1 DOWNTO 0);
	  sum : OUT std_logic_vector (N DOWNTO 0));
END somador_ol;

ARCHITECTURE rtl OF somador_ol IS
BEGIN
sum <= std_logic_vector(resize(signed(add1), N+1) + resize(signed(add2), N+1));
END rtl;
