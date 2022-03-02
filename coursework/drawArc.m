%function for drawing a Circle given startPoint,center,degree,step.
function lst = drawArc(startPoint,center,degree,step)
         radius = sqrt((startPoint(1)-center(1))^2+(startPoint(2)-center(2))^2)
         if (startPoint(2)-center(2))>=0
            startDegree = acos((startPoint(1)-center(1))/radius)
         else
            startDegree = acos((startPoint(1)-center(1))/radius)+pi
         end

         lst = drawCircle(startDegree,center,radius,degree+startDegree,step)
         disp(startDegree)
         disp(radius)

end