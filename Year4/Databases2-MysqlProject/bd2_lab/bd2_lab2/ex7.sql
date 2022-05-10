set serveroutput on;
declare
	type secventa is varray(5) of varchar2(10);
	v_sec secventa := secventa ('alb', 'negru', 'rosu', 'verde');
begin
	dbms_output.put_line(v_sec(1) || ' ' || v_sec(2) || ' ' || v_sec(3) || ' ' || v_sec(4));
	v_sec(4) := 'rosu';
	dbms_output.put_line(v_sec(1) || ' ' || v_sec(2) || ' ' || v_sec(3) || ' ' || v_sec(4));
	-- desi s-au declarat 5 elemente pentru vector acest print va da eroare
	-- dbms_output.put_line(v_sec(5));
	v_sec.extend; -- adauga element null
	dbms_output.put_line(v_sec(1) || ' ' || v_sec(2) || ' ' || v_sec(3) || ' ' || v_sec(4)
		|| ' ' || v_sec(5));
	v_sec(5) := 'albastru';
	dbms_output.put_line(v_sec(1) || ' ' || v_sec(2) || ' ' || v_sec(3) || ' ' || v_sec(4)
		|| ' ' || v_sec(5));
	-- extinderea la 6 elemente va genera o eroare
	-- v_sec.extend;
end;
/