function image = cropBackgroundForDice(videoFrame)

    image = videoFrame;
    
    [row, col] = size(image(:,:,1));
        
    % if in portrait
    if row > col
        
        x1 = round(col/8);
        x2 = round(row/56);
        y1 = round(row/12);
        y2 = round(row/46);
        
        % MiddleVertical, Endsvertical, Horizontal, Horizontal, Horizontal

 
        for j = 1:x1
            
            image(j,:,:) = 0;
            image(end-j + 1,:,:) = 0;
        end
        for j = round(row/2)-x2:round(row/2)+x2
            
            image(j,:,:) = 0;
        end
    else
        
        x1 = round(row/8);
        x2 = round(col/56);
        y1 = round(col/12);
        y2 = round(col/46);
        
        for j = 1:x1
        
            image(:,j,:) = 0;
            image(:,end-j + 1,:) = 0;
        end
        
        for j = round(col/2)-x2:round(col/2)+x2
            
            image(:,j,:) = 0;
        end
    end
    
    
end