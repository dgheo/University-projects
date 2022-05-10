--	@C:\Users\alina\Desktop\bd2_lab8\ex1.sql

-- show errors;

--Să se scrie un pachet p_angajare, care conține o funcție și o
--procedură, pentru a face o listă cu angajații care au venit în firmă înaintea
--unui director al companiei(care le este șef direct) și au primit comision.
--Șeful direct al unui angajat este specificat în coloana mgr. Procedura va
--insera rezultatele în tabela lista2.



-- PAS I: creare tabela
create table lista2
(
	den_dep varchar2(20),
	nume_sef varchar2(20),
	data_sef date,
	nume_sub varchar2(20),
	data_sub date,
	com_sub number
);
/


-- PAS II: creare specificatii
create or replace package angajare as
	cursor depart is select deptno, dname from dept order by deptno;
	v_dep depart%rowtype;
	function vechime(data_ang date, data_ang_sef date) return boolean;
	procedure prelucrare;
end angajare;
/


-- PAS III: creare corp pachet
create or replace package body angajare as
	function vechime(data_ang date, data_ang_sef date)
	return boolean
	is
		verif boolean;
	begin
		if data_ang < data_ang_sef then
			verif := true;
		else
			verif := false;
		end if;
		
		return verif;
	end vechime;
	
	procedure prelucrare is
		cursor c_ang is select * from emp;
		w_c c_ang%rowtype;
		sef number(4);
		nume_sef varchar2(20);
		data_ang_sef date;
		nume varchar2(20);
		conditie boolean;
	begin
		delete from lista2;
		for i in angajare.depart
		loop
			begin
				select empno, ename, hiredate into sef, nume_sef, data_ang_sef
					from emp where deptno = i.deptno and lower(job) = 'manager';
			exception
				when no_data_found then sef := 0;
			end;
			
			open c_ang;
			loop
				fetch c_ang into w_c;
				exit when c_ang%notfound;
				
				if w_c.mgr = sef then
					conditie := vechime(w_c.hiredate, data_ang_sef);
					if conditie in (true) and nvl(w_c.comm, 0) <> 0 then
						insert into lista2 values(i.dname, nume_sef, data_ang_sef,
							w_c.ename, w_c.hiredate, w_c.comm);
					end if;
				end if;
			end loop;
			close c_ang;
		end loop;
	end prelucrare;
end angajare;
/


-- PAS IV: executie pachet
begin
	angajare.prelucrare;
end;
/


-- PAS V: rezultat executie
select * from lista2;
--/

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		