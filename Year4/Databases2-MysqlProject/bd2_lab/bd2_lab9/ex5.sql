--	@C:\Users\alina\Desktop\bd2_lab9\ex5.sql

-- Să se scrie un trigger de tip AFTER care se declanșează dacă salariul 
--unui angajat este majorat

create or replace trigger majorareSal
after update on emp
for each row
when (new.sal > old.sal)
begin
	dbms_output.put_line('Salariul lui ' || :old.ename
		|| ' a fost majorat de la ' || :old.sal || ' la ' || :new.sal);
end;
/


-- set serveroutput on;
-- update emp set sal = 3000 where empno = 7566;
-- rollback;

