--Lista Prime

--DEN_DEPARTAMENT, NMUE_ANGAJAT, JOB, SALARIU, COMISION, SAL_MED_DEPT, PRIMA

--1)ang fara comision -> prima=20% * SAL_MED_DEPT
--2)ang cu com -> prima = 10% * SAL_MED_DEPT
--3)presedinte si manager -> nu primesc prima


set serveroutput on;
declare
	numeDepartament dept.dname%type;
	idDep emp.deptno%type;
	numeAngajat varchar2(20);
	functie varchar2(15);
	salariu emp.sal%type;
	comAngajat number;
	salMedDept emp.sal%type;
	prima emp.sal%type;
	contor integer := 7000;
begin
	dbms_output.put_line(rpad('DEN_DEPARTAMENT', 30, '=') ||
		rpad('NMUE_ANGAJAT', 15, '=') ||
		rpad('JOB', 15, '=') ||
		rpad('SALARIU', 15, '=') ||
		rpad('COMISION', 15, '=') ||
		
		lpad('PRIMA', 10, '='));
		
				CREATE TABLE PRIME
        (DEN_DEPARTAMENT dept.dname%type,
		 NMUE_ANGAJAT varchar2(20), 
		 JOB varchar2(15), 
		 SALARIU emp.sal%type, 
		 COMISION number, 
		 SAL_MED_DEPT emp.sal%type, 
		 PRIMA emp.sal%type);

	
		 
	
 
	loop
		contor := contor + 1;
		begin
			select ename, job, sal, comm, deptno
				into numeAngajat, functie, salariu, comAngajat, idDep
				from emp
				where empno = contor;
			select dname into numeDepartament from dept where deptno = idDep;
			
			
			select avg(sal) into salMedDept from emp where deptno=idDep;
			
			if lower(functie) = 'manager' or lower(functie) = 'president'
			then
				prima := 0;
			elsif (comAngajat = 0 or comAngajat is null)
			then
				prima := 0.20 * salMedDept;
			elsif comAngajat > 0
			then 
				prima := 0.10 * salMedDept;
			end if;
				
			dbms_output.put_line('Angajatul ' ||
				numeAngajat || ' din dep=' || numeDepartament ||
				'cu sal=' || salariu ||
				', functia=' || functie ||
				' are prima=' || prima || 'salMedDept=' || salMedDept);
		
		exception 
			when no_data_found then null;
		end;
		exit when contor=8000;
	end loop;
	exception 
		when no_data_found then 
			dbms_output.put_line('Nu exista angajat');
end;
/


