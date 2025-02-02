library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sad_operativo_v3 is
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
        final: out std_logic_vector(3 downto 0);
        pA0: in std_logic_vector(7 downto 0);
        pA1: in std_logic_vector(7 downto 0);
        pA2: in std_logic_vector(7 downto 0);
        pA3: in std_logic_vector(7 downto 0);
        pB0: in std_logic_vector(7 downto 0);
        pB1: in std_logic_vector(7 downto 0);
        pB2: in std_logic_vector(7 downto 0);
        pB3: in std_logic_vector(7 downto 0);
        sad: out std_logic_vector(13 downto 0)
    );

end entity;


architecture comportamento of sad_operativo_v3 is
    signal pa0m: std_logic_vector(7 downto 0);
    signal pa1m: std_logic_vector(7 downto 0);
    signal pa2m: std_logic_vector(7 downto 0);
    signal pa3m: std_logic_vector(7 downto 0);
    signal pb0m: std_logic_vector(7 downto 0);
    signal pb1m: std_logic_vector(7 downto 0);
    signal pb2m: std_logic_vector(7 downto 0);
    signal pb3m: std_logic_vector(7 downto 0);

    signal abs0: signed(8 downto 0);
    signal abs1: signed(8 downto 0);
    signal abs2: signed(8 downto 0);
    signal abs3: signed(8 downto 0);

    signal abs0_e: std_logic_vector(7 downto 0);
    signal abs1_e: std_logic_vector(7 downto 0);
    signal abs2_e: std_logic_vector(7 downto 0);
    signal abs3_e: std_logic_vector(7 downto 0);

    signal sum0: std_logic_vector(8 downto 0);
    signal sum1: std_logic_vector(8 downto 0);

    signal sum_end: std_logic_vector(9 downto 0);
    signal sum_concat: std_logic_vector(13 downto 0);

    signal sum_mult: std_logic_vector(13 downto 0);
    signal mult_reg: std_logic_vector(13 downto 0);
    signal sad_sum: std_logic_vector(13 downto 0);
	 
	 signal mult_i: std_logic_vector(4 downto 0);
    signal i_sum: std_logic_vector(4 downto 0);
	 signal concat: std_logic_vector(4 downto 0);
    signal sum_mult_i: std_logic_vector(4 downto 0);
	 
	component somador is
        generic (
            N: integer := 14
        );
        PORT(add1 :IN std_logic_vector(N-1 DOWNTO 0);
	        add2 : IN std_logic_vector(N-1 DOWNTO 0);
	        sum : OUT std_logic_vector (N-1 DOWNTO 0));
    end component;
    component subtractor is
        GENERIC(N :INTEGER := 8);
        PORT(sub1 :IN std_logic_vector(N-1 DOWNTO 0);
	        sub2 : IN std_logic_vector(N-1 DOWNTO 0);
	        sub : OUT signed (N DOWNTO 0));
    end component;
    component absolute is
    generic (
        N: integer := 4
    );
    port (
        q: in signed(N-1 downto 0);
        y: out std_logic_vector(N-2 downto 0)
    );
    end component;
    component multiplexer is
        generic(N :integer := 4);
        PORT( s0, s1: in std_logic_vector(N-1 downto 0);
            sel: IN STD_LOGIC ;
            y : OUT std_logic_vector(N-1 downto 0) ) ;
    end component;
    component Reg is
        generic (
            N: integer := 4
        );
        port (
            clk   : in std_logic;
            enable : in std_logic;
            q: in std_logic_vector(N-1 downto 0);
            y: out std_logic_vector(N-1 downto 0)
        );
    end component;
    component somador_ol is
        GENERIC(N :INTEGER := 14);
        PORT(add1 :IN std_logic_vector(N-1 DOWNTO 0);
	        add2 : IN std_logic_vector(N-1 DOWNTO 0);
	        sum : OUT std_logic_vector (N DOWNTO 0));
    end component;
