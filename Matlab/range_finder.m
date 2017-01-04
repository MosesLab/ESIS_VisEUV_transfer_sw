
%OVERVIEW: determines how the next measurent should be taken to get the
%neccessary confidence for position

%uses cut gaussian data
run plotter.m

%data variables pulled and given to other programs
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

%finds a new start and stop position for stepper motor to avoid collecting
%unnessasay data
strt=min([distance1 distance2 distance3]);
stp=max([distance1 distance2 distance3]);

%finds the distance value for which the voltage is maximized
mx1=distanc1(find(voltag1==max(voltag1)));
mx2=distanc2(find(voltag2==max(voltag2)));
mx3=distanc3(find(voltag3==max(voltag3)));

%keeps start/stop additions/subrations from piling up
usdp=1;
usds=1;

%adds distance to stop position if neccessary data is being cut off
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

%subracts distance to start position if neccessary data is being cut off
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

%finds a new start and stop position for stepper motor to avoid collecting
%unnessasay data
gausth=1;
gaustl=1;

%creats a small amound of excess data to for manual checking purposes
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

%tells if program is precise enough
bot=1;

%determines distance between voltage readings
if(gaustl==1&gausth==1&usds==1&usdp==1)
    stept=(stp-strt)/.002;
    %number of voltage measurents per position
    mest=10;
    %tells if program is precise enough
    bot=0;
    %output strt,stp,stept,mest
else
    stept=(stp-strt)/.05;
    %number of voltage measurents per position
    mest=3;
    %output strt,stp,stept,mest
end

%determines what to do with data
%if full measurment with no known issues over a wide enough range:
if(bot==0)
    %determiens confidence interval
    run bootstrapper.m
    
    %depending on the width of the confidence interval:
    if(hi_rng<.0038)
        %%%%%if vis measurment, end program
        
        %if narrow enough, run shimming program
        run shimmer.m
        
        %if this program has been run once before but wasn't precice enough
    else if(pro==0)
        %increase range of measurment
        strt=strt-.1;
        stp=stp+.1;
        stept=(stp-strt)/.002;
        %tells if this program has been run before
        pro=1;
        %output strt,stp,stept,mest
        else
            %will propt to manually input start, stop, step number, and
            %measurments per position
            %%%%%alert me to manually input strt,stp,stept,mest
        end
    end
else
    %tell program this section has never been run before
    pro=0;
end