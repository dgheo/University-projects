--	@C:\Users\alina\Desktop\bd2_lab9\ex1.sql

--Să se scrie un trigger de tip BEFORE care printează un mesaj ori de
--câte ori se face un insert în tabela emp


create or replace trigger insertemp
before insert on emp
begin
	dbms_output.put_line('S-a facut o noua inserare in tabela emp');
end;
/


-- set serveroutput on;
-- insert into emp(empno, ename, sal) values(999, 'Preda', 1500);


-- alter table emp modify empno not null;
-- insert into emp(ename, sal) values('Preda', 1500);
