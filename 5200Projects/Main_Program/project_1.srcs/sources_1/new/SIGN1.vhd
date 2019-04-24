library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity SIGN1 is
    port(
        clk : in STD_LOGIC;
        instrIn: in STD_LOGIC_VECTOR(15 downto 0);
        bit16Out: out STD_LOGIC_VECTOR(15 downto 0);
        signCtrl: in STD_LOGIC);
end SIGN1;

architecture Behavioral of SIGN1 is
signal bit16OutSig : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; 
begin
CTRL: process(signCtrl,clk)
    begin
    if(signCtrl = '0') then
        bit16OutSig <= instrIn AND "0000000000001111";
        
    elsif(signCtrl = '1') then
        bit16OutSig <= instrIn AND "0000111111111111";
    end if;
    end process;
    bit16Out <= bit16OutSig;
end Behavioral;
