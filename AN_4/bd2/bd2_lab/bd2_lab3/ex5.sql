set serveroutput on;
declare
	grade float := 7.2;
begin
	case
		when grade >=9 then dbms_output.put_line('excelent');
		when grade >=8 and grade<9 then dbms_output.put_line('very good');
		when grade >=7 and grade<8 then dbms_output.put_line('good');
		when grade >=6 and grade<7 then dbms_output.put_line('fair');
		when grade <5 then dbms_output.put_line('poor');
		else dbms_output.put_line('no such grade');
	end case;
end;
/