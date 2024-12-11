------- ROM creada automaticamente por ppm2rom -----------
------- Felipe Machado -----------------------------------
------- Departamento de Tecnologia Electronica -----------
------- Universidad Rey Juan Carlos ----------------------
------- http://gtebim.es ---------------------------------
----------------------------------------------------------
--------Datos de la imagen -------------------------------
--- Fichero original    : imagenes16_16x16.ppm
--- Filas    : 256
--- Columnas : 16
--- Color    :  Blanco y negro. 2 niveles (1 bit)



------ Puertos -------------------------------------------
-- Entradas ----------------------------------------------
--    clk  :  senal de reloj
--    addr :  direccion de la memoria
-- Salidas  ----------------------------------------------
--    dout :  dato de 16 bits de la direccion addr (un ciclo despues)


library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity MARIO_MANUAL_ROJO_MEMO is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(4-1 downto 0);
    addr_orientacion : in  std_logic_vector(4-1 downto 0);
    dout_orientacion : out std_logic_vector(16-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0)
  );
end MARIO_MANUAL_ROJO_MEMO;


architecture BEHAVIORAL of MARIO_MANUAL_ROJO_MEMO is
  signal addr_int  : natural range 0 to 2**8-1;
  signal addr_int_orientacion  : natural range 0 to 2**8-1;

  type memostruct is array (natural range<>) of std_logic_vector(16-1 downto 0);
  constant filaimg : memostruct := (
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1000010110100001",
       "1000110110110001",
       "1100001111000011",
       "1100000110000011",
       "1100010000100011",
       "1110011111100111",
       "0110001001000110",
       "0011001001001100",
       "0011001111001100",
       "0011110110111100",
       "0011111111111100"
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