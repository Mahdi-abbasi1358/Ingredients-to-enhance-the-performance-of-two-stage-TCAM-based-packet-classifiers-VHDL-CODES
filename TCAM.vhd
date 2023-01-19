----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:45:49 05/11/2014 
-- Design Name: 
-- Module Name:    TCAM - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.pack.all;
 



entity TCAM is
port( 
			CLK_TCAM  : in bit;
			search_TCAM: in bit;
			write_TCAM : in bit;
			data_in:in TCAM_vector_width;
			data_out:out TCAM_vector_width;
			addr:in integer;
			match_TCAM : out bit
			
			);
end TCAM;

architecture Behavioral of TCAM is
component TCAM_P 
port(
			CLK_TCAM  : in bit;
			search_TCAM: in bit;
			write_TCAM : in bit;
			data_in:in TCAM_vector_width;
			data_out: out resolved2 TCAM_vector_width;
			addr:in integer ;
			counter:in integer ; 
			match_TCAM : out bit
			
);
end component;
--signal test_out: resolved TCAM_vector_width;
signal match :bit_vector(0 to entry_number);
begin
	 
	 
	 for1:for counter in 0 to entry_number generate
	  begin
			a: TCAM_P port map (CLK_TCAM,'1','0',data_in,data_out,addr,counter,match(counter));
	  end generate;

end Behavioral;

