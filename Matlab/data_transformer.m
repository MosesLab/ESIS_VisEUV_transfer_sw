
%OVERVIEW: formats data into readable format and makes it available to
%other programs

%all data variables output from this program
global impo
global distanc1
global distanc2
global distanc3
global voltag1
global voltag2
global voltag3

%{
    here data will be interpreted from its csv format
%}

data=fileread(impo);

[h l]=size(data)

%position of stage at time of measurement
distanc1=data(:,1);
%distanc values will be the same for all 3 data sets
distanc2=distanc1;
distanc3=distanc1;


%voltag values will differ between the 3 measurements
voltag1
for(n=1:(l/3))
    voltag1(1,n)=mean(data(n,2:3:end))
    voltag2=
end