clc
clear all
close all
tic
figure(1);hold on
ezplot('x*sin(10*pi*x)+2',[-1,2]);

fishnum=50;
MAXGEN=500;
try_number=100;
visual=1; 
delta=0.618; 
step=0.1;

lb_ub=[-1,2,1];
X=AF_init(fishnum,lb_ub);
LBUB=[];
for i=1:size(lb_ub,1)
    LBUB=[LBUB;repmat(lb_ub(i,1:2),lb_ub(i,3),1)];
end
gen=1;
BestY=-1*ones(1,MAXGEN);
BestX=-1*ones(1,MAXGEN); 
besty=-100;
Y=AF_foodconsistence(X);
while gen<=MAXGEN
    fprintf(1,'%d\n',gen)
    for i=1:fishnum
       
        [Xi1,Yi1]=AF_swarm(X,i,visual,step,delta,try_number,LBUB,Y); 
  
        [Xi2,Yi2]=AF_follow(X,i,visual,step,delta,try_number,LBUB,Y); 
        if Yi1>Yi2
            X(:,i)=Xi1;
            Y(1,i)=Yi1;
        else
            X(:,i)=Xi2;
            Y(1,i)=Yi2;
        end
    end
    [Ymax,index]=max(Y);
    figure(1);
    plot(X(1,index),Ymax,'.','color',[gen/MAXGEN,0,0])
    if Ymax>besty
        besty=Ymax;
        bestx=X(:,index);
        BestY(gen)=Ymax;
        [BestX(:,gen)]=X(:,index);
    else
        BestY(gen)=BestY(gen-1);
        [BestX(:,gen)]=BestX(:,gen-1);
    end
    gen=gen+1;
end
plot(bestx(1),besty,'ro','MarkerSize',100)
xlabel('x')
ylabel('y')
