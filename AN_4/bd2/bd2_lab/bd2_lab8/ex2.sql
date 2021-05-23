--	@C:\Users\alina\Desktop\bd2_lab8\ex2.sql

--Să se scrie un pachet care conține:
-- –O funcție care calculează venitul maxim pe un departament;
-- –O funcție care calculează vechimea cea mai mare în companie, a unui 
--angajat din deprtamentul din care face parte;
-- –O procedură care apelează cele două funcții pentru a face o listă cu 
--angajații care au venitul sau vechimea cea mai mare
--în propriul departament (calculată ca număr de luni complete);

-- –Procedura face o listă care are antetul:
--DEPARTAMENT   NUME    VENIT   VECHIME


create or replace package prima as
	function venit_maxim(nr_dep number) return number;
	function vechime_maxima(nr_dep number) return number;
	procedure calcul;
end prima;
/


create or replace package body prima as
	function venit_maxim(nr_dep number) return number is
		venit_max number;
	begin
		select max(sal+nvl(comm, 0)) into venit_max from emp where deptno=nr_dep;
		return venit_max;
	end venit_maxim;
	
	function vechime_maxima(nr_dep number) return number is
		vec_max number;
	begin
		select max(months_between(sysdate, hiredate)) into vec_max from emp
			where deptno=nr_dep;
		return vec_max;
	end vechime_maxima;  
						   
	procedure calcul is
		cursor c_dep is select distinct deptno from dept;
		w_dep c_dep%rowtype;
		den_dep dept.dname%type;
		nume emp.ename%type;
		data_ang emp.hiredate%type;
		venit_m number;
		vec_m number;
		venit_a number;
		vec_a number;
		venit_prim number;
		vec_prim number;
		ok integer := 0;
	begin
		dbms_output.put_line(rpad('Departament', 15) || rpad('Nume', 10)
			|| rpad('Venit', 10) || rpad('Vechime', 10));
		dbms_output.put_line(rpad('=', 45, '='));

		open c_dep;
		loop
			fetch c_dep into w_dep;					  
			exit when c_dep%notfound;
			begin
				select dname into den_dep from dept where deptno = w_dep.deptno;				  
				venit_m := trunc(prima.venit_maxim(w_dep.deptno));
				vec_m := trunc(prima.vechime_maxima(w_dep.deptno));
				venit_prim := 0;
				vec_prim := 0;	  

				for i in (select distinct empno, ename from emp
					where deptno = w_dep.deptno)
				loop
					ok := 0;
					select trunc(sal+nvl(comm, 0)),						
						trunc(months_between(sysdate, hiredate))
						into venit_a, vec_a from emp where empno = i.empno;
					if venit_a = venit_m and vec_a = vec_m then
						venit_prim := venit_a;
						vec_prim := vec_a;
						ok := 1;
					elsif venit_a = venit_m and vec <> vec_m then
						venit_prim := venit_a;
						vec_prim := 0;
						ok := 1;
					elsif venit_a <> venit_m then
						venit_prim := 0;
						vec_prim := vec_a;
						ok := 1;
					end if;
				end loop;				 
			exception
				when too_many_rows then
					dbms_output.put_line('Exista mai multe inregistrari');
				when no_data_found then
					dbms_output.put_line('Nu exista inregistrari');											 
			end;
		end loop;							 
		close c_dep;							 
	end calcul;
end prima;
/
											 
											 
set serveroutput on;
begin						 
	prima.calcul;										 
end;							 
/										 
