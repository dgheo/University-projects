set serveroutput on;
declare
	numeAngajat varchar2(20);
	venit number;
	gradSalariu integer;
	impozit number;
	ecuson emp.empno%type;
begin
	ecuson := &idAngajat;
	select ename, sal+nvl(comm, 0) into numeAngajat, venit
		from emp where empno = ecuson;
	select grade  into gradSalariu from salgrade
		where losal<=venit and venit<=hisal;
		
	<<mycase>> -- exemplu de folosire eticheta(nu este obligatorie)
	case gradSalariu
		when 1 then impozit := venit*0.10;
		when 2 then impozit := venit*0.15;
		when 3 then impozit := venit*0.20;
		when 4 then impozit := venit*0.25;
	else
		impozit := venit*0.30;
	end case mycase;
	
	dbms_output.put_line('Angajatul ' || numeAngajat ||
		' are venitul=' || venit || ' si un impozit=' || impozit);
	exception 
		when no_data_found then 
			dbms_output.put_line('Nu exista angajat cu ecusonul = ' || ecuson);
end;
/		