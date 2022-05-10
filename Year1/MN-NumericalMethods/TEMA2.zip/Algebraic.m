function R = Algebraic(nume, d)
%citirea din fisier text, linie cu linie, dupa care construirea imediata
%a matricei de adiacenta A-fara duplicate cu 0 pe diagonala.
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

	M = (K*A)';			%Matricea adiacenta grafului
	
	I=eye(N);

	MF = I-d*M;			%Am aplicat formula din enunt.

%Calcularea componentelor Q si R a Matricei MF .
	[m n] = size(MF);
	Q = zeros(m,n);
	R = zeros(m);
	
	for j = 1 : n
		for i = 1 : j-1
			R(i,j) = Q(:,i)' * MF(:,j);
		endfor
		s = zeros(m,1);

		for i = 1 : j-1
			s = s + R(i,j) * Q(:,i);
		endfor
	
		aux = MF(:,j) - s;		
		
		R(j,j) = norm(aux,2);
		
		Q(:,j) = aux/R(j,j);
		
	endfor
%disp(MF);
%construirea lui INV,folosindu-ma de functia SST construita de mine
%pentru a calcula inversa unei matrici, folosind algoritmul Gram-Schmidt
%si rezolvarea unui sistem triunghiular superior . Aflarea lui R^-1.
	Inv= zeros(n);
	I = eye(n);
	for i=1:n
		for j=n:-1:1
			Inv(j,i) = (I(j,i) - R(j, j+1:n)*Inv(j+1:n, i))/R(j,j);
		end
	end
	T = Inv*Q';					%Verificare.
	F = MF*T;
	Y=ones(N,1);
	R=T*(1-d)/N*Y;					%Calculul indicelui Page Rank folosind formula din enunt.
	fclose(f);					%Inchidere fisier.
endfunction
