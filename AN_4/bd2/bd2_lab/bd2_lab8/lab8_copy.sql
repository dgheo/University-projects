--	@C:\Users\alina\Desktop\bd2_lab8\laborator8.sql

-- Sa se scrie un package care contine o functie si o procedura
-- care face o lista cu cel bine platit si 
-- cel mai prost platit subaltern pe fiecare sef de departament
--daca un sef are un singur subaltern ->  exceptie si venit_max =yes

-- LISTA SUBALTERNI
-- 	NUME_SEF	NUME_SUB	VENIT_SUB	VENIT_MAX(y/n)



-- PAS I: creare specificatii
create or replace package p_subalterni as
	-- returneaza nr de subalterni cu min/max
	function venit_min_max(f_idSef in emp.empno%type, f_idMin out emp.empno%type, f_idMax out emp.empno%type) return boolean;
	procedure prelucrare;
end p_subalterni;
/

-- PAS II: creare corp pachet
create or replace package body p_subalterni as
	function venit_min_max(f_idSef in emp.empno%type, f_idMin out emp.empno%type, f_idMax out emp.empno%type)
	return boolean
	is
		unSubaltern boolean;
		salMin emp.sal%type;
		salMax emp.sal%type;
		unAngajat exception;
	begin
		unSubaltern := false;
		
		select min(sal), max(sal) into salMin, salMax from emp where mgr = f_idSef;
	--	select max(sal) into salMax from emp where mgr = f_idSef;
		
		select empno into f_idMin from emp where sal=salMin and mgr=f_idSef;
		select empno into f_idMax from emp where sal=salMax and mgr=f_idSef;
		
		if f_idMin = f_idMax then
			raise unAngajat;
		end if;
		
		exception
			when too_many_rows then
				select empno into f_idMin from emp 
					where sal=salMin and mgr=f_idSef fetch first row only;
				select empno into f_idMax from emp 
					where sal=salMax and mgr=f_idSef offset 1 rows fetch next 1 rows only;
			when unAngajat then
				unSubaltern := true;
				
		return unSubaltern;
	end venit_min_max;

	
	procedure prelucrare is
		cursor c_sef is select empno from emp where lower(job) = 'manager';
		w_sef c_sef%rowtype;
		nume_sef emp.ename%type;
		unSub boolean;
		idMin emp.empno%type;
		idMax emp.empno%type;
		numeMin emp.ename%type;
		numeMax emp.ename%type;
		venitMin emp.sal%type;
		venitMax emp.sal%type;
	begin
		-- antetul listei
		dbms_output.put_line(rpad('LISTA CANDIDATI', 30,' '));
		dbms_output.put_line(rpad('NUME_SEF', 20) || rpad('NUME_SUB', 20)
			|| rpad('VENIT_SUB', 20) || rpad('VENIT_MAX(y/n)', 20));
		dbms_output.put_line(rpad('=', 80, '='));
		
		open c_sef;
		loop
			fetch c_sef into w_sef;
			exit when c_sef%notfound;
			begin
				select ename into nume_sef from emp where empno = w_sef.empno;
				
				unSub := venit_min_max(w_sef.empno, idMin, idMax);
				
				if unSub in (false) then
					select ename, sal into numeMin, venitMin from emp where empno = idMin;
					select ename, sal into numeMax, venitMax from emp where empno = idMax;
				
					dbms_output.put_line(rpad(nume_sef, 20) || rpad(numeMin, 20)
						|| rpad(venitMin, 20) || rpad('', 20));
					dbms_output.put_line(rpad(nume_sef, 20) || rpad(numeMax, 20)
						|| rpad(venitMax, 20) || rpad('', 20));
				elsif unSub in (true) then
					select ename, sal into numeMax, venitMax from emp where empno = idMax;
					dbms_output.put_line(rpad(nume_sef, 20) || rpad(numeMax, 20)
						|| rpad(venitMax, 20) || rpad('y', 20));
				end if;
			end;
		end loop;
		close c_sef;
	end prelucrare;
end p_subalterni;
/
					
				
				
set serveroutput on;
begin						 
	p_subalterni.prelucrare;										 
end;							 
/	

