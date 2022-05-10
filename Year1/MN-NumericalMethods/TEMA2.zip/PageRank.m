function [R1 R2 R3]=PageRank(nume,d,eps)

	R1=Iterative(nume,d,eps);
	R2=Algebraic(nume,d);
	numeout=strcat(nume,'.out');
	f=fopen(numeout,'w');
	N = fscanf(f, "%f", 1);
	for i=1:N
		fprintf(f,'%f\n\n',N);
		fprintf(f,'\n');
	end
	[N,M]=size(R1);
	fprintf(f,'%i\n',N);
	for i=1:N
        	 fprintf(f,'%f\n',R1(i));
	end
		fprintf(f,'\n');
	for i=1:N
        	 fprintf(f,'%f\n',R2(i));
	end

	b=fopen(nume,'rt');
	x=fgets(b);
	for i=1:N
        	 x=fgets(b);
	end
	PR2b=R2;
	v1=fscanf(b,'%f',1);
	v2=fscanf(b,'%f',1);
	fclose(b);

	a=1/(v2-v1);
	b=(-v1)/(v2-v1);

	for i=1:N-1
         	for j=i+1:N
                    if PR2b(i)<PR2b(j)
                                    aux=PR2b(j);
                                    PR2b(j)=PR2b(i);
                                    PR2b(i)=aux;
                    end
         	end
	end
	fprintf(f,'\n');

	for i=1:N
        	 for j=1:N
        	          if PR2b(i)==R2(j)
        	                            ind(i)=j;
        	          end
        	 end
	end
             

	for i=1:N
        	 fprintf(f,'%i %i ',i,ind(i));
        	 if PR2b(i)<v1 
        	    	 fprintf(f,'%i\n',0);
        	 end
        	 if PR2b(i)<=v2 && PR2b(i)>v1 
                   	fprintf(f,'%f\n',a*PR2b(i)+b);
        	 end
        	 if PR2b(i)>=v2 
       	                fprintf(f,'%i\n',1);
        	 end
	end
fclose(f);
endfunction
