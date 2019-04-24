library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity CONTROL is
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
        
        
end CONTROL;

architecture Behavioral of CONTROL is
signal regTableAsig : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal regTableBsig : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal regTableDsig : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal ALUOutsig : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal regTablesig : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal signCtrlsig: STD_LOGIC := '0';
signal regMuxCtrlsig: STD_LOGIC := '0';
signal dataMemsig: STD_LOGIC := '0';
signal addCtrlsig: STD_LOGIC_VECTOR(1 downto 0) := "00";
signal storeAddrSig : STD_LOGIC_VECTOR(15 downto 0);


begin

process(instruction) begin
    if(instruction(15 downto 12) = "0000") then --halt
        addCtrlsig <= "11";
        regTablesig <= "000";
    elsif(instruction(15 downto 12) = "0001")then --jump
        signCtrlsig <= '1';
        addCtrlsig <= "01"; --sign extended
        regTablesig <= "000";
        
    elsif(instruction(15 downto 12) = "0010")then --add
        regTableDsig <= instruction(11 downto 8);
        regTableAsig <= instruction(7 downto 4);
        regTableBsig <= instruction(3 downto 0);
        ALUOutsig <= "0010";
        dataMemsig <= '0'; -- do nothing
        addCtrlsig <= "00"; --PC + 1
        regMuxCtrlsig <= '0'; --ALU TO REG
        regTablesig <= "010";
        
    elsif(instruction(15 downto 12) = "0011")then --sub
        regTablesig <= "000";
        regTableDsig <= instruction(11 downto 8);
        regTableAsig <= instruction(7 downto 4);
        regTableBsig <= instruction(3 downto 0);
        ALUOutsig <= "0011";
        dataMemsig <= '0'; --do nothing
        addCtrlsig <= "00"; --PC + 1
        regMuxCtrlsig <= '0'; --ALU TO REG
        regTablesig <= "010";
        
    elsif(instruction(15 downto 12) = "0100")then --load
        regTableAsig <= instruction(11 downto 8);
        storeAddrSig <= instruction(15 downto 0);
        regTablesig <= "001"; --read so regtable looks at input
        regTableDsig <= instruction(11 downto 8); --load address
        ALUOutsig <= "0000"; --do nothing
        dataMemsig <= '0'; --write pcIn address
        addCtrlsig <= "00"; --PC + 1
        regMuxCtrlsig <= '1'; --MEM TO REG
        
        
    elsif(instruction(15 downto 12) = "0101")then --load C
        regTableAsig <= instruction(11 downto 8);
        regTablesig <= "011"; --read sign extend 2
        regTableDsig <= instruction(11 downto 8); --load address
        ALUOutsig <= "0000"; --do nothing
        dataMemsig <= '0'; --do nothing
        addCtrlsig <= "00"; --PC + 1
        
    
    elsif(instruction(15 downto 12) = "0110")then --MOV
        
        regTableDsig <= instruction(11 downto 8); --destination
        regTableAsig <= instruction(7 downto 4); --value being moved
        ALUOutsig <= "0110"; --pass values from reg to reg mux
        dataMemsig <= '0'; --default
        addCtrlsig <= "00"; --PC + 1
        regMuxCtrlsig <= '0'; --ALU TO REG
        regTablesig <= "010";
        
    elsif(instruction(15 downto 12) = "0111")then --STORE
        storeAddrSig <= instruction(15 downto 0);
        regTablesig <= "000"; --rtype 
        regTableAsig <= instruction(11 downto 8);
        ALUOutsig <= "0110"; --pass values from reg to reg mux
        dataMemsig <= '1'; --write to mem
        addCtrlsig <= "00"; --PC + 1
        regMuxCtrlsig <= '0'; --ALU TO REG
        
        
       
        
    elsif(instruction(15 downto 12) = "1000")then --JUMP AND LINK
        
        regTableAsig <= "1111"; --value being stored
        ALUOutsig <= "0000"; --pass values from reg to reg mux
        dataMemsig <= '0'; --do nothing
        signCtrlsig <= '1'; --put 12 bit offset to add
        addCtrlsig <= "01"; --sign extended
        --regMuxCtrlsig <= '0'; --ALU TO REG
        regTablesig <= "100";
        
    elsif(instruction(15 downto 12) = "1001")then --RETURN
        regTablesig <= "000"; --do nothing
        dataMemsig <= '0'; --do nothing
        addCtrlsig <= "10"; -- add puts the register into PC
        ALUOutsig <= "0000"; --do nothing
        
        regMuxCtrlsig <= '0'; --ALU TO REG
        
        
     elsif(instruction(15 downto 12) = "1010")then --BRANCH IF EQUAL
        
        dataMemsig <='0'; --do nothing
        ALUOutsig <= "1010"; --branch if equal
        
        regMuxCtrlsig <= '0'; --ALU TO REG
        signCtrlsig <= '0'; --put 8 bit offset to add
        regTablesig <= "000"; --read the 2 registers
        
        
        addCtrlsig <= "00"; -- PC + 1
        
        
    elsif(instruction(15 downto 12) = "1011")then --BRANCH IF NOT EQUAL
        
        dataMemsig <= '0'; --do nothing
        signCtrlsig <= '0'; --put 8 bit offset to add
        ALUOutsig <= "1011"; --branch if equal
        
        regMuxCtrlsig <= '0'; --ALU TO REG
        regTablesig <= "000"; --read the 2 registers
        
        
        addCtrlsig <= "00"; -- PC + 1
        
        
    elsif(instruction(15 downto 12) = "1100")then --OR 
        
        regTableDsig <= instruction(11 downto 8);
        regTableAsig <= instruction(7 downto 4);
        regTableBsig <= instruction(3 downto 0);
        ALUOutsig <= "1100";
        dataMemsig <= '0'; -- do nothing
        addCtrlsig <= "00"; --PC + 1
        regMuxCtrlsig <= '0'; --ALU TO REG
        regTablesig <= "010"; --read the 2 registers and write
        
     elsif(instruction(15 downto 12) = "1101")then --AND
       
       regTableDsig <= instruction(11 downto 8);
       regTableAsig <= instruction(7 downto 4);
       regTableBsig <= instruction(3 downto 0);
       ALUOutsig <= "1101";
       dataMemsig <= '0'; -- do nothing
       addCtrlsig <= "00"; --PC + 1
       regMuxCtrlsig <= '0'; --ALU TO REG
       regTablesig <= "010"; 
    
    elsif(instruction(15 downto 12) = "1110")then --BRANCH IF LESS THAN
           
           dataMemsig <= '0'; --do nothing
           signCtrlsig <= '0'; --put 8 bit offset to add
           ALUOutsig <= "1110"; --branch if equal
           
           regTablesig <= "000"; --read the 2 registers
           
           
               addCtrlsig <= "00"; -- PC + 1
           
           
       elsif(instruction(15 downto 12) = "1111")then --BRANCH IF greater THAN
              
              dataMemsig <= '0'; --do nothing
              signCtrlsig <= '0'; --put 8 bit offset to add
              ALUOutsig <= "1111"; --branch if equal
              
              regTablesig <= "000"; --read the 2 registers
              
           
                  addCtrlsig <= "00"; -- PC + 1
             
    
    end if;
end process;
storeAddr <= storeAddrSig; 
regTableA <= regTableAsig;
regTableB <= regTableBsig;
regTableD <= regTableDsig;
ALUout <= ALUOutsig;
regTable <= regTablesig;
signCtrl <= signCtrlsig;
dataMem <= dataMemsig;
addCtrl <= addCtrlsig;
regMuxCtrl <= regMuxCtrlsig;


end Behavioral;
