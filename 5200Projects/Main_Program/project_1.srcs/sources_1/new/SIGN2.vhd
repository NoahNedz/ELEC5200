library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity SIGN2 is
    port(
        instrIn : in STD_LOGIC_VECTOR(15 downto 0);
        bit16Out: out STD_LOGIC_VECTOR(15 downto 0));
end SIGN2;

architecture Behavioral of SIGN2 is
signal bit16OutSig : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; 
begin
    process(instrIn)
    begin
        bit16OutSig <= instrIn and "0000000011111111";
    
    end process;
bit16Out <= bit16OutSig;
end Behavioral;