begin

    reg0: Reg
        generic map (
            N => 8
        )
        port map (
            clk   => clk,
            enable => cpA,
            q => PA0,
            y => pa0m
        );
    reg1: Reg
        generic map (
            N => 8
        )
        port map (
            clk   => clk,
            enable => cpA,
            q => PA1,
            y => pa1m
        );
    reg2: Reg
        generic map (
            N => 8
        )
        port map (
            clk   => clk,
            enable => cpA,
            q => PA2,
            y => pa2m
        );
    reg3: Reg
        generic map (
            N => 8
        )
        port map (
            clk   => clk,
            enable => cpA,
            q => PA3,
            y => pa3m
        );


    reg4: Reg
        generic map (
            N => 8
        )
        port map (
            clk   => clk,
            enable => cpB,
            q => PB0,
            y => pb0m
        );
    reg5: Reg
        generic map (
            N => 8
        )
        port map (
            clk   => clk,
            enable => cpB,
            q => PB1,
            y => pb1m
        );
    reg6: Reg
        generic map (
            N => 8
        )
        port map (
            clk   => clk,
            enable => cpB,
            q => PB2,
            y => pb2m
        );
    reg7: Reg
        generic map (
            N => 8
        )
        port map (
            clk   => clk,
            enable => cpB,
            q => PB3,
            y => pb3m
        );
    
    minus0: subtractor
        generic map (
            N => 8
        )
        port map (
            sub1 => pa0m,
            sub2 => pb0m,
            sub => abs0 
        );
    minus1: subtractor
        generic map (
            N => 8
        )
        port map (
            sub1 => pa1m,
            sub2 => pb1m,
            sub => abs1
        );
    minus2: subtractor
        generic map (
            N => 8
        )
        port map (
            sub1 => pa2m,
            sub2 => pb2m,
            sub => abs2
        );
    minus3: subtractor
        generic map (
            N => 8
        )
        port map (
            sub1 => pa3m,
            sub2 => pb3m,
            sub => abs3
        );

    a0: absolute
        generic map (
            N => 9
        )
        port map (
            q => abs0,
            y => abs0_e (7 downto 0)
        );
    a1: absolute
        generic map (
            N => 9
        )
        port map (
            q => abs1,
            y => abs1_e (7 downto 0)
        );
    a2: absolute
        generic map (
            N => 9
        )
        port map (
            q => abs2,
            y => abs2_e (7 downto 0)
        );
    a3: absolute
        generic map (
            N => 9
        )
        port map (
            q => abs3,
            y => abs3_e (7 downto 0)
        );

    plus1: somador_ol
        generic map (
            N => 8
        )
        port map (
            add1 => abs0_e,
            add2 => abs1_e,
            sum => sum0
        );

    plus2: somador_ol
        generic map (
            N => 8
        )
        port map (
            add1 => abs2_e,
            add2 => abs3_e,
            sum => sum1
        );

    plus3: somador_ol
        generic map (
            N => 9
        )
        port map (
            add1 => sum0,
            add2 => sum1,
            sum => sum_end 
        );
    
    sum_concat <= "0000" & sum_end;
    
    plus4: somador
        generic map (
            N => 14
        )
        port map (
            add1 => sum_concat,
            add2 => sad_sum,
            sum => sum_mult 
        );
    
    mult0: multiplexer
        generic map (
            N => 14
        )
        port map (
            sel => zsoma,
            s0 => sum_mult,
            s1 => (others => '0'),
            y => mult_reg
        );
    
    reg_soma: Reg
        generic map (
            N => 14
        )
        port map (
            clk   => clk,
            enable => csoma,
            q => mult_reg,
            y => sad_sum
        );
		  
    reg_sad: Reg
        generic map (
            N => 14
        )
        port map (
            clk   => clk,
            enable => csad_reg,
            q => sad_sum,
            y => sad
        );

    -- Now the counter

    mult_counter: multiplexer
        generic map (
            N => 5
        )
        port map (
            s0 => sum_mult_i,
            s1 => (others => '0'),
            sel => zi,
            y => mult_i 
        );

    counter_reg: Reg
        generic map (
            N => 5
        )
        port map (
            enable => csoma,
            clk => clk,
            q => mult_i,
            y => i_sum 
        );
    
        menor <= not i_sum(4);
        concat(3 downto 0) <= i_sum(3 downto 0);
		  concat(4) <= '0';
        final <= concat(3 downto 0);

    soma_counter: somador
        generic map (
            N => 5
        )
        port map (
            add1 => concat,
            add2 => "00001",
            sum => sum_mult_i
        );
    
end architecture;