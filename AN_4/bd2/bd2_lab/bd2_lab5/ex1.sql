--	@C:\Users\alina\Desktop\bd2_lab5\ex1.sql


-- Exemplu greșit de folosire a unui cursor implicit
-- (returnează mai multe valori care nu pot să fie inserate în variabila salariu):

set serveroutput on;
declare
	salariu number;
begin
	select sal into salariu from emp where deptno = 20;
end;
/
