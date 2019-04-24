library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;


entity regBench is
--  Port ( );
end regBench;

architecture Behavioral of regBench is

component REGTABLE is
     port(
    addressA: in STD_LOGIC_VECTOR(3 downto 0);--from contrl
    addressB: in STD_LOGIC_VECTOR(3 downto 0);--from contrl
    addressD: in STD_LOGIC_VECTOR(3 downto 0);--from contrl
    PC: in STD_LOGIC_VECTOR(15 downto 0); --from PC
    regMuxIn: in STD_LOGIC_VECTOR(15 downto 0);--from REGister MUX
    addOUT : out STD_LOGIC_VECTOR(15 downto 0);--to ADD
    signExtend2: in STD_LOGIC_VECTOR(15 downto 0); -- for loadC
    signCTRL: in STD_LOGIC_VECTOR(2 downto 0);  --from control
    bit16OutB: out STD_LOGIC_VECTOR(15 downto 0);
    bit16OutA: out STD_LOGIC_VECTOR(15 downto 0));
end component;

signal adA : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal adB : STD_LOGIC_VECTOR(3 downto 0):= "0000";
signal adD : STD_LOGIC_VECTOR(3 downto 0):= "0000";
signal PCsig: STD_LOGIC_VECTOR(15 downto 0) := "1111111111111111";
signal regMuxSig : STD_LOGIC_VECTOR(15 downto 0) := "1111111111111111";
signal signExSig: STD_LOGIC_VECTOR(15 downto 0):= "0000000000001111";
signal Ctrl : STD_LOGIC_VECTOR(2 downto 0):= "111";
signal outA : STD_LOGIC_VECTOR(15 downto 0) := "1111111111111111";
signal outB : STD_LOGIC_VECTOR(15 downto 0) := "1111111111111111";
signal addOutSig: STD_LOGIC_VECTOR(15 downto 0) := "1111111111111111";

begin

M1: REGTABLE port map(addressA => adA, addressB => adB, addressD => adD,PC => PCsig, regMuxIn => regMuxSig, signExtend2 => signExSig, signCtrl => Ctrl, addOut => addOutSig,bit16OutA => outA, bit16OutB => outB);
 
 process begin

Ctrl <= "111"; -- read
adA <= "0000";
adB <= "0000";
adD <= "0000";
signExSig <= "0000000000001111";
regMuxSig <="0000000000000000";
PCsig <= "1111111111111111";

wait for 5 ps;
 Ctrl <= "001"; -- load imm

 wait for 5 ps;
 Ctrl <="111"; --read 
 wait for 1 ps;
 
 assert outA = "0000000000001111"
 report "REG FILE NOT SET"
 severity ERROR;
  
 wait for 5 ps;
 Ctrl <= "010"; --write pc
 wait for 1 ps;
 
assert addOutSig = "1111111111111111"
report "REG FILE NOT SET"
severity ERROR;
 
 
 
 end process;

end Behavioral;
