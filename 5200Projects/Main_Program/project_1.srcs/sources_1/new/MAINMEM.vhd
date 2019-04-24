library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity MAINMEM is
    Port (
        clk : in STD_LOGIC;
        storeOff : in STD_LOGIC_VECTOR(15 downto 0);
        PCin : in STD_LOGIC_VECTOR(15 downto 0);
        signCtrl : in STD_LOGIC;
        valIn : in STD_LOGIC_VECTOR(15 downto 0);
        evalAddr : out STD_LOGIC_VECTOR(15 downto 0);
        valOut : out STD_LOGIC_VECTOR(15 downto 0));
       
end MAINMEM;

architecture Behavioral of MAINMEM is

    subtype WORD is STD_LOGIC_VECTOR (15 downto 0);
    type MEMORY is array (65535 downto 0) of WORD; -- 2^16 words               
    signal main_mem: MEMORY;
    signal regFileOutA : STD_LOGIC_VECTOR(15 downto 0);
    signal writeAd : STD_LOGIC_VECTOR(15 downto 0);
    begin
        process(storeOff,clk,PCin,signCtrl)
        
            variable W_ADDR: integer range 0 to 65535;
            
            variable STARTUP: boolean := true;
        begin
            if(STARTUP = true)then
                main_mem <= (
                      1 => "0000000000001110", --E
                      2 => "0000000000000001", --1
                      3 => "0000000000001110", --E
                      4 => "0000000000001100", --C
                      5 => "0000000000000101", --5
                      6 => "0000000000000010", --2
                      7 => "0000000000000000", --0
                      8 => "0000000000000000", --0
                     
                      others => "0000000000000000");
                STARTUP := false;
            else
                writeAd <= (storeOff and "0000000011111111") + PCIN;                 
                 W_ADDR := conv_integer((storeOff and "0000000011111111") + PCIN);
                
               
                if(signCtrl = '1') then
                    main_mem(W_ADDR) <= valIn; --Write
                end if;    
           
           valOut <= main_mem(W_ADDR);
           end if;
       end process;
       evalAddr <= writeAd; 
   end Behavioral;