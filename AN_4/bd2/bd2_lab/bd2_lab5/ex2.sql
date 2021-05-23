--	@C:\Users\alina\Desktop\bd2_lab5\ex2.sql


-- Exemplu corect de folosire a unui cursor implicit
-- (clauza where conține o condiție care garantează că se va întoarce o singură valoare)

set serveroutput on;
declare
	salariu number;
begin
	select sal into salariu from emp where empno = 7499;
end;
/
