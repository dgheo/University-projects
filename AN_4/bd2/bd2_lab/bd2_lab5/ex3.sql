--	@C:\Users\alina\Desktop\bd2_lab5\ex3.sql


-- Exemplu corect de folosire a unui cursor implicit
-- care returnează mai multe înregistrări
-- (se folosește un nested table în care se inserează
-- salariile angajaților din departamentul 20)

set serveroutput on;
declare
	type nestedTable is table of emp.sal%type;
	salariu nestedTable;
begin
	select sal bulk collect into salariu from emp where deptno = 20;
end;
/
