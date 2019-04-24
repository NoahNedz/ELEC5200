library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 

entity INSTRMEM is
    Port (
        clk : in STD_LOGIC;
        readAddr : in STD_LOGIC_VECTOR(15 downto 0);
        instrOut : out STD_LOGIC_VECTOR(15 downto 0));  
end INSTRMEM;

architecture Behavioral of INSTRMEM is

    subtype WORD is STD_LOGIC_VECTOR (15 downto 0);
    type MEMORY is array (65535 downto 0) of WORD; -- 2^16 words               
    signal instr_mem: MEMORY;
    signal instrOutsig : STD_LOGIC_VECTOR(15 downto 0);
    
    begin
    
        process(readAddr,clk)
        variable R_ADDR: integer range 0 to 65535;
        variable W_ADDR: integer range 0 to 65535;
        variable STARTUP: boolean := true;
        begin
            if(STARTUP = true)then
                instr_mem <= (0 => "0101000000000001", --loadc 1 into reg 0
                              1 => "0101000100000001", --loadc 1 into reg 1
                              2 => "0010000000000001", --add reg 0 and reg 1 store in reg 0
                              3 => "0101000100000010", --loadc 2 into reg 1
                              4 => "1010000000010011", -- branch 3 away if reg 1 and 0 are equal
                              others => "0101000000000001");
                STARTUP := false;
            else
                
             R_ADDR := conv_integer(readAddr); 
            instrOut <= instr_mem(R_ADDR); 
                
            end if;
        end process;
            
                
    
end Behavioral;