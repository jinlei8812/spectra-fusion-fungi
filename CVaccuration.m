function statis=CVaccuration(A,B,class)
% A was the standard matrix, B was the assessement matrix
%A=Label_test;
%B=Y_pre;
%class=5;
number1=[];
for i=1:class
    number1=[number1;sum(A(:)==i)];%% calculated different classification numbers in standard matrix
end
statis=[];
C=0;
for i=1:class
   % i=2;
     N=number1(i,:);%% calculated different classification numbers in evaluated matrix
     number2=sum(B(:)==i);% i in whole data
     if (i>1)
         for j=1:i
             C=sum(number1(1:j-1));
         end
     else
         C=0;
     end
     number3=sum(B(C+1:C+N,:)==i);% Frequency of i in selected N data 
     Accuracy=1-(N-number3)/N-(number2-number3)/(size(B,1)-N);
     statis=[statis,Accuracy];
end