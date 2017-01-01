
%fits line
%finds max
%outputs new range

run plotter.m

global distanc1
global distanc2
global distanc3
global voltag1
global voltag2
global voltag3
global distance1
global distance2
global distance3
global voltage1
global voltage2
global voltage3

global prec_dis
global hi_rng

strt=min(prec_dis);
stp=max(prec_dis);

mx1=distanc1(find(voltag1==max(voltag1)));
mx2=distanc2(find(voltag2==max(voltag2)));
mx3=distanc3(find(voltag3==max(voltag3)));

usdp=1;
usds=1;

if((mx1==max(distanc1))&(usdp==1))
    stp=stp+.5;
    usdp=0;
end
if((mx2==max(distanc2))&used==1)
    stp=stp+.5;
    usdp=0;
end
if(mx3==max(distanc3)==1)
    stp=stp+.5;
    usdp=0;
end

if((mx1==min(distanc1))&usdp==1)
    strt=strt-.5;
    usds=0;
end
if((mx2==min(distanc2))&used==1)
    strt=strt-.5;
    usds=0;
end
if(mx3==min(distanc3)==1)
    strt=strt-.5;
    usds=0;
end

gausth=1;
gaustl=1;

if(min(distance1)==min(distanc1)&gaustl==1)
    strt=strt-.25;
    gaustl=0;
end
if(min(distance2)==min(distanc2)&gaustl==1)
    strt=strt-.25;
    gaustl=0;
end
if(min(distance3)==min(distanc3)&gaustl==1)
    strt=strt-.25;
    gaustl=0;
end

if(max(distance1)==max(distanc1)&gausth==1)
    stp=stp+.25;
    gaustl=0;
end
if(max(distance2)==max(distanc2)&gausth==1)
    stp=stp+.25;
    gaustl=0;
end
if(max(distance3)==max(distanc3)&gausth==1)
    stp=stp+.25;
    gaustl=0;
end

bot=1;

if(gaustl==1&gausth==1&usds==1&usdp==1)
    stept=(stp-strt)/.002;
    mest=10;
    bot=0;
    %output strt,stp,stept,mest
else
    stept=(stp-strt)/.05;
    mest=3;
    %output strt,stp,stept,mest
end

if(bot==0)
    run bootstrapper.m
    if(hi_rng<.0038)
        %run a shimming program
        %end program
    else if(pro==0)
        strt=strt-.1;
        stp=stp+.1;
        stpt=(stp-strt)/.002;
        pro=1;
        %output strt,stp,stept,mest
        else
            %alert me to manually input strt,stp,stept,mest
        end
    end
else
    pro=0;
end
