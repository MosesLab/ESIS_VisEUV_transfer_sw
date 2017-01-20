
%OVERVIEW: formats data into readable format and makes it available to
%other programs

%all data variables output from this program
global distanc1
global distanc2
global distanc3
global voltag1
global voltag2
global voltag3

%{
    here data will be interpreted from its csv format
%}

%dummy data; TO BE REMOVED
distanc1=[1 2 3 4 5 6 7 8 9 10]';
%distanc values will be the same for all 3 data sets
distanc2=distanc1;
distanc3=distanc1;

%dummy data; TO BE REMOVED
%voltag values will differ between the 3 measurements
voltag1=[1 2 6 5 4 3 3 2 2 0]';
voltag2=[7 8 8 8 9 10 12 15 8 3]';
voltag3=[2 3 4 5 6 7 7 6 5 4]';