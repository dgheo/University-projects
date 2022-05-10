--	@C:\Users\alina\Desktop\bd2_lab9\laborator9.sql


-- LOG SALARII
-- EMPNO
-- SAL_OLD
-- SAL_NEW
-- OPERATOR

-- Sa se faca o copie a tabelei emp 
-- Sa se scrie un trigger care insereaza o linie completa in tabela LOG
-- ori de cate ori se face o operatie de insert, update, delete pe coloanele empno, sal din emp_copy




create or replace trigger salariu2
after delete or insert or update of empno, sal on emp_copy2
for each row
declare
	empno number;
	sal_old number;
	sal_new number;
begin
	if inserting then
		empno := :new.empno;
		sal_old := 0;
		sal_new := :new.sal;
	elsif updating then
		empno := :new.empno;
		sal_old := :old.sal;
		sal_new := :new.sal;
	elsif deleting then
		empno := :old.empno;
		sal_old := :old.sal;
		sal_new := 0;
	end if;
	
	insert into log_salarii2 values(empno, sal_old, sal_new, user, to_char(sysdate, 'yyyy-mm-dd hh-mi-ss'));
end;
/



