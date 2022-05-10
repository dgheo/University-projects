set serveroutput on;
declare
	numeAngajat varchar2(20);
	comAngajat number;
	functie varchar2(15);
	ecuson emp.empno%type;
begin 
	ecuson := &idAngajat;
	select ename, job, comm into numeAngajat, functie, comAngajat 
		from emp 
		where empno = ecuson; 
	if lower(functie) = 'president'
	then 
		dbms_output.put_line('Presedintele nu primeste comision!');
	elsif lower(functie) = 'manager' and (comAngajat = 0 or comAngajat is null)
	then
		update emp set comm = 0.1*sal where empno = ecuson; 
		dbms_output.put_line('Comisionul lui ' ||
			numeAngajat || ' a fost modificat!');
	else
		dbms_output.put_line('Angajatul nu face parte din conducere!');
	end if;
	exception 
		when no_data_found then 
			dbms_output.put_line('Nu exista angajat cu empno = ' || ecuson);
end;
/