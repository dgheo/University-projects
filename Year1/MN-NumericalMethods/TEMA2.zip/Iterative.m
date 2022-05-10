function R = Iterative(nume, d, eps)
%citirea din fisier text, linie cu linie, dupa care construirea imediata
%a matricei de adiacenta A-fara duplicate.

	f=fopen(nume,'rt');
	N=fscanf(f,'%i',1);
	A=zeros(N,N);
	for i=1:N
    		c=fscanf(f,'%d',1);
    		k=fscanf(f,'%d',1);
    		s=fgets(f);
    		s=str2num(s);
    		for j=1:k
                	if c~=s(j) A(c,s(j))=1;
                	end
    		end
	end



	K=zeros(N,N);
	for i=1:N
            for j=1:N
                        K(i,i)=K(i,i)+A(i,j);
            end
	end

	K = K^-1;

	M = (K*A)'; %Matricea M adiacenta
	%disp(M);
	l = ones(1,N);
	l = l';
	%disp(l);
	R_v=ones(N,1).*(1/N);
	%disp(R);
%Calculul indicelui Page Rank pe forma matriciala intr-o bucla while.
	while 1
		R = d*M*R_v+(1-d)/N*l;  
		if norm(R - R_v) < eps 
			break;
    		else
      		R_v = R;
		endif
	endwhile
fclose(f);				%Inchidere fisier.

endfunction

