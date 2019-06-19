% Function theshold = thresh(I);
%  Program to find optimal threshold for image I (from Sonka et al.)
%
function T = thresh(I);
err = .001;
[M N] = size(I);
error_flag = 1;

Ti = .5;   %  Initialize threshold Assumes corners contain background
%
for k = 1:100     % Put limit on number of iterations
    NU_fore = 1; NU_back = 1;
    fore = 0; back = 0;
    for i =1:M
        for j = 1:N
            if I(i,j) > Ti
                fore = fore + I(i,j);
                NU_fore = NU_fore + 1;
            else
                back = back + I(i,j);
                NU_back = NU_back + 1;
            end
        end
    end
    T = (fore/NU_fore + back/NU_back)/2;
    if abs(Ti-T) < err
        error_flag = 0;
        break;
    else
        Ti = T;
    end    
end   
if error_flag == 1
    disp('ERROR ~ Failure to converge');
end    