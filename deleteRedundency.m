function [newBrownCoords, newBrownRads] = deleteRedundency(coordinatesWhite, ...
                            radiusWhite, coordinatesBrown, radiusBrown)
                        
    newCoordinatesBrown = [];
    newRadBrown = [];
    L = linspace(0,2*pi,11);
    
    for j = 1:length(radiusBrown)
        
        count = 0;
        
        for k = 1:length(radiusWhite)
            
            xv = radiusWhite(k).*cos(L)' + coordinatesWhite(k,1);
            yv = radiusWhite(k).*sin(L)' + coordinatesWhite(k,2);
            
            if inpolygon(coordinatesBrown(j,1), coordinatesBrown(j,2),...
                            xv, yv)
                        
                count = count + 1;
            end
        end
        
        if count == 0
            
            newCoordinatesBrown = [newCoordinatesBrown; ...
                coordinatesBrown(j,1), coordinatesBrown(j,2)];
            newRadBrown = [newRadBrown; ...
                radiusBrown(j)];
        end
    end
    
    newBrownCoords = newCoordinatesBrown;
    newBrownRads = newRadBrown;
end