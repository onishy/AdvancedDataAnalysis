% x = [1; 2; 3; 4; 5]
% X = [1 2 3 4 5;
%      1 2 3 4 5;
%      1 2 3 4 5]

h=5
lambda = 0.001

n=50
N=1000
% x=linspace(-3,3,n)'; pix=pi*x; y=sin(pix)./(pix)+0.1*x+0.2*randn(n,1);
x=linspace(-3,3,n)';
pix=pi*x;
truey=sin(pix)./(pix)+0.1*x;

% csvwrite('data.csv',cat(2,x,y))
data = csvread('data.csv')
x = data(:,1)
y = data(:,2)

function retval = distance(x, c, h)
    retval = exp(-norm(x-c)**2/(2*h**2));
endfunction

function retval = kernel_column(X, i, h)
    col = columns(X);
    retval = zeros(col, 1);
    for j = 1:col
        retval(j) = distance(X(:,i), X(:,j), h);
    endfor
endfunction

function retval = calc_kernel(X, h)
    col = columns(X);
    retval = zeros(col, col);
    for i = 1:col
        retval(:,i) = kernel_column(X, i, h);
    endfor
endfunction

function retval = theta(K, y, lambda)
    retval = pinv(K**2 + lambda * eye(rows(K)))*K'*y
endfunction

K = calc_kernel(x',h);
th=theta(K, y, lambda)

X=linspace(-3,3,N)';
F=linspace(-3,3,N)';
for i = 1:N
    F(i) = 0;
    for j = 1:n
        F(i) += th(j)*distance(X(i), x(j), h);
    endfor
endfor

plot(x,y,'bo')
hold on
plot(x,truey,'r-')
hold on
plot(X,F,'g-')
pause