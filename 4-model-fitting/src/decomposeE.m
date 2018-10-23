% Decompose the essential matrix
% Return P = [R|t] which relates the two views
% You will need the point correspondences to find the correct solution for P
function P = decomposeE(E, x1s, x2s)
    [U,S,V] = svd(E);
    t = U(:,3);
    t = t/norm(t);
    
    W = zeros(3);
    W(2,1) = 1;
    W(1,2) = -1;
    W(3,3) = 1;
    
    R1 = U*W*V';
    if det(R1) < 0
        R1 = -R1;
    end
    
    R2 = U*W'*V';
    if det(R2) < 0
        R2 = -R2;
    end
    
    It = [eye(3),t];
    Imt = [eye(3),-t];
    
    %P0 = [eye(3), zeros(3,1)]
    P0 = eye(4);
    %P1 = R1*It;
    %P2 = R1*Imt;
    %P3 = R2*It;
    %P4 = R2*Imt;
    P1 = [R1,t];
    P2 = [R1,-t];
    P3 = [R2,t];
    P4 = [R2,-t];
    
    v = [0 0 0 1];
    Ps = {[P1;v],[P2;v],[P3;v],[P4;v]};
    
    [nx1s,T1] = normalizePoints2d(x1s);
    [nx2s,T2] = normalizePoints2d(x2s);
    
    P = [];
    for i = 1:4
        P = Ps{i};
        [X,err] = linearTriangulation(P0,x1s,P,x2s);
        PX = P*X;
        
        X_target = find(X(3,:) > 0);
        PX_target = find(PX(3,:) > 0);
        
        if length(X_target) == 9 && length(PX_target) == 9
            figure(3) 
            scatter3(X(1,:),X(2,:),X(3,:))
            hold on
            showCameras({P0,P},3);
            break;
        end
    end
    
end