library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 

entity REGFILE is
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
end REGFILE;

architecture Behavioral of REGFILE is

    subtype WORD is STD_LOGIC_VECTOR (15 downto 0);
    type MEMORY is array (15 downto 0) of WORD; -- 2^16 words               
    signal reg_file: MEMORY;
    signal regFileOutA : STD_LOGIC_VECTOR(15 downto 0);
    signal regFileOutB : STD_LOGIC_VECTOR(15 downto 0);
    
    
    begin
    
        process(readAddrA,writeAddrA,readAddrB,clk,signCtrl,valIn,extendIn)
        variable R_ADDRA: integer range 0 to 15;
        variable R_ADDRB: integer range 0 to 15;
        variable W_ADDRA: integer range 0 to 15;
        
        variable STARTUP: boolean := true;
        begin
            if(STARTUP = true)then
                reg_file <= (0 => "0000000000000000", 
                      1 => "0000000000000000",
                      2 => "0000000000000000",
                      others => "0000000000000000");
                STARTUP := false;
            else
                 R_ADDRA := conv_integer(readAddrA);
                 W_ADDRA := conv_integer(writeAddrA);
                 R_ADDRB := conv_integer(readAddrB);
                 
                 
               --if(falling_edge(clk))then
                                           
                    if(signCtrl = "001") then
                        reg_file(W_ADDRA) <= valIn; --Write to A
                    elsif(signCtrl = "010") then
                        reg_file(W_ADDRA) <= valIn; --Write to A 
                    elsif(signCtrl = "011") then
                        reg_file(W_ADDRA) <= extendIn; --Write to A 
                    elsif(signCtrl = "100")then 
                        reg_file(15) <= valIn; -- write to the link   
                        end if;    
               --end if;
           valOutA <= reg_file(R_ADDRA);
           valOutB <= reg_file(R_ADDRB);
           end if;
       end process;
   linkOut <= reg_file(15);
  
   end Behavioral;