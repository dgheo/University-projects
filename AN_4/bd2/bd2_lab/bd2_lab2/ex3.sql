set serveroutput on;
declare
	numeAngajat varchar2(20);
	functie string(20);
	dataMax date;
	vechime interval year(2) to month;
begin
	vechime := interval '29-6' year to month;
	dbms_output.put_line('Vechimea solicitata = ' || vechime);
	select hiredate into dataMax from emp
		where hiredate < sysdate - vechime;
	dbms_output.put_line('Data maxima ' || dataMax);
	select ename, job into numeAngajat, functie
		from emp where hiredate = dataMax;
	dbms_output.put_line('Angajatul cu vechimea cautata este ' ||
		numeAngajat || ' si are functia ' || functie);
	exception
		when no_data_found then
			dbms_output.put_line('Nu exista angajati cu aceasta vechime');
		when too_many_rows then
			dbms_output.put_line('Sunt mai multi angajati cu aceasta vechime');
end;
/
		