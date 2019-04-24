library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
--this is for reg table
entity REGTABLE is
    port(
    addressA: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');--from contrl
    addressB: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');--from contrl
    addressD: in STD_LOGIC_VECTOR(3 downto 0) := (others => '0');--from contrl
    PC: in STD_LOGIC_VECTOR(15 downto 0) := (others => '0'); --from CP
    regMuxIn: in STD_LOGIC_VECTOR(15 downto 0) := (others => '0');--from REGister MUX
    addOUT : out STD_LOGIC_VECTOR(15 downto 0);--to ADD
    signExtend2: in STD_LOGIC_VECTOR(15 downto 0) := (others => '0'); -- for loadC
    signCTRL: in STD_LOGIC_VECTOR(2 downto 0):= (others => '0');  --from control
    bit16OutB: out STD_LOGIC_VECTOR(15 downto 0);
    bit16OutA: out STD_LOGIC_VECTOR(15 downto 0));
    
end REGTABLE;

architecture Behavioral of REGTABLE is
signal bit16OutSigA : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; 
signal bit16OutSigB : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; 

 
subtype word is std_logic_vector(15 downto 0);
type memory is array((2**4)-1 downto 0) of word;
signal RAM: memory;

begin

process(signCTRL)
begin
    if(signCTRL = "000")then
        bit16OutSigA <= RAM(conv_integer(addressA)); --basic read at addresses R TYPE
        bit16OutSigB <= RAM(conv_integer(addressB));
        
    
    elsif(signCTRL = "001")then
        RAM(conv_integer(addressA)) <= signExtend2;  --write immediate to mem LOADC
        
    elsif(signCTRL = "010")then
        bit16OutSigA <= RAM(conv_integer(addressA)); 
        bit16OutSigB <= RAM(conv_integer(addressB));
        RAM(conv_integer("1111")) <= PC;           --write PC value to reg for Jump and LINK

    else
        bit16OutSigA <= RAM(conv_integer(addressA)); --basic read at addresses
        bit16OutSigB <= RAM(conv_integer(addressB)); --basic read at addresses
    end if;
end process;

process(regMuxIn) begin
if(signCTRL = "000") then
    RAM(conv_integer(addressD)) <= regMuxIn;
    end if;
end process;

addOUT <= RAM(conv_integer("1111"));
bit16OutA <= bit16OutSigA;
bit16OutB <= bit16OutSigB;
end Behavioral;
