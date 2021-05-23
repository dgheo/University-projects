set serveroutput on;
declare
	numeAngajat varchar2(30);
	ecuson emp.empno%type;
	dataAngajare date;
begin
	ecuson := &idAng;
	select ename, hiredate into numeAngajat, dataAngajare
		from emp where empno = ecuson;	
	if dataAngajare < add_months(sysdate, -384)
	then
		update emp set comm = 0.1 * sal where empno=ecuson;
		dbms_output.put_line('Angajatul ' || numeAngajat || ' a primit comision!');
	else
		dbms_output.put_line('Angajatul nu indeplineste conditia!');
	end if;
	exception
		when no_data_found then
			dbms_output.put_line('Nu exista angajat cu ecusonul=' || ecuson);
end;
/