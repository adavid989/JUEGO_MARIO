library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity MARIO_AUTOMATICO_AZUL_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    addr_orientacion : in  std_logic_vector(4-1 downto 0);
    dout_orientacion : out std_logic_vector(16-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end MARIO_AUTOMATICO_AZUL_MEMO;


architecture Behavioral of MARIO_AUTOMATICO_AZUL_MEMO is
  signal addr_int  : natural range 0 to 2**8-1;
  signal addr_int_orientacion  : natural range 0 to 2**8-1;
  type memostruct is array (natural range<>) of std_logic_vector(16-1 downto 0);
  constant filaimg : memostruct := (
       "1111100000111111",
       "1111000000000111",
       "1111000000011111",
       "1110000000000111",
       "1110000000000011",
       "1110000000000111",
       "1111100000000111",
       "1111110111111111",
       "1111110110111111",
       "1111110000111111",
       "1100101001010011",
       "1100000000000011",
       "1100000000000011",
       "1111000110001111",
       "1110001111000111",
       "1100001111000011"
       --"1111111111111111",
       --"1111111111111111",
       --"1111111111111111",
       --"1111100000011111",
       --"1111100000011111",
       --"1111111001111111",
       --"1111111001111111",
       --"1111110000111111",
       --"1111110000111111",
       --"1111100000011111",
       --"1111100000011111",
       --"1111000000001111",
       --"1111000000001111",
       --"1111100000011111",
       --"1111111111111111",
       --"1111111111111111"
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