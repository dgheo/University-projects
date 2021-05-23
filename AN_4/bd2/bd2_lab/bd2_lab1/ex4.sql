declare
	nume varchar2(17) := 'Popescu';
	functie varchar2(11) := 'Analyst';
begin
	begin
		
		insert into emp(empno, ename, job, sal)
			values(&&ecuson, nume, functie, &salariu);

		/* bloc imbricat */
		begin
			update emp set comm = &comision
				where empno =&ecuson and job=functie;
		end;
	end;
end;
/