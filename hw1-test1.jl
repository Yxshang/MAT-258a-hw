using ECOS
using Convex
using PyPlot

n=100; m=30;
A=randn(n,m)
b=randn(n,1)
x1 = Variable(m)
x2 = Variable(m)
x3 = Variable(m)

a = 0.5 ##???

##1st problem is to minimize max(| A x - b |,1)
p1 = minimize( 0.5 * sum_squares( A * x1 - b ) + 10 * norm( x1 , 1 ))
solve!(p1,ECOS.ECOSSolver())

##2nd problem is to minimize max(| A x - b|,2)
p2 = minimize( 0.5 * sum_squares( A * x2 - b ) + 10 * norm( x2 , 2 ))
solve!(p2,ECOS.ECOSSolver())

##deadzone-linear penalty function
p3 = minimize( 0.5 * sum_squares( A * x3 - b ) + 10 * sum(max( x3 - 0.5 , 0) + max( - x3- 0.5 , 0)))
solve!(p3,ECOS.ECOSSolver())

##log barrier penalty

##plot figure
figure(figsize=(20,5))
r=-1:.1/50:1
plt[:hist](x1.value,50,facecolor="w")
plot(r,100 * abs(r),"k")
axis([-1,1,0,30]);

figure(figsize=(20,5))
r=-1:.1/50:1
plt[:hist](x2.value,50,facecolor="w")
plot(r,100 * abs(r .* r),"k")
axis([-1,1,0,30]);

figure(figsize=(20,5))
r=-1:.1/50:1
plt[:hist](x3.value,50,facecolor="w")
plot(r,100 * (max( r - 0.5 , 0) + max( - r - 0.5 , 0)),"k")
axis([-1,1,0,30]);
