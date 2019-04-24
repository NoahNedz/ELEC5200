library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity INSTMEM is
    port(
    address: in STD_LOGIC_VECTOR(15 downto 0);
    bit8out: out STD_LOGIC_VECTOR(7 downto 0);
    bit12out: out STD_LOGIC_VECTOR(11 downto 0);
    bit16out: out STD_LOGIC_VECTOR(15 downto 0));
end INSTMEM;

architecture Behavioral of INSTMEM is
signal bit16OutSig : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; 
signal bit12OutSig : STD_LOGIC_VECTOR(15 downto 0) := "000000000000"; 
signal bit8OutSig : STD_LOGIC_VECTOR(15 downto 0) := "00000000"; 

subtype word is std_logic_vector(15 downto 0);
type memory is array((2**16)-1 downto 0) of word;
signal INSTMEM: memory;

begin
ADDR: process(address)
begin
    bit8OutSig <= INSTMEM(conv_integer(address));
    bit12OutSig <= INSTMEM(conv_integer(address));
    bit16OutSig <= INSTMEM(conv_integer(address));
end process;
bit8Out <= bit8OutSig;
bit12Out <= bit12OutSig;
bit16Out <= bit16OutSig;
end Behavioral;
