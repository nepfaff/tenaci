%function for drawing an arc given startPoint,center,degree,step.
function lst = drawArc(startPoint, center, degree, step, clockwise)
     radius = sqrt((startPoint(1)-center(1))^2+(startPoint(2)-center(2))^2);
     if (startPoint(2)-center(2))>=0
        startDegree = acos((startPoint(1)-center(1))/radius);
     else
        startDegree = acos((startPoint(1)-center(1))/radius)+pi;
     end
     
     sign = 1;
     if ~clockwise
         sign = -1;
     end
     lst = drawCircle(startDegree,center,radius,startDegree+sign*degree,sign*step);
end
