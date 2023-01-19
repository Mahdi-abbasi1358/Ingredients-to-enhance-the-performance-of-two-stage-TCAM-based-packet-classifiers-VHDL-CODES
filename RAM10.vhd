----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:50:01 05/11/2014 
-- Design Name: 
-- Module Name:    RAM10 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
  LIBRARY ieee;
  library std;
  USE ieee.std_logic_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
  USE ieee.numeric_std.ALL;
  USE STD.TEXTIO.ALL;
  use work.pack.all;
 



entity RAM10 is
port(	
			CLK 			: in bit;
			write_RAM 	: in bit;
			addr			:in integer;
			data_in		:in bit_vector(0 to 9);
			data_out		:out bit_vector(0 to 9)
);
end RAM10;

architecture Behavioral of RAM10 is
signal ram:RAM_MEMORY;

begin

process(CLK)
		begin
			if CLK'event and CLK='1' then
				if(write_ram='1') then
					ram(addr)<= data_in;
				else
					data_out<=ram(addr);
				end if;
			
			end if;
		end process;
end Behavioral;

