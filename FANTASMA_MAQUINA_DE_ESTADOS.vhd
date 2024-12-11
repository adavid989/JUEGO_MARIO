library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FANTASMA_MAQUINA_DE_ESTADOS is
    Port ( 
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           fcuenta_in : in STD_LOGIC; -- entrada de mi salida de 100ms
           col_out : out STD_LOGIC_VECTOR (5 downto 0);
           fil_out: out STD_LOGIC_VECTOR (5 downto 0)
    );
end FANTASMA_MAQUINA_DE_ESTADOS;

architecture Behavioral of FANTASMA_MAQUINA_DE_ESTADOS is
    type estados_FMS  is (arriba_dcha, abajo_dcha, arriba_izq, abajo_izq);
    signal estado_actual, estado_siguiente : estados_FMS;
    signal fila : unsigned(5 downto 0) := (others =>'0');
    signal columna : unsigned(5 downto 0) := (others => '0');

    constant fila_fincuenta: natural := 29; 
    constant columna_fincuenta : natural := 31; 

begin
proceso_reloj : process(clk, rst)
begin
    if rst = '1' then   
        estado_actual <= abajo_izq;
    elsif rising_edge(clk) then
         estado_actual <= estado_siguiente;
    end if;
end process;

-- ES UNA MAQUINA DE ESTADOS PARA LE MOVIMIENTO DIAGONAL DEL FANTASMA TENEMOS 4 ESTADOS QUE INDICARAN EL MOVIMIENTO
-- QUE TENDRA EL FANTASMA. EN CADA ESTADO, SE EVALUA LAS CONDICIONES DE FILAS Y COLUMNAS PARA DETERMINAR SU ESTADO SIGUIENTE, SINO
-- SE CUMPLE CON LAS CONDICIONES PERMANECE EN EL MISMO ESTADO

p_comb : process(estado_actual, columna, fila)
begin
    estado_siguiente <= estado_actual;
    case estado_Actual is 
          when arriba_izq =>
            if fila = 0 then 
                if columna = 0 then
                    estado_siguiente <= abajo_dcha;
                else
                    estado_siguiente <= abajo_izq;
               end if;
           else 
                if columna = 0 then
                    estado_siguiente <= arriba_dcha;
                end if;
            end if;
           when arriba_dcha =>
            if fila = 0 then
                if columna = 31 then 
                    estado_siguiente <= abajo_izq;
                else
                    estado_siguiente <= abajo_dcha;
                end if;
            else
                if columna = 31 then
                    estado_siguiente <= arriba_izq;
                end if;
            end if;
            when abajo_dcha =>
                if fila = 29 then
                    if columna = 31 then
                        estado_siguiente <= arriba_izq;
                    else
                        estado_siguiente <= arriba_dcha;
                    end if;
                else
                    if columna = 31 then
                        estado_siguiente <= abajo_izq;
                    end if;
                end if;
             when abajo_izq =>
                if fila = 29 then
                    if columna = 0 then
                        estado_siguiente <= arriba_dcha;
                    else
                        estado_siguiente <= arriba_izq;
                    end if;
                else
                    if columna = 0 then
                        estado_siguiente <= abajo_dcha;
                    end if;
                end if;
                        
     end case;
end process;

-- CUANDO SE ACTIVE LA SEÑAL DE 100MS PARA CADA ESTADO SE ACTUALIZA LA POSTICION DE LAS FILAS Y LAS COLUMNAS PARA QUE EL FATNASMA HAGA EL MOVIMIENTO DIAGONAL

p_com2 : process(rst,clk, estado_actual, fcuenta_in)
begin
    if rst = '1' then
        columna <= (others => '0');
        fila <= "010000";
    elsif rising_edge(clk) then
     if fcuenta_in = '1' then
        case estado_actual is 
            when abajo_dcha =>
                columna <= columna + 1;
                fila <= fila + 1;
            when abajo_izq =>
                columna <= columna - 1;
                fila <= fila + 1;
             when arriba_izq =>
                columna <= columna - 1;
                fila <= fila - 1;
             when arriba_dcha => 
                columna <= columna + 1;
                fila <= fila - 1;
             end case;
         end if;
     end if;
end process;                

col_out <= std_logic_vector(columna);
fil_out <= std_logic_vector(fila);  

end Behavioral;