set serveroutput on;
declare
	idemp number(4) := 7839;
	nume varchar(10);
begin
	select ename into nume from emp where empno = idemp;
	dbms_output.put_line('Numele angajatului este: ' || nume);
exception
	when no_data_found then
		dbms_output.put_line('Nu am gasit angajatul cu id-ul ' || idemp);
end;
/		