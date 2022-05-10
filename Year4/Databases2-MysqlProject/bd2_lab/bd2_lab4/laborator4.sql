--Lista venituri
-- Den_Dep_Ang Nume_Ang Venit_Ang Nume_Sef Venit_Sef

-- sa se scrie un bloc pl/sql care face o lista cu angajatii care 
-- au venituri mai mare decat jum din venitul sefului si
-- au venit in firma inaintea lui

--ang care nu au sef vor fi tratati ca o exceptie



--@E:\bd2_lab4\enunt.txt
set serveroutput on;
declare
	contor integer := 7000;
	numeDepartament dept.dname%type;
	idDept emp.deptno%type;
	numeAngajat emp.ename%type;
	venitAngajat emp.sal%type;
	dataAngajat emp.hiredate%type;
	dataSef emp.hiredate%type;
	numeSef emp.ename%type;
	idSef emp.mgr%type;
	venitSef emp.sal%type;
	lipsaSef exception;
begin
	dbms_output.put_line(rpad('LISTA VENITURI', 30,' '));
	dbms_output.put_line(rpad('Den_Dep_Ang',15,' ')
		|| rpad('Nume_Ang',15,' ') || rpad('Venit_Ang',15,' ') 
		|| rpad('Nume_Sef',15,' ') || lpad('Venit_Sef',15,' '));
	dbms_output.put_line(rpad('=',15,'=')
		|| rpad('=',15,'=') || rpad('=',15,'=') 
		|| rpad('=',15,'=') || lpad('=',15,'='));
	loop
		contor := contor + 1;
		begin
			select ename, deptno, sal+nvl(comm, 0), mgr, hiredate
				into numeAngajat, idDept, venitAngajat, idSef, dataAngajat
				from emp where empno=contor;
			if idSef is null then
				raise lipsaSef ;
			end if;
			select dname into numeDepartament 
				from dept where deptno=idDept;
			select ename, sal+nvl(comm, 0), hiredate
				into numeSef, venitSef, dataSef
				from emp where empno=idSef;
			
			if (dataAngajat < dataSef)  and (venitAngajat > venitSef/2) then
				dbms_output.put_line(rpad(numeDepartament ,15,' ')
					|| rpad(numeAngajat ,15,' ') || rpad(venitAngajat ,15,' ') 
					|| rpad(numeSef ,15,' ') || lpad(venitSef ,15,' '));
			end if;
	exception
		when lipsaSef then
			dbms_output.put_line(rpad(numeDepartament ,15,' ')
				|| rpad(numeAngajat ,15,' ') || rpad(venitAngajat ,15,' ') 
				|| rpad('lipsa sef' ,15,' ') || lpad('--',15,' '));
		when no_data_found then null;
		when others then null;
	end;
	exit when contor=8000;
end loop;
end;
/