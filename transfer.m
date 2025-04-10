function output=transfer(Input,vari)
% This function transfer a six varible into a binary varible,..
% Input was a new matrix with N*1;
% A was the total vabriable of out put
% For example, Input was matrix of 1110*1, which contained six different
% classes, A was  6.
B=vari;
A=size(Input,1);
output=zeros(A,B);
n=size(Input,1); 
for j=1:B
for i=1:n
      if(Input(i,:)==j)
          output(i,j)=1;
      end
end
end
        
