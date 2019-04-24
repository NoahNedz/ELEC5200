library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;



entity mainBench is
--  Port ( );
end mainBench;

architecture Behavioral of mainBench is
signal clk : std_logic;
signal READBUSA : STD_LOGIC_VECTOR(15 downto 0);
signal READBUSB : STD_LOGIC_VECTOR(15 downto 0);

signal MEMREAD : STD_LOGIC_VECTOR(15 downto 0);

signal INSTRUCTION : STD_LOGIC_VECTOR(15 downto 0);

signal WRITEBUS : STD_LOGIC_VECTOR(15 downto 0);
signal EXTENDBUS : STD_LOGIC_VECTOR(15 downto 0);
signal JUMPBUS : STD_LOGIC_VECTOR(15 downto 0);

--Add
signal bit16OutAdd : STD_LOGIC_VECTOR(15 downto 0);

--Control
signal CONregMuxCtrl : STD_LOGIC;
signal CONregTableA : STD_LOGIC_VECTOR(3 downto 0);
signal CONregTableB : STD_LOGIC_VECTOR(3 downto 0);
signal CONregTableD : STD_LOGIC_VECTOR(3 downto 0);
signal CONALUout : STD_LOGIC_VECTOR(3 downto 0);
signal CONregTable :  STD_LOGIC_VECTOR(2 downto 0);
signal CONsignCtrl : STD_LOGIC;
signal CONdataMem : STD_LOGIC;
signal CONaddCtrl : STD_LOGIC_VECTOR(1 downto 0);

--RegMux
signal REGbit16Out : STD_LOGIC_VECTOR(15 downto 0);

--Sign1
signal Sign1bit16Out : STD_LOGIC_VECTOR(15 downto 0);

--Sign2
signal Sign2bit16Out : STD_LOGIC_VECTOR(15 downto 0);

--PC
signal PCOUTsig : STD_LOGIC_VECTOR(15 downto 0);

--ALU
signal ALUbit16Out : STD_LOGIC_VECTOR(15 downto 0);
signal ALUbranchBit : STD_LOGIC;

--INSTR MEM
signal instrOutSig : STD_LOGIC_VECTOR(15 downto 0);

-- PC
signal PC : STD_LOGIC_VECTOR(15 downto 0);

--Store Signal
signal storeSig : STD_LOGIC_VECTOR(15 downto 0);
signal evalSig : STD_LOGIC_VECTOR(15 downto 0);

component ADD
    port(
        branchIn : in STD_LOGIC;
        clk : in std_logic;
        bit16In : in STD_LOGIC_VECTOR(15 downto 0);
        PCin : in STD_LOGIC_VECTOR(15 downto 0);
        REGin : in STD_LOGIC_VECTOR(15 downto 0);
        bit16Out : out STD_LOGIC_VECTOR(15 downto 0);
        signCtrl : in STD_LOGIC_VECTOR(1 downto 0));
end component;

component CONTROL
    port(
            instruction : in STD_LOGIC_VECTOR(15 downto 0);
            
            regMuxCtrl : out STD_LOGIC;
            regTableA : out STD_LOGIC_VECTOR(3 downto 0);
            regTableB : out STD_LOGIC_VECTOR(3 downto 0);
            regTableD : out STD_LOGIC_VECTOR(3 downto 0);
            ALUout : out STD_LOGIC_VECTOR(3 downto 0);
            regTable : out STD_LOGIC_VECTOR(2 downto 0);
            regFileCtrl : out STD_LOGIC_VECTOR(2 downto 0);
            storeAddr : out STD_LOGIC_VECTOR(15 downto 0);
           
            signCtrl: out STD_LOGIC;
            dataMem : out STD_LOGIC;
            addCtrl: out STD_LOGIC_VECTOR(1 downto 0));
end component;

component REGMUX
port(   
        clk : in STD_LOGIC;
        signCtrl : in STD_LOGIC;
        bit16Out : out STD_LOGIC_VECTOR(15 downto 0);
        aluIn : in STD_LOGIC_VECTOR(15 downto 0);
        memIn : in STD_LOGIC_VECTOR(15 downto 0));
end component;

component SIGN1
    port(
    clk : in STD_LOGIC;
    instrIn : in STD_LOGIC_VECTOR(15 downto 0);
    bit16Out: out STD_LOGIC_VECTOR(15 downto 0);
    signCtrl: in STD_LOGIC);
end component;

component SIGN2
 port(
   instrIn : in STD_LOGIC_VECTOR(15 downto 0);
   bit16Out: out STD_LOGIC_VECTOR(15 downto 0));
