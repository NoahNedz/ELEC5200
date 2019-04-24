library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity controlBench is
--  Port ( );
end controlBench;

architecture Behavioral of controlBench is

signal instructionSig : STD_LOGIC_VECTOR(15 downto 0);
signal branchBitSig : STD_LOGIC;
signal regMuxCtrlSig : STD_LOGIC;
signal regTableASig : STD_LOGIC_VECTOR(3 downto 0);
signal regTableBSig : STD_LOGIC_VECTOR(3 downto 0);
signal regTableDSig : STD_LOGIC_VECTOR(3 downto 0);
signal ALUoutSig: STD_LOGIC_VECTOR(3 downto 0);
signal regTableSig : STD_LOGIC_VECTOR(2 downto 0);
signal signCtrlSig: STD_LOGIC;
signal dataMemSig: STD_LOGIC_VECTOR(1 downto 0);
signal AddCtrlSig: STD_LOGIC_VECTOR(1 downto 0);

component CONTROL is
     port(
             instruction : in STD_LOGIC_VECTOR(15 downto 0);
             branchBit : in STD_LOGIC;
             regMuxCtrl : out STD_LOGIC;
             regTableA : out STD_LOGIC_VECTOR(3 downto 0);
             regTableB : out STD_LOGIC_VECTOR(3 downto 0);
             regTableD : out STD_LOGIC_VECTOR(3 downto 0);
             ALUout : out STD_LOGIC_VECTOR(3 downto 0);
             regTable : out STD_LOGIC_VECTOR(2 downto 0);
             signCtrl: out STD_LOGIC;
             
             dataMem : out STD_LOGIC_VECTOR(1 downto 0);
             addCtrl: out STD_LOGIC_VECTOR(1 downto 0));
end component;


begin
M1: CONTROL port map(instruction => instructionSig,  branchBit => branchBitSig,  regMuxCtrl => regMuxCtrlSig, regTableA => regTableAsig, 
regTableB => regTableBsig, regTableD => regTableDsig, ALUout => ALUoutSig, regTable => regTableSig, signCtrl => signCtrlSig, dataMem => dataMemSig,
addCtrl => addCtrlSig);

process begin
----------------------------------------------------------------------HALT
wait for 1ps;
instructionSig <= "0000000000000000";
assert AddCtrlSig =  "11"
report "CNTRL HALT IS BAD"
severity ERROR;

---------------------------------------------------------------------JUMP
wait for 1 ps;
instructionSig <= "0001000000000000";

assert AddCtrlSig =  "01"
report "ADDER CONTROL IS BAD"
severity ERROR;
wait for 1 ps;

assert signCtrlSig =  '1' -- 12bit extension
report "EXTEND CONTROL IS BAD"
severity ERROR;
------------------------------------------------------------------------

--ADD reg0 to reg1 store in reg 2 / SUB WITH ALU CHANGE
wait for 1 ps;
instructionSig <= "0010001000010000";
wait for 1 ps;
assert regTableASig = "0000" -- A = 0
report "INCORRECT FIRST OP"
severity ERROR;
wait for 1 ps;
assert regTableBSig = "0001" --B = 1
report "INCORRECT SECOND OP"
severity ERROR;
wait for 1 ps;
assert regTableDSig = "0010" --D = 0010
report "INCORRECT DEST OP"
severity ERROR;
wait for 1 ps;

assert addCtrlsig = "00" -- PC + 1
report "INCORRECT DEST OP"
severity ERROR;
wait for 1 ps;

 assert  ALUOutsig = "0010"; -- ALU to ADD
 report "INCORRECT ALU ADD OP"
 severity ERROR;
 wait for 1 ps;
 
assert  regMuxCtrlSig = '0'; -- REG MUX to REG
 report "INCORRECT REG MUX LOCAL OP"
 severity ERROR;
 wait for 1 ps;
---------------------------------------------------------------LOAD
wait for 1 ps;
instructionSig <= "0100000000000000"; --load reg 0 with add 00000000
wait for 1 ps;

assert  regTablesig = "000"; -- REG set to write
report "REG TABLE SET WRONG"
severity ERROR;
wait for 1 ps;

assert  regTableDSig = "0000" -- REGister to write
report "REG TABLE SET WRONG"
severity ERROR;
wait for 1 ps;

 assert dataMemsig = "10" -- data mem to read
 report "DATA REG SET WRONG"
 severity ERROR;
 wait for 1 ps;
 
assert regMuxCtrlsig = '1'
report " REG MUX SET WRONG"
severity ERROR;
wait for 1 ps;
------------------------------------------------------------LOAD C
wait for 1 ps;
instructionSig <= "0101000011111111"; --load reg 0 with 11111111
wait for 1 ps;

assert  regTablesig = "000"; -- REG set to read/write
report "REG TABLE SET WRONG"
severity ERROR;
wait for 1 ps;

assert  regTableDSig = "0000" -- REGister to write
report "REG TABLE SET WRONG"
severity ERROR;
wait for 1 ps;

assert dataMemsig = "11" -- data mem to do nothing
report "DATA REG SET WRONG"
severity ERROR;
wait for 1 ps;
------------------------------------------------------------MOV reg 1 to reg 0
instructionSig <= "0110000000010000"; --load reg 0 with 11111111
wait for 1 ps;

assert regMuxCtrlsig = '0' --ALU TO REG
report "REG MUX SET WRONG"
severity ERROR;
wait for 1 ps;

