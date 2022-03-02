%function for drawing a line given start,ed,step.
function lst = drawLine(start,ed,step)
    vec = ed-start
    univec = vec/norm(vec)
    pointStep = start
    dis = sqrt(vec(1)^2+vec(2)^2+vec(3)^2)
    lst = [start]
    for i=0:step:(dis-step)
        pointStep = pointStep+univec*step
        lst = [lst;pointStep]
    end
    lst=[lst;ed]
    disp(dis)
    disp(step)
end