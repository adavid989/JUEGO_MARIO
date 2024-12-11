library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONTADOR_100MS is
    generic(
        N_BITS : integer := 23;        
        FCONTA : integer := 12500000  
    );
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        salida100MS : out STD_LOGIC
    );
end CONTADOR_100MS;

architecture Behavioral of CONTADOR_100MS is
    signal conta : unsigned(N_BITS downto 0) := (others => '0'); 
    signal S100MS : std_logic := '0'; 
begin

-- CUANDO LA ENTRADA DE RST = '1' SE REINICIAL EL CONTADOR A 0 Y DESCATIVA LA SEÑAL DE 100MS,
-- EN EL FLANCO DE SUBIDA DEL RELOJ CUANDO EL CONTADOR LLEGA SU VALOR LIMITE ACTIVA UNA SEÑAL DE 100 MS Y REINICIA EL CONTADOR,
-- EN CASO DE NO HABER ALCANZADO EL VALOR LIMITE SE INCREMENTA EL VALOR DEL CONTADOR MANTENIENDO LA SEÑAL DE 100MS A 0.
--ASIGNAMOS EL VALOR DE 100MS A LA SALIDA DEL CONTADOR

process(clk, rst)
begin
    if rst = '1' then
        conta <= (others => '0');
        S100MS <= '0';
    elsif rising_edge(clk) then
        if conta = FCONTA - 1 then
            S100MS <= '1';
            conta <= (others => '0'); 
        else
            S100MS <= '0';
            conta <= conta + 1;
        end if;
    end if;
end process;
salida100MS <= S100MS;
end Behavioral;