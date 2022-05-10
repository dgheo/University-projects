--@E:\bd2_lab4\ex3.txt
--alter table emp add constraint pk_empno primary key(empno);
set serveroutput on;
declare
	insert_angajat exception;
	pragma exception_init(insert_angajat, -01400);
begin
	insert into emp(ename, hiredate, sal)
		values('Niculescu', '14-AUG-2010', 1450);
	exception
		when insert_angajat then
			dbms_output.put_line('Nu se accepta inregistrari ' ||
				' noi in tabela emp fara empno.');
			dbms_output.put_line('Cod eroare SQL ' || SQLCODE);
			dbms_output.put_line('Mesaj ' || SQLERRM);
end;
/