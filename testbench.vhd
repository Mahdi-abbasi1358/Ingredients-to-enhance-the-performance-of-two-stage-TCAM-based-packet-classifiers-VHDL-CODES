--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:52:48 05/11/2014
-- Design Name:   
-- Module Name:   C:/Users/SHAKOOR/Desktop/tez_vhdl/classifier/testbench.vhd
-- Project Name:  classifier
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: classifier
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
  LIBRARY ieee;
  library std;
  USE ieee.std_logic_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
  USE ieee.numeric_std.ALL;
  USE STD.TEXTIO.ALL;
  use work.pack.all;
 

 
ENTITY testbench IS

END testbench;
 
ARCHITECTURE behavior OF testbench IS 
 
 component classifier 
		port(
				clk			: in bit;
				rull_packet : in bit_vector(0 to 139);
				search		: in bit;
				update		: in bit;
				add_remove	: in bit;
				int			:integer
				
		);
end component;
signal clk							:resolved bit:='0';
signal start						:bit:='0';
signal rull_packet_signal		:bit_vector(0 to 139);
signal search						: resolved bit;
signal update						: resolved bit;
signal add_remove					: resolved bit;
signal int:integer:=0;
signal tree							: bit;
BEGIN
 process (start)
		FILE inFile : TEXT is in "set/test2000/bin/acl3.txt";
		VARIABLE  inLine      			:LINE;
		VARIABLE  dataRead    			:bit;
		VARIABLE	 char				 		:character;
		VARIABLE  test_rull_packet		:bit_vector(0 to 139);
		VARIABLE  num_sip_dip			:integer;
		VARIABLE  rull_packet			:rull_packet_vector;
		VARIABLE  num						:integer:=0;
		variable	s:Tirnary_bit;
		
		
	begin
			
			
			
			READLINE(inFile, inLine);
			for i in 0 to 31 loop					--read source ip
				READ(inLine,dataRead);
				test_rull_packet(i):=dataRead;
			end loop;
				READ(inLine,char);
			for i in 32 to 37 loop					--read prefix source ip
				READ(inLine,dataRead);
				test_rull_packet(i):=dataRead;
			end loop;
			

						
			for i in 38 to 69 loop					--read dest ip
				READ(inLine,dataRead);
				test_rull_packet(i):=dataRead;
			end loop;
			READ(inLine,char);
			for i in 70 to 75 loop					--read prefix dest ip
				READ(inLine,dataRead);
				test_rull_packet(i):=dataRead;
			end loop;
				
			for i in 76 to 91 loop					--read source port part1
				READ(inLine,dataRead);
				test_rull_packet(i):=dataRead;
			end loop;
			READ(inLine,char);
			
			
			for i in 92 to 107 loop					--read source port part2
				READ(inLine,dataRead);
				test_rull_packet(i):=dataRead;
			end loop;
			

			for i in 108 to 123 loop					--read dest port part1
				READ(inLine,dataRead);
				test_rull_packet(i):=dataRead;
			end loop;
			READ(inLine,char);
			for i in 124 to 139 loop					--read dest port part2
				READ(inLine,dataRead);
				test_rull_packet(i):=dataRead;
			end loop;
			
			
			
			int <= int+1;
			rull_packet_signal<=	test_rull_packet;
			num:=1;
			if (NOT ENDFILE(inFile)) then
				clk<= not clk;
				start<=not start;
				search<='0';
				update<='0';
				add_remove<='1';
				num:=0;
			end if;
			if(num = 1)then
				clk<=not clk;
				search<='1';
				update<='1';
				add_remove<='1';
				num:=0;
				
			end if;
			
			
		
			
	end process;
	

	
	classify: classifier port map(clk,rull_packet_signal,search,update,add_remove, int);


END;
