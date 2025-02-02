library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity sad_operativo is
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

end entity;


architecture comportamento of sad_operativo is
    signal pa_minus: std_logic_vector(7 downto 0);
    signal pb_minus: std_logic_vector(7 downto 0);

    signal abs0: signed(8 downto 0);
    signal abs_e: std_logic_vector(7 downto 0);
    signal abs_concat: std_logic_vector(13 downto 0);

    signal sum_mult: std_logic_vector(13 downto 0);
    signal mult_reg: std_logic_vector(13 downto 0);
    signal soma_sad: std_logic_vector(13 downto 0);

    signal mult_i: std_logic_vector(6 downto 0);
    signal i_sum: std_logic_vector(6 downto 0);
    signal saida: std_logic_vector(6 downto 0);
    signal concat: std_logic_vector(6 downto 0);

	component somador is
        generic (N: integer := 14);
        PORT(add1 :IN std_logic_vector(N-1 DOWNTO 0);
	        add2 : IN std_logic_vector(N-1 DOWNTO 0);
	        sum : OUT std_logic_vector (N-1 DOWNTO 0));
    end component;
    component subtractor is
        GENERIC(N: INTEGER := 8);
        PORT(sub1 :IN std_logic_vector(N-1 DOWNTO 0);
	        sub2 : IN std_logic_vector(N-1 DOWNTO 0);
	        sub : OUT signed (N DOWNTO 0));
    end component;
    component absolute is
    generic (N: integer := 4);
    port (
        q: in signed(N-1 downto 0);
        y: out std_logic_vector(N-2 downto 0)
    );
    end component;
    component multiplexer is
        generic(N: integer := 4);
        PORT( s0, s1: in std_logic_vector(N-1 downto 0);
            sel: IN STD_LOGIC ;
            y : OUT std_logic_vector(N-1 downto 0) ) ;
    end component;
    component Reg is
        generic (N: integer := 4);
        port (
            clk   : in std_logic;
            enable : in std_logic;
            q: in std_logic_vector(N-1 downto 0);
            y: out std_logic_vector(N-1 downto 0)
        );
    end component;
    component somador_ol is
        GENERIC(N: INTEGER := 14);
        PORT(add1: IN std_logic_vector(N-1 DOWNTO 0);
	        add2: IN std_logic_vector(N-1 DOWNTO 0);
	        sum: OUT std_logic_vector(N DOWNTO 0));
    end component;
begin
    regPA: Reg
        generic map (
            N => 8
        )
        port map (
            clk   => clk,
            enable => cpA,
            q => pA,
            y => pa_minus
        );
    regPB: Reg
        generic map (
            N => 8
        )
        port map (
            clk   => clk,
            enable => cpB,
            q => pB,
            y => pb_minus
        );
    Sub: subtractor
        generic map (
            N => 8
        )
        port map (
            sub1 => pa_minus,
            sub2 => pb_minus,
            sub => abs0
        );
    
    absol: absolute
        generic map (
            N => 9
        )
        port map (
            q => abs0,
            y => abs_e (7 downto 0)
        );
    
    abs_concat <= "000000" & abs_e;

    soma1: somador
        generic map (
            N => 14
        )
        port map (
            add1 => abs_concat,
            add2 => soma_sad,
            sum => sum_mult
        );
    
    mult: multiplexer
        generic map (
            N => 14
        )
        port map (
            s0 => sum_mult,
            s1 => (others => '0'),
            sel => zsoma,
            y => mult_reg
        );
    
    soma: Reg
        generic map (
            N => 14
        )
        port map (
            enable => csoma,
            clk => clk,
            q => mult_reg,
            y => soma_sad
        );
    
    sad_reg: Reg
        generic map (
            N => 14
        )
        port map (
            enable => csad_reg,
            clk => clk,
            q => soma_sad,
            y => sad 
        );

    -- Now the counter

    mult2: multiplexer
        generic map (
            N => 7
        )
        port map (
            s0 => saida,
            s1 => (others => '0'),
            sel => zi,
            y => mult_i 
        );

    counter_reg: Reg
        generic map (
            N => 7
        )
        port map (
            enable => csoma,
            clk => clk,
            q => mult_i,
            y => i_sum 
        );
    
        menor <= not i_sum(6);
        concat(5 downto 0) <= i_sum(5 downto 0);
        concat(6) <= '0';
        final <= concat(5 downto 0);

    soma_counter: somador
        generic map (
            N => 7
        )
        port map (
            add1 => concat,
            add2 => "0000001",
            sum => saida 
        );

end architecture;