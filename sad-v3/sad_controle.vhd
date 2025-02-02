LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sad_controle IS
PORT(clk, rst, iniciar, menor : IN STD_LOGIC;
	  read_d, pronto, zi, ci, cpa, cpb, zsoma, csoma, csag_reg :OUT STD_LOGIC);
END sad_controle;

ARCHITECTURE Behavior OF sad_controle IS
TYPE
Tipo_estado IS (S0, S1, S2, S3, S4, S5);
SIGNAL EstadoAtual : Tipo_estado;

BEGIN

PROCESS (rst, clk)
	BEGIN
		IF rst = '1' THEN
			EstadoAtual <= S0;
		ELSIF (rising_edge(clk)) THEN
			CASE EstadoAtual IS
			WHEN
			S0 =>
				IF iniciar = '1' THEN
					EstadoAtual <= S1;
				ELSE
					EstadoAtual <= S0;
				END IF;
			WHEN
			S1 =>
					EstadoAtual <= S2;
		WHEN
			S2 =>
				IF menor = '1' THEN
					EstadoAtual <= S3;
				ELSE
					EstadoAtual <= S5;
				END IF;
			WHEN
			S3 =>
					EstadoAtual <= S4;
			WHEN
			S4 =>
					EstadoAtual <= S2;
			WHEN
			S5 =>
					EstadoAtual <= S0;
			END CASE;
		END IF;
	END PROCESS;
		pronto <= '1' WHEN
			EstadoAtual = S0
			ELSE '0';
		read_d <= '1' WHEN
			EstadoAtual = S3
			ELSE '0';
		zi <= '1' WHEN
			EstadoAtual = S1
			ELSE '0';
		ci <= '1' WHEN
			(EstadoAtual = S1) or (EstadoAtual = S4)
			ELSE '0';
		zsoma <= '1' WHEN
			EstadoAtual = S1
			ELSE '0';
		csoma <= '1' WHEN
			(EstadoAtual = S1) or (EstadoAtual = S4)
			ELSE '0';
		cpa <= '1' WHEN
			EstadoAtual = S3
			ELSE '0';
		cpb <= '1' WHEN
			EstadoAtual = S3
			ELSE '0';
		csag_reg <= '1' WHEN
			EstadoAtual = S5
			ELSE '0';
END Behavior;
