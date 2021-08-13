function rgb = uppixel(image)
    % define the global parameters
    global wid;         global hig;  global stp;         global averageh0;
    
    I0=image;
    % IO: image L0: low frequency H0: high frequency
    if stp==3           %step is the number of cycling times
        L1=imresize(I0,[hig*2 wid*2],'bilinear');     
    else 
        L1=imresize(I0,1.25,'bilinear');    
    end

    % reset the upsampling factor
    [newh1 neww1]=size(L1);
    [newh1x neww1x]=size(image);
    coef=newh1x/newh1;

    hfs_y1=10;

    if stp==1
        Ltmp=imresize(I0,1.25,'bilinear');
        L0=imresize(Ltmp, size(I0),'bilinear');   
        H0=round((I0-L0));  
    else
        L0=round(image);
         H0=round(averageh0(hfs_y1+1:end-hfs_y1,hfs_y1+1:end-hfs_y1));
    end

    %padding
    largeL0=L0([ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)],[ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)]);
    largeL1=L1([ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)],[ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)]);
    largeH0=H0([ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)],[ones(1,hfs_y1),1:end,end*ones(1,hfs_y1)]);

    sumh0=zeros(size(largeL1));
    counth0=zeros(size(largeL1));
    
    %searching and patch matching
    for iteri=1:1:newh1
        for iterj=1:1:neww1
            centerx=iteri;
            centery=iterj;
            p_L1=largeL1(hfs_y1+centerx-1:hfs_y1+centerx+1,hfs_y1+centery-1:hfs_y1+centery+1);
            newx=floor(centerx*coef);    
            newy=floor(centery*coef);

            maxsum=100000;
            retrievex=newx;
            retrievey=newy;
            
            % in-place self similarity
            for iterin1=0:1
                for iterin2=0:1
                    p_L0=largeL0(hfs_y1+newx-1+iterin1:hfs_y1+newx+1+iterin1,hfs_y1+newy-1+iterin2:hfs_y1+newy+1+iterin2);
                    subtmp=abs(p_L1-p_L0);
                    subtmp=sum(subtmp(:));
                    if subtmp<maxsum     
                        maxsum=subtmp;
                        retrievex=newx+iterin1;
                        retrievey=newy+iterin2;
                    end
                end
            end
            
       % has found the match patch
       q_p_H0=largeH0(hfs_y1+retrievex-2:hfs_y1+retrievex+2,hfs_y1+retrievey-2:hfs_y1+retrievey+2);           
       sumh0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)=sumh0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)+q_p_H0;
       counth0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)=counth0(hfs_y1+centerx-2:hfs_y1+centerx+2,hfs_y1+centery-2:hfs_y1+centery+2)+1;
       end
    end
    counth0(counth0<1)=1;
    averageh0=sumh0./counth0;
    endupimg=largeL1+averageh0;
    rgb=endupimg(hfs_y1+1:end-hfs_y1,hfs_y1+1:end-hfs_y1);
    clear endupimg;
end


