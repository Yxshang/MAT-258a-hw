using ECOS
using Convex
using PyPlot

n=100
A=randn(n,n)
b=randn(n,1)
x=Variable(n)
p=minimize(0.5*sum_squares(A*x-b)+10*norm(x,1))
solve!(p,ECOS.ECOSSolver())

figure(figsize=(20,5))
r=-.25:.1/50:.25
plt[:hist](x.value,50,facecolor="w")
plot(r,100*abs(r),"k")
axis([-.25,.25,0,30]);