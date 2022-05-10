function [c] = hsvHistogram(A,count_bins)
HSV=imread(A);						%Creem matricea HSV- Matricea imaginii citite.
%Creem 3 vectori F,T,K de dimensiunea count_bins.
F = zeros(1,count_bins);				
T = zeros(1,count_bins);
K = zeros(1,count_bins);
%Creeam 3 matrici de dimensiunea lui A care vor reprezenta matricile H S si V.
H = zeros(1,size(A));
S = zeros(1,size(A));
V = zeros(1,size(A));
%Citim dimensiunea lui A.
dim =size(HSV);
%Creem doi indici i si j cu care vom parcurge pe linii si pe coloane toate elementele pe rand.
for i=1:dim(1,1)
  for j=1:dim(1,2)
      R = HSV(:,:,1);					%Extragem matricea R pentru red
      G = HSV(:,:,2);  					%Extragem matricea G pentru verde
      B = HSV(:,:,3);					%Extragem matricea B pentru rosu

% Aflam matricile r,g,b care au valoarea matricelor R G B impartite la 255.
      r = double(R)/255;
      g = double(G)/255;
      b = double(B)/255;
	
      M(i,j) = max([r(i,j),g(i,j),b(i,j)]);		%Aflam maximul M la fiecare pozitie pentru r,g,b.
 
      m(i,j) = min([r(i,j),g(i,j),b(i,j)]);		%Aflam minimul m la fiecare pozitie pentru r,g,b.
      
      x(i,j) = M(i,j) - m(i,j);				%Aflam diferente dintre maxim si minim la fiecare pas.
%Aplicam algoritmul de conversie	
	if (x(i,j) == 0)
		 H(i,j) = 0;
	else     
       		 if (M(i,j) == r(i,j))
          		 H(i,j) = 60*mod(((g(i,j)-b(i,j))/x(i,j)),6);
          	 end
      		 if (M(i,j) == g(i,j))
           		 H(i,j) = 60 * (((b(i,j)-r(i,j))/x(i,j)) + 2);
          	 end
       		 if (M(i,j)==b(i,j))
          		 H(i,j) = 60 * (((r(i,j)-g(i,j))/x(i,j)) +4);
      		 end
	end

	H(i,j) =double(H(i,j))/360;

	if (M(i,j) == 0)
            S(i,j) = 0
	else
            S(i,j) = x(i,j)/M(i,j);
      	end
	
	V(i,j) = M(i,j);
   endfor
endfor

%Parcurgem cu un i de la 1 la count_bins primit ca parametru.
for i = 1: count_bins
%Creeam matricea X de 0 si 1 ,unde 1 sunt elementele ce se incadreaza in intervalul dat.
	X = (double(H) >= double((i-1)*1.01)/double(count_bins) & double(H) < double((i-1)+1)*1.01/double(count_bins));

%Calculam suma elementelor unitate pentru matricea X,la fiecare pas si salvam valoare intru-un vector F de count_bins valori.  
	F(i)=sum(sum(X));

%Creeam matricea Q de 0 si 1 ,unde 1 sunt elementele ce se incadreaza in intervalul dat.					
 	Q = (double(S) >= double((i-1)*1.01)/double(count_bins) & double(S) < double((i-1)+1)*1.01/double(count_bins));

%Calculam suma elementelor unitate pentru matricea Q,la fiecare pas si salvam valoare intru-un vector K de count bins valori.   
	K(i)=sum(sum(Q));

%Creeam matricea Z de 0 si 1 ,unde 1 sunt elementele ce se incadreaza in intervalul dat.
	Z = (V >= double((i-1)*1.01)/count_bins & double(V) < double(((i-1)+1)*1.01)/count_bins);

%Calculam suma elementelor unitate pentru matricea Z,la fiecare pas si salvam valoare intru-un vector T de count bins valori.	
	T(i)=sum(sum(Z));
endfor

c = [F, K, T]; 					%Concatenam cei 3 vectori obtinuti de count_bins dimensiune,si obtinem output-ul dorit. 

endfunction
