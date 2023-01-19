--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;



 

package pack is
constant width : integer:=64 ;
constant entry_number : integer:=2000 ;
constant limit:integer:=260;
type Tirnary_bit is ( '0' , '1' , 'X' );
--type TCAM_vector_width_data is array( 0 to width-1) of Tirnary_bit;
--type TCAM_MEMORY is array ( natural range <> ) of TCAM_vector_width;
type TCAM_vector_width is array( 0 to 64) of Tirnary_bit;
type tcam_height is array(0 to entry_number) of TCAM_vector_width;

type rull_packet_vector is array(0 to 63) of Tirnary_bit;
--type TCAM_vector_height is array( 0 to entry_number) of bit;
type ipmask is array(0 to 31) of Tirnary_bit;
type ipmask2 is array (0 to 1) of ipmask;
type ram_ipmask is array (0 to entry_number ) of ipmask2;
type RAM is array(0 to entry_number )of bit_vector(0 to 139);
type RAM_MEMORY is array(0 to entry_number)of bit_vector(0 to 9);
type int_array is array(0 to entry_number )of integer; 
type counter is array (0 to 8) of integer;

type array_tree is array(1 to 256)of integer;
type array_tree_dimention is array(1 to 256)of Tirnary_bit;
type enteryfuncpref is array(0 to entry_number )of Tirnary_bit;

signal ram_temp:RAM;
signal tempram:ram_ipmask;
shared variable blook:array_tree:=(others=>10);
shared variable num_block:int_array:=(others=>0);			--number of blocks for ip classified
shared variable array_tree_make:array_tree:=(others=>300); --array for make tree
shared variable array_tree_make_dimention:array_tree_dimention:=(others=>'X');
shared variable numberblock:counter:=(others=>0);
--function

function compare(memory: Tirnary_bit; general:bit ; entry:Tirnary_bit )return boolean;
function resolved(s: bit_vector )return bit;
function resolved2(s: tcam_height )return TCAM_vector_width;
function bit_to_int16(enter:bit_vector(0 to 15))return integer;
function bit_to_int6(enter:bit_vector(0 to 5))return integer;
function minimum(enter1:integer;enter2:integer)return integer;
function minimum_dimention(enter1:integer;enter2:integer;d1:integer;d2:integer)return integer;
function int_to_bit6(enter:integer)return bit_vector;
function maskip (enter:bit_vector(0 to 31);mask :integer) return ipmask;      --return tirnary_bit and use for mask ip
function startip(enter:bit_vector(0 to 31);mask :integer) return bit_vector;		--return start ip in range that defined
function endip(enter:bit_vector(0 to 31);mask :integer) return bit_vector;			--return end ip in range that defined
function complement2(enter:bit_vector(0 to 31)) return bit_vector;					--2's complement
function halfbitvector(startrange:bit_vector(0 to 31);endrange:bit_vector(0 to 31)) return bit_vector;		--return half bit_vector between  two bit_vector
function fulladder(enter1:bit_vector(0 to 31);enter2:bit_vector(0 to 31)) return bit_vector;				--fulladder
function first_grater_than_second(enterip:bit_vector(0 to 31);testip:bit_vector(0 to 31)) return Tirnary_bit;		--comparitor first grater than second return true
function check_ip_in_range(enterip:bit_vector(0 to 31);startip:bit_vector(0 to 31);endip:bit_vector(0 to 31)) return Tirnary_bit;	--check ip in range that we want
function pref(enterram:enteryfuncpref; numblock:integer ; number_block_enter:int_array;number_rull_enter:integer) return integer;
end pack;

package body pack is
-------------------------------------------------------------------------------

function compare(memory: Tirnary_bit; general:bit ; entry:Tirnary_bit )return boolean is
begin
			if(general='0') then
				return true;
			elsif(memory=entry) then
				return true;
			else
				return false;
			end if;
		
end compare;
-------------------------------------------------------------------------------

