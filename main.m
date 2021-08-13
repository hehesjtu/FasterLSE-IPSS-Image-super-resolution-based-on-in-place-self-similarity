clc;clear all;close all; warning off;
%% define the global parameters
global wid;   global hig;   global stp; 
Files = dir(strcat('.\data\','*.png')); 
LengthFiles =length(Files); 

for ii = 1:LengthFiles 
    Files(ii).name
    image=double(imread(strcat('.\data\',Files(ii).name)));
    [h0,w0,d]=size(image);
    wid=w0;
    hig=h0;
    outimg1=image(:,:,1);
    outimg2=image(:,:,2);
    outimg3=image(:,:,3);
    
    for i=1:3             
        tic
        stp=i;
        outimg1=uppixel(outimg1);             
        if i==3
            outimg(:,:,1)=outimg1;
        end
        toc
    end

    for i=1:3             
        tic
        stp=i;
        outimg2=uppixel(outimg2);             
        if i==3
            outimg(:,:,2)=outimg2;
        end
        toc
    end

    for i=1:3               
        tic
        stp=i;
        outimg3=uppixel(outimg3);             
        if i==3
            outimg(:,:,3)=outimg3;
        end
        toc
    end
    imwrite(uint8(outimg),strcat('.\results\',Files(ii).name(1:end-4),'_IPSS.png'));
    clear outimg;
end







