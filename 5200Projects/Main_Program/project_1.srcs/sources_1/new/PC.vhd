library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity PC is
    generic ( N : integer := 16);
    port(
    CLK : in STD_LOGIC;
    PCIN : in STD_LOGIC_VECTOR(15 downto 0);
    PCOUT : out STD_LOGIC_VECTOR(15 downto 0));
end PC;

architecture Behavioral of PC is
signal PCOUTsig : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
begin
    CLOCK : process(CLK)
    begin
    if rising_edge(CLK) then
        PCOUTsig <= PCIN;
    end if;
    end process;
    
    PCOUT <= PCOUTsig;
end Behavioral;
