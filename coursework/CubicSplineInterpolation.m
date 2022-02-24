function cubics = CubicSplineInterpolation(points)
%CUBICSPLINEINTERPOLATION Performs cubic spine interpolation through the
%points. Returns the cubic coefficients.
%points is a struct with attributes x and y.
%cubics is a list of structs with attributes a0, a1, a2, a3, xmin, xmax
%where a0, a1, a2, a3 represent the cubic coefficients and xmin, xmax
%represent the range over which the cubic is defined.
%Cubic: y = a0 + a1*x + a2*x^2 + a3*x^3
    
    numberOfCubics = length(points)-1;
    % Each cubic has 4 coefficients
    numberOfCoefficients = numberOfCubics * 4;
    % M is the augmented matrix
    M = zeros(numberOfCoefficients, numberOfCoefficients + 1);
    
    % Ax=b => M = (A:b), solution index is index of b in M
    solIdx = numberOfCoefficients + 1;
    
    % Keep track of current row in M
    row = 1;
    
    % Position constraints
    for i = 0 : numberOfCubics - 1
        p0 = points(i+1);
        p1 = points(i+2);
        
        M(row, i*4 + 1) = p0.x^3;
        M(row, i*4 + 2) = p0.x^2;
        M(row, i*4 + 3) = p0.x;
        M(row, i*4 + 4) = 1;
        M(row, solIdx) = p0.y;
        
        row = row + 1;
        
        M(row, i*4 + 1) = p1.x^3;
        M(row, i*4 + 2) = p1.x^2;
        M(row, i*4 + 3) = p1.x;
        M(row, i*4 + 4) = 1;
        M(row, solIdx) = p1.y;
        
        row = row + 1;
    end
    
    % Velocity constraints
    for i = 0 : numberOfCubics - 2
        p1 = points(i+2);
        
        M(row, i*4 + 1) = 3 * p1.x^2;
        M(row, i*4 + 2) = 2 * p1.x;
        M(row, i*4 + 3) = 1;
        M(row, i*4 + 5) = -3 * p1.x^2;
        M(row, i*4 + 6) = -2 * p1.x;
        M(row, i*4 + 7) = -1;
        
        row = row + 1;
    end
    
    % Acceleration constraints
    for i = 0 : numberOfCubics - 2
        p1 = points(i+2);
        
        M(row, i*4 + 1) = 6 * p1.x;
        M(row, i*4 + 2) = 2;
        M(row, i*4 + 5) = -6 * p1.x;
        M(row, i*4 + 6) = -2;
        
        row = row + 1;
    end
    
    % Boundary conditions (natural spline)
    M(row, 1) = 6 * points(1).x;
    M(row, 2) = 2;
    row = row + 1;
    M(row, solIdx-4 + 0) = 6 * points(length(points)).x;
    M(row, solIdx-4 + 1) = 2;
    
    % Solve system of equations using reduced row echelon form
    % M has always a unique solution. Hence, its main part will be the
    % identity and the last column represents the solution
    Mrref = rref(M);
    coefficients = Mrref(:, solIdx)';
    
    cubics = [];
    for i = 0 : numberOfCubics-1
        cubic.a3 = coefficients(i*4 + 1);
        cubic.a2 = coefficients(i*4 + 2);
        cubic.a1 = coefficients(i*4 + 3);
        cubic.a0 = coefficients(i*4 + 4);
        cubic.xmin = points(i+1).x;
        cubic.xmax = points(i+2).x;
        
        cubics = [cubics, cubic];
    end
end
