function lst = drawCircle(startDegree,center,radius,endDegree,step)
        lst = []
    for i = startDegree:step:endDegree
        lst = [lst; radius*cos(i)+center(1), radius*sin(i)+center(2),center(3)]
    end
end