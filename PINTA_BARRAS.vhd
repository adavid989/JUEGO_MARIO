library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pinta_barras is
  Port (
    -- Entradas
    visible       : in std_logic;
    col           : in unsigned(9 downto 0);
    fila          : in unsigned(9 downto 0);
    -- MARIO_AUTOMATICO
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
    --dato_memo_fantasma : in unsigned(15 downto 0);
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
end pinta_barras;

architecture Behavioral of pinta_barras is
    signal col_cuad : unsigned(5 downto 0);
    signal fila_cuad : unsigned(5 downto 0);
    signal col_in : unsigned(3 downto 0);
    signal fila_in : unsigned(3 downto 0);
    
    signal pasillo: std_logic;
    signal pared: std_logic;
    signal borde : std_logic;
    signal linea_meta : std_logic;
   
   -- PISTA
    signal dato_memo_selector_pista_verde : std_logic;
    signal dato_memo_selector_pista_azul : std_logic;
    
    --MARIO AUTOMATICO
    signal dato_memo_selector_mario_automatico_verde : std_logic;
    signal dato_memo_selector_mario_automatico_azul : std_logic;
    signal dato_memo_selector_mario_automatico_rojo : std_logic;
   
   --FANTASMA
    signal dato_memo_selector_fantasma_verde : std_logic;
    signal dato_memo_selector_fantasma_azul : std_logic;
    signal dato_memo_selector_fantasma_rojo : std_logic;
    
    --MARIO MANUAL
    signal dato_memo_selector_mario_manual_verde : std_logic;
    signal dato_memo_selector_mario_manual_azul : std_logic;
    signal dato_memo_selector_mario_manual_rojo : std_logic;
        
    signal  figura_dcha_s : std_logic;
    signal  figura_arriba_s : std_logic;
    signal  figura_abajo_s : std_logic;
    signal  figura_izq_s : std_logic;
    

begin

  P_pinta: Process (visible, col, fila, mario_automatico_fil_and_col,mario_manual_fil_and_col,dato_memo_selector_mario_automatico_rojo,dato_memo_selector_mario_manual_rojo,dato_memo_selector_mario_automatico_azul,dato_memo_selector_mario_manual_azul,dato_memo_selector_mario_automatico_verde,dato_memo_selector_mario_manual_verde,dato_memo_selector_fantasma_azul,dato_memo_selector_fantasma_rojo,dato_memo_selector_fantasma_verde,fantasma_fil_and_col,pista_fil_and_col, dato_memo_selector_pista_verde,dato_memo_selector_pista_azul)
  begin
 
    if visible = '1' then
        if col_cuad(5)  >= '1' then -- PARA PINTAR MIS COLUMNAS A PARTIR DE LA 31 EN NEGRO
            rojo   <= (others => '0');
            verde  <= (others => '0');
            azul   <= (others => '0');
        else
           if dato_memo_selector_pista_verde = '0' and dato_memo_selector_pista_azul = '0' then --PARA PINTAR BORDE ROJO CON SOLO 2 MEMORIAS DE LA PISTA
                rojo   <= (others => '1');
                verde  <= (others => '0');
                azul   <= (others => '0');
                pasillo <= '0'; -- VARIABLES QUE SE VAN A USAR PARA LAS DEMAS FIGURAS CUANDO PASEN POR DIFERENTES COLORES DE FONDO
                pared <= '0';
                borde <= '1';
                linea_meta <= '0';
                
           elsif dato_memo_selector_pista_verde = '1' and dato_memo_selector_pista_azul = '0' then --PARA PINTAR PARED(CESPED) VERDE EN PISTA
                rojo   <= (others => '0');
                verde  <= (others => '1');
                azul   <= (others => '0');
                pasillo <= '0'; --VARIABLES QUE SE VAN A USAR PARA LAS DEMAS FIGURAS CUANDO PASEN POR DIFERENTES COLORES DE FONDO
                pared <= '1';
                borde <= '0';
                linea_meta <= '0';
           elsif dato_memo_selector_pista_verde = '1' and dato_memo_selector_pista_azul = '1' then --PARA PINTAR PASILLO BLANCO EN PISTA
                rojo   <= (others => '1');
                verde  <= (others => '1');
                azul   <= (others => '1');
                pasillo <= '1'; --VARIABLES QUE SE VAN USAR PARA LAS DEMAS FIGURAS CUANDO PASEN POR DIFERENTES COLORES DE FONDO
                pared <= '0';
                borde <= '0';
                linea_meta <= '0';
           elsif dato_memo_selector_pista_verde = '0' and dato_memo_selector_pista_azul = '1' then --PARA PINTAR LINEA AZUL EN PISTA
                rojo   <= (others => '0');
                verde  <= (others => '0');
                azul   <= (others => '1');
                pasillo <= '0'; --VARIABLES QUE SE VAN A USAR PARA LAS DEMAS FIGURAS CUANDO PASEN POR DIFERENTES COLORES DE FONDO
                pared <= '0';
                borde <= '0';
                linea_meta <= '1';
         end if;
          -- CELDA MARIO AUTOMATICO
          if pared = '1' then -- PARA QUE SE QUEDE CON EL FONDO VERDE CUANDO PASE EL MARIO
              if  mario_automatico_fil_and_col = '1'  then
                if (dato_memo_selector_mario_automatico_rojo = '1' and dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '1') then --COLOR BLANCO
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '0');                  
                elsif (dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '0')  then --COLOR VERDE
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1')  then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '0')  then -- COLOR NEGRO
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '0');          
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1')  then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '1' and dato_memo_selector_mario_automatico_rojo ='0')then --COLOR AZUL
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif (dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1')  then
                   rojo   <= (others => '1');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                end if;
             end if;
          elsif pasillo = '1' then-- PARA QUE SE QUEDE CON EL FONDO BLANCO CUANDO PASE EL MARIO
            if  mario_automatico_fil_and_col = '1'  then
                if (dato_memo_selector_mario_automatico_rojo = '1' and dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '1')  then --COLOR BLANCO
                   rojo   <= (others => '1');
                   verde  <= (others => '1');
                   azul   <= (others => '1');                  
                elsif (dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '0') then --COLOR VERDE
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '0')  then -- COLOR NEGRO
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '0');          
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '1' and dato_memo_selector_mario_automatico_rojo ='0')  then --COLOR AZUL
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif (dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1')  then
                   rojo   <= (others => '1');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                end if;
            end if;    
          elsif borde = '1' then --PARA QUE SE QUEDE CON EL FONDO ROJO CUANDO PASE EL MARIO
            if  mario_automatico_fil_and_col = '1' then
                if (dato_memo_selector_mario_automatico_rojo = '1' and dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '1') then --COLOR BLANCO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');                  
                elsif (dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '0')  then --COLOR VERDE
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '0') then --color NEGRO
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '0');          
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1')then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '1' and dato_memo_selector_mario_automatico_rojo ='0') then
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif (dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1') then
                   rojo   <= (others => '1');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                end if;
            end if;
          elsif linea_meta = '1' then --PARA QUE PINTE EL FONDO DE AZUL CUANDO PASE EL MARIO
            if  mario_automatico_fil_and_col = '1'  then
                if dato_memo_selector_mario_automatico_rojo = '1' and dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '1' then --COLOR BLANCO
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '1');                  
                elsif (dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '0')  then --COLOR VERDE
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '0')  then -- COLOR NEGRO
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '0');         
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_automatico_verde = '0' and dato_memo_selector_mario_automatico_azul = '1' and dato_memo_selector_mario_automatico_rojo ='0')  then --COLOR AZUL
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif (dato_memo_selector_mario_automatico_verde = '1' and dato_memo_selector_mario_automatico_azul = '0' and dato_memo_selector_mario_automatico_rojo = '1')  then
                   rojo   <= (others => '1');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                end if;
            end if;
          end if;
          
          -- CELDA MARIO MANUAL
              if pared = '1' then -- PARA PINTAR EL FONDO DE VERDE CUANDO PASE EL MARIO 
              if  mario_manual_fil_and_col = '1' then
                if (dato_memo_selector_mario_manual_rojo = '1' and dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '1') then --COLOR BLANCO
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '0');                  
                elsif (dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '0') then --COLOR VERDE
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif  (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '0') then -- COLOR NEGRO
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '0');          
                elsif  (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '1' and dato_memo_selector_mario_manual_rojo = '0') then --COLOR AZUL
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then
                   rojo   <= (others => '1');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                end if;
             end if;
          elsif pasillo = '1' then -- PARA PINTAR EL FONDO DE BLANCO CUANDO PASE LE MARIO
            if mario_manual_fil_and_col = '1' then
                if (dato_memo_selector_mario_manual_rojo = '1' and dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '1') then --COLOR BLANCO
                   rojo   <= (others => '1');
                   verde  <= (others => '1');
                   azul   <= (others => '1');                  
                elsif (dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '0') then --COLOR VERDE
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif  (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '0') then -- COLOR NEGRO
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '0');          
                elsif  (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '1' and dato_memo_selector_mario_manual_rojo = '0') then --COLOR AZUL
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then
                   rojo   <= (others => '1');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                end if;
            end if;    
          elsif borde = '1' then --PARA PINTAR EL FONDO DE ROJO CUANDO PASE EL MARIO
            if  mario_manual_fil_and_col = '1' then
                if (dato_memo_selector_mario_manual_rojo = '1' and dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '1') or (dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '1' and dato_memo_selector_mario_manual_rojo = '1')  then --COLOR BLANCO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');                  
                elsif (dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '0') then --COLOR VERDE
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif  (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '0') then -- COLOR NEGRO
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '0');          
                elsif  (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '1' and dato_memo_selector_mario_manual_rojo = '0') then --COLOR AZUL
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then
                   rojo   <= (others => '1');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                end if;
            end if;
          elsif linea_meta = '1' then --PARA PINTAR EL FONDO DE AZUL CUANDO PASE EL MARIO
            if mario_manual_fil_and_col = '1' then
                elsif (dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '0') then --COLOR VERDE
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif  (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '0') then -- COLOR NEGRO
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '0');          
                elsif  (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then --COLOR ROJO
                   rojo   <= (others => '1');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                elsif (dato_memo_selector_mario_manual_verde = '0' and dato_memo_selector_mario_manual_azul = '1' and dato_memo_selector_mario_manual_rojo = '0') then --COLOR AZUL
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                elsif (dato_memo_selector_mario_manual_verde = '1' and dato_memo_selector_mario_manual_azul = '0' and dato_memo_selector_mario_manual_rojo = '1') then
                   rojo   <= (others => '1');
                   verde  <= (others => '1');
                   azul   <= (others => '0');
                end if;
          end if;

          -- CELDA FANTASMA
          if pared = '1' then --PARA PINTAR EL FONDO DE VERDE CUANDO PASE EL FANTASMA
              if  fantasma_fil_and_col = '1' then
                if dato_memo_selector_fantasma_rojo = '1' and dato_memo_selector_fantasma_verde = '1' and dato_memo_selector_fantasma_azul = '1' then --COLOR PARED VERDE
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '0');                  
                elsif dato_memo_selector_fantasma_verde = '0' and dato_memo_selector_fantasma_azul = '0' and dato_memo_selector_fantasma_rojo = '1' then --COLOR CUERPO
                   rojo   <= (others => '0');
                   verde  <= (others => '1');
                   azul   <= (others => '1');
                elsif dato_memo_selector_fantasma_verde = '1' and dato_memo_selector_fantasma_azul = '1' and dato_memo_selector_fantasma_rojo = '1' then --COLOR BLANCO OJOS
                   rojo   <= (others => '1');
                   verde  <= (others => '1');
                   azul   <= (others => '1');
                elsif dato_memo_selector_fantasma_verde = '0' and dato_memo_selector_fantasma_azul = '1' and dato_memo_selector_fantasma_rojo = '0' then --COLOR AZUL OJOS
                   rojo   <= (others => '0');
                   verde  <= (others => '0');
                   azul   <= (others => '1');
                end if;
              end if;
            elsif pasillo = '1' then --PARA PINTAR EL FONDO DE BLANCO CUANDO PASE EL FANTASMA
                if  fantasma_fil_and_col = '1' then
                    if dato_memo_selector_fantasma_rojo = '1' and dato_memo_selector_fantasma_verde = '1' and dato_memo_selector_fantasma_azul = '1' then --COLOR PASILLO BLANCO
                       rojo   <= (others => '1');
                       verde  <= (others => '1');
                       azul   <= (others => '1');                  
                    elsif dato_memo_selector_fantasma_verde = '0' and dato_memo_selector_fantasma_azul = '0' and dato_memo_selector_fantasma_rojo = '1' then --COLOR CUERPO
                       rojo   <= (others => '0');
                       verde  <= (others => '1');
                       azul   <= (others => '1');
                    elsif dato_memo_selector_fantasma_verde = '1' and dato_memo_selector_fantasma_azul = '1' and dato_memo_selector_fantasma_rojo = '1' then --COLOR BLANCO OJOS
                       rojo   <= (others => '1');
                       verde  <= (others => '1');
                       azul   <= (others => '1');
                    elsif dato_memo_selector_fantasma_verde = '0' and dato_memo_selector_fantasma_azul = '1' and dato_memo_selector_fantasma_rojo = '0' then --COLOR AZUL OJOS
                       rojo   <= (others => '0');
                       verde  <= (others => '0');
                       azul   <= (others => '1');
                    end if;
                end if;
            elsif borde = '1' then --PARA PINTAR EL FONDO DE ROJO CUANDO PASE EL MARIO
                if  fantasma_fil_and_col = '1' then
                    if dato_memo_selector_fantasma_rojo = '1' and dato_memo_selector_fantasma_verde = '1' and dato_memo_selector_fantasma_azul = '1' then --COLOR BORDE ROJO
                       rojo   <= (others => '1');
                       verde  <= (others => '0');
                       azul   <= (others => '0');                  
                    elsif dato_memo_selector_fantasma_verde = '0' and dato_memo_selector_fantasma_azul = '0' and dato_memo_selector_fantasma_rojo = '1' then --COLOR CUERPO
                       rojo   <= (others => '0');
                       verde  <= (others => '1');
                       azul   <= (others => '1');
                    elsif dato_memo_selector_fantasma_verde = '1' and dato_memo_selector_fantasma_azul = '1' and dato_memo_selector_fantasma_rojo = '1' then --COLOR BLANCO OJOS
                       rojo   <= (others => '1');
                       verde  <= (others => '1');
                       azul   <= (others => '1');
                    elsif dato_memo_selector_fantasma_verde = '0' and dato_memo_selector_fantasma_azul = '1' and dato_memo_selector_fantasma_rojo = '0' then --COLOR AZUL OJOS
                       rojo   <= (others => '0');
                       verde  <= (others => '0');
                       azul   <= (others => '1');
                    end if;
                end if;
            elsif linea_meta = '1' then --PARA PINTAR EL FONDO DE AZUL CUADNO PASE EL FANTASMA
                if  fantasma_fil_and_col = '1' then
                    if dato_memo_selector_fantasma_rojo = '1' and dato_memo_selector_fantasma_verde = '1' and dato_memo_selector_fantasma_azul = '1' then --COLOR META AZUL
                       rojo   <= (others => '0');
                       verde  <= (others => '0');
                       azul   <= (others => '1');                  
                    elsif dato_memo_selector_fantasma_verde = '0' and dato_memo_selector_fantasma_azul = '0' and dato_memo_selector_fantasma_rojo = '1' then --COLOR CUERPO
                       rojo   <= (others => '0');
                       verde  <= (others => '1');
                       azul   <= (others => '1');
                    elsif dato_memo_selector_fantasma_verde = '1' and dato_memo_selector_fantasma_azul = '1' and dato_memo_selector_fantasma_rojo = '1' then --COLOR BLANCO OJOS
                       rojo   <= (others => '1');
                       verde  <= (others => '1');
                       azul   <= (others => '1');
                    elsif dato_memo_selector_fantasma_verde = '0' and dato_memo_selector_fantasma_azul = '1' and dato_memo_selector_fantasma_rojo = '0' then --COLOR AZUL OJOS
                       rojo   <= (others => '0');
                       verde  <= (others => '0');
                       azul   <= (others => '1');
                    end if;
                end if;
            end if;
         end if;
        end if;
  end process;
  
