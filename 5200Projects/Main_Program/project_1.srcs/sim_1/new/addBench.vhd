----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2019 04:20:01 PM
-- Design Name: 
-- Module Name: addBench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity addBench is
--  Port ( );
end addBench;

architecture Behavioral of addBench is

signal EXTEND: std_logic_vector(15 downto 0);
signal REG: std_logic_vector(15 downto 0);
signal CTRL: std_logic_vector(1 downto 0);
signal DATAOUTPUT: std_logic_vector(15 downto 0);
signal PC: std_logic_vector(15 downto 0);


component ADD is
     port(
       bit16In : in STD_LOGIC_VECTOR(15 downto 0);
       PCin : in STD_LOGIC_VECTOR(15 downto 0);
       REGin : in STD_LOGIC_VECTOR(15 downto 0);
       bit16Out : out STD_LOGIC_VECTOR(15 downto 0);
       signCtrl : in STD_LOGIC_VECTOR(1 downto 0));
end component;


begin
M1: ADD port map(bit16In => EXTEND, PCin => PC, REGin => REG, bit16Out => DATAOUTPUT, signCtrl => CTRL); 

process begin

--test control to increment PC + 1
wait for 1 ps;
--EXTEND <= "0000000000000011";
CTRL <= "00";
wait for 1 ps;
PC <=     "0000000000000001";
wait for 1 ps;

assert DATAOUTPUT = "0000000000000010"
report "PC WAS NOT INCREMENTED"
severity ERROR;

--test to see if extended gets added
CTRL <= "00";
EXTEND <= "0000000000000011";
PC <=  "0000000000000001";
REG <= "0000000000000100";
wait for 2 ps;
CTRL <= "01";
wait for 2 ps;

assert DATAOUTPUT = "0000000000000100"
report "PC WAS NOT INCREMENTED"
severity ERROR;

----test to see if register write works
CTRL <= "00";
EXTEND <= "0000000000000011";
PC <=  "0000000000000001";
REG <= "0000000000000100";
wait for 2 ps;
CTRL <= "10";
wait for 2 ps;

assert DATAOUTPUT = "0000000000000100"
report "PC WAS NOT INCREMENTED"
severity ERROR;
end process;


end Behavioral;