end component;



component ALU
port(
        clk : in STD_LOGIC;
        bit16InA : in STD_LOGIC_VECTOR(15 downto 0);
        bit16InB : in STD_LOGIC_VECTOR(15 downto 0);
        bit16Out : out STD_LOGIC_VECTOR(15 downto 0); -- this goes to either datamem or regtable
        branchBit : out STD_LOGIC;
        signCtrl : in STD_LOGIC_VECTOR(15 downto 0));
end component;

component INSTRMEM
 port (
       clk : in STD_LOGIC;
       readAddr : in STD_LOGIC_VECTOR(15 downto 0);
       instrOut : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component PCREG
port(
        clk : in STD_LOGIC;
        addrIn : in STD_LOGIC_VECTOR(15 downto 0);
        addrOut : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component REGFILE
Port (
        clk : in STD_LOGIC;
        readAddrA : in STD_LOGIC_VECTOR(3 downto 0);
        readAddrB : in STD_LOGIC_VECTOR(3 downto 0);
        writeAddrA : in STD_LOGIC_VECTOR(3 downto 0);
        signCtrl : in STD_LOGIC_VECTOR(2 downto 0);
        valIn : in STD_LOGIC_VECTOR(15 downto 0);
        extendIn : in STD_LOGIC_VECTOR(15 downto 0);
        linkOut : out STD_LOGIC_VECTOR(15 downto 0);
        valOutA : out STD_LOGIC_VECTOR(15 downto 0);
        valOutB : out STD_LOGIC_VECTOR(15 downto 0)); 
end component;

component MAINMEM
 Port (
         clk : in STD_LOGIC;
         storeOff : in STD_LOGIC_VECTOR(15 downto 0);
         PCin : in STD_LOGIC_VECTOR(15 downto 0);
         evalAddr : out STD_LOGIC_VECTOR(15 downto 0);
         signCtrl : in STD_LOGIC;
         valIn : in STD_LOGIC_VECTOR(15 downto 0);
         valOut : out STD_LOGIC_VECTOR(15 downto 0));
      
end component;

begin


A1 : ADD port map(branchIn => ALUbranchBit,clk => clk,bit16In => Sign1bit16Out, PCin => PC, REGin => JUMPBUS, bit16Out => bit16OutAdd, signCtrl => CONaddCtrl);

--dear lord
A2: CONTROL port map(instruction => instrOutSig,  regMuxCtrl => CONregMuxCtrl, 
regTableA => CONregTableA, regTableB => CONregTableB, regTableD => CONregTableD, ALUout => CONALUout,
regTable => CONregTable, signCtrl => CONsignCtrl, dataMem => CONdataMem, addCtrl => CONaddCtrl, storeAddr => storeSig);


A3: REGMUX port map(clk => clk,signCtrl => CONregMuxCtrl, bit16Out => WRITEBUS, aluIn => ALUbit16Out, memIn => MEMREAD);

A4: SIGN1 port map(clk => clk, instrIn => instrOutSig, bit16Out => Sign1bit16Out, signCtrl => CONsignCtrl);

A5: SIGN2 port map(instrIn => instrOutSig, bit16Out => EXTENDBUS);

A6: ALU port map(clk => clk, bit16InA => READBUSA, bit16InB => READBUSB, bit16Out => ALUbit16Out, branchBit => ALUbranchBit, signCtrl => instrOutSig);

A7: INSTRMEM port map(clk => clk, readAddr => PC, instrOut => instrOutSig);

A8 : PCREG port map(clk => clk, addrIn => bit16OutAdd, addrOut => PC);

A9 : REGFILE port map(clk => clk, extendIn => EXTENDBUS, readAddrA => CONregTableA, readAddrB => CONregTableB, writeAddrA => CONregTableD,
signCtrl => CONregTable, valIn => WRITEBUS, linkOut => JUMPBUS, valOutA => READBUSA, valOutB => READBUSB);

A10 : MAINMEM port map(clk => clk, storeOff => storeSig, PCin => PC,
 signCtrl => CONdataMem, valIn => ALUbit16Out,valOut => MEMREAD,evalAddr => evalSig);
process begin



------HALT
--clk <= '0';
--INSTRUCTION <= "0000000000000000"; --halt
--PCOUTsig <= "1111111111111111"; --PC value
--wait for 1ps;
--clk <= '1';
--wait for 1ps;
--assert bit16OutAdd =  "0000000000000000"
--report "ADD CNTRL HALT IS BAD"
--severity ERROR;

----JUMP
--clk <= '0';
--PCOUTsig <= "0000000000000000"; --PC value
--INSTRUCTION <= "0001000000000011"; --jump
--wait for 1ps;
--clk <= '1';
--wait for 1ps;

--assert bit16OutAdd = "00000000000000011"
--report "ADD CNTRL JUMP IS BAD"
--severity ERROR;

----ADD
--clk <= '0';
--PCOUTsig <= "0000000000000000"; --PC value
--READBUSA <= "0000000000000001";
--READBUSB <= "0000000000000001";
--INSTRUCTION <= "0010000000000000";
--wait for 1ps;
--clk <= '1';
--wait for 1ps;
--assert ALUbit16Out = "0000000000000010"
--report "ADD CNTRL ALU IS BAD"
--severity ERROR;
--wait for 1ps;
--assert ALUbit16Out = REGbit16Out
--report "ADD CNTRL REGMUX IS BAD"
--severity ERROR;

----SUB
--clk <= '0';
--PCOUTsig <= "0000000000000000"; --PC value
--READBUSA <= "0000000000000001";
--READBUSB <= "0000000000000001";
--INSTRUCTION <= "0011000000000000";
--wait for 1ps;
--clk <= '1';
--wait for 1ps;
--assert ALUbit16Out = "0000000000000000"
--report "SUB CNTRL ALU IS BAD"
--severity ERROR;
--wait for 1ps;
--assert ALUbit16Out = REGbit16Out
--report "SUB CNTRL REGMUX IS BAD"
--severity ERROR;

----LOAD
--INSTRUCTION <= "0100000100000011";
--PCOUTsig <= "0000000000000000"; --PC value
--MEMREAD <= "0000000000000001";
--clk <= '0';
--wait for 1ps;
--clk <= '1';
--wait for 1ps;

--assert CONregTableD = INSTRUCTION(11 downto 8)
--report "LOAD CNTRL DEST ADDR IS BAD"
--severity ERROR;

--assert REGbit16Out = "0000000000000001"
--report "LOAD CNTRL REGMUX IS BAD"
--severity ERROR;

----LOADC
--INSTRUCTION <= "0101000000000000";
--PCOUTsig <= "0000000000000000"; --PC value
--clk <= '0';
--wait for 2ps;
--clk <= '1';
--wait for 2ps;
--assert CONregTable = "001"
--report "REG CNTRL IS BAD"
--severity ERROR;

--assert CONregTableD = INSTRUCTION(11 downto 8)
--report "LOADC CNTRL DEST ADDR IS BAD"
--severity ERROR;

----MOV
--INSTRUCTION <= "0110001100010000";
--READBUSA <= "0000000000000001";--input values
--PCOUTsig <= "0000000000000000"; --PC value
--clk <= '0';
--wait for 1ps;
--clk <= '1';
--wait for 1ps;

--assert CONregTableD = "0011"
--report "MOV CNTRL DEST ADDR IS BAD"
--severity ERROR;

--assert CONregTableA = "0001"
--report "MOV CNTRL SRC ADDR IS BAD"
--severity ERROR;

--assert REGbit16Out = "0000000000000001"
--report "MOV CNTRL REGMUX IS BAD"
--severity ERROR;

----STORE
--INSTRUCTION <= "0111000000000001";
--PCOUTsig <= "0000000000000000"; --PC value
--READBUSA <= "0000000000000001";--input values
--clk <= '0';
--wait for 1ps;
--clk <= '1';
--wait for 1ps;
--assert ALUbit16Out = "0000000000000001"
--report "STORE CNTRL ALU IS BAD"
--severity ERROR;

--assert REGbit16Out = "0000000000000001"
--report "STORE CNTRL REGMUX IS BAD"
--severity ERROR;


----JUMP AND LINK
--clk <= '0';
--PCOUTsig <= "0000000000000000"; --PC value
--INSTRUCTION <= "1000000000000011"; --JUMP and LINK
--wait for 1ps;
--clk <= '1';
--wait for 1ps;

--assert bit16OutAdd = "00000000000000011"
--report "ADD CNTRL JUMP IS BAD"
--severity ERROR;

----RETURN
--clk <= '0';
--PCOUTsig <= "0000000000000000"; --PC value
--INSTRUCTION <= "1001000000000000"; --RETURN
--WRITEBUS <= "1111111111111111";
--wait for 1ps;
--clk <= '1';
--wait for 1ps;

--assert bit16OutAdd = "1111111111111111"
--report "ADD CNTRL RETURN IS BAD"
--severity ERROR;

----Branch if Equal --- branch bit not being evaluated
--clk <= '0';
--PCOUTsig <= "0000000000000000"; --PC value
--INSTRUCTION <= "1010000000001111"; --RETURN
--WRITEBUS <= "0000000000001111";

--READBUSA <= "0000000000000001";
--READBUSB <= "0000000000000001";

--wait for 1ps;
--clk <= '1';
--wait for 1ps;

--assert bit16OutAdd = "0000000000001111"
--report "ADD CNTRL RETURN IS BAD"
--severity ERROR;

--PCOUTsig <= "0000000000000000"; --PC value
--INSTRUCTION <= "1010000000001111"; --RETURN
--WRITEBUS <= "0000000000001111";
--clk <= '0';
--READBUSA <= "0000000000000001";
--READBUSB <= "0000000000000000";

--wait for 1ps;
--clk <= '1';
--wait for 1ps;

--assert bit16OutAdd = "0000000000010000"
--report "ADD CNTRL RETURN IS BAD"
--severity ERROR;

----branch if not equal
--clk <= '0';
--PCOUTsig <= "0000000000000000"; --PC value
--INSTRUCTION <= "1011000000001111"; --RETURN
--WRITEBUS <= "0000000000001111";

--READBUSA <= "0000000000000001";
--READBUSB <= "0000000000000001";

--wait for 1ps;
--clk <= '1';
--wait for 1ps;

--assert bit16OutAdd = "0000000000000001"
--report "ADD CNTRL RETURN IS BAD"
--severity ERROR;

--wait for 1ps;
--clk <= '0';
--READBUSA <= "0000000000000001";
--READBUSB <= "0000000000000000";

--wait for 1ps;
--clk <= '1';
--wait for 1ps;

--assert bit16OutAdd = "0000000000001111"
--report "ADD CNTRL RETURN IS BAD"
--severity ERROR;

----OR
--clk <= '0';
--PCOUTsig <= "0000000000000000"; --PC value
--INSTRUCTION <= "1100000000000000"; --RETURN
--READBUSA <= "0000000000000001";
--READBUSB <= "0000000000000000";
--wait for 1ps;
--clk <= '1';
--wait for 1ps;
--clk <= '0';
--wait for 1ps;
--assert REGbit16Out = "0000000000000001"
--report "OR CNTRL RETURN IS BAD"
--severity ERROR;

------AND
--clk <= '0';
--PCOUTsig <= "0000000000000000"; --PC value
--INSTRUCTION <= "1101000000000000"; --RETURN
--READBUSA <= "0000000000000011";
--READBUSB <= "0000000000000001";
--wait for 1ps;
--clk <= '1';
--wait for 1ps;
--clk <= '0';
--wait for 1ps;
--assert REGbit16Out = "0000000000000001"
--report "OR CNTRL RETURN IS BAD"
--severity ERROR;


----BRANCH IF LESS THAN
--clk <= '0';
--PCOUTsig <= "0000000000000000"; --PC value
--INSTRUCTION <= "1110000000001111"; --RETURN
--READBUSA <= "0000000000000000";
--READBUSB <= "0000000000000001";

--wait for 1ps;
--clk <= '1';
--wait for 1ps;
--clk <= '0';
--wait for 1ps;

--assert bit16OutAdd = "0000000000001111"
--report "ADD CNTRL RETURN IS BAD"
--severity ERROR;

--Testing adds
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;
clk <= '0';
wait for 1ps;
clk <= '1';
wait for 1ps;


---CHANGED REGMUX OUTPUT TO WRITE BUS
--clk <= '0';
--PCOUTsig <= "0000000000000000"; --PC value
--INSTRUCTION <= "0010000000000000"; --add
--READBUSA <= "0000000000000001";
--READBUSB <= "0000000000000001";
--wait for 1ps;
--clk <= '1';

--wait for 1 ps;

--clk <= '0';
--PCOUTsig <= bit16OutAdd;
--READBUSA <= WRITEBUS;
--READBUSB <= "0000000000000011";
--INSTRUCTION <= "1101000000000000"; --and
--wait for 1ps;
--clk <= '1';

--wait for 1ps;

--clk <= '0';
--PCOUTsig <= bit16OutAdd;
--READBUSA <= WRITEBUS;
--READBUSB <= "0000000000000010";
--INSTRUCTION <= "1011000000000010"; --BNEQ
--wait for 1ps;
--clk <= '1';
--wait for 1ps;
--clk <= '0';
--wait for 1ps;
--clk <= '1';
--wait for 1ps;
--assert ALUbranchBit = '0'
--report "FAILED"
--severity ERROR;


end process;
end Behavioral;