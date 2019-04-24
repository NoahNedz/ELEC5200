library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity PCREG is
    port(
        clk : in STD_LOGIC;
        addrIn : in STD_LOGIC_VECTOR(15 downto 0);
        addrOut : out STD_LOGIC_VECTOR(15 downto 0));
end PCREG;

architecture Behavioral of PCREG is
signal outputSig : STD_LOGIC_VECTOR(15 downto 0);
signal startAddr : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";


begin
    process(addrIn)
    variable STARTUP: boolean := true;
    begin
    if(STARTUP = true)then
        outputSig <= startAddr;
        STARTUP := false;
    else
        outputSig <= addrIn;  
    end if;
end process;
addrOut <= outputSig;

end Behavioral;
