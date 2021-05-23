--	@C:\Users\alina\Desktop\bd2_lab7\ex1.sql


-- Să se scrie o funcție locală care 
-- primește ca parametru un identificator de departament
-- și returnează numărul salariaților din departamentrul respectiv.

set serveroutput on;
declare
	function f_salariati(p_idDept in number) return number
	as
		nrAng number;
	begin
		select count(distinct empno) into nrAng
			from emp where deptno = p_idDept;
		return nrAng;
	end;
begin
	declare
		numeDept dept.dname%type;
		idDept dept.deptno%type;
		nrAng number;
	begin
		idDept := &idDept;
		select dname into numeDept from dept where deptno = idDept;
		nrAng := f_salariati(idDept);
		dbms_output.put_line('DEpartamentul ' || numeDept
			|| ' are ' || nrAng || ' salariati');
		exception
			when no_data_found then
				dbms_output.put_line('Departament inexistent');		
	end;
end;
/