function bit_to_int16(enter:bit_vector(0 to 15))return integer is
variable int:integer:=0;
begin
			for i in 0 to 15 loop
				if(enter(i)='1') then
				int:= int+ 2**(15-i);
				end if;
			end loop;
		
		return int;
end bit_to_int16;
-------------------------------------------------------------------------------
function bit_to_int6(enter:bit_vector(0 to 5))return integer is
variable int:integer:=0;
begin
			for i in 0 to 5 loop
				if(enter(i)='1') then
				int:= int+ 2**(5-i);
				end if;
			end loop;
		
		return int;
end bit_to_int6;
-------------------------------------------------------------------------------
function int_to_bit6(enter:integer)return bit_vector is
variable temp:bit_vector(0 to 5);
variable tempint:integer;
begin
	tempint:=enter;
	for i in 5 downto 0 loop
		if(tempint mod 2 =1)then
		temp(i):='1';
		else
		temp(i):='0';
		end if;
		tempint:=tempint/2;
	end loop;
return temp;
end int_to_bit6;
-------------------------------------------------------------------------------
function resolved(s: bit_vector )return bit is
begin
	
	return s(s'right);
end resolved;
-------------------------------------------------------------------------------
function resolved2(s: tcam_height )return TCAM_vector_width is
begin
	
	return s(s'right);
end resolved2;

-------------------------------------------------------------------------------
function maskip (enter:bit_vector(0 to 31);mask :integer) return ipmask is
variable temp :ipmask;
begin
		for i in 0 to mask-1 loop
			if enter(i)='1' then
				temp(i):='1';
			else
				temp(i):='0';
			end if;	
		end loop;
		for i in mask to 31 loop
				temp(i):='X';
		end loop;
	return temp;
end maskip;

-------------------------------------------------------------------------------
function startip (enter:bit_vector(0 to 31);mask :integer) return bit_vector is
variable temp :bit_vector(0 to 31);
begin
		for i in 0 to mask-1 loop
			temp(i):=enter(i);
		end loop;
		for i in mask to 31 loop
				temp(i):='0';
		end loop;
	return temp;
end startip;

-------------------------------------------------------------------------------
function endip (enter:bit_vector(0 to 31);mask :integer) return bit_vector is
variable temp :bit_vector(0 to 31);
begin
		for i in 0 to mask-1 loop
			temp(i):=enter(i);
		end loop;
		for i in mask to 31 loop
				temp(i):='1';
		end loop;
	return temp;
end endip;

-------------------------------------------------------------------------------
function first_grater_than_second(enterip:bit_vector(0 to 31);testip:bit_vector(0 to 31)) return Tirnary_bit is
variable temp1			:Tirnary_bit:='X';
variable temp			:bit_vector(0 to 31);
begin
		temp(0 to 31):=enterip(0 to 31);
		for i in 31 downto 0 loop
			if(enterip(i)='1' and testip(i)='0')then
				temp(0 to 31):=enterip(0 to 31);
			elsif(enterip(i)='0' and testip(i)='1')then
				temp(0 to 31):= testip(0 to 31);
			end if;
		end loop;
		
		if temp=enterip and temp=testip then
			temp1:='X';
		elsif temp=enterip then
			temp1:='1';
		elsif temp=testip then
			temp1:='0';
		end if;
return temp1;
end first_grater_than_second;
-------------------------------------------------------------------------------
function check_ip_in_range(enterip:bit_vector(0 to 31);startip:bit_vector(0 to 31);endip:bit_vector(0 to 31)) return Tirnary_bit is
variable temp1:Tirnary_bit:='1';
variable temp2:Tirnary_bit:='1';
variable temp3:Tirnary_bit:='1';
begin
	temp1:=first_grater_than_second(enterip,startip);
	temp1:=first_grater_than_second(endip,enterip);
	
	if temp1='1' and temp2='1' then
			temp3:='1';
	elsif temp1='0' and temp2='1' then
			temp3:='0';
	elsif temp1='1' and temp2='0' then
			temp3:='0';
	elsif temp1='X' and temp2='X' then
			temp3:='1';
	elsif temp1='X' and temp2='1' then
			temp3:='1';
	elsif temp1='1' and temp2='X' then
			temp3:='1';
	end if;
	return temp3;
end check_ip_in_range;
-------------------------------------------------------------------------------
function halfbitvector(startrange:bit_vector(0 to 31);endrange:bit_vector(0 to 31)) return bit_vector is
variable temp:bit_vector(0 to 31);
begin
temp:=complement2(startrange);
temp:=fulladder(temp,endrange);
temp(0 to 31):= '0'&temp(0 to 30);
temp:=fulladder(startrange,temp);

return temp;
end halfbitvector;
-------------------------------------------------------------------------------
function complement2(enter:bit_vector(0 to 31)) return bit_vector is
variable temp:bit_vector(0 to 31);
variable counter:integer:=0;
begin


for i in 31 downto 0 loop
temp(i):=enter(i);
if(enter(i)='1')then
counter:=i;
exit;
end if;
end loop;
for i in counter-1 downto 0 loop
temp(i):= not enter(i);
	
end loop;
return temp;
end complement2;
-------------------------------------------------------------------------------
function fulladder(enter1:bit_vector(0 to 31);enter2:bit_vector(0 to 31)) return bit_vector is
variable sum:bit_vector(0 to 31);
variable c:bit;
begin
c:='0';
for i in 31 downto 0 loop
	sum(i):= enter1(i) xor enter2(i) xor c;
	c:=(enter1(i) and enter2(i))or(enter1(i) and c)or(c and enter2(i));
end loop;

return sum;
end fulladder;
-------------------------------------------------------------------------------
function pref(enterram:enteryfuncpref; numblock:integer ; number_block_enter:int_array;number_rull_enter:integer) return integer is

variable count1,count2,count3 :integer:=0;
variable count:counter:=(others=>0);
begin

		for i in 0 to (number_rull_enter-1) loop
					if numblock=number_block_enter(i) then
						if enterram(i)='1' then
							count1:=count1+1;
						elsif	enterram(i)='0' then
							count2:=count2+1;	
						elsif enterram(i)='X' then
							count1:=count1+1;
							count2:=count2+1;
						end if;
					end if;
					if number_block_enter(i)=0 then
						count(0):=count(0)+1;
					elsif number_block_enter(i)=1 then
						count(1):=count(1)+1;
					elsif number_block_enter(i)=2 then
						count(2):=count(2)+1;
					elsif number_block_enter(i)=3 then
						count(3):=count(3)+1;
					elsif number_block_enter(i)=4 then
						count(4):=count(4)+1;
					elsif number_block_enter(i)=5 then
						count(5):=count(5)+1;
					elsif number_block_enter(i)=6 then
						count(6):=count(6)+1;
					elsif number_block_enter(i)=7 then
						count(7):=count(7)+1;
					end if;
		end loop;
				for k in 0 to 7 loop
					if numblock=k then
						count(k):=0;
					end if;
				end loop;	
			
		count3:= (count1**2) +(count2**2)+(count(0)**2)+(count(1)**2)+(count(2)**2)+(count(3)**2)+(count(4)**2)+(count(5)**2)+(count(6)**2)+(count(7)**2);

	

return count3;
end pref;

-------------------------------------------------------------------------------
function minimum(enter1:integer;enter2:integer)return integer is
variable min:integer:=2**31-1;
begin
	
	if enter1<enter2 then
		min:=enter1;
	else
		min:=enter2;
	end if;
	

return min;
end minimum;

-------------------------------------------------------------------------------
function minimum_dimention(enter1:integer;enter2:integer;d1:integer;d2:integer)return integer is

begin

if enter1>enter2 then
	return d2;
else
	return d1;
end if;
end minimum_dimention;
-------------------------------------------------------------------------------
end pack;
