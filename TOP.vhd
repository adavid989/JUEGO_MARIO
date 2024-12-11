
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        btn_arriba    : in  std_logic;
        btn_abajo  : in  std_logic;
        btn_izq  : in  std_logic;
        btn_dcha : in  std_logic;
        clkP : out std_logic;  
        clkN : out std_logic;
        dataP : out std_logic_vector(2 downto 0);
        dataN : out std_logic_vector(2 downto 0)
    );
end TOP;

architecture Behavioral of TOP is
    signal clk0 : std_logic;
    signal clk1 : std_logic;
    signal hsync : std_logic;
    signal vsync : std_logic;
    signal visible : std_logic;
    signal columnas_s: std_logic_vector(9 downto 0);
    signal filas_s : std_logic_vector(9 downto 0);
    signal VDataRGB : std_logic_vector(23 downto 0);
    signal azul : std_logic_vector(8-1 downto 0) := (others => '0');
    signal verde : std_logic_vector(8-1 downto 0) := (others => '0');
    signal rojo : std_logic_vector(8-1 downto 0) := (others => '0');
    signal VActive : std_logic; 
       
    -- RELOJ 100MS
    signal S100MS_s : std_logic;
   
    -- RELOJ 500MS
    signal S500MS_s : std_logic;
   
    -- MARIO AUTOMATICO  
    signal mario_automatico_fil_and_col_s  : std_logic;
    
   signal dato_memo_mario_automatico_verde_s : std_logic_vector(15 downto 0);
   signal dato_memo_mario_automatico_rojo_s : std_logic_vector(15 downto 0);
   signal dato_memo_mario_automatico_azul_s : std_logic_vector(15 downto 0);
   
   signal dato_memo_mario_automatico_verde_orientacion_s : std_logic_vector(15 downto 0);
   signal dato_memo_mario_automatico_rojo_orientacion_s : std_logic_vector(15 downto 0);
   signal dato_memo_mario_automatico_azul_orientacion_s : std_logic_vector(15 downto 0);
   
    --señal que conecta mi MARIO_AUTOMATICO_MDE con mi comparador       
    signal pos_columna_mario_automatico_s : std_logic_vector(5 downto 0);
    signal pos_fila_mario_automatico_s : std_logic_vector(5 downto 0);  
    
    
        
    --MARIO MANUAL
    signal mario_manual_fil_and_col_s : std_logic;
    
    signal dato_memo_mario_manual_verde_s : std_logic_vector(15 downto 0);
    signal dato_memo_mario_manual_rojo_s : std_logic_vector(15 downto 0);
    signal dato_memo_mario_manual_azul_s : std_logic_vector(15 downto 0);
    
    signal dato_memo_mario_manual_verde_orientacion_s : std_logic_vector(15 downto 0);
    signal dato_memo_mario_manual_rojo_orientacion_s : std_logic_vector(15 downto 0);
    signal dato_memo_mario_manual_azul_orientacion_s : std_logic_vector(15 downto 0);
    
    --señal que conecta mi MARIO_MANUAL con mi comparador
    signal pos_columna_mario_manual_s : std_logic_vector(5 downto 0);
    signal pos_fila_mario_manual_s : std_logic_vector(5 downto 0);
    
    
       
    -- FANTASMA
    signal fantasma_fil_and_col_s : std_logic;
    signal dato_memo_fantasma_s : std_logic_vector(15 downto 0);
    signal dato_memo_fantasma_azul_s : std_logic_vector(15 downto 0);
    signal dato_memo_fantasma_verde_s : std_logic_vector(15 downto 0);
    signal dato_memo_fantasma_rojo_s : std_logic_vector(15 downto 0);
    
    --señal que conecta mi  FANTASMA_MDE con mi comparador
    signal pos_columna_fantasma_s : std_logic_vector(5 downto 0);
    signal pos_fila_fantasma_s : std_logic_vector(5 downto 0);
    
    
       
    ---- PISTA
    signal pista_fil_and_col_s : std_logic;
    signal dato_memo_pista_s : std_logic_vector(31 downto 0);
    signal dato_memo_pista_verde_s : std_logic_vector(31 downto 0);
    signal dato_memo_pista_azul_s : std_logic_vector(31 downto 0);
    
   --señal que conecta mi CONTADOR_PSTA con mi comparador
    signal pos_columna_pista_s : std_logic_vector(4 downto 0);
    signal pos_fila_pista_s : std_logic_vector(4 downto 0);   





    signal figura_arriba_s : std_logic;
    signal figura_abajo_s : std_logic;
    signal figura_dcha_s : std_logic;
    signal figura_izq_s : std_logic;
    
    signal orientacion_s : std_logic_vector(1 downto 0);
    signal orientacion_mario_manual_s : std_logic_vector(1 downto 0);
    
    
                                                           
