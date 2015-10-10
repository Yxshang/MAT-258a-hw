%%% 258a, 2015 fall
%%% hw2,q3
%%% Yunxiang Shang


%%% file reading

%save file to local disk
url='http://www.ats.ucla.edu/stat/data/binary.csv';
filename='hw2q3.csv';
outfilename=websave(filename,url);

%read csv file to workspace
data=csvread(filename,1,0);

Y=data(:,1); %admit
U=data(:,[2,3]); %GRE & gpa

[m,n]=size(U); %m:numb of element; n:dimension of u in funciton

%nondimensionlize
for i=1:2
    U(:,i)=(U(:,i)-min(U(:,i)))/(max(U(:,i))-min(U(:,i)));
end


%%% gradient descent method

%stop criterion
eta=1e-5;

%initialize
x=[5,3,-4];% starting point, i.e. a=x([1,2]); beta=x(3)
% make it as row vector for convenient
%x_new=[1;1;1];
gradient_L=zeros(1,3);

alpha0=0.2; beta0=0.5; % used for backtracking line search

gradient_L_norm2=1; % we just initialize it to get start
G=0; % array used to store the 2 norm of gradient for each step
%repeat
i=1;
while gradient_L_norm2 > eta
    
    %%1. delta_x, i.e. minuous gradient at x
    
    %common part in the grad
    p=1-1./(exp((x([1,2])*U')'+x(3))+1);
    %has form like p in logistic model
    %p=exp(a'u_i+beta)/(1+exp(a'u_i+beta))
    
    %p0=exp((x([1,2])*U')'+x(3))+1;
    %display(p0); % we need to do the nondimensionalize, or it be INF
    
    gradient_L(1)=-sum(U(:,1).*Y-(1-Y).*p.*U(:,1));
    gradient_L(2)=-sum(U(:,2).*Y-(1-Y).*p.*U(:,2));
    gradient_L(3)=-sum(Y-(1-Y).*p);
    
    delta_x=-gradient_L;
    
    %%2. line search
    % by backtracking line search
    
    t=1;
    diff=1; % initialize the loop for backtracking
    
    j=1;
    while diff > 0
        f_old=-sum(Y.*((x([1,2])*U')'+x(3))-...
            (1-Y).*log(1+exp((x([1,2])*U')'+x(3))));
        % f_old is f(x)
        
        x_new=x+t*delta_x;
        f_new=-sum(Y.*((x_new([1,2])*U')'+x_new(3))-...
            (1-Y).*log(1+exp((x_new([1,2])*U')'+x_new(3))));
        diff=f_new-f_old;
        
        t=beta0*t;
        j=j+1;
        display(j);
    end
    
    %%3. update
    x=x+t*delta_x;
    
    gradient_L_norm2=norm(gradient_L,2);
    
    i=i+1;
    %display(i);
    
    G=[G,gradient_L_norm2];
end

disp(['a = [ ',num2str(x(1)),' , ',num2str(x(2)),' ]']);
disp(['b = ',num2str(x(3))]);
disp(['minimizes value L = ',num2str(f_new)]);


%%third part of the problem 

% figure(1)
% for t=1:400
%     if Y(t)==1
%         plot(U(t,1),U(t,2),'b+');
%         hold on
%     else
%         plot(U(t,1),U(t,2),'ro');
%         hold on
%     end
% end
% title('GRE vs GPA in nondimensional form')
% 
% figure(2)
figure(1)
UU=data(:,[2,3]);
for k=1:400
    if Y(k)==1
        plot(UU(k,1),UU(k,2),'b+');
        hold on
    else
        plot(UU(k,1),UU(k,2),'ro');
        hold on
    end
end
hold off
title('GRE vs GPA in original data')
xlabel('GRE');ylabel('GPA');
legend('Possitive','Negative','location','NorthWest');

%%forth part of the problem
figure(2)
x0=0:0.05:1;
y0=(1/2-x(3)-x(1)*x0)/x(2);
plot(x0,y0);

