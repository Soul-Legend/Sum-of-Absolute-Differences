library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sad is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        iniciar: in std_logic;
        pronto: out std_logic;
        SAD: out std_logic_vector(13 downto 0);
        enda: out std_logic_vector(5 downto 0);
        reada: out std_logic;
        endb: out std_logic_vector(5 downto 0);
        readb: out std_logic;
		  mema: in std_logic_vector(7 downto 0);
        memb: in std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of sad is
    component sad_operativo is
    port (
        clk: in std_logic;
        zi: in std_logic;
        ci: in std_logic;
        cpA: in std_logic;
        cpB: in std_logic;
        zsoma: in std_logic;
        csoma: in std_logic;
        csad_reg: in std_logic;
        menor: out std_logic;
        final: out std_logic_vector(5 downto 0);
        pA: in std_logic_vector(7 downto 0);
        pB: in std_logic_vector(7 downto 0);
        sad: out std_logic_vector(13 downto 0)
    );
    end component;

    component sad_controle is
        PORT(clk, rst, iniciar, menor : IN STD_LOGIC;
	        read_d, pronto, zi, ci, cpa, cpb, zsoma, csoma, csag_reg :OUT STD_LOGIC);
    end component;

    signal zi: std_logic;
    signal ci: std_logic;
    signal cpA: std_logic;
    signal cpB: std_logic;
    signal zsoma: std_logic;
    signal csoma: std_logic;
    signal csad_reg: std_logic;
    signal menor: std_logic;
	 signal read_inter: std_logic;
	 signal end_inter: std_logic_vector(5 downto 0);

begin
    controle: sad_controle
        port map (
            clk   => clk,
            rst => reset,
            iniciar => iniciar,
            menor => menor,
            read_d => read_inter,
            pronto => pronto,
            zi => zi,
            ci => ci,
            cpa => cpA,
            cpb => cpB,
            zsoma => zsoma,
            csoma => csoma,
            csag_reg => csad_reg
        );
	readb <= read_inter;
	reada <= read_inter;
    
    operativo: sad_operativo
        port map (
            clk   => clk,
            zi => zi,
            ci => ci,
            cpA => cpA,
            cpB => cpB,
            zsoma => zsoma,
            csoma => csoma,
            csad_reg => csad_reg,
            menor => menor,
            pA => memA(7 downto 0),
            pB => memB(7 downto 0),
            sad => SAD,
				final => end_inter
        );
	enda <= end_inter;
	endb <= end_inter;

end architecture;