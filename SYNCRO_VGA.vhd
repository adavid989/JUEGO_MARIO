library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SYNC_VGA is
    port (
        clk1 : in std_logic;
        rst : in std_logic;  
        hsync : out std_logic;  
        vsync : out std_logic;  
        visible : out std_logic;
        columnas : out std_logic_vector(9 downto 0);
        filas : out std_logic_vector(9 downto 0)    
    );
end SYNC_VGA;

architecture Behavioral of SYNC_VGA is
    signal new_line : std_logic;
    signal new_frame : std_logic;
    signal cols : unsigned(9 downto 0) := (others => '0');
    signal fils : unsigned(9 downto 0) := (others => '0');
    signal pxl_visible : std_logic;
    signal line_visible : std_logic;
   
    signal pos_fila : unsigned(5 downto 0);
    signal pos_col : unsigned(5 downto 0);

    component contador
        generic(
            fin_cuenta : natural := 800;
            numero_bits : natural := 9
        );
        port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            enable : in STD_LOGIC;
            salida : out STD_LOGIC;
            cuenta_OUT : out unsigned(numero_bits downto 0)
        );
    end component;
   
begin

conta_cols : contador
    generic map(
        fin_cuenta => 799, --linea horizontal(640 + 160) es mi zona visible + mi zona no visible
        numero_bits => 9)
    port map(
        clk => clk1,
        rst => rst,
        enable => '1',
        salida => new_line,
        cuenta_OUT => cols
        );

conta_filas : contador
    generic map(
        fin_cuenta => 524, -- linea del cuadro (480 + 45)
        numero_bits => 9)
    port map(
        clk => clk1,
        rst => rst,
        enable => new_line,
        salida => new_frame,
        cuenta_OUT => fils
        );

hsync <= '0' when (cols > 655 and cols < 752) else '1';  -- 640 + 16 y 800 - 48
pxl_visible <= '1' when (cols < 640) else '0'; -- si se encuentra en la zona visible, px1 me vale 1

vsync <= '0' when (fils > 489 and fils < 492) else '1';  -- 479 + 10 y 524 - 33
line_visible <= '1' when (fils < 480) else '0'; -- si se encuentra en la zona visible, line me vale 1

visible <= pxl_visible and line_visible; -- cuando esta dentro de ambas zonas visibles, mi señal la marcamos visible

columnas <= std_logic_vector(cols);
filas <= std_logic_vector(fils);



end Behavioral;