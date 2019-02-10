function X=AF_init(Nfish,lb_ub)
row=size(lb_ub,1);
X=[];
for i=1:row
    lb=lb_ub(i,1);
    ub=lb_ub(i,2);
    nr=lb_ub(i,3);
    for j=1:nr
        X(end+1,:)=lb+(ub-lb)*rand(1,Nfish);
    end
end

 function [Y]=AF_foodconsistence(X)
fishnum=size(X,2);
for i=1:fishnum
     Y(1,i)=X(i)*sin(10*pi*X(i))+2;
end

function [Xnext,Ynext]=AF_swarm(X,i,visual,step,deta,try_number,LBUB,lastY)

Xi=X(:,i);
D=AF_dist(Xi,X);
index=find(D>0 & D<visual);
nf=length(index);
if nf>0
    for j=1:size(X,1)
        Xc(j,1)=mean(X(j,index));
    end
    Yc=AF_foodconsistence(Xc);
    Yi=lastY(i);
    if Yc/nf>deta*Yi
        Xnext=Xi+rand*step*(Xc-Xi)/norm(Xc-Xi);
        for i=1:length(Xnext)
            if  Xnext(i)>LBUB(i,2)
                Xnext(i)=LBUB(i,2);
            end
            if  Xnext(i)<LBUB(i,1)
                Xnext(i)=LBUB(i,1);
            end
        end
        Ynext=AF_foodconsistence(Xnext);
    else
        [Xnext,Ynext]=AF_prey(Xi,i,visual,step,try_number,LBUB,lastY);
    end
else
    [Xnext,Ynext]=AF_prey(Xi,i,visual,step,try_number,LBUB,lastY);
end


 function [Xnext,Ynext]=AF_prey(Xi,ii,visual,step,try_number,LBUB,lastY)

Xnext=[];
Yi=lastY(ii);
for i=1:try_number
    Xj=Xi+(2*rand(length(Xi),1)-1)*visual;
    Yj=AF_foodconsistence(Xj);
    if Yi<Yj
        Xnext=Xi+rand*step*(Xj-Xi)/norm(Xj-Xi);
        for i=1:length(Xnext)
            if  Xnext(i)>LBUB(i,2)
                Xnext(i)=LBUB(i,2);
            end
            if  Xnext(i)<LBUB(i,1)
                Xnext(i)=LBUB(i,1);
            end
        end
        Xi=Xnext;
        break;
    end
end

%random movement
if isempty(Xnext)
    Xj=Xi+(2*rand(length(Xi),1)-1)*visual;
    Xnext=Xj;
    for i=1:length(Xnext)
        if  Xnext(i)>LBUB(i,2)
            Xnext(i)=LBUB(i,2);
        end
        if  Xnext(i)<LBUB(i,1)
            Xnext(i)=LBUB(i,1);
        end
    end
end
Ynext=AF_foodconsistence(Xnext);

function [Xnext,Ynext]=AF_follow(X,i,visual,step,deta,try_number,LBUB,lastY)
Xi=X(:,i);
D=AF_dist(Xi,X);
index=find(D>0 & D<visual);
nf=length(index);
if nf>0
    XX=X(:,index);
    YY=lastY(index);
    [Ymax,Max_index]=max(YY);
    Xmax=XX(:,Max_index);
    Yi=lastY(i);
    if Ymax/nf>deta*Yi;
        Xnext=Xi+rand*step*(Xmax-Xi)/norm(Xmax-Xi);
        for i=1:length(Xnext)
            if  Xnext(i)>LBUB(i,2)
                Xnext(i)=LBUB(i,2);
            end
            if  Xnext(i)<LBUB(i,1)
                Xnext(i)=LBUB(i,1);
            end
        end
        Ynext=AF_foodconsistence(Xnext);
    else
        [Xnext,Ynext]=AF_prey(X(:,i),i,visual,step,try_number,LBUB,lastY);
    end
else
   [Xnext,Ynext]=AF_prey(X(:,i),i,visual,step,try_number,LBUB,lastY);
end

function D=AF_dist(Xi,X)
col=size(X,2);
D=zeros(1,col);
for j=1:col
    D(j)=norm(Xi-X(:,j));
end