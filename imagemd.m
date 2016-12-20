function dat=imagemd(leaf,dingdian)  

global dat
predata=zeros(1,12);data=zeros(1,12);
[y,x,z]=size(leaf);

%erode 
leaf2=rgb2gray(leaf);
%radius can be selected to adapt1 2 3 4 
stru1=strel('disk',1);   
stru2=strel('disk',2);
stru3=strel('disk',3);
stru4=strel('disk',4);
back1=imopen(leaf2,stru1);
back2=imopen(leaf2,stru2);
back3=imopen(leaf2,stru3);
back4=imopen(leaf2,stru4);
leaf31=imsubtract(leaf2,back1);
leaf32=imsubtract(leaf2,back2);
leaf33=imsubtract(leaf2,back3);
leaf34=imsubtract(leaf2,back4);
ts1=graythresh(leaf31);
ts2=graythresh(leaf32);
ts3=graythresh(leaf33);
ts4=graythresh(leaf34);
leaf41=im2bw(leaf31,ts1);
leaf42=im2bw(leaf32,ts2);
leaf43=im2bw(leaf33,ts3);
leaf44=im2bw(leaf34,ts4);
[labeled1 n]=bwlabel(leaf41,8);
[labeled2 n]=bwlabel(leaf42,8);
[labeled3 n]=bwlabel(leaf43,8);
[labeled4 n]=bwlabel(leaf44,8);
data1=regionprops(labeled1,'basic');   
data2=regionprops(labeled2,'basic');
data3=regionprops(labeled3,'basic');
data4=regionprops(labeled4,'basic');
all1=[data1.Area];Se1=sum(all1);
all2=[data2.Area];Se2=sum(all2);
all3=[data3.Area];Se3=sum(all3);
all4=[data4.Area];Se4=sum(all4);
clear all1 all2 all3 all4 
clear back1 back2 back3 back4 
clear data1 data2 data3 data4 
clear labeled1 labeled2 labeled3 labeled4 
clear leaf31 leaf32 leaf33 leaf34 
clear leaf41 leaf42 leaf43 leaf44 
clear stru1 stru2 stru3 stru4 
%%%%%
%%%%%
g1=im2bw(leaf,0.95);      
 %threshold can be 0.95,0.92  
h=fspecial('average',3);   
g=round(filter2(h,g1));
c11=bwarea(~g);  
%opposite, calculate white area
%radius equals 2
h33=fspecial('average',2);
g33=round(filter2(h33,g1));
c33=bwarea(~g33);
%%%%%
%radius equals 5
h55=fspecial('average',5); 
g55=round(filter2(h55,g1));
c55=bwarea(~g55);

t=bwlabel(g);     
g2=bwmorph(g,'remove');c21=bwarea(g2);
c21=c21-2*(x+y);
%%%%%%%%%
%%%%%%%%%
g3=double(g2);
c22=round(c21);
a=1;h=zeros(c22*2,2);
x=x-3;y=y-3;       %maybe it is 4
for m=3:x
    for n=3:y
        if g3(n,m)==1 
           h(a,1)=m;h(a,2)=n;a=a+1;
         end
    end
end

clear g g1 g2 g3

l1=zeros(a^2,1);
b=1;
for r1=1:(a-1)
    for s1=r1:a
        if h(r1,1)==0 | h(s1,1)==0
           b=b;
        else 
           l1(b)=((h(r1,1)-h(s1,1))^2+(h(r1,2)-h(s1,2))^2)^(0.5);
           b=b+1; 
        end
    end
end
ll2=max(l1);       
%%%%%ll2 --- longest diameter

pr1(1)=dingdian(1);pr1(2)=dingdian(2);
pr2(1)=dingdian(3);pr2(2)=dingdian(4);
ll1=((pr1(1)-pr2(1))^2+(pr1(2)-pr2(2))^2)^0.5;   
%%%%%ll1 --- physilogical diameter 

l2=zeros(a^2,1);
b=1;
c=1;ls=zeros(2*a,1);
if pr1(1)~=pr2(1) & pr1(2)~=pr2(2)
    tg1=(pr1(2)-pr2(2))/(pr1(1)-pr2(1));     
    tg=(-1)/tg1;
elseif pr1(1)==pr2(1)
    tg=0;
elseif pr1(2)==pr2(2)
    tg1=0;
end
if exist('tg')==1 
  for m=1:(a-1)
    for n=(m+1):a           
        if h(m,1)==0
           break;
        end
        if h(m,1)==h(n,1) 
           if tg1<0.0314 & tg1>-0.0314      % +-1%
              if h(n,1)==0
              ls(c)=0;
              else
              ls(c)=((h(m,1)-h(n,1))^2+(h(m,2)-h(n,2))^2);
              end
              c=c+1;
           end                     
        else                          
            l2(b)=(h(m,2)-h(n,2))/(h(m,1)-h(n,1)); 
            if l2(b)<(tg+abs(0.01*tg))& l2(b)>(tg-abs(0.01*tg))
%%%%%%%%%%can not make sure the absolutely upright 
                 if h(n,1)==0
                    ls(c)=0;
                 else  
                    ls(c)=((h(m,1)-h(n,1))^2+(h(m,2)-h(n,2))^2);
                 end
                 c=c+1;                    
              end 
           b=b+1; 
        end               
    end 
 end
else 
for m=1:(a-1)
    for n=(m+1):a           
        if h(m,1)==0
           break;
        end
        if h(m,1)==h(n,1)      
              ls(c)=((h(m,1)-h(n,1))^2+(h(m,2)-h(n,2))^2);
              c=c+1;                    
        else                          
            l2(b)=(h(m,2)-h(n,2))/(h(m,1)-h(n,1));    
            if l2(b)>=57.29 | l2(b)<=-57.29
                 ls(c)=((h(m,1)-h(n,1))^2+(h(m,2)-h(n,2))^2);
            end  
            c=c+1;
        end
    end
end
end
ls1=(max(ls))^(0.5);                             

dat(1)=c55/c33;dat(2)=4*pi*c11/(c21)^2;dat(3)=c11/(ls1*ll1);dat(4)=ll1/ls1;dat(5)=ll2/ls1;
dat(6)=Se1/c11;dat(7)=Se2/c11;dat(8)=Se3/c11;dat(9)=Se4/c11;dat(10)=Se4/Se1;
dat(11)=c21/ll2;dat(12)=c21/(ls1+ll1);






