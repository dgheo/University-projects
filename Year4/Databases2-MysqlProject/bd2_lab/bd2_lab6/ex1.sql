--   @C:\Users\alina\Desktop\bd2_lab6\ex1.txt

set verify off
set serveroutput on
declare
	procedure procFaraParam
	as
	begin
		dbms_output.put_line('Am apelat o procedura fara parametri');
	end;
begin
	procFaraParam();
end;
/