--MARIO AUTOMATICO
proceso_orientacion_automatico: process( orientacion, col_in, fila_in)
begin
    case orientacion is
    when "00" => 
        dato_memo_selector_mario_automatico_verde <= dato_memo_mario_automatico_verde_orientacion(to_integer((fila_in)));
        dato_memo_selector_mario_automatico_azul <= dato_memo_mario_automatico_azul_orientacion(to_integer((fila_in)));
        dato_memo_selector_mario_automatico_rojo <= dato_memo_mario_automatico_rojo_orientacion(to_integer((fila_in)));                
                      
     when "01" =>
        dato_memo_selector_mario_automatico_verde <= dato_memo_mario_automatico_verde_orientacion(to_integer(not(fila_in))); 
        dato_memo_selector_mario_automatico_azul <= dato_memo_mario_automatico_azul_orientacion(to_integer(not(fila_in))); 
        dato_memo_selector_mario_automatico_rojo <= dato_memo_mario_automatico_rojo_orientacion(to_integer (not(fila_in)));
    when "10" => 
        dato_memo_selector_mario_automatico_verde <= dato_memo_mario_automatico_verde(to_integer(not(col_in))); 
        dato_memo_selector_mario_automatico_azul <= dato_memo_mario_automatico_azul(to_integer(not(col_in)));   
        dato_memo_selector_mario_automatico_rojo <= dato_memo_mario_automatico_rojo(to_integer(not(col_in)));   
    when "11" => 
        dato_memo_selector_mario_automatico_verde <= dato_memo_mario_automatico_verde(to_integer(col_in)); 
        dato_memo_selector_mario_automatico_azul <= dato_memo_mario_automatico_azul(to_integer(col_in)); 
        dato_memo_selector_mario_automatico_rojo <= dato_memo_mario_automatico_rojo(to_integer(col_in)); 
    end case;
end process;
    
-- MARIO MANUAL
proceso_orientacion_manual: process( orientacion_mario_manual, col_in, fila_in)
begin
    case orientacion_mario_manual is
    when "00" =>
        dato_memo_selector_mario_manual_verde <= dato_memo_mario_manual_verde_orientacion(to_integer((fila_in)));
        dato_memo_selector_mario_manual_azul <= dato_memo_mario_manual_azul_orientacion(to_integer((fila_in)));
        dato_memo_selector_mario_manual_rojo <= dato_memo_mario_manual_rojo_orientacion(to_integer((fila_in)));                
                      
     when "01" =>
        dato_memo_selector_mario_manual_verde <= dato_memo_mario_manual_verde_orientacion(to_integer(not(fila_in))); 
        dato_memo_selector_mario_manual_azul <= dato_memo_mario_manual_azul_orientacion(to_integer(not(fila_in))); 
        dato_memo_selector_mario_manual_rojo <= dato_memo_mario_manual_rojo_orientacion(to_integer (not(fila_in)));
    when "10" =>
        dato_memo_selector_mario_manual_verde <= dato_memo_mario_manual_verde(to_integer(not(col_in))); 
        dato_memo_selector_mario_manual_azul <= dato_memo_mario_manual_azul(to_integer(not(col_in)));   
        dato_memo_selector_mario_manual_rojo <= dato_memo_mario_manual_rojo(to_integer(not(col_in)));   
    when "11" => 
        dato_memo_selector_mario_manual_verde <= dato_memo_mario_manual_verde(to_integer(col_in)); 
        dato_memo_selector_mario_manual_azul <= dato_memo_mario_manual_azul(to_integer(col_in)); 
        dato_memo_selector_mario_manual_rojo <= dato_memo_mario_manual_rojo(to_integer(col_in)); 
    end case;
end process;


dato_memo_selector_pista_verde <= dato_memo_pista_verde(to_integer(col(8 downto 4))); -- PISTA
dato_memo_selector_pista_azul <= dato_memo_pista_azul(to_integer(col(8 downto 4))); -- PISTA

dato_memo_selector_fantasma_verde <= dato_memo_fantasma_verde(to_integer(col_in)); --FANTASMA
dato_memo_selector_fantasma_azul <= dato_memo_fantasma_azul(to_integer(col_in)); --FANTASMA
dato_memo_selector_fantasma_rojo <= dato_memo_fantasma_rojo(to_integer(col_in)); --FANTASMA

   
   
  fila_in   <= fila(3 downto 0);
  col_in    <= col(3 downto 0);
  fila_cuad <= fila(9 downto 4);
  col_cuad  <= col(9 downto 4);

end Behavioral;


