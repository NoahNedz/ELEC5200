library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity aluBench is
--  Port ( );
end aluBench;

architecture Behavioral of aluBench is

signal AIn: std_logic_vector(15 downto 0);
signal BIn: std_logic_vector(15 downto 0);
signal branch: std_logic;
signal DATAOUTPUT: std_logic_vector(15 downto 0);
signal CONTROL: std_logic_vector(3 downto 0);


component ALU is
     port(
        bit16InA : in STD_LOGIC_VECTOR(15 downto 0);
        bit16InB : in STD_LOGIC_VECTOR(15 downto 0);
        bit16Out : out STD_LOGIC_VECTOR(15 downto 0); -- this goes to either datamem or regtable
        branchBit : out STD_LOGIC;
        signCtrl : in STD_LOGIC_VECTOR(3 downto 0));
end component;


begin
M1: ALU port map(bit16InA => AIn, bit16InB => Bin, bit16Out => DATAOUTPUT, branchBit => branch, signCtrl => CONTROL); 

process begin

----test add
wait for 1ps;
AIn <= "0000000000000001";
BIn <= "0000000000000001";
branch <= '0';
CONTROL <= "0010";
wait for 1 ps;
assert DATAOUTPUT = "0000000000000010"
report "ALU ADD IS BAD"
severity ERROR;

----test sub
wait for 1 ps;
AIn <= "0000000000000001";
BIn <= "0000000000000001";
branch <= '0';
CONTROL <= "0011";
wait for 1 ps;
assert DATAOUTPUT = "0000000000000000"
report "ALU SUB IS BAD"
severity ERROR;

--alu mov store
wait for 1 ps;
AIn <= "0000000000000001";
BIn <= "0000000000000010";
branch <= '0';
CONTROL <= "0110";
wait for 1 ps;
assert DATAOUTPUT =  "0000000000000001";
report "ALU MOVE IS BAD"
severity ERROR;

----alu equal than
wait for 1 ps;
AIn <= "0000000000000001";
BIn <= "0000000000000010";

CONTROL <= "1010";
wait for 1 ps;
assert branch =  '0'
report "ALU BRANCH EQUAL IS BAD"
severity ERROR;
wait for 1 ps;

CONTROL <= "0010";
wait for 1 ps;
CONTROL <= "1010";
AIn <= "0000000000000010";
BIn <= "0000000000000010";
wait for 1 ps;

assert branch =  '1'
report "ALU BRANCH EQUAL IS BAD"
severity ERROR;

--OR
CONTROL <= "0000";
wait for 1 ps;
CONTROL <= "1100";
AIn <= "0000000000000001";
BIn <= "0000000000000010";

wait for 1 ps;
assert DATAOUTPUT = "0000000000000011";
report "ALU OR IS BAD"
severity ERROR;

--AND
wait for 1 ps;
CONTROL <= "0000";
wait for 1 ps;
CONTROL <= "1101";
AIn <= "0000000000000010";
BIn <= "0000000000000011";
wait for 1 ps;

assert DATAOUTPUT = "0000000000000010";
report "ALU AND IS BAD"
severity ERROR;

--branch less that
wait for 1 ps;
CONTROL <= "0000";
wait for 1 ps;
CONTROL <= "1110";
AIn <= "0000000000000001";
BIn <= "0000000000000011";
wait for 1 ps;

assert BRANCH = '1'
report "ALU BRANCH LESS IS BAD"
severity ERROR;

--branch greater
wait for 1 ps;
CONTROL <= "0000";
wait for 1 ps;
CONTROL <= "1111";
AIn <= "0000000000000010";
BIn <= "0000000000000001";
wait for 1 ps;

assert BRANCH = '1'
report "ALU BRANCH GREATER IS BAD"
severity ERROR;

end process;
end Behavioral;