component PLL
    generic (
        CLKIN_PERIOD : real := 8.000;
        CLK_MULTIPLY : integer := 8;  
        CLK_DIVIDE : integer := 1;
        CLKOUT0_DIV : integer := 8;  
        CLKOUT1_DIV : integer := 40
    );
    port (
        clk_i : in  std_logic;
        rst : in  std_logic;
        clk0_o : out std_logic;
        clk1_o : out std_logic
    );
end component;

component SYNC_VGA
    port (
        clk1 : in  std_logic;
        rst : in  std_logic;
        hsync : out std_logic;
        vsync : out std_logic;
        visible : out std_logic;
        columnas : out std_logic_vector(9 downto 0);
        filas : out std_logic_vector(9 downto 0)
    );
end component;

component pinta_barras is
  Port (
    -- Entradas
    visible       : in std_logic;
    col           : in unsigned(9 downto 0);
    fila          : in unsigned(9 downto 0);
    -- MARIO AUTOMATICO
    mario_automatico_fil_and_col   : in std_logic; -- entrada que sale de mi comparador
    
    dato_memo_mario_automatico_verde : in unsigned(15 downto 0);
    dato_memo_mario_automatico_azul : in unsigned(15 downto 0);
    dato_memo_mario_automatico_rojo : in unsigned(15 downto 0);
    
    dato_memo_mario_automatico_verde_orientacion : in unsigned(15 downto 0);
    dato_memo_mario_automatico_azul_orientacion : in unsigned(15 downto 0);
    dato_memo_mario_automatico_rojo_orientacion : in unsigned(15 downto 0);
    
    -- MARIO MANUAL
    mario_manual_fil_and_col   : in std_logic; -- entrada que sale de mi comparador
    dato_memo_mario_manual_verde : in unsigned(15 downto 0);
    dato_memo_mario_manual_azul : in unsigned(15 downto 0);
    dato_memo_mario_manual_rojo : in unsigned(15 downto 0);
    
    dato_memo_mario_manual_verde_orientacion : in unsigned(15 downto 0);
    dato_memo_mario_manual_azul_orientacion : in unsigned(15 downto 0);
    dato_memo_mario_manual_rojo_orientacion : in unsigned(15 downto 0);
    
    -- FANTASMA
    fantasma_fil_and_col : in std_logic; --entrada que sale de mi comparador
    
    dato_memo_fantasma_azul : in unsigned(15 downto 0);
    dato_memo_fantasma_rojo : in unsigned(15 downto 0);
    dato_memo_fantasma_verde : in unsigned(15 downto 0);
    
    -- PISTA
    pista_fil_and_col : in std_logic;
    
    dato_memo_pista : in unsigned(31 downto 0);
    dato_memo_pista_verde : in unsigned(31 downto 0);
    dato_memo_pista_azul : in unsigned(31 downto 0);
   
    -- ORIENTACION FIGURA
    figura_arriba : in std_logic;
    figura_abajo : in std_logic;
    figura_dcha : in std_logic;
    figura_izq : in std_logic;
    
    
     orientacion : in std_logic_vector(1 downto 0);
     orientacion_mario_manual : in std_logic_vector(1 downto 0);
     
    rojo          : out std_logic_vector(7 downto 0);
    verde         : out std_logic_vector(7 downto 0);
    azul          : out std_logic_vector(7 downto 0)
  );
end component;

component hdmi_rgb2tmds is
    generic (
        SERIES6 : boolean := false
    );
    port(
        rst : in std_logic;
        pixelclock : in std_logic;
        serialclock : in std_logic;

        video_data : in std_logic_vector(23 downto 0);
        video_active  : in std_logic;
        hsync : in std_logic;
        vsync : in std_logic;

        clk_p : out std_logic;
        clk_n : out std_logic;
        data_p : out std_logic_vector(2 downto 0);
        data_n : out std_logic_vector(2 downto 0)
    );
