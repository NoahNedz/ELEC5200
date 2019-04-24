
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;


entity main is
end main;

architecture Behavioral of main is
signal clk : STD_LOGIC;
signal READBUSA : STD_LOGIC_VECTOR(15 downto 0);
signal READBUSB : STD_LOGIC_VECTOR(15 downto 0);

signal MEMREAD : STD_LOGIC_VECTOR(15 downto 0);

signal INSTRUCTION : STD_LOGIC_VECTOR(15 downto 0);

signal WRITEBUS : STD_LOGIC_VECTOR(15 downto 0);
signal EXTENDBUS : STD_LOGIC_VECTOR(15 downto 0);
signal LINKBUS : STD_LOGIC_VECTOR(15 downto 0);


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
    instrIn: in STD_LOGIC_VECTOR(15 downto 0);
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
        extendIn : in STD_LOGIC_VECTOR(15 downto 0);
        readAddrB : in STD_LOGIC_VECTOR(3 downto 0);
        writeAddrA : in STD_LOGIC_VECTOR(3 downto 0);
        signCtrl : in STD_LOGIC_VECTOR(2 downto 0);
        valIn : in STD_LOGIC_VECTOR(15 downto 0);
        linkOut : out STD_LOGIC_VECTOR(15 downto 0);
        valOutA : out STD_LOGIC_VECTOR(15 downto 0);
        valOutB : out STD_LOGIC_VECTOR(15 downto 0)); 
end component;

component MAINMEM
 Port (
       clk : in STD_LOGIC;
       evalAddr : out STD_LOGIC_VECTOR(15 downto 0);
         storeOff : in STD_LOGIC_VECTOR(15 downto 0);
         PCin : in STD_LOGIC_VECTOR(15 downto 0);
         signCtrl : in STD_LOGIC;
         valIn : in STD_LOGIC_VECTOR(15 downto 0);
         valOut : out STD_LOGIC_VECTOR(15 downto 0));
      
end component;

begin
A1 : ADD port map(branchIn => ALUbranchBit,clk => clk,bit16In => Sign1bit16Out, PCin => PC, REGin => LINKBUS, bit16Out => bit16OutAdd, signCtrl => CONaddCtrl);


--dear lord
A2: CONTROL port map(instruction => instrOutSig, regMuxCtrl => CONregMuxCtrl, 
regTableA => CONregTableA, regTableB => CONregTableB, regTableD => CONregTableD, ALUout => CONALUout,
regTable => CONregTable, signCtrl => CONsignCtrl, dataMem => CONdataMem, addCtrl => CONaddCtrl,storeAddr => storeSig);


A3: REGMUX port map(clk => clk, signCtrl => CONregMuxCtrl, bit16Out => WRITEBUS, aluIn => ALUbit16Out, memIn => MEMREAD);

A4: SIGN1 port map(clk => clk,instrIn => instrOutSig, bit16Out => Sign1bit16Out, signCtrl => CONsignCtrl);

A5: SIGN2 port map(instrIn => instrOutSig, bit16Out => EXTENDBUS);

A6: ALU port map(clk => clk, bit16InA => READBUSA, bit16InB => READBUSB, bit16Out => ALUbit16Out, branchBit => ALUbranchBit, signCtrl => instrOutSig);

A7: INSTRMEM port map(clk => clk, readAddr => PC, instrOut => instrOutSig);

A8 : PCREG port map(clk => clk, addrIn => bit16OutAdd, addrOut => PC);

A9 : REGFILE port map(clk => clk,extendIn => EXTENDBUS, readAddrA => CONregTableA, readAddrB => CONregTableB, writeAddrA => CONregTableD,
signCtrl => CONregTable, valIn => WRITEBUS, linkOut => LINKBUS, valOutA => READBUSA, valOutB => READBUSB);

A10 : MAINMEM port map(clk => clk, storeOff => storeSig, PCin => PC,
 signCtrl => CONdataMem, valIn => ALUbit16Out,valOut => MEMREAD,evalAddr => evalSig); 
 
end Behavioral;
