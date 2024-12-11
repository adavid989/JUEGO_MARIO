library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.RACETRACK_PKG.ALL;

entity MARIO_MANUAL is
    generic(
        FCONTA_FIL : integer := 29; 
        FCONTA_COL : integer := 31      
    );
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        entrada_100ms : in STD_LOGIC;
        entrada_500ms : in STD_LOGIC;
        btn_arriba : in STD_LOGIC;      
        btn_abajo : in STD_LOGIC;      
        btn_izq : in STD_LOGIC;      
        btn_dcha : in STD_LOGIC;     
        figura_arriba : out STD_LOGIC;
        figura_abajo : out STD_LOGIC;
        figura_dcha : out STD_LOGIC;
        figura_izq : out STD_LOGIC;
        orientacion_mario_manual : out std_logic_vector(1 downto 0);
        mueve_col : out STD_LOGIC_VECTOR(5 downto 0); 
        mueve_fil : out STD_LOGIC_VECTOR(5 downto 0)  
    );
end MARIO_MANUAL;

architecture Behavioral of MARIO_MANUAL is
    signal Sfila : unsigned(5 downto 0) := "011011"; 
    signal Scolumna : unsigned(5 downto 0) := "001111"; 
    signal direccion : std_logic_vector(1 downto 0) := "00"; 
    signal jug_en_pista : std_logic := '0';
    signal figura_arriba_s : std_logic := '0';
    signal figura_abajo_s : std_logic := '0';
    signal figura_dcha_s : std_logic := '0';
    signal figura_izq_s : std_logic := '0';
    
begin

jug_en_pista <= pista(to_integer(Sfila))(to_integer(Scolumna)); --CONSTANTE DE LA PISTA

-- AQUI LO QUE VAMOS A HACER ES EVALUAR SI EL MARIO PASA DENTRO DE LA PARED, PARA ELLO VAMOS A USAR EL PAQUETE QUE CONTIENE LA CONSTANTE
-- PISTA POR LO QUE UNA VEZ QUE DETECTE UN 0, QUE EN LA PISTA ES LA PARED VA A DISMINUIR LA VELOCIDAD, SIN EMBARGO, CUANDO DETECTE UN 1
-- SIGNIFICA QUE VAMOS A ESTAR EN LA PARTE DEL PASILLO Y VA A MOVERSE A MAYOR VELOCIDAD. PARA LA VELOCIDAD SE VA A USAR LAS SALIDAS DE LOS 
-- CONTADORES 100MS Y 500MS Y PARA CONTROLAR UTILIZAREMOS UNOS BOTONES

proceso_mueve_fila_100ms : process(clk, rst)
begin
    if rst = '1' then              
        Sfila <= "011011";
        figura_arriba_s <= '1';
    elsif rising_edge(clk) then
        if jug_en_pista = '1' then
            if entrada_100ms = '1' then
                if btn_arriba = '1' then
                    if Sfila > 0 then
                        Sfila <= Sfila - 1; 
                        figura_arriba_s <= '1';
                        figura_abajo_s <= '0';
                    else
                        figura_arriba_s <= '0';
                        figura_abajo_s <= '0';
                    end if;
                elsif btn_abajo = '1' then
                    if Sfila < FCONTA_FIL then
                        Sfila <= Sfila + 1;
                        figura_abajo_s <= '1';
                        figura_arriba_s <= '0';
                    else
                        figura_abajo_s <= '0';
                        figura_arriba_s <= '0';
                    end if;
                end if;
            end if;
        else
            if entrada_500ms = '1' then
                if btn_arriba = '1' then
                    if Sfila > 0 then
                        Sfila <= Sfila - 1; 
                        figura_arriba_s <= '1';
                        figura_abajo_s <= '0';
                    else
                        figura_arriba_s <= '0';
                        figura_abajo_s <= '0';
                    end if;
                elsif btn_abajo = '1' then
                    if Sfila < FCONTA_FIL then
                        Sfila <= Sfila + 1; 
                        figura_abajo_s <= '1';
                        figura_arriba_s <= '0';
                     else
                        figura_abajo_s <= '0';
                        figura_arriba_s <= '0';
                    end if;
                end if;
            end if;
        end if;
    end if;
end process;

proceso_mueve_columna_100ms : process(clk, rst)
begin
    if rst = '1' then
        Scolumna <= "001111";
    elsif rising_edge(clk) then
        if jug_en_pista = '1' then
            if entrada_100ms = '1' then
                if btn_izq = '1' then
                    if Scolumna > 0 then
                        Scolumna <= Scolumna - 1; 
                        figura_izq_s <= '1';
                        figura_dcha_s <= '0';
                    else
                        figura_izq_s <= '0';
                        figura_dcha_s <= '0';
                    end if;
                elsif btn_dcha = '1' then
                    if Scolumna < FCONTA_COL then
                        Scolumna <= Scolumna + 1; 
                        figura_dcha_s <= '1';
                        figura_izq_s <= '0';
                    else
                        figura_dcha_s <= '0';
                        figura_izq_s <= '0';
                    end if;
                end if;
            end if;
        else
            if entrada_500ms = '1' then
                if btn_izq = '1' then
                    if Scolumna > 0 then
                        Scolumna <= Scolumna - 1; 
                        figura_izq_s <= '1';
                        figura_dcha_s <= '0';
                    else
                        figura_izq_s <= '0';
                        figura_dcha_s <= '0';
                    end if;
                elsif btn_dcha = '1' then
                    if Scolumna < FCONTA_COL then
                        Scolumna <= Scolumna + 1;
                        figura_dcha_s <= '1';
                        figura_izq_s <= '0';
                    else
                        figura_dcha_s <= '0';
                        figura_izq_s <= '0';
                    end if;
                end if;
            end if;
        end if;
    end if;
end process;

-- CON ESTE PROCESO VAMOS A UTILZIAR PARA ORIENTAR EL MARIO DEPENDIENDO DEL BOTON QUE ESTE PULSADO.

proceso_movimiento: process(clk)
begin
    if rising_edge(clk) then
        if btn_arriba = '1' then
            direccion <= "00";
        elsif btn_abajo = '1' then
            direccion <= "01";
        elsif btn_dcha = '1' then
            direccion <= "10";
        elsif btn_izq = '1' then
            direccion <= "11";
        end if;
    end if;
end process;

    orientacion_mario_manual <= direccion;

-- PARA MOVER LA FIGURA
mueve_fil <= std_logic_vector(Sfila);
mueve_col <= std_logic_vector(Scolumna);

-- PARA ORIENTAR LA FIGURA
figura_arriba <= figura_arriba_s;
figura_abajo <= figura_abajo_s;
figura_dcha <= figura_dcha_s;
figura_izq <= figura_izq_s;

end Behavioral;