assert  regTablesig = "000"; -- REG set to read/write
report "REG TABLE SET WRONG"
severity ERROR;
wait for 1 ps;

assert ALUOutsig = "0110"
report "ALU SET WRONG"
severity ERROR;
 -------------------------------------------------------STORE reg 0 to 11111111
instructionSig <= "0111000011111111"; 
wait for 1 ps;

assert regMuxCtrlsig = '0' --ALU TO REG
report "REG MUX SET WRONG"
severity ERROR;
wait for 1 ps;

assert  regTablesig = "000" -- REG set to read/write
report "REG TABLE SET WRONG"
severity ERROR;
wait for 1 ps;

assert ALUOutsig = "0110"
report "ALU SET WRONG"
severity ERROR; 

assert dataMemsig = "01";
report "DATA MEM SET WRONG"
severity ERROR; 
--------------------------------------------------------JUMP AND LINK
instructionSig <= "1000000000000001";  
 
assert signCtrlsig = '0' --8 bits to PC
report "SIGN EXTEN SET WRONG"
severity ERROR; 
wait for 1 ps;

assert addCtrlsig = "01" 
report "ADD UNIT SET WRONG"
severity ERROR; 
wait for 1 ps;

assert regTablesig = "010"
report "REGFILE SET WRONG"
severity ERROR;
wait for 1 ps;

----------------------------------------------------------RETURN
instructionSig <= "1001000000000000";  
wait for 1 ps;
 
assert addCtrlsig = "10" 
report "ADD UNIT SET WRONG"
severity ERROR; 
wait for 1 ps;

assert regTablesig = "010"
report "REGFILE SET WRONG"
severity ERROR;
wait for 1 ps;

----------------------------------------------------------BRANCH EQUAL NOT EQUAL
wait for 1 ps;
instructionSig <= "1010000000000000";
branchBitSig <= '1';  
wait for 1 ps;

assert ALUOutsig <= "1010"
report "ALU SET INCORRECTLY"
severity ERROR;

assert signCtrlsig = '0' --8 bits to PC
report "SIGN EXTEN SET WRONG"
severity ERROR; 
wait for 1 ps;

assert  addCtrlsig = "01"
report "BRANCH BIT RESPONSE WRONG"
severity ERROR; 
wait for 1 ps;

instructionSig <= "1010000000000001";
branchBitSig <= '0';  
wait for 1 ps;
assert  addCtrlsig = "00"
report "BRANCH BIT RESPONSE WRONG"
severity ERROR; 
wait for 1 ps;
--------------------------------------------------OR 1 and 0 into 2

wait for 1 ps;
instructionSig <= "1100001000000001";
wait for 1 ps;
assert regTableASig = "0000" -- A = 0
report "INCORRECT FIRST OP"
severity ERROR;
wait for 1 ps;
assert regTableBSig = "0001" --B = 1
report "INCORRECT SECOND OP"
severity ERROR;
wait for 1 ps;
assert regTableDSig = "0010" --D = 0010
report "INCORRECT DEST OP"
severity ERROR;
wait for 1 ps;

assert addCtrlsig = "00" -- PC + 1
report "INCORRECT ADD OP"
severity ERROR;
wait for 1 ps;

 assert  ALUOutsig = "1100"; -- ALU to OR
 report "INCORRECT ALU OR OP"
 severity ERROR;
 wait for 1 ps;
 
assert  regMuxCtrlSig = '0'; -- REG MUX to REG
 report "INCORRECT REG MUX LOCAL OP"
 severity ERROR;
 wait for 1 ps; 
 
------------------------------------------------AND
wait for 1 ps;
instructionSig <= "1101001000000001";
wait for 1 ps;
assert regTableASig = "0000" -- A = 0
report "INCORRECT FIRST OP"
severity ERROR;
wait for 1 ps;
assert regTableBSig = "0001" --B = 1
report "INCORRECT SECOND OP"
severity ERROR;
wait for 1 ps;
assert regTableDSig = "0010" --D = 0010
report "INCORRECT DEST OP"
severity ERROR;
wait for 1 ps;

assert addCtrlsig = "00" -- PC + 1
report "INCORRECT ADD OP"
severity ERROR;
wait for 1 ps;

 assert  ALUOutsig = "1101"; -- ALU to OR
 report "INCORRECT ALU OR OP"
 severity ERROR;
 wait for 1 ps;
 
assert  regMuxCtrlSig = '0'; -- REG MUX to REG
 report "INCORRECT REG MUX LOCAL OP"
 severity ERROR;
 wait for 1 ps; 
 
-------------------------------------------------BRANCH GREATER LESS THAN

 wait for 1 ps;
instructionSig <= "1110001000000001";
branchBitSig <= '1';  
wait for 1 ps;

assert ALUOutsig <= "1110"
report "ALU SET INCORRECTLY"
severity ERROR;

assert signCtrlsig = '0' --8 bits to PC
report "SIGN EXTEN SET WRONG"
severity ERROR; 
wait for 1 ps;

assert  addCtrlsig = "01"
report "BRANCH BIT RESPONSE WRONG"
severity ERROR; 
wait for 1 ps;

instructionSig <= "1110000000000000";
branchBitSig <= '0';  
wait for 1 ps;
assert  addCtrlsig = "00"
report "BRANCH BIT RESPONSE WRONG"
severity ERROR; 
wait for 1 ps;
 
end process;
end Behavioral;

