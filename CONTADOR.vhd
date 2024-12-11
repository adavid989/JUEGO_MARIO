library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador is
    generic(
        --fconta : natural := 12500000;
        --n_bits : natural := 23;
        fin_cuenta : natural := 800;
        numero_bits : natural := 9
    );
    port(
        clk : in STD_LOGIC; -- este sera el clk de mi pll
        rst : in STD_LOGIC;  
        enable : in STD_LOGIC;  
        salida : out STD_LOGIC;
        cuenta_OUT : out unsigned(numero_bits  downto 0)
    );
end contador;

architecture Behavioral of contador is
    signal cuenta : unsigned(numero_bits downto 0) := (others => '0');
    signal fcuenta : std_logic ;
    --signal conta : unsigned(n_bits downto 0) := (others => '0');
begin
process(clk, rst)
begin
    if rst = '1' then
        cuenta <= (others => '0');
        -- salida <= '0';
    elsif rising_edge(clk) then
        --if conta = fconta - 1 then
            if enable = '1' then
                if fcuenta = '1' then
                    cuenta <= (others => '0');
                    -- salida <= '1';
                else
                    cuenta <= cuenta + 1;
                    -- salida <= '0';
                end if;
            --end if;
    end if;
    end if;
end process;

fcuenta <= '1' when cuenta = fin_cuenta else '0';
salida <= fcuenta;
cuenta_OUT <= cuenta;

end Behavioral;