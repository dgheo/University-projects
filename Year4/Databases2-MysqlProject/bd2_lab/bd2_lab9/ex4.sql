--	@C:\Users\alina\Desktop\bd2_lab9\ex4.sql

-- Să se scrie un trigger de tip BEFORE care afișează un mesaj ori de 
--câte ori se face un insert în tabela EMP, doar dacă salariul noului angajat 
--este strict mai mare de 500 și strict mai mic de 5000.

create or replace trigger insertemp2
before insert on emp
for each row
when (new.sal > 500 and new.sal < 5000)
begin
	dbms_output.put_line('ex4: S-a facut o noua inserare in tabela emp');
end;
/


-- set serveroutput on;
-- insert into emp(empno, ename, sal) values(1111, 'Frunza', 5500);
-- rollback;
