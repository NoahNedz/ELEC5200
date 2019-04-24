library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity ADD is
    port(
        clk : in STD_LOGIC;
        branchIn : in STD_LOGIC;
        bit16In : in STD_LOGIC_VECTOR(15 downto 0);
        PCin : in STD_LOGIC_VECTOR(15 downto 0);
        REGin : in STD_LOGIC_VECTOR(15 downto 0);
        bit16Out : out STD_LOGIC_VECTOR(15 downto 0);
        signCtrl : in STD_LOGIC_VECTOR(1 downto 0));
end ADD;

architecture Behavioral of ADD is
signal bit16OutSig : STD_LOGIC_VECTOR(15 downto 0);
begin

CTRL: process(clk,signCtrl,REGin,PCin,branchIn)
    begin
    if rising_edge(clk) then
    
        if(branchIn = '1') then             
                bit16OutSig <= PCIn + bit16In;--Branch value
        elsif(branchIn = '0')then
            if(signCtrl = "00") then
                bit16OutSig <= PCin + "0000000000000001";--PC = PC+1
            elsif(signCtrl = "01") then             
                bit16OutSig <= PCin + bit16In;--from signextend1
                
            
            elsif(signCtrl = "11") then
                bit16OutSig <= "0000000000000000"; --HALT
            end if;
       end if; 
    end if;
    end process;
    bit16Out <= bit16OutSig;
    
end Behavioral;
