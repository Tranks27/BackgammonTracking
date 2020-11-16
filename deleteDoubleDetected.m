function [newBrownCoords, newBrownRad] = deleteDoubleDetected(newBrownCoords, ...
                                newBrownRad)
                            
    newCoordinatesBrown = [];
    newRadBrown = [];
    L = linspace(0,2*pi,11);
    
    for i = 1:length(newBrownRad)-1
        
        count = 0;
        
        xv = newBrownRad(i).*cos(L)' + newBrownCoords(i,1);
        yv = newBrownRad(i).*sin(L)' + newBrownCoords(i,2);
        
        for j = i + 1:length(newBrownRad)
            
            if inpolygon(newBrownCoords(j,1), newBrownCoords(j,2), ...
                    xv, yv)
                
                count = count + 1;
            end
        end
        
        if count == 0
            
            newCoordinatesBrown = [newCoordinatesBrown; ...
                newBrownCoords(i,1), newBrownCoords(i,2)];
            newRadBrown = [newRadBrown; ...
                newBrownRad(i)];
        end
    end
    
    newBrownCoords = newCoordinatesBrown;
    newBrownRad = newRadBrown;            
end