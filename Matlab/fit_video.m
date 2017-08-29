D=dir('/home/krg/CLIP0');
D=D(3:end,:);
S=struct2cell(D);
S=S(1,:);


for(i=1:length(S))
    data(:,:,i)=fitsread(char(S(i)));
end
return
for(i=1:length(S))
    imshow(data(:,:,i),[])
end

% X=imread('/media/krg/KINGSTON/13-41-25-67.JPG');
% Y=imread('/media/krg/KINGSTON/13-41-30-459.JPG');
% Z=imsubtract(X,Y);
% figure()
% imshow(X)
% figure()
% imshow(Y)
% figure()
% imshow(Z)
