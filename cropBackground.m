function cropBackground(videoFrame)

    image = videoFrame;
    
    [row, col] = size(image(:,:,1));
    
    
    if row > col
        
        x1 = round(col/8);
        x2 = round(row/50);
        y1 = round(row/12);
        y2 = round(row/46);
        
        for j = round(col/2)-y1:round(col/2)+y1

            image(:,j,:) = 0;
        end
        for j = 1:y2

            image(:,j,:) = 0;
            image(:,end-j + 1,:) = 0;
        end
        for j = 1:x1
            
            image(j,:,:) = 0;
            image(end-j + 1,:,:) = 0;
        end
        for j = round(row/2)-x2:round(row/2)+x2
            
            image(j,:,:) = 0;
        end
    else
        
        x1 = round(row/8);
        x2 = round(col/50);
        y1 = round(col/12);
        y2 = round(col/46);
        
        for j = round(row/2)-y1:round(row/2)+y1

            image(j,:,:) = 0;
        end
        for j = 1:y2

            image(j,:,:) = 0;
            image(end-j + 1,:,:) = 0;
        end
        for j = 1:x1
        
            image(:,j,:) = 0;
            image(:,end-j + 1,:) = 0;
        end
        for j = round(col/2)-x2:round(col/2)+x2
            
            image(:,j,:) = 0;
        end
    end
    
    newfile = strcat('trial.png');
    
    imwrite(image, newfile);
end