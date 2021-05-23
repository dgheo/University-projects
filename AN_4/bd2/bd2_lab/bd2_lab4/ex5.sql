--@E:\bd2_lab4\ex5.txt
--alter table emp add constraint pk_empno primary key(empno);
set serveroutput on;
declare
	idDept integer;
	contor integer := 7000;
	numeAngajat emp.ename%type;
	comision emp.comm%type;
	dataAngajare emp.hiredate%type;
	lipsaComision exception;
begin
	idDept :=&idDept;
	dbms_output.put_line(rpad('Nume',15,' ')
		|| rpad('Data angajare',20,' ') || lpad('Comision',15,' '));
	dbms_output.put_line(rpad('=',15,'=')
		|| rpad('=',20,'=') || lpad('=',15,'='));
	loop
		contor := contor + 1;
		begin
			select ename, hiredate, comm
				into numeAngajat, dataAngajare, comision
				from emp where deptno=idDept and empno=contor;
			if comision is null then
				raise lipsaComision;
			end if;
			dbms_output.put_line(rpad(numeAngajat,15,' ')
				|| rpad(dataAngajare,20,' ') || lpad(comision,15,' '));
	exception
		when lipsaComision then
			dbms_output.put_line(rpad(numeAngajat,15,' ')
				|| rpad(dataAngajare,20,' ') || lpad('lipsa comision',15,' '));
		when no_data_found then null;
		when others then null;
	end;
	exit when contor=8000;
end loop;
end;
/