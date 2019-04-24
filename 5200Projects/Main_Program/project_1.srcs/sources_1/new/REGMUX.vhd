
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity REGMUX is
    port(
        clk : in STD_LOGIC;
        signCtrl : in STD_LOGIC;
        bit16Out : out STD_LOGIC_VECTOR(15 downto 0);
        aluIn : in STD_LOGIC_VECTOR(15 downto 0);
        memIn : in STD_LOGIC_VECTOR(15 downto 0));
end REGMUX;

architecture Behavioral of REGMUX is
signal bit16Outsig : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; 
begin

process(clk, signCtrl,aluIn,memIn)begin
    --if rising_edge(clk) then
        if(signCtrl = '0')then
            bit16Outsig <= aluIn;
        else
            bit16Outsig <= memIn;
        end if;
    --end if;
    
end process;
bit16Out <= bit16Outsig;

end Behavioral;
