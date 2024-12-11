library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library xil_defaultlib;
use xil_defaultlib.racetrack_pkg.all;

entity MARIO_AUTOMATICO_MAQUINA_DE_ESTADOS is
    Port (
        clk       : in STD_LOGIC;
        rst       : in STD_LOGIC;
        fcuenta_in : in STD_LOGIC;
        orientacion : out std_logic_vector(1 downto 0);

        col_out   : out STD_LOGIC_VECTOR(5 downto 0);
        fil_out   : out STD_LOGIC_VECTOR(5 downto 0)
        
    );
end MARIO_AUTOMATICO_MAQUINA_DE_ESTADOS;

architecture Behavioral of MARIO_AUTOMATICO_MAQUINA_DE_ESTADOS is
    type estados_FMS is (derecha, arriba, izquierda, abajo);
    signal estado_actual, estado_siguiente : estados_FMS;

    signal columna : unsigned(5 downto 0) := "001111"; -- mario_automatico esta en la columna 15
    signal fila : unsigned(5 downto 0) := "011011"; --mario_automatico esta en la fila 27
    
    signal marcador_izq : std_logic := '0';
    signal marcador_abajo : std_logic := '0';
    signal marcador_dcha : std_logic := '0';
    signal marcador_arriba : std_logic;

    signal celda_arriba, celda_abajo, celda_izquierda, celda_derecha : STD_LOGIC;
begin

proceso_reloj : process(clk, rst)
begin
    if rst = '1' then
        estado_actual <= derecha; 
    elsif rising_edge(clk) then
        estado_actual <= estado_siguiente;
    end if;
end process;

proceso_estados : process(estado_actual, celda_arriba, celda_abajo, celda_izquierda, celda_derecha)
begin
    estado_siguiente <= estado_actual; 
    case estado_actual is
        when derecha =>
            if celda_derecha = '0' then 
                if celda_abajo = '0' then
                    estado_siguiente <= arriba; 
                else
                    estado_siguiente <= abajo;
                end if;
           end if;
    
        when arriba =>
            if celda_arriba = '0' then
                if celda_izquierda = '0' then
                    estado_siguiente <= derecha; 
                else
                    estado_siguiente <= izquierda;
                end if;
            end if;

        when izquierda =>
            if celda_arriba = '0' then 
                if celda_izquierda = '0'  then
                    estado_siguiente <= abajo; 
                end if;
            end if;

        when abajo =>
            if celda_abajo = '0' then
                if celda_izquierda = '1' then
                    estado_siguiente <= izquierda;
                else
                    estado_siguiente <= derecha;
                end if;
            end if;

        when others =>
            estado_siguiente <= derecha;
    end case;
end process;

proceso_posiciones : process(clk, rst)
begin
    if rst = '1' then
        columna <= "001111"; -- al hacer el rst empiezo en mi columna 15
        fila <= "011011"; -- al hacer el rst empiezo en mi fila 27
    elsif rising_edge(clk) then
        if fcuenta_in  = '1' then
        case estado_actual is
            when derecha =>
                columna <= columna + 1;
                orientacion <= "10";

            when arriba =>
                fila <= fila - 1;
                orientacion <= "00";

            when izquierda =>
                columna <= columna - 1;
                orientacion <= "11";

            when abajo =>
                fila <= fila + 1;
                orientacion <= "01";
        end case;
        end if;
    end if;

    celda_derecha <= pista(to_integer(fila))(to_integer(columna + 1));
    celda_izquierda <= pista(to_integer(fila))(to_integer(columna - 1));
    celda_arriba <= pista(to_integer(fila - 1))(to_integer(columna));
    celda_abajo <= pista(to_integer(fila + 1))(to_integer(columna));
end process;

col_out <= std_logic_vector(columna);
fil_out <= std_logic_vector(fila);

end Behavioral;
