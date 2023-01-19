----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:51:02 05/11/2014 
-- Design Name: 
-- Module Name:    classifier - Behavioral 
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
  use work.pack.all;
 



entity classifier is
port(
		clk			: in bit;
		rull_packet : in  bit_vector(0 to 139);
		search		: in bit;
		update		: in bit;
		add_remove	: in bit;
		int			: integer
		
);
end classifier;

architecture Behavioral of classifier is
signal clock					:bit;
signal start					:bit:='0';
signal cut1,cut2,cut3,cut4,cut5,cut6,cut7		:bit:='0';
type int32 is array(0 to 31) of integer;
--signal array_temp:counter;

begin
		---------------------------------------------------------------------------------
		add: process(clk,add_remove,search,update)
		 	  
   		  begin
				  if (search='0' and update='0' and add_remove='1') then
						ram_temp((int-1))<=rull_packet;
						--clock <= not clock;
						
				  end if;
				  if (search='1' and update='1' and add_remove='1') then
						ram_temp((int-1))<=rull_packet;
						start <= '1';
						
				  end if;
				  
			  end process;
		----------------------------------------------------------------------------------
		tree:process(start)
			  variable int1,int2 : integer:=0;
			  begin
				if (start'event and start='1') then
					
					for i in 1 to int loop
						int1:=bit_to_int6(ram_temp(i-1)(32 to 37));	
						tempram(i-1)(0)(0 to 31)<=maskip(ram_temp(i-1)(0 to 31),int1);
						int2:=bit_to_int6(ram_temp(i-1)(70 to 75));
						tempram(i-1)(1)(0 to 31)<=maskip(ram_temp(i-1)(38 to 69),int2);		
					end loop;
					cut1<='1';
			  end if;
			  end process;
	--------------------------------------------------------------------------------------------cut1
	cut1_tree:process(cut1)
	type counter1 is array(0 to 1) of int32; 
	variable count:counter1;
	variable temp1,temp2:enteryfuncpref;
	variable test,te:integer;
	variable min:integer:=(2**30-1);
	
	begin
	if(cut1'event and cut1='1')then
		blook(1):=10;
		blook(2):=0;
		blook(3):=1;
		for i in 0 to 31 loop
			for j in 0 to int-1  loop
				temp1(j):=tempram(j)(0)(i);
				temp2(j):=tempram(j)(1)(i);
			end loop;
			--*************************************
			count(0)(i):= pref(temp1,0,num_block,int);--number block 0 with dimention source ip
			count(1)(i):= pref(temp2,0,num_block,int);--number block 0 with dimention dest ip
			--*************************************
			for k in 0 to 1 loop
				if min > count(k)(i)then
					min:=count(k)(i);
					array_tree_make(1):=i;
					if k=0 then
						array_tree_make_dimention(1):='0';
					elsif k=1 then
						array_tree_make_dimention(1):='1';
					end if;
				end if;
			end loop;
			--*************************************
		end loop;
		--*************************************
		for i in 0 to int-1  loop
			if array_tree_make_dimention(1)='1' then
				if tempram(i)(1)(array_tree_make(1))='1' then
					num_block(i):=1;
				elsif tempram(i)(1)(array_tree_make(1))='0' then
					num_block(i):=0;
				else
					num_block(i):=8;
				end if;
			else
				if tempram(i)(0)(array_tree_make(1))='1' then
					num_block(i):=1;
				elsif  tempram(i)(0)(array_tree_make(1))='0' then
					num_block(i):=0;
				else
					num_block(i):=8;
				end if;
			end if;
		end loop;
		
		--*********************************************************
		for k in 0 to 8 loop 
			numberblock(k):=0;
		end loop;
		for k in 0 to int-1 loop
			if num_block(k)=0 then
				numberblock(0):=numberblock(0)+1;
			elsif num_block(k)=1 then
				numberblock(1):=numberblock(1)+1;
			elsif num_block(k)=2 then
				numberblock(2):=numberblock(2)+1;
			elsif num_block(k)=3 then
				numberblock(3):=numberblock(3)+1;
			elsif num_block(k)=4 then
				numberblock(4):=numberblock(4)+1;
			elsif num_block(k)=5 then
				numberblock(5):=numberblock(5)+1;
			elsif num_block(k)=6 then
				numberblock(6):=numberblock(6)+1;
			elsif num_block(k)=7 then
				numberblock(7):=numberblock(7)+1;
			elsif num_block(k)=8 then
				numberblock(8):=numberblock(8)+1;
			end if;	
		end loop;
		--*************************************
		cut2<='1';
	end if;
	end process;
	--------------------------------------------------------------------------------------------cut2
	cut2_tree:process(cut2)
	type counter is array(0 to 3) of int32; 
	variable count:counter;
	variable temp1,temp2:enteryfuncpref;
	variable dim,dim_test,min,test,choose,choose_test,test_test,min_test,te,i_test:integer:=(2**30-1);
	variable control:bit:='0';
	begin
	if(cut2'event and cut2='1')then
		--******************************************************
		for i in 0 to 31 loop
			for j in 0 to int-1  loop
				temp1(j):=tempram(j)(0)(i);
				temp2(j):=tempram(j)(1)(i);
			end loop;
				
				
			
				count(0)(i):= pref(temp1,0,num_block,int);--number block 0 with dimention source ip
				count(1)(i):= pref(temp1,1,num_block,int);--number block 1 with dimention source ip
				count(2)(i):= pref(temp2,0,num_block,int);--number block 0 with dimention dest ip
				count(3)(i):= pref(temp2,1,num_block,int);--number block 1 with dimention dest ip
				
				for k in 0 to 1 loop
					if numberblock(k)<limit then
						count(k)(i):=(2**30-1);
						count(k+2)(i):=(2**30-1);
					end if;
				end loop;
				
				test_test:=0;
				for k in 0 to 3 loop
					if min>count(k)(i) and count(k)(i)>1 then
						min:=count(k)(i);
						test:=i;
						if k=0 or k=1 then
							dim:=0;
						else
							dim:=1;
						end if;
						if k =0 or k=2 then
							choose:=0;
							for j in 1 to 256 loop
								 if blook(j)=0 then
									test_test:=j;
									exit;
								 end if;
							end loop;
							test_test:= test_test/2;

							while test_test > 0 loop
								if k=0 then
									if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
										min:=min_test;
										test:=i_test;
										dim:=dim_test;
										choose:=choose_test;
									end if;
								end if;
								if k=2 then
									if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
										min:=min_test;
										test:=i_test;
										dim:=dim_test;
										choose:=choose_test;
									end if;
								end if;
								test_test:= test_test/2;
							end loop;
								

						else
							choose:=1;
							for j in 1 to 256 loop
								 if blook(j)=1 then
									test_test:=j;
									exit;
								 end if;
							end loop;
							test_test:= test_test/2;
							while test_test > 0 loop
								
								if k=1 then
									if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
										min:=min_test;
										test:=i_test;
										dim:=dim_test;
										choose:=choose_test;
									end if;
								end if;
								if k=3 then
									if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
										min:=min_test;
										test:=i_test;
										dim:=dim_test;
										choose:=choose_test;
									end if;
								end if;
								test_test:= test_test/2;
							end loop;
								

						end if;
					end if;
					min_test:=min;
					i_test:=test;
					dim_test:=dim;
					choose_test:=choose;
				end loop;	
			
	end loop;
--*****************************************		
		for k in 1 to 256 loop
			if blook(k)=choose then
				test_test:=k;
				exit;
			end if;
		end loop;
		for k in 0 to 1 loop
			if choose=k then
				array_tree_make(test_test):=test;
				blook(test_test):=10;
				blook(2*test_test):=k;
				blook(2*test_test+1):=2;
				
			end if;
		end loop;
	--******************************************************
		if (min=count(0)(test) or min=count(1)(test)) and dim=0 then
				array_tree_make_dimention(test_test):='0';
		elsif (min=count(2)(test) or min=count(3)(test)) and dim=1 then
				array_tree_make_dimention(test_test):='1';
		end if;
	--******************************************************
		for i in 0 to int-1  loop
			for k in 2 to 3 loop
					if num_block(i)=choose and array_tree_make_dimention(k)='0' then
						if tempram(i)(0)(array_tree_make(k))='1' then
								num_block(i):=2;
						elsif tempram(i)(0)(array_tree_make(k))='0' then
								num_block(i):=num_block(i);
						else
								num_block(i):=8;
						end if;
					elsif num_block(i)=choose and array_tree_make_dimention(k)='1' then
						if tempram(i)(1)(array_tree_make(k))='1' then
								num_block(i):=2;
						elsif tempram(i)(1)(array_tree_make(k))='0' then
								num_block(i):=num_block(i);
						else
								num_block(i):=8;
						end if;
					end if;
				end loop;
			
		end loop;
		--*********************************************************
		for k in 0 to 8 loop 
			numberblock(k):=0;
		end loop;
		for k in 0 to int-1 loop
			if num_block(k)=0 then
				numberblock(0):=numberblock(0)+1;
			elsif num_block(k)=1 then
				numberblock(1):=numberblock(1)+1;
			elsif num_block(k)=2 then
				numberblock(2):=numberblock(2)+1;
			elsif num_block(k)=3 then
				numberblock(3):=numberblock(3)+1;
			elsif num_block(k)=4 then
				numberblock(4):=numberblock(4)+1;
			elsif num_block(k)=5 then
				numberblock(5):=numberblock(5)+1;
			elsif num_block(k)=6 then
				numberblock(6):=numberblock(6)+1;
			elsif num_block(k)=7 then
				numberblock(7):=numberblock(7)+1;
			elsif num_block(k)=8 then
				numberblock(8):=numberblock(8)+1;
			end if;
		end loop;
		--*********************************************************
		cut3<='1';
		
	end if;
	end process;
	--------------------------------------------------------------------------------------------cut3
	cut3_tree:process(cut3)
	type counter is array(0 to 5) of int32; 
	variable count:counter;
	variable temp1,temp2:enteryfuncpref;
	variable dim,dim_test,min,test,choose,choose_test,test_test,min_test,te,i_test:integer:=(2**30-1);
	variable control:bit:='0';
	begin
	if(cut3'event and cut3='1')then
		for i in 0 to 31 loop
			for j in 0 to int-1  loop
				temp1(j):=tempram(j)(0)(i);
				temp2(j):=tempram(j)(1)(i);
			end loop;
			
				count(0)(i):=pref(temp1,0,num_block,int);	--number block 0 with dimention source ip
				count(1)(i):=pref(temp1,1,num_block,int);	--number block 1 with dimention source ip
				count(2)(i):=pref(temp1,2,num_block,int);	--number block 2 with dimention source ip
				count(3)(i):=pref(temp2,0,num_block,int);	--number block 0 with dimention dest ip
				count(4)(i):=pref(temp2,1,num_block,int);	--number block 1 with dimention dest ip
				count(5)(i):=pref(temp2,2,num_block,int);	--number block 2 with dimention dest ip
				--************************************************
				for k in 0 to 2 loop
					if numberblock(k)<limit then
						count(k)(i):=(2**30-1);
						count(k+3)(i):=(2**30-1);
					end if;
				end loop;
				--************************************************
				for k in 0 to 5 loop
					if min> count(k)(i) and count(k)(i)>1 then
						min:=count(k)(i);
						test:=i;
						if k=0 or k=1 or k=2 then
							dim:=0;
						else 
							dim:=1;
						end if;
						if k =0 or k=3 then
							choose:=0;
							for j in 1 to 256 loop
								 if blook(j)=0 then
									test_test:=j;
								 end if;
							end loop;
							test_test:= test_test/2;

							while test_test > 0 loop
								if k=0 then
									if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
										min:=min_test;
										test:=i_test;
										dim:=dim_test;
										choose:=choose_test;
									end if;
								end if;
								if k=3 then
									if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
										min:=min_test;
										test:=i_test;
										dim:=dim_test;
										choose:=choose_test;
									end if;
								end if;
								test_test:= test_test/2;
							end loop;
								

						elsif k=1 or k=4 then
							choose:=1;
							for j in 1 to 256 loop
								 if blook(j)=1 then
									test_test:=j;
								 end if;
							end loop;
							test_test:= test_test/2;

							while test_test > 0 loop
								if k=1 then
									if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
										min:=min_test;
										test:=i_test;
										dim:=dim_test;
										choose:=choose_test;
									end if;
								end if;
								if k=4 then
									if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
										min:=min_test;
										test:=i_test;
										dim:=dim_test;
										choose:=choose_test;
									end if;
								end if;
								test_test:= test_test/2;
							end loop;
								

						else
							choose:=2;
							for j in 1 to 256 loop
								 if blook(j)=2 then
									test_test:=j;
								 end if;
							end loop;
							test_test:= test_test/2;

							while test_test > 0 loop
								if k=2 then
									if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
										min:=min_test;
										test:=i_test;
										dim:=dim_test;
										choose:=choose_test;
									end if;
								end if;
								if k=5 then
									if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
										min:=min_test;
										test:=i_test;
										dim:=dim_test;
										choose:=choose_test;
									end if;
								end if;
								test_test:= test_test/2;
							end loop;
								

						end if;
					end if;
					min_test:=min;
					i_test:=test;
					dim_test:=dim;
					choose_test:=choose;
				end loop;	
		end loop;
	--******************************************************
		for k in 1 to 256 loop
			if blook(k)=choose then
				test_test:=k;
				exit;
			end if;
		end loop;
		for k in 0 to 2 loop
			if choose=k then
				array_tree_make(test_test):=test;
				blook(test_test):=10;
				blook(2*test_test):=k;
				blook(2*test_test+1):=3;
				
			end if;
		end loop;
	--******************************************************
		if (min=count(0)(test) or min=count(1)(test)or min=count(2)(test))and dim=0 then
				array_tree_make_dimention(test_test):='0';
		elsif (min=count(3)(test) or min=count(4)(test)or min=count(5)(test))and dim=1 then
				array_tree_make_dimention(test_test):='1';
		end if;
	--******************************************************	

		for i in 0 to int-1  loop
				if num_block(i)=choose and array_tree_make_dimention(test_test)='0' then
					if tempram(i)(0)(array_tree_make(test_test))='1' then
							num_block(i):=3;
					elsif tempram(i)(0)(array_tree_make(test_test))='0' then
							num_block(i):=num_block(i);
					else
							num_block(i):=8;
					end if;
				elsif num_block(i)=choose and array_tree_make_dimention(test_test)='1' then
					if tempram(i)(1)(array_tree_make(test_test))='1' then
							num_block(i):=3;
					elsif tempram(i)(1)(array_tree_make(test_test))='0' then
							num_block(i):=num_block(i);
					else
							num_block(i):=8;
					end if;
				end if;
		end loop;
--*********************************************************
		for k in 0 to 8 loop 
			numberblock(k):=0;
		end loop;
		for k in 0 to int-1 loop
			if num_block(k)=0 then
				numberblock(0):=numberblock(0)+1;
			elsif num_block(k)=1 then
				numberblock(1):=numberblock(1)+1;
			elsif num_block(k)=2 then
				numberblock(2):=numberblock(2)+1;
			elsif num_block(k)=3 then
				numberblock(3):=numberblock(3)+1;
			elsif num_block(k)=4 then
				numberblock(4):=numberblock(4)+1;
			elsif num_block(k)=5 then
				numberblock(5):=numberblock(5)+1;
			elsif num_block(k)=6 then
				numberblock(6):=numberblock(6)+1;
			elsif num_block(k)=7 then
				numberblock(7):=numberblock(7)+1;
			elsif num_block(k)=8 then
				numberblock(8):=numberblock(8)+1;
			end if;	
		end loop;

	cut4<='1';
	end if;
	end process;
	-------------------------------------------------------------------------------------------cut4
	cut4_tree:process(cut4)
	type counter is array(0 to 7) of int32; 
	variable count:counter;
	variable temp1,temp2:enteryfuncpref;
	variable dim,dim_test,min,test,choose,choose_test,test_test,min_test,i_test:integer:=(2**30-1);
	variable control:bit:='0';
	begin
	if(cut4'event and cut4='1')then
		for i in 0 to 31 loop
			for j in 0 to int-1 loop
				temp1(j):=tempram(j)(0)(i);
				temp2(j):=tempram(j)(1)(i);
			end loop;
			
				count(0)(i):=pref(temp1,0,num_block,int);	--number block 0 with dimention source ip
				count(1)(i):=pref(temp1,1,num_block,int);	--number block 1 with dimention source ip
				count(2)(i):=pref(temp1,2,num_block,int);	--number block 2 with dimention source ip
				count(3)(i):=pref(temp1,3,num_block,int);	--number block 3 with dimention source ip
				count(4)(i):=pref(temp2,0,num_block,int);	--number block 0 with dimention dest ip
				count(5)(i):=pref(temp2,1,num_block,int);	--number block 1 with dimention dest ip
				count(6)(i):=pref(temp2,2,num_block,int);	--number block 2 with dimention dest ip
				count(7)(i):=pref(temp2,3,num_block,int);	--number block 3 with dimention dest ip
		
				--************************************************
				for k in 0 to 3 loop
					if numberblock(k)<limit then
						count(k)(i):=(2**30-1);
						count(k+4)(i):=(2**30-1);
					end if;
				end loop;
				--************************************************
				
				for k in 0 to 7 loop
					if min> count(k)(i) and count(k)(i)>1 then
						min:=count(k)(i);
						test:=i;
						if k=0 or k=1 or k=2 or k=3 then
							dim:=0;
						else
							dim:=1;
						end if;
						if k =0 or k=4 then
									choose:=0;
									for j in 1 to 256 loop
										 if blook(j)=0 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=0 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=4 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						elsif k=1 or k=5 then
									choose:=1;
									for j in 1 to 256 loop
										 if blook(j)=1 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=1 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=5 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						elsif k=2 or k=6 then
									choose:=2;
									for j in 1 to 256 loop
										 if blook(j)=2 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=2 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=6 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						else
									choose:=3;
									for j in 1 to 256 loop
										 if blook(j)=3 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=3 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=7 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						end if;
					end if;
					min_test:=min;
					i_test:=test;
					dim_test:=dim;
					choose_test:=choose;
				end loop;
		end loop;
	--******************************************************
		for k in 1 to 256 loop
			if blook(k)=choose then
				test_test:=k;
				exit;
			end if;
		end loop;
		for k in 0 to 3 loop
			if choose=k then
				array_tree_make(test_test):=test;
				blook(test_test):=10;
				blook(2*test_test):=k;
				blook(2*test_test+1):=4;
				
			end if;
		end loop;
	--******************************************************		
		if (min=count(0)(test) or min=count(1)(test)or min=count(2)(test) or min=count(3)(test))and dim=0 then
						array_tree_make_dimention(test_test):='0';
		elsif (min=count(4)(test) or min=count(5)(test)or min=count(6)(test) or min=count(7)(test))and dim=1 then
						array_tree_make_dimention(test_test):='1';
		end if;
	--******************************************************					
		for i in 0 to int-1  loop
					if num_block(i)=choose and array_tree_make_dimention(test_test)='0' then
						if tempram(i)(0)(array_tree_make(test_test))='1' then
								num_block(i):=4;
						elsif tempram(i)(0)(array_tree_make(test_test))='0' then
								num_block(i):=num_block(i);
						else
								num_block(i):=8;
						end if;
					elsif num_block(i)=choose and array_tree_make_dimention(test_test)='1' then
						if tempram(i)(1)(array_tree_make(test_test))='1' then
								num_block(i):=4;
						elsif tempram(i)(1)(array_tree_make(test_test))='0' then
								num_block(i):=num_block(i);
						else
								num_block(i):=8;
						end if;
					end if;
			
		end loop;
--*********************************************************
		for k in 0 to 8 loop 
			numberblock(k):=0;
		end loop;
		for k in 0 to int-1 loop
			if num_block(k)=0 then
				numberblock(0):=numberblock(0)+1;
			elsif num_block(k)=1 then
				numberblock(1):=numberblock(1)+1;
			elsif num_block(k)=2 then
				numberblock(2):=numberblock(2)+1;
			elsif num_block(k)=3 then
				numberblock(3):=numberblock(3)+1;
			elsif num_block(k)=4 then
				numberblock(4):=numberblock(4)+1;
			elsif num_block(k)=5 then
				numberblock(5):=numberblock(5)+1;
			elsif num_block(k)=6 then
				numberblock(6):=numberblock(6)+1;
			elsif num_block(k)=7 then
				numberblock(7):=numberblock(7)+1;
			elsif num_block(k)=8 then
				numberblock(8):=numberblock(8)+1;
			end if;
		end loop;


		cut5<='1';
	end if;
	end process;
	
	-------------------------------------------------------------------------------------------cut5
	cut5_tree:process(cut5)
	type counter is array(0 to 9) of int32; 
	variable count:counter;
	variable temp1,temp2:enteryfuncpref;
	variable min,test,dim,dim_test,choose,choose_test,test_test,min_test,i_test:integer:=(2**30-1);
	variable control:bit:='0';
	begin
	if(cut5'event and cut5='1')then
		for i in 0 to 31 loop
			for j in 0 to int-1 loop
				temp1(j):=tempram(j)(0)(i);
				temp2(j):=tempram(j)(1)(i);
			end loop;
			
				count(0)(i):=pref(temp1,0,num_block,int);	--number block 0 with dimention source ip
				count(1)(i):=pref(temp1,1,num_block,int);	--number block 1 with dimention source ip
				count(2)(i):=pref(temp1,2,num_block,int);	--number block 2 with dimention source ip
				count(3)(i):=pref(temp1,3,num_block,int);	--number block 3 with dimention source ip
				count(4)(i):=pref(temp2,4,num_block,int);	--number block 4 with dimention source ip
				count(5)(i):=pref(temp2,0,num_block,int);	--number block 0 with dimention dest ip
				count(6)(i):=pref(temp2,1,num_block,int);	--number block 1 with dimention dest ip
				count(7)(i):=pref(temp2,2,num_block,int);	--number block 2 with dimention dest ip
				count(8)(i):=pref(temp2,3,num_block,int);	--number block 3 with dimention dest ip
				count(9)(i):=pref(temp2,4,num_block,int);	--number block 4 with dimention dest ip
				
				--************************************************
				for k in 0 to 4 loop
					if numberblock(k)<limit then
						count(k)(i):=(2**30-1);
						count(k+5)(i):=(2**30-1);
					end if;
				end loop;
				--************************************************
				
				for k in 0 to 9 loop
					if min> count(k)(i) and count(k)(i)>1 then
						min:=count(k)(i);
						test:=i;
						if k=0 or k=1 or k=2 or k=3 or k=4 then
							dim:=0;
						else
							dim:=1;
						end if;
						if k =0 or k=5 then
									choose:=0;
									for j in 1 to 256 loop
										 if blook(j)=0 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=0 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=5 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						elsif k=1 or k=6 then
									choose:=1;	
									for j in 1 to 256 loop
										 if blook(j)=1 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=1 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=6 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
									

						elsif k=2 or k=7 then
									choose:=2;
									for j in 1 to 256 loop
										 if blook(j)=2 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=2 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=7 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						elsif k=3 or k=8 then
									choose:=3;
									for j in 1 to 256 loop
										 if blook(j)=3 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=3 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=8 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						else
									choose:=4;
									for j in 1 to 256 loop
										 if blook(j)=4 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=4 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=9 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						end if;
					end if;
					min_test:=min;
					i_test:=test;
					dim_test:=dim;
					choose_test:=choose;
				end loop;
		end loop;
	--*************************************************************
	for k in 1 to 256 loop
			if blook(k)=choose then
				test_test:=k;
				exit;
			end if;
		end loop;
		for k in 0 to 4 loop
			if choose=k then
				array_tree_make(test_test):=test;
				blook(test_test):=10;
				blook(2*test_test):=k;
				blook(2*test_test+1):=5;
				
			end if;
		end loop;
	--*************************************************************
	if (min=count(0)(test) or min=count(1)(test)or min=count(2)(test) or min=count(3)(test) or min=count(4)(test))and dim=0 then
						array_tree_make_dimention(test_test):='0';
	elsif (min=count(5)(test) or min=count(6)(test)or min=count(7)(test) or min=count(8)(test) or min=count(9)(test))and dim=1 then
						array_tree_make_dimention(test_test):='1';
	end if;
		--*************************************************************	
		for i in 0 to int-1  loop
					if num_block(i)=choose and array_tree_make_dimention(test_test)='0' then
						if tempram(i)(0)(array_tree_make(test_test))='1' then
								num_block(i):=5;
						elsif tempram(i)(0)(array_tree_make(test_test))='0' then
								num_block(i):=num_block(i);
						else
								num_block(i):=8;
						end if;
					elsif num_block(i)=choose and array_tree_make_dimention(test_test)='1' then
						if tempram(i)(1)(array_tree_make(test_test))='1' then
								num_block(i):=5;
						elsif tempram(i)(1)(array_tree_make(test_test))='0' then
								num_block(i):=num_block(i);
						else
								num_block(i):=8;
						end if;
					end if;
			
		end loop;
		--*********************************************************
		for k in 0 to 8 loop 
			numberblock(k):=0;
		end loop;
		for k in 0 to int-1 loop
			if num_block(k)=0 then
				numberblock(0):=numberblock(0)+1;
			elsif num_block(k)=1 then
				numberblock(1):=numberblock(1)+1;
			elsif num_block(k)=2 then
				numberblock(2):=numberblock(2)+1;
			elsif num_block(k)=3 then
				numberblock(3):=numberblock(3)+1;
			elsif num_block(k)=4 then
				numberblock(4):=numberblock(4)+1;
			elsif num_block(k)=5 then
				numberblock(5):=numberblock(5)+1;
			elsif num_block(k)=6 then
				numberblock(6):=numberblock(6)+1;
			elsif num_block(k)=7 then
				numberblock(7):=numberblock(7)+1;
			elsif num_block(k)=8 then
				numberblock(8):=numberblock(8)+1;
			end if;	
		end loop;

		cut6<='1';
	end if;
	end process;
	
		-------------------------------------------------------------------------------------------cut6
	cut6_tree:process(cut6)
	type counter is array(0 to 11) of int32; 
	variable count:counter;
	variable temp1,temp2:enteryfuncpref;
	variable min,test,dim,dim_test,choose,choose_test,test_test,min_test,i_test:integer:=(2**30-1);
	variable control:bit:='0';
	begin
	if(cut6'event and cut6='1')then
		for i in 0 to 31 loop
			for j in 0 to int-1  loop
				temp1(j):=tempram(j)(0)(i);
				temp2(j):=tempram(j)(1)(i);
			end loop;
			
				count(0)(i):=pref(temp1,0,num_block,int);	--number block 0 with dimention source ip
				count(1)(i):=pref(temp1,1,num_block,int);	--number block 1 with dimention source ip
				count(2)(i):=pref(temp1,2,num_block,int);	--number block 2 with dimention source ip
				count(3)(i):=pref(temp1,3,num_block,int);	--number block 3 with dimention source ip
				count(4)(i):=pref(temp2,4,num_block,int);	--number block 4 with dimention source ip
				count(5)(i):=pref(temp2,5,num_block,int);	--number block 5 with dimention source ip
				count(6)(i):=pref(temp2,0,num_block,int);	--number block 0 with dimention dest ip
				count(7)(i):=pref(temp2,1,num_block,int);	--number block 1 with dimention dest ip
				count(8)(i):=pref(temp2,2,num_block,int);	--number block 2 with dimention dest ip
				count(9)(i):=pref(temp2,3,num_block,int);	--number block 3 with dimention dest ip
				count(10)(i):=pref(temp2,4,num_block,int);--number block 4 with dimention dest ip
				count(11)(i):=pref(temp2,5,num_block,int);--number block 5 with dimention dest ip
			
				--************************************************
				for k in 0 to 5 loop
					if numberblock(k)<limit then
						count(k)(i):=(2**30-1);
						count(k+6)(i):=(2**30-1);
					end if;
				end loop;
				--************************************************
				
				for k in 0 to 11 loop
					if min> count(k)(i) and count(k)(i)>1 then
						min:=count(k)(i);
						test:=i;
						if k=0 or k=1 or k=2 or k=3 or k=4 or k=5 then
							dim:=0;
						else
							dim:=1;
						end if;
						if k =0 or k=6 then
									choose:=0;
									for j in 1 to 256 loop
										 if blook(j)=0 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=0 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=6 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						elsif k=1 or k=7 then
									choose:=1;
									for j in 1 to 256 loop
										 if blook(j)=1 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=1 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=7 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						elsif k=2 or k=8 then
									choose:=2;
									for j in 1 to 256 loop
										 if blook(j)=2 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=2 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=8 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
									

						elsif k=3 or k=9 then
									choose:=3;
									for j in 1 to 256 loop
										 if blook(j)=3 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=3 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=9 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						elsif k=4 or k=10 then
									choose:=4;
									for j in 1 to 256 loop
										 if blook(j)=4 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=4 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=10 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										

						else
									choose:=5;	
									for j in 1 to 256 loop
										 if blook(j)=5 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=5 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=11 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
									

						end if;
					end if;
					min_test:=min;
					i_test:=test;
					dim_test:=dim;
					choose_test:=choose;
				end loop;
		end loop;
	--*************************************************************
		for k in 1 to 256 loop
			if blook(k)=choose then
				test_test:=k;
				exit;
			end if;
		end loop;
		for k in 0 to 5 loop
			if choose=k then
				array_tree_make(test_test):=test;
				blook(test_test):=10;
				blook(2*test_test):=k;
				blook(2*test_test+1):=6;
				
			end if;
		end loop;
	--*************************************************************		
		if (min=count(0)(test) or min=count(1)(test)or min=count(2)(test) or min=count(3)(test) or min=count(4)(test) or min=count(5)(test)) and dim=0 then
				array_tree_make_dimention(test_test):='0';
		elsif (min=count(6)(test) or min=count(7)(test)or min=count(8)(test) or min=count(9)(test) or min=count(10)(test) or min=count(11)(test))and dim=1 then
				array_tree_make_dimention(test_test):='1';
		end if;
				
	--*************************************************************	
		for i in 0 to int-1  loop
					if num_block(i)=choose and array_tree_make_dimention(test_test)='0' then
						if tempram(i)(0)(array_tree_make(test_test))='1' then
								num_block(i):=6;
						elsif tempram(i)(0)(array_tree_make(test_test))='0' then
								num_block(i):=num_block(i);
						else
								num_block(i):=8;
						end if;
					elsif num_block(i)=choose and array_tree_make_dimention(test_test)='1' then
						if tempram(i)(1)(array_tree_make(test_test))='1' then
								num_block(i):=6;
						elsif tempram(i)(1)(array_tree_make(test_test))='0' then
								num_block(i):=num_block(i);
						else
								num_block(i):=8;
						end if;
					end if;
		end loop;
		--*********************************************************
		for k in 0 to 8 loop 
			numberblock(k):=0;
		end loop;
		for k in 0 to int-1 loop
			if num_block(k)=0 then
				numberblock(0):=numberblock(0)+1;
			elsif num_block(k)=1 then
				numberblock(1):=numberblock(1)+1;
			elsif num_block(k)=2 then
				numberblock(2):=numberblock(2)+1;
			elsif num_block(k)=3 then
				numberblock(3):=numberblock(3)+1;
			elsif num_block(k)=4 then
				numberblock(4):=numberblock(4)+1;
			elsif num_block(k)=5 then
				numberblock(5):=numberblock(5)+1;
			elsif num_block(k)=6 then
				numberblock(6):=numberblock(6)+1;
			elsif num_block(k)=7 then
				numberblock(7):=numberblock(7)+1;
			elsif num_block(k)=8 then
				numberblock(8):=numberblock(8)+1;
			end if;	
		end loop;

		cut7<='1';
	end if;
	end process;
		-------------------------------------------------------------------------------------------cut7
	cut7_tree:process(cut7)
	type counter is array(0 to 13) of int32; 
	variable count:counter;
	variable temp1,temp2:enteryfuncpref;
	variable dim,dim_test,min,test,choose,choose_test,test_test,min_test,i_test:integer:=(2**30-1);
	variable control:bit:='0';
	begin
	if(cut7'event and cut7='1')then
		for i in 0 to 31 loop
			for j in 0 to int-1  loop
				temp1(j):=tempram(j)(0)(i);
				temp2(j):=tempram(j)(1)(i);
			end loop;
			
				count(0)(i):=pref(temp1,0,num_block,int);	--number block 0 with dimention source ip
				count(1)(i):=pref(temp1,1,num_block,int);	--number block 1 with dimention source ip
				count(2)(i):=pref(temp1,2,num_block,int);	--number block 2 with dimention source ip
				count(3)(i):=pref(temp1,3,num_block,int);	--number block 3 with dimention source ip
				count(4)(i):=pref(temp2,4,num_block,int);	--number block 4 with dimention source ip
				count(5)(i):=pref(temp2,5,num_block,int);	--number block 5 with dimention source ip
				count(6)(i):=pref(temp2,6,num_block,int);	--number block 6 with dimention source ip
				count(7)(i):=pref(temp2,0,num_block,int);	--number block 0 with dimention dest ip
				count(8)(i):=pref(temp2,1,num_block,int);	--number block 1 with dimention dest ip
				count(9)(i):=pref(temp2,2,num_block,int);	--number block 2 with dimention dest ip
				count(10)(i):=pref(temp2,3,num_block,int);--number block 3 with dimention dest ip
				count(11)(i):=pref(temp2,4,num_block,int);--number block 4 with dimention dest ip
				count(12)(i):=pref(temp2,5,num_block,int);--number block 5 with dimention dest ip
				count(13)(i):=pref(temp2,6,num_block,int);--number block 6 with dimention dest ip				
		
				--************************************************
				for k in 0 to 6 loop
					if numberblock(k)<limit then
						count(k)(i):=(2**30-1);
						count(k+7)(i):=(2**30-1);
					end if;
				end loop;
				--************************************************
				
				for k in 0 to 13 loop
					if min> count(k)(i) and count(k)(i)>1 then
						min:=count(k)(i);
						test:=i;
						if k=0 or k=1 or k=2 or k=3 or k=4 or k=5 or k=6 then
							dim:=0;
						else
							dim:=1;
						end if;
						if k =0 or k=7 then
									choose:=0;
									for j in 1 to 256 loop
										 if blook(j)=0 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=0 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=7 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										
								
						elsif k=1 or k=8 then
									choose:=1;	
									for j in 1 to 256 loop
										 if blook(j)=1 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=1 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=8 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
									
								
						elsif k=2 or k=9 then
									choose:=2;	
									for j in 1 to 256 loop
										 if blook(j)=2 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=2 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=9 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
									
								
						elsif k=3 or k=10 then
									choose:=3;	
									for j in 1 to 256 loop
										 if blook(j)=3 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=3 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=10 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
									
								
						elsif k=4 or k=11 then
									choose:=4;
									for j in 1 to 256 loop
										 if blook(j)=4 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=4 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=11 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										
								
						elsif k=5 or k=12 then
									choose:=5;
									for j in 1 to 256 loop
										 if blook(j)=5 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=5 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=12 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
									
									
						else
									choose:=6;
									for j in 1 to 256 loop
										 if blook(j)=6 then
											test_test:=j;
										 end if;
									end loop;
									test_test:= test_test/2;

									while test_test > 0 loop
										if k=6 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='0' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										if k=13 then
											if array_tree_make(test_test)=i and array_tree_make_dimention(test_test)='1' then
												min:=min_test;
												test:=i_test;
												dim:=dim_test;
												choose:=choose_test;
											end if;
										end if;
										test_test:= test_test/2;
									end loop;
										
									
						end if;
					end if;
					min_test:=min;
					i_test:=test;
					dim_test:=dim;
					choose_test:=choose;
				end loop;
		
								
		end loop;
	--*************************************************************
		for k in 1 to 256 loop
			if blook(k)=choose then
				test_test:=k;
				exit;
			end if;
		end loop;
		for k in 0 to 6 loop
			if choose=k then
				array_tree_make(test_test):=test;
				blook(test_test):=10;
				blook(2*test_test):=k;
				blook(2*test_test+1):=7;
				
			end if;
		end loop;
	--*************************************************************		
			
		if (min=count(0)(test) or min=count(1)(test)or min=count(2)(test) or min=count(3)(test) or min=count(4)(test) or min=count(5)(test)or min=count(6)(test))and dim=0 then
			array_tree_make_dimention(test_test):='0';
		elsif (min=count(7)(test) or min=count(8)(test)or min=count(9)(test) or min=count(10)(test) or min=count(11)(test) or min=count(12)(test)or min=count(13)(test))and dim=1 then
			array_tree_make_dimention(test_test):='1';
		end if;	
	--*************************************************************	
		for i in 0 to int-1  loop
					if num_block(i)=choose and array_tree_make_dimention(test_test)='0' then
						if tempram(i)(0)(array_tree_make(test_test))='1' then
								num_block(i):=7;
						elsif tempram(i)(0)(array_tree_make(test_test))='0' then
								num_block(i):=num_block(i);
						else
								num_block(i):=8;
						end if;
					elsif num_block(i)=choose and array_tree_make_dimention(test_test)='1' then
						if tempram(i)(1)(array_tree_make(test_test))='1' then
								num_block(i):=7;
						elsif tempram(i)(1)(array_tree_make(test_test))='0' then
								num_block(i):=num_block(i);
						else
								num_block(i):=8;
						end if;
					end if;
		end loop;
--*********************************************************
		for k in 0 to 8 loop 
			numberblock(k):=0;
		end loop;
		for k in 0 to int-1 loop
			if num_block(k)=0 then
				numberblock(0):=numberblock(0)+1;
			elsif num_block(k)=1 then
				numberblock(1):=numberblock(1)+1;
			elsif num_block(k)=2 then
				numberblock(2):=numberblock(2)+1;
			elsif num_block(k)=3 then
				numberblock(3):=numberblock(3)+1;
			elsif num_block(k)=4 then
				numberblock(4):=numberblock(4)+1;
			elsif num_block(k)=5 then
				numberblock(5):=numberblock(5)+1;
			elsif num_block(k)=6 then
				numberblock(6):=numberblock(6)+1;
			elsif num_block(k)=7 then
				numberblock(7):=numberblock(7)+1;
			elsif num_block(k)=8 then
				numberblock(8):=numberblock(8)+1;
			end if;	
		end loop;

		
	end if;
	end process;
end Behavioral;

