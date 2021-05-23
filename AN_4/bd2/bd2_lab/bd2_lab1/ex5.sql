--update.txt
--tabel.txt
declare
	v_nume varchar2(20);
	v_job varchar2(20);
begin
	select ename, job into v_nume, v_job from emp
		where hiredate between '1-jan-1992' and '31-dec-1992';
	exception
		when no_data_found then
			insert into mesaje values(1, 'Nu exista angajari in anul 1992');
		when too_many_rows then
			insert into mesaje values(2, 'Sunt mai multe angajari in anul 1992');
end;
/