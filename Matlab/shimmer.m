
%OVERVIEW: tells how much to shim each corner of the euv gratings

%pulls relevant data from other programs
global conf_int1
global conf_int2
global conf_int3

%the most popular distance position for maximum voltage
pos_euv1=conf_int1(4);
pos_euv2=conf_int2(4);
pos_euv3=conf_int3(4);

%$$$$pulls conf_int1,conf_int2,conf_int3 from vis

%dummy data; TO BE REMOVED
pos_vis1=pos_euv1-1;
pos_vis2=pos_euv2+.02321563;
pos_vis3=pos_euv3-.000001;

%pulls the most likely position of the visible grating of the same serial
%number
%%%%%{
pos_vis1=%something pulled;
pos_vis2=%something pulled;
pos_vis3=%something pulled;
%%%%%}

%finds the difference in position from the euv to the visible grating and
%converts to thousandths of an inch
dist1=(pos_euv1-pos_vis1)*.0393701*1000;
dist2=(pos_euv2-pos_vis2)*.0393701*1000;
dist3=(pos_euv3-pos_vis3)*.0393701*1000;

%tells direction and magnatude of shimming for each corner of the euv
%grating
if(dist1<0)
    sprintf('Place shims under corner 1 to move it forward %f thou',abs(round(dist1,2)))
else
    sprintf('Remove shims under corner 1 to move it backward %f thou',abs(round(dist1,2)))
end
if(dist2<0)
    sprintf('Place shims under corner 2 to move it forward %f thou',abs(round(dist2,2)))
else
    sprintf('Remove shims under corner 2 to move it backward %f thou',abs(round(dist2,2)))
end
if(dist3<0)
    sprintf('Place shims under corner 3 to move it forward %f thou',abs(round(dist3,2)))
else
    sprintf('Remove shims under corner 3 to move it backward %f thou',abs(round(dist3,2)))
end