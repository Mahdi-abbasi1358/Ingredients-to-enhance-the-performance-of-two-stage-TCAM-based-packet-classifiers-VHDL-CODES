----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:47:23 05/11/2014 
-- Design Name: 
-- Module Name:    TCAM_P - Behavioral 
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

use work.pack.all;
 


entity TCAM_P is
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
end TCAM_P;

architecture Behavioral of TCAM_P is
type TCAM_MEMORY_S is array ( 0 to entry_number ) of TCAM_vector_width;
signal memorytcam: TCAM_MEMORY_S;
signal match:bit_vector(0 to entry_number);
signal temp: TCAM_vector_width;
begin
		process(CLK_TCAM)
		variable temp: TCAM_vector_width;
		begin		
			if( CLK_TCAM='1' and CLK_TCAM'event)	then
				
				if ( search_TCAM = '1' ) then	
						
					if(memorytcam(addr)(0)='1')then
								
								match_TCAM<= '1' ;
								for i in 1 to 64 loop
									
										if memorytcam(addr)(i)/= data_in(i-1) then
											match_TCAM <= '0' ;
											exit;
										end if;
									
								end loop;	
					end if;
				elsif write_TCAM='1' then								
								memorytcam(addr)<= data_in;	
				elsif write_TCAM='0' then
							
								data_out<=memorytcam(addr);
								
				end if;
			
		end if;
		end process;

end Behavioral;

