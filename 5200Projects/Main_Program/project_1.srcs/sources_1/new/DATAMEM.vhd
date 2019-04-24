library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
--this is for instruction mem
entity DATAMEM is
    port(
    address: in STD_LOGIC_VECTOR(15 downto 0);
    aluIn: in STD_LOGIC_VECTOR(15 downto 0);
    pcIn: in STD_LOGIC_VECTOR(15 downto 0);
    signCtrl: in STD_LOGIC_VECTOR(1 downto 0);
    bit16out: out STD_LOGIC_VECTOR(15 downto 0));
end DATAMEM;

architecture Behavioral of DATAMEM is
signal bit16OutSig : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; 
 

subtype word is std_logic_vector(15 downto 0);
type memory is array((2**16)-1 downto 0) of word;
signal INSTMEM: memory;

begin


ADDR: process(signCtrl)
begin
   if(signCtrl = "00") then
    bit16OutSig <= INSTMEM(conv_integer(address));
    elsif(signCtrl = "01")then
    INSTMEM(conv_integer(address)) <= aluIn;
    elsif(signCtrl = "10")then
        bit16OutSig <= INSTMEM(conv_integer(pcIn));
    else
        bit16OutSig <= "0000000000000000";
    end if;
end process;

bit16Out <= bit16OutSig;
end Behavioral;
