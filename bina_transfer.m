function out=bina_transfer(Input)
   %% this function transfer multi-matrix containg  0 and 1 to one colune containg 1: n
   %% n was the total numbers of classification.
   out=[];
   [n,m]=size(Input);
   for i=1:n
       for j=1:m
           if (Input(i,j))
               out=[out;i];
           end
           end
       end
   end