library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity CONTADOR_500MS is
    generic(
            FCONTA : integer := 62500000;
            N_BITS : integer := 25 --26 pero como es 25 downto 0 = 26 bits
            );
     port(
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            salida_500ms : out STD_LOGIC
            );
end CONTADOR_500MS;

architecture Behavioral of CONTADOR_500MS is
    signal conta500ms : unsigned(N_BITS downto 0);
    signal S500MS : std_logic;

begin

-- CUANDO LA ENTRADA DE RST = '1' SE REINICIAL EL CONTADOR A 0 Y DESCATIVA LA SEÑAL DE 500MS,
-- EN EL FLANCO DE SUBIDA DEL RELOJ CUANDO EL CONTADOR LLEGA SU VALOR LIMITE ACTIVA UNA SEÑAL DE 500 MS Y REINICIA EL CONTADOR,
-- EN CASO DE NO HABER ALCANZADO EL VALOR LIMITE SE INCREMENTA EL VALOR DEL CONTADOR MANTENIENDO LA SEÑAL DE 500MS A 0.
--ASIGNAMOS EL VALOR DE 100MS A LA SALIDA DEL CONTADOR

contador_500ms : process(clk, rst)
begin
    if rst = '1' then
        S500MS <= '0';
        conta500ms <= (others => '0');
    elsif rising_edge(clk) then
        if conta500ms = FCONTA - 1 then
            conta500ms <= (others => '0');
            S500MS <= '1';
        else
            conta500ms <= conta500ms + 1;
            S500MS <= '0';
        end if;
     end if;
end process;
salida_500ms <= S500MS;

end Behavioral;
