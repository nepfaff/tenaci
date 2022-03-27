function tf = tfFromDH(alpha, a, d, theta)
%tfFromDH Converts DH parameters into a homogenous transformation matrix.

    tf = [
        cos(theta), -sin(theta), 0, a;
        sin(theta)*cos(alpha), cos(theta)*cos(alpha), -sin(alpha), -sin(alpha)*d;
        sin(theta)*sin(alpha), cos(theta)*sin(alpha), cos(alpha), cos(alpha)*d;
        0 0 0 1
    ];
end
