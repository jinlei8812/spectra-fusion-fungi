function statis=accuration(A,class,N)
%% THis function calcutale the classitication accucy
%A=Y_pre_RF;
%class=5;
%N=36;
whole=class*N;
statis=[];
for i=1:class
    number1=sum(A(:)==i);% Frequency of i in whole data 
    number2=sum(A(N*(i-1)+1:N*i,:)==i);% Frequency of i in selected data 
    Accuracy=1-(N-number2)/N-(number1-number2)/(whole-N);
    statis=[statis;Accuracy];
end

