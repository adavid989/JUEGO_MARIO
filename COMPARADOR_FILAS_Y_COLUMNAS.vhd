library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity COMPARADOR_FILAS_Y_COLUMNAS is
    port(
        --FILAS Y COLUMNAS SYNCRO
        fila_syncro : in STD_LOGIC_VECTOR(9 downto 0);
        columna_syncro : in STD_LOGIC_VECTOR(9 downto 0);
        
        -- FILAS Y COLUMNAS MARIO AUTOMATICO
        pos_fila_mario_automatico : in STD_LOGIC_VECTOR(5 downto 0); -- salida de mi FMS
        pos_columna_mario_automatico: in STD_LOGIC_VECTOR(5 downto 0); --salida de mi FMS
        mario_automatico_fil_and_col : out STD_LOGIC; -- salida de mi puerta and
        
        --FILAS Y COLUMNAS FANTASMA
        pos_fila_fantasma : in STD_LOGIC_VECTOR(5 downto 0); -- salida de mi FMS
        pos_columna_fantasma : in STD_LOGIC_VECTOR(5 downto 0); --salida de mi FMS
        fantasma_fil_and_col : out STD_LOGIC; -- salida de mi puerta and

        --FILAS Y COLUMNAS PISTA
        pos_fila_pista : in STD_LOGIC_VECTOR(4 downto 0); --salida de mi contador
        pos_columna_pista : in STD_LOGIC_VECTOR(4 downto 0);-- salida de mi contador
        pista_fil_and_col : out STD_LOGIC; --salida de mi puerta and
        
        -- FILAS Y COLUMNAS MARIO MANUAL
        pos_fila_mario_manual : in STD_LOGIC_VECTOR(5 downto 0); -- salida de mi FMS
        pos_columna_mario_manual : in STD_LOGIC_VECTOR(5 downto 0); --salida de mi FMS
        mario_manual_fil_and_col : out STD_LOGIC-- salida de mi puerta and

        );
end COMPARADOR_FILAS_Y_COLUMNAS;

architecture Behavioral of COMPARADOR_FILAS_Y_COLUMNAS is
    signal fila_cuad : std_logic_vector(5 downto 0); -- 9 hasta 4 bit
    signal columna_cuad : std_logic_vector(5 downto 0); --9 hasta 4 bit
    signal fila_in : std_logic_vector(3 downto 0);-- 3 hasta 0
    signal columna_in : std_logic_vector(3 downto 0); -- 3 hasta 0
    
   --SEÑAL PISTA
   signal fila_cuad_p : std_logic_vector(4 downto 0);
   signal columna_cuad_p : std_logic_vector(4 downto 0);
    

begin
                       
-- EN ESTOS PROCESOS DEL MARIO, EL FANTASMA Y LA PISTA SE COMPARAN LAS POSICIONES DE LA CUADRICULA TANTO DE LA FILA COMO DE LA COLUMNA,
-- CN LAS POSICIONES DE LAS FIGURAS, SI COICNIDEN LAS POSICIONES LA SALIDA DEL COMPARADOR SE PONE A 1, Y SINO A 0
                       
proceso_comparacion_mario_automatico : process(fila_cuad, columna_cuad, pos_fila_mario_automatico, pos_columna_mario_automatico)
begin
    if fila_cuad = pos_fila_mario_automatico and columna_cuad = pos_columna_mario_automatico then
        mario_automatico_fil_and_col <= '1';
    else
        mario_automatico_fil_and_col <= '0';
    end if;
end process;

proceso_comparacion_fantasma : process(fila_cuad, columna_cuad, pos_fila_fantasma, pos_columna_fantasma)
begin
    if fila_cuad = pos_fila_fantasma and columna_cuad = pos_columna_fantasma then
        fantasma_fil_and_col <= '1';
    else
        fantasma_fil_and_col <= '0';
    end if;
end process;

proceso_comparacion_pista : process(fila_cuad, columna_cuad, pos_fila_pista, pos_columna_pista)
begin
    if fila_cuad_p = pos_fila_pista and columna_cuad_p = pos_columna_pista then
        pista_fil_and_col <= '1';
    else
        pista_fil_and_col <= '0';
    end if;
end process;

proceso_comparacion_mario_manual : process(fila_cuad, columna_cuad, pos_fila_mario_manual, pos_columna_mario_manual)
begin
    if fila_cuad = pos_fila_mario_manual and columna_cuad = pos_columna_mario_manual then
        mario_manual_fil_and_col <= '1';
    else
        mario_manual_fil_and_col <= '0';
    end if;
end process;

fila_cuad <= fila_syncro(9 downto 4);
fila_in <= fila_syncro(3 downto 0);
columna_cuad <= columna_syncro(9 downto 4);
columna_in <= columna_syncro(3 downto 0);

----PISTA
fila_cuad_p <= fila_syncro(8 downto 4);
columna_cuad_p <= columna_syncro(8 downto 4);

end Behavioral;
