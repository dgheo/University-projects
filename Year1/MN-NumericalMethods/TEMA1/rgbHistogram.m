function [c] = rgbHistogram(a,count_bins)
RGB = imread(a);					%Creem matricea RGB- Matricea imaginii citite.
%Creem 3 vectori F,T,K de dimensiunea count_bins.
F = zeros(1,count_bins);
T = zeros(1,count_bins);
R = zeros(1,count_bins);
%Parcurgem cu un i de la 1 la count_bins primit ca parametru.
	for i = 1: count_bins
		r= RGB(:,:,1); 					%Extragem matricea r pentru red
%Creeam matricea X de 0 si 1 ,unde 1 sunt elementele ce se incadreaza in intervalul dat.
		X = (r >= (i-1)*256/count_bins & r < ((i-1)+1)*256/count_bins);
%Calculam suma elementelor unitate pentru matricea X,la fiecare pas si salvam valoare intru-un vector F.
		F(i)=sum(sum(X));
    
		g= RGB(:,:,2);					%Extragem matricea g pentru verde
%Creeam matricea Y de 0 si 1 ,unde 1 sunt elementele ce se incadreaza in intervalul dat.					
		Y = (g >= (i-1)*256/count_bins & g < ((i-1)+1)*256/count_bins);
%Calculam suma elementelor unitate pentru matricea Y,la fiecare pas si salvam valoare intru-un vector R.
		R(i)=sum(sum(Y));
    
		b= RGB(:,:,3);					%Extragem matricea b pentru rosu
%Creeam matricea Z de 0 si 1 ,unde 1 sunt elementele ce se incadreaza in intervalul dat.					
    		Z = (b >= (i-1)*256/count_bins & b < ((i-1)+1)*256/count_bins);
%Calculam suma elementelor unitate pentru matricea Z,la fiecare pas si salvam valoare intru-un vector T.
    		T(i)=sum(sum(Z));
    
	endfor
	c = [F,R,T];				%Concatenam cei 3 vectori obtinuti de count_bins dimensiune,si obtinem output-ul dorit.
endfunction
