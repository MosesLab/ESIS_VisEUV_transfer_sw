

close all

x=1:.002:1.6;
y=-(x-1.3).^2+5;

figure()
scatter(x,y)

len=10000;

x_mx=repmat(0,1,len);
for(n=1:len)
    ind_bot=datasample(1:length(x),length(x));
    ind_bot=sort(ind_bot);

    x_bot=x(ind_bot);
    y_bot=y(ind_bot);

    
    
    v=x_bot(y==max(y_bot));
    x_mx(n)=v(1);
    
    if(n==1)
        figure()
        scatter(x_bot,y_bot)
    end
end

figure()
histogram(x_mx)

num_pt=round(length(x_mx)*.98/2,0);

lwbd1=x_mx((length(x_mx)/2)-num_pt);
hibd1=x_mx((length(x_mx)/2)+num_pt);

%width of the confidence intervals
rng1=(hibd1-lwbd1)