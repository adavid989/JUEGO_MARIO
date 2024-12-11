library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity PLL is
    generic (
        CLKIN_PERIOD : real := 8.000;
        CLK_MULTIPLY : integer := 8;  
        CLK_DIVIDE : integer := 1;
        CLKOUT0_DIV : integer := 8;  
        CLKOUT1_DIV : integer := 40
    );
    port(
        clk_i : in  std_logic;  
        rst : in std_logic;
        clk0_o : out std_logic;  
        clk1_o : out std_logic
    );
end PLL;

architecture Behavioral of PLL is
    signal clkfbout : std_logic;
    signal pllclk0 : std_logic;
    signal pllclk1 : std_logic;
   
begin

clk0buf: BUFG port map (I=>pllclk0, O=>clk0_o);
clk1buf: BUFG port map (I=>pllclk1, O=>clk1_o);

clock: PLLE2_BASE
    generic map (
        clkin1_period => CLKIN_PERIOD,
        clkfbout_mult => CLK_MULTIPLY,
        clkout0_divide => CLKOUT0_DIV,
        clkout1_divide => CLKOUT1_DIV,
        divclk_divide => CLK_DIVIDE
    )
    port map(
        rst => '0',
        pwrdwn => '0',
        clkin1 => clk_i,
        clkfbin => clkfbout,
        clkfbout => clkfbout,
        clkout0 => pllclk0,
        clkout1 => pllclk1
     );
     
end Behavioral;