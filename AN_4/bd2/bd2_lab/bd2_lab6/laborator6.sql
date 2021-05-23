--   @C:\Users\alina\Desktop\bd2_lab6\enunt.txt

-- DEN_DEPT NUME GR_SAL DATA_ANG ANI_VEC PRIMA  salariu OBS

-- sa se scrie o procedura :
-- pt calculul primei angajatilor dupa urm alg:
-- 1) PRIMA =(GR_SAL * 5%) * SAl_MED_DEPT
-- 2) ANI_VEC < 35 atunci exceptii  prima diminuata cu 10%
-- obs= 'Prima diminuata'

-- grad salarizare in tabela salgrade


set serveroutput on;
declare
	procedure calculPrima
	as
		cursor c_calculPrima is select * from emp order by deptno;
		randCalculPrima c_calculPrima%rowtype;
		type r_calculPrima is record(
			numeDept dept.dname%type,
			numeAng emp.ename%type,
			gradSal number,
			dataAng emp.hiredate%type,
			aniVechime number,
			salariu emp.sal%type,
			prima number,
			obs varchar2(30)
		);
	calculPrima r_calculPrima;
	sal_med_dept emp.sal%type;
	exceptie exception;
		
	begin
		open c_calculPrima;
		loop
			fetch c_calculPrima into randCalculPrima;
			exit when c_calculPrima%notfound;
			
			select dname into calculPrima.numeDept from dept
				where deptno = randCalculPrima.deptno;
				
			calculPrima.numeAng := randCalculPrima.ename;
				
			select grade into calculPrima.gradSal from salgrade
				where randCalculPrima.sal >= losal and randCalculPrima.sal <= hisal;
				
			calculPrima.dataAng := randCalculPrima.hiredate;
			
			calculPrima.salariu := randCalculPrima.sal;
			
			select round(avg(sal)) into sal_med_dept from emp
				where deptno = randCalculPrima.deptno;
			
			calculPrima.prima := calculPrima.gradSal * round(0.5*sal_med_dept);
			
			calculPrima.aniVechime := trunc(months_between(sysdate, randCalculPrima.hiredate)/12);

			begin 
				if calculPrima.aniVechime < 35 then
					raise exceptie;
				end if;
			exception
				when exceptie then calculPrima.prima := calculPrima.prima - calculPrima.prima/10;
				calculPrima.obs := 'primaScazuta';
			end;
			
			dbms_output.put_line(rpad(calculPrima.numeDept, 20) || rpad(calculPrima.numeAng, 20) ||
				rpad(calculPrima.gradSal, 10) || rpad(calculPrima.dataAng, 20) ||
				rpad(calculPrima.aniVechime, 10) || rpad(calculPrima.prima, 20) ||
				rpad(calculPrima.salariu, 10) || lpad(calculPrima.obs, 20));
			
			
			
		end loop;
	end;
begin
	dbms_output.put_line('LISTA PRIME');
	dbms_output.put_line(rpad('DEN_DEP', 20) || rpad('NUME', 20) ||
		rpad('GR_SAL', 10) || rpad('DATA_ANG', 20) ||
		rpad('ANI_VEC', 10) || rpad('PRIMA', 20) ||
		rpad('SALARIU', 10) || lpad('OBS', 20));
	dbms_output.put_line(rpad('=', 20, '=') || rpad('=', 20, '=') ||
		rpad('=', 10, '=') || rpad('=', 10, '=') ||
		rpad('=', 10, '=') || rpad('=', 20, '=') ||
		rpad('=', 10, '=') || lpad('=', 20, '='));
		
	calculPrima;
end;
/
			
			
			
			