end component;

component CONTADOR_100MS is
    generic(
        N_BITS : integer := 23;        
        FCONTA : integer := 12500000  
    );
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        salida100MS : out STD_LOGIC
    );
end component;

component MARIO_MANUAL is
    generic(
        FCONTA_FIL : integer := 29;
        FCONTA_COL : integer := 31      
    );
    Port (
        clk        : in STD_LOGIC;
        rst        : in STD_LOGIC;
        entrada_100ms : in STD_LOGIC;
        entrada_500ms: in STD_LOGIC;
        btn_arriba     : in STD_LOGIC;      
        btn_abajo   : in STD_LOGIC;      
        btn_izq   : in STD_LOGIC;      
        btn_dcha  : in STD_LOGIC;  
        figura_arriba : out STD_LOGIC;
        figura_abajo : out STD_LOGIC;
        figura_dcha : out STD_LOGIC;
        figura_izq : out STD_LOGIC;  
        mueve_col  : out STD_LOGIC_VECTOR(5 downto 0);
        mueve_fil  : out STD_LOGIC_VECTOR(5 downto 0);
        orientacion_mario_manual : out std_logic_vector(1 downto 0)  
    );
end COMPONENT;

component MARIO_AUTOMATICO_MAQUINA_DE_ESTADOS is
    port(
        clk : in std_logic;
        rst : in std_logic;
        fcuenta_in : in std_logic;
        orientacion : out std_logic_vector(1 downto 0);
        col_out : out std_logic_vector(5 downto 0);
        fil_out : out std_logic_vector(5 downto 0)
        );
end component;

component COMPARADOR_FILAS_Y_COLUMNAS is
    port(
        --FILAS Y COLUMNAS SYNCRO
        fila_syncro : in STD_LOGIC_VECTOR(9 downto 0);
        columna_syncro : in STD_LOGIC_VECTOR(9 downto 0);
       
        -- FILAS Y COLUMNAS MARIO_AUTOMATICO
        pos_fila_mario_automatico : in STD_LOGIC_VECTOR(5 downto 0); -- salida de mi MARIO_AUTOMATICO_MDE
        pos_columna_mario_automatico : in STD_LOGIC_VECTOR(5 downto 0); --salida de mi MARIO_AUTOMATICO_MDE
        mario_automatico_fil_and_col : out STD_LOGIC; -- salida de mi puerta and
       
        --FILAS Y COLUMNAS FANTASMA
        pos_fila_fantasma : in STD_LOGIC_VECTOR(5 downto 0); -- salida de mi FANTASMA_MDE
        pos_columna_fantasma : in STD_LOGIC_VECTOR(5 downto 0); --salida de mi FANTASMA_MDE
        fantasma_fil_and_col : out STD_LOGIC; -- salida de mi puerta and
       
        --FILAS Y COLUMNAS PISTA
        pos_fila_pista : in STD_LOGIC_VECTOR(4 downto 0); --salida de mi contador
        pos_columna_pista : in STD_LOGIC_VECTOR(4 downto 0);-- salida de mi contador
        pista_fil_and_col : out STD_LOGIC; --salida de mi puerta and
        
        -- FILAS Y COLUMNAS MARIO MANUAL                                  
        pos_fila_mario_manual : in STD_LOGIC_VECTOR(5 downto 0); -- salida de mi MARIO_MANUAL
        pos_columna_mario_manual : in STD_LOGIC_VECTOR(5 downto 0); --salida de mi MARIO_MANUAL
        mario_manual_fil_and_col : out STD_LOGIC-- salida de mi puerta and
        
        

        );
end component;

component FANTASMA_MAQUINA_DE_ESTADOS is
    Port (
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           fcuenta_in : in STD_LOGIC; -- entrada de mi salida de 100ms
           col_out : out STD_LOGIC_VECTOR (5 downto 0);
           fil_out: out STD_LOGIC_VECTOR (5 downto 0)
    );
end component;

component FANTASMA_MEMO is
  port (
    clk  : in  std_logic;
    addr : in  std_logic_vector(4-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end component;


component CONTADOR_PISTA is
    generic(
        n_bits : integer := 4; --
        finconta_col : integer := 31;
        finconta_fil : integer := 29);
    port(
        clk : in std_logic;
        rst : in std_logic;
        contador_filas_pistas : out std_logic_vector(4 downto 0);
        contador_columnas_pistas : out std_logic_vector(4 downto 0)
        );
end component;

component CONTADOR_500MS is
    generic(
            FCONTA : integer := 62500000;
            N_BITS : integer := 25 --26 pero como es 25 downto 0 = 26 bits
            );
     port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            salida_500ms : out STD_LOGIC
            );
end component;


component PISTA_VERDE_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(5-1 downto 0);
    dout : out std_logic_vector(32-1 downto 0)
  );
end component;


component PISTA_AZUL_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(5-1 downto 0);
    dout : out std_logic_vector(32-1 downto 0)
  );
end component;

component MARIO_AUTOMATICO_VERDE_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    addr_orientacion : in  std_logic_vector(4-1 downto 0);
    dout_orientacion : out std_logic_vector(16-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end component;

component MARIO_AUTOMATICO_AZUL_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    addr_orientacion : in  std_logic_vector(4-1 downto 0);
    dout_orientacion : out std_logic_vector(16-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end component;

component MARIO_AUTOMATICO_ROJO_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    addr_orientacion : in  std_logic_vector(4-1 downto 0);
    dout_orientacion : out std_logic_vector(16-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end component;

component FANTASMA_AZUL_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end component;

component FANTASMA_ROJO_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end component;

component FANTASMA_VERDE_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end component;

component MARIO_MANUAL_VERDE_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    addr_orientacion : in  std_logic_vector(4-1 downto 0);
    dout_orientacion : out std_logic_vector(16-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end component;

component MARIO_MANUAL_AZUL_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    addr_orientacion : in  std_logic_vector(4-1 downto 0);
    dout_orientacion : out std_logic_vector(16-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end component;


component MARIO_MANUAL_ROJO_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    addr_orientacion : in  std_logic_vector(4-1 downto 0);
    dout_orientacion : out std_logic_vector(16-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end component;


begin
instancia_PLL : PLL
    generic map(
        CLKIN_PERIOD => 8.000,
        CLK_MULTIPLY => 8,  
        CLK_DIVIDE => 1,
        CLKOUT0_DIV => 8,  
        CLKOUT1_DIV => 40
    )
    port map (
        clk_i => clk,
        rst => rst,
        clk0_o => clk0,
        clk1_o => clk1  
    );

instancia_syncro_vga : SYNC_VGA
    port map (
        clk1 => clk1,
        rst => rst,
        hsync => hsync,
        vsync => vsync,
        visible => visible,
        columnas => columnas_s,
        filas => filas_s
    );

instancia_pinta_barras : pinta_barras
    port map (
        col => unsigned(columnas_s),
        fila => unsigned(filas_s),
        visible => visible,
        
        --MARIO AUTOMATICO
        mario_automatico_fil_and_col => mario_automatico_fil_and_col_s,
        
        dato_memo_mario_automatico_verde => unsigned(dato_memo_mario_automatico_verde_s),
        dato_memo_mario_automatico_azul => unsigned(dato_memo_mario_automatico_azul_s),
        dato_memo_mario_automatico_rojo => unsigned(dato_memo_mario_automatico_rojo_s),
       
        dato_memo_mario_automatico_verde_orientacion => unsigned(dato_memo_mario_automatico_verde_orientacion_s),
        dato_memo_mario_automatico_azul_orientacion => unsigned(dato_memo_mario_automatico_azul_orientacion_s),
        dato_memo_mario_automatico_rojo_orientacion => unsigned(dato_memo_mario_automatico_rojo_orientacion_s),
        
        --MARIO MANUAL
        mario_manual_fil_and_col => mario_manual_fil_and_col_s,
        
        dato_memo_mario_manual_verde => unsigned(dato_memo_mario_manual_verde_s),
        dato_memo_mario_manual_azul => unsigned(dato_memo_mario_manual_azul_s),
        dato_memo_mario_manual_rojo => unsigned(dato_memo_mario_manual_rojo_s),
                  
        dato_memo_mario_manual_verde_orientacion => unsigned(dato_memo_mario_manual_verde_orientacion_s),
        dato_memo_mario_manual_azul_orientacion => unsigned(dato_memo_mario_manual_azul_orientacion_s),
        dato_memo_mario_manual_rojo_orientacion => unsigned(dato_memo_mario_manual_rojo_orientacion_s),
        
        --FANTASMA
        fantasma_fil_and_col => fantasma_fil_and_col_s,
        
        dato_memo_fantasma_azul => unsigned(dato_memo_fantasma_azul_s),
        dato_memo_fantasma_rojo => unsigned(dato_memo_fantasma_rojo_s),
        dato_memo_fantasma_verde => unsigned(dato_memo_fantasma_verde_s),
        
        --PISTA
        pista_fil_and_col => pista_fil_and_col_s,
        
        dato_memo_pista => unsigned(dato_memo_pista_s),
        dato_memo_pista_verde => unsigned(dato_memo_pista_verde_s),
        dato_memo_pista_azul => unsigned(dato_memo_pista_azul_s),
        
        figura_arriba => figura_arriba_s,
        figura_abajo => figura_abajo_s,
        figura_dcha => figura_dcha_s,
        figura_izq => figura_izq_s,
        
        orientacion => orientacion_s,
        orientacion_mario_manual => orientacion_mario_manual_s,
        
        rojo  => rojo,
        verde => verde,
        azul => azul
    );
   
instancia_100ms :  CONTADOR_100MS
    generic map(
        N_BITS => 23,        
        FCONTA => 12500000  
    )
    port map(
        clk => clk ,
        rst => rst,
        salida100MS => S100MS_s
    );

instancia_mario_manual : MARIO_MANUAL
        generic map(
            FCONTA_FIL  => 29  ,
            FCONTA_COL  => 31  )
           
        port map (
            clk => clk,
            rst => rst,
            entrada_100ms => S100MS_s,
            entrada_500ms => S500MS_s,
            btn_arriba => btn_arriba,
            btn_abajo => btn_abajo,
            btn_izq => btn_izq,
            btn_dcha  => btn_dcha,
            figura_arriba => figura_arriba_s,
            figura_abajo => figura_abajo_s,
            figura_dcha => figura_dcha_s,
            figura_izq => figura_izq_s,
            mueve_fil  => pos_fila_mario_manual_s,
            mueve_col  => pos_columna_mario_manual_s,
            orientacion_mario_manual => orientacion_mario_manual_s
        );

isntancia_mario_automatico_mde : MARIO_AUTOMATICO_MAQUINA_DE_ESTADOS
    port map(
        clk => clk,
        rst => rst,
        fcuenta_in => S100MS_S,
        orientacion => orientacion_s,
        col_out => pos_columna_mario_automatico_s,
        fil_out => pos_fila_mario_automatico_s
        );


instancia_rgb2tdms : hdmi_rgb2tmds
    port map (
        pixelclock => clk1,  
        serialclock => clk0,
        rst => rst,
        hsync => hsync,
        vsync => vsync,
        video_data => VDataRGB,
        video_active => visible,
        clk_p => clkP,
        clk_n => clkN,
        data_p => dataP,
        data_n => dataN
    );

       
instancia_fantasma_mde :  FANTASMA_MAQUINA_DE_ESTADOS
    Port map(
           clk => clk,
           rst => rst,
           fcuenta_in => S100MS_s,
           col_out => pos_columna_fantasma_s,
           fil_out => pos_fila_fantasma_s
    );

instancia_fantasma_memo : FANTASMA_MEMO
  port map(
    clk  => clk,
    addr => filas_s(3 downto 0),
    dout => dato_memo_fantasma_s
  );

   
instancia_comparador : COMPARADOR_FILAS_Y_COLUMNAS
    port map(
        fila_syncro => filas_s,
        columna_syncro => columnas_s,
        
        pos_fila_mario_automatico => pos_fila_mario_automatico_s,
        pos_columna_mario_automatico => pos_columna_mario_automatico_s,
        mario_automatico_fil_and_col => mario_automatico_fil_and_col_s,
        
        pos_fila_fantasma => pos_fila_fantasma_s,
        pos_columna_fantasma => pos_columna_fantasma_s,
        fantasma_fil_and_col => fantasma_fil_and_col_s,
        
        pos_fila_pista => pos_fila_pista_s,
        pos_columna_pista => pos_columna_pista_s,
        pista_fil_and_col => pista_fil_and_col_s,
        
        pos_fila_mario_manual => pos_fila_mario_manual_s,
        pos_columna_mario_manual => pos_columna_mario_manual_s,
        mario_manual_fil_and_col => mario_manual_fil_and_col_s
       
        );


--instancia_conta_pista : contador_pista
--   generic map(
--       n_bits => 4,
--       finconta_col => 31,
--       finconta_fil => 29
--       )
--   port map(
--       clk => clk,
--       rst => rst,
--       contador_filas_pistas => pos_fila_pista_s,
--       contador_columnas_pistas => pos_columna_pista_s
--       );

instancia_conta500ms : CONTADOR_500MS
    generic map(
            FCONTA => 62500000,
            N_BITS => 25 --26 pero como es 25 downto 0 = 26 bits
            )
     port map(
            clk => clk,
            rst => rst,
            salida_500ms => S500MS_s
            );
           
instancia_pista_verde :  PISTA_VERDE_MEMO
 port map(
   clk  => clk,
   addr => filas_s(8 downto 4),
   dout => dato_memo_pista_verde_s
 );
 
instancia_pista_azul :  PISTA_AZUL_MEMO
  port map(
    clk  => clk,
    addr => filas_s(8 downto 4),
    dout => dato_memo_pista_azul_s
  );          

instancia_mario_automatico_verde : MARIO_AUTOMATICO_VERDE_MEMO
  port map(
    clk  => clk,
    addr => filas_s(3 downto 0),
    addr_orientacion => columnas_s(3 downto 0),
    dout_orientacion => dato_memo_mario_automatico_verde_orientacion_s,
    dout => dato_memo_mario_automatico_verde_s
  );
           
instancia_mario_automatico_azul :  MARIO_AUTOMATICO_AZUL_MEMO
  port map(
    clk  => clk,
    addr => filas_s(3 downto 0),
    addr_orientacion => columnas_s(3 downto 0),
    dout_orientacion => dato_memo_mario_automatico_azul_orientacion_s,
    dout => dato_memo_mario_automatico_azul_s
  );
 
instancia_mario_automatico_rojo : MARIO_AUTOMATICO_ROJO_MEMO
  port map(
    clk  => clk,
    addr => filas_s(3 downto 0),
    addr_orientacion => columnas_s(3 downto 0),
    dout_orientacion => dato_memo_mario_automatico_rojo_orientacion_s,
    dout => dato_memo_mario_automatico_rojo_s
  );

instancia_fantasma_azul : FANTASMA_AZUL_MEMO
  port map(
    clk  => clk,
    addr => filas_s(3 downto 0),
    dout  => dato_memo_fantasma_azul_s
  );
 
instancia_fantasma_rojo : FANTASMA_ROJO_MEMO
  port map(
    clk  => clk,
    addr => filas_s(3 downto 0),
    dout  => dato_memo_fantasma_rojo_s
  );
 
  instancia_fantasma_verde : FANTASMA_VERDE_MEMO
  port map(
    clk  => clk,
    addr => filas_s(3 downto 0),
    dout  => dato_memo_fantasma_verde_s
  );
  
instancia_mario_manual_verde : MARIO_MANUAL_VERDE_MEMO
  port map(
    clk  => clk,
    addr => filas_s(3 downto 0),
    addr_orientacion => columnas_s(3 downto 0),
    dout_orientacion => dato_memo_mario_manual_verde_orientacion_s,
    dout => dato_memo_mario_manual_verde_s
  );
           
instancia_mario_manual_azul :  MARIO_MANUAL_AZUL_MEMO
  port map(
    clk  => clk,
    addr => filas_s(3 downto 0),
    addr_orientacion => columnas_s(3 downto 0),
    dout_orientacion => dato_memo_mario_manual_azul_orientacion_s,
    dout => dato_memo_mario_manual_azul_s
  );
 
instancia_mario_manual_rojo :  MARIO_MANUAL_ROJO_MEMO
  port map(
    clk  => clk,
    addr => filas_s(3 downto 0),
    addr_orientacion => columnas_s(3 downto 0),
    dout_orientacion => dato_memo_mario_manual_rojo_orientacion_s,
    dout => dato_memo_mario_manual_rojo_s
  );

VDataRGB <= rojo & verde & azul;
Vactive <= visible;
end Behavioral;