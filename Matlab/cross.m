
close all

%bring in two data sets
data1=csvread('data2.csv');
data2=csvread('data2.csv');

%format data
[h1,l1]=size(data1);
[h2,l2]=size(data2);
x1=data1(:,1)';
x2=data2(:,1)';
y1=zeros(1,(l1-1));
y2=zeros(1,(l2-1));
for n=1:h1
    y1(n)=mean(data1(n,2:end));
end
for n=1:h2
    y2(n)=mean(data2(n,2:end));
end

%plot data curves
figure()
hold on
scatter(x1,y1)
scatter(x2,y2)
xlabel('Distance')
ylabel('Voltage')
title('Original Curves')

%cross correlate the two curves
r=xcorr(y1,y2);
dx = ((2*max(x1)-min(x1))/length(r));
x3=((0:(length(r)-1)) - (length(r) - 1) / 2) / ((length(r) - 1) / (2*max(x1) - min(x1)));

%plot the cross correlation
figure()
scatter(x3,r)
xlabel('Distance')
ylabel('Voltage ^ 2 ?')
title('Cross Correlation Curve')



%prepare indexs to bootstrap with
yidx1=1:length(y1);
yidx2=1:length(y2);
n=0;
tims=1000;
mxxs=zeros(1,tims);

%run through bootstrap process many times
while(n<tims)
    %prevents data memory stackup
    clear trend1
    clear trend2
    clear xf
    clear yld
    clear ylf
    clear yf
    clear y2f
    
    n=n+1;

    %creates list of random indexs for fitting
    yidxbot1=datasample(yidx1,length(yidx1));
    yidxbot1=sort(yidxbot1);
    yidxbot2=datasample(yidx2,length(yidx2));
    yidxbot2=sort(yidxbot2);

    %creates arrays giving weight to points
    wt1=zeros(1,length(y1));
    wt2=zeros(1,length(y2));
    
    for i=1:length(y1) 
        wt1(i)=length(yidx1(yidxbot1==yidx1(i)));
    end
    for i=1:length(y2)
        wt2(i)=length(yidx2(yidxbot2==yidx2(i)));
    end
    
    %creates weighted y data
    bot_y1=wt1.*y1;
    bot_y2=wt2.*y2;
    
    %cross corelate the weighted data
    c=xcorr(bot_y1,bot_y2);
    bot_x3=((0:(length(c)-1)) - (length(c) - 1) / 2) / ((length(c) - 1) / (2*max(x1) - min(x1)));
    
    %format for Charles' fourier interpolation
    yf=c;
    xf=bot_x3;
    
    %%%%%fourier interpolation
    
        % Original data are (x1, y1). x1 is assumed to be uniformly spaced.
        % (but note that only x1(1) and x1(n) are used).
        % N2 is the size of the interpolated grid.
        % y2 is the new (interpolated) y values.
        % x2 is corresponding the new set of x values.

        N1 = length(yf);
        N2=N1*10;

        % Construct the new x-axis, x2
        dx1 = (xf(N1) - xf(1))/(N1-1);
        period = N1*dx1; % Note that this is larger than x1(N1)-x1(1).
        dx2 = period/N2; % New sampling interval.
        xf = xf(1) + (0:N2-1)*dx2; % New x-axis

        % Detrend the data
        slope = (yf(N1) - yf(1))/((N1-1)*dx1);
        trend1 = slope * dx1 * (0:N1-1);
        y1d = yf - trend1;
        y1f = fft(y1d); % FFT of y1, which will supply parts for FFT of y2.

        % Construct the FFT of the interpolated signal, y2
        y2f = zeros(1,N2); % initialize blank FFT for y2
        y2f(1:floor(N1/2+1)) = y1f(1:floor(N1/2+1));

        % Frequencies 0 through Nyquist go to the first part of y2f.
        y2f(N2-floor(N1/2-1):N2) = y1f(ceil(N1/2+1):N1);

        % Frequencies from Nyquist to N go to the last part of y2f.
        % In the case where N1 is odd, there is no element at Nyquist
        % frequency; this case is handled above by floor() and ceil().

        yf = ifft((N2/N1)*y2f); % create y2 by the inverse transform.

        % Reconstruct the original trend, rebinned for the newly interpolated
        % data, and add it back in.
        trend2 = slope * dx2 * (0:N2-1);
        yf = yf + trend2; % Add the trend back in
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
    
    %finds x value for which y is maxed
    mxxs(n)=xf(yf==max(yf));
    
    %provide sample bootstrapped plots
    if(n==1)
        figure()
        hold on
        plot(x1,y1,'k')
        plot(x2,y2,'k')
        scatter(x1,bot_y1,'r')
        scatter(x2,bot_y2,'b')
        xlabel('Distance')
        ylabel('Voltage')
        title('Bootstrap Weighted Curves')
        
        figure()
        hold on
        scatter(xf,yf,'r')
        scatter(bot_x3,c,'b')
        plot(bot_x3,c,'k')
        xlabel('Distance')
        ylabel('Voltage ^ 2 ?')
        title('Bootstrap Weighted Cross Correlation')
        legend('Interpolated','Original','Original Plot')
    end
    
end

mxxs=sort(mxxs);

%create confidence intervals
num_pt=round(length(mxxs)*.98/2,0);
lwbd=mxxs((n/2)-num_pt);
hibd=mxxs((n/2)+num_pt);

figure()
histogram(mxxs)

%output data
actualmax=x3(r==max(r))
boot_max=mode(mxxs)
conf_int=(hibd-lwbd)

