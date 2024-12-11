library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity MARIO_MANUAL_AZUL_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    addr_orientacion : in  std_logic_vector(4-1 downto 0);
    dout_orientacion : out std_logic_vector(16-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end MARIO_MANUAL_AZUL_MEMO;


architecture Behavioral of MARIO_MANUAL_AZUL_MEMO is
  signal addr_int  : natural range 0 to 2**8-1;
  signal addr_int_orientacion  : natural range 0 to 2**8-1;
  type memostruct is array (natural range<>) of std_logic_vector(16-1 downto 0);
  constant filaimg : memostruct := (
       "1111111111111111",
       "1111111111111111",
       "1000111111110001",
       "1000100000010001",
       "1000000000000001",
       "1111000000001111",
       "1111000000001111",
       "1111100000001111",
       "1111100000011111",
       "1111100000011111",
       "1111100000011111",
       "0111110110111110",
       "0011110110111100",
       "0000110000110000",
       "0000001001000000",
       "0000000000000000"
        );

begin

  addr_int <= TO_INTEGER(unsigned(addr));
  addr_int_orientacion <= TO_INTEGER(unsigned(addr_orientacion));
  P_ROM: process (clk)
  begin
    if clk'event and clk='1' then
      dout <= filaimg(addr_int);
      dout_orientacion <= filaimg(addr_int_orientacion);
    end if;
  end process;

end BEHAVIORAL;