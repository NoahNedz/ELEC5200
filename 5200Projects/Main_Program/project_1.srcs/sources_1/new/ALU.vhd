library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.std_logic_unsigned.all;

entity ALU is
    port(
        clk: in std_logic;
        bit16InA : in STD_LOGIC_VECTOR(15 downto 0);
        bit16InB : in STD_LOGIC_VECTOR(15 downto 0);
        bit16Out : out STD_LOGIC_VECTOR(15 downto 0); -- this goes to either datamem or regtable
        branchBit : out STD_LOGIC;
        signCtrl : in STD_LOGIC_VECTOR(15 downto 0));
 
end ALU;

architecture Behavioral of ALU is
signal bit16Outsig : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal branchBitsig : STD_LOGIC := '0';
signal signCtrl1 : STD_LOGIC_VECTOR(3 downto 0);
begin
process(signCtrl,clk)begin
        signCtrl1 <= signCtrl(15 downto 12);
        --if(rising_edge(clk))then
            
            
            if(signCtrl1 = "0010") then --add
                bit16Outsig <= bit16InA + bit16InB;
            elsif(signCtrl1 = "0011") then --sub
                bit16Outsig <= bit16InA - bit16InB;
            
            elsif(signCtrl1 = "0110") then --mov/store passes A out to dataMem or registers
                bit16Outsig <= bit16InA;
                
            elsif(signCtrl1 = "1010") then
                bit16Outsig <= bit16InA + bit16InB;
                if(bit16inA - bit16inB = "0000000000000000") then --branch if equal
                    branchBitsig <= '1';  
                else
                    branchBitsig <= '0';
                end if; 
            elsif(signCtrl1 = "1011") then
                if(bit16inA - bit16inB = 0) then --branch if not equal 
                    branchBitsig <= '0';  
                else
                    branchBitsig <= '1';
                end if;
                
            elsif(signCtrl1 = "1100") then
                bit16Outsig <= bit16InA or bit16InB; --or
                
            elsif(signCtrl1 = "1101") then
                bit16Outsig <= bit16InA and bit16InB; -- and
                
            elsif(signCtrl1 = "1110") then
                if(bit16inB - bit16inA > 0) then
                    branchBitsig <= '1';  --Branch if less than
                else
                    branchBitsig <= '0';
                end if;
            elsif(signCtrl1 = "1111") then
                if(bit16inA - bit16inB > 0) then
                    branchBitsig <= '1';  --Branch if greater than
                else
                    branchBitsig <= '0';
                end if;
            else
                bit16Outsig <= "0000000000000000";
            end if;
        --end if;
end process;

bit16Out <= bit16Outsig;
branchBit <= branchBitsig;
end Behavioral;
