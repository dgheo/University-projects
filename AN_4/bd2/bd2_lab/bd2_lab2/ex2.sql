set serveroutput on;
declare
	numeAngajat varchar2(20);
	functie string(30);
	dataMax date;
	dataInceput date := '1-JAN-1982';
	dataSfarsit date := '31-DEC-1982';
begin
	select max(hiredate) into dataMax from emp
		where hiredate between dataInceput and dataSfarsit;
	select ename, job into numeAngajat, functie
		from emp where hiredate = dataMax;
	dbms_output.put_line('Ultimul angajat venit in firma
		in anul 1982 este ' || numeAngajat || ' si are functia ' || functie);
	exception
		when no_data_found then
			dbms_output.put_line('Nu a fost angajat nimeni in 1982');
		when too_many_rows then
			dbms_output.put_line('Sunt mai multe angajari in ultima zi');
end;
/
		