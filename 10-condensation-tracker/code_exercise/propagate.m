function particles = propagate(particles,sizeFrame,params)
    model = params.model;
    sigma_pos = params.sigma_position;
    sigma_vel = params.sigma_velocity;
    heightFrame = sizeFrame(1);
    widthFrame = sizeFrame(2);
    
    w = zeros(size(particles));
    if model == 0
        % If no motion, state length = 2, A is 2x2 matrix
        A = eye(2);
        
    elseif model == 1
        % If constant velocity, state length = 4, A is 4x4 matrix
        A = eye(4);
        A(1,3) = 1;
        A(2,4) = 1; 
    end
    
    % Propagate each sample
    for i = 1:size(particles,1)
        w(i,1:2) = normrnd(0,sigma_pos,[1,2]);
           
        if model == 1
            w(i,3:4) = normrnd(0,sigma_vel,[1,2]);
        end
        
%         if particles(i,1) == widthFrame || particles(i,1) == 1 || particles(i,2) == heightFrame || particles(i,2) == 1
%             continue;
%         end
        
        prediction = (A * particles(i,:)' + w(i,:)')';
        
%         while prediction(1,1) > widthFrame || prediction(1,1) <= 0 || prediction(1,2) > heightFrame || prediction(1,2) <= 0
%             w(i,1:2) = normrnd(0,sigma_pos,[1,2]);
%             prediction = (A * particles(i,:)' + w(i,:)')';
%         end

        if prediction(1,1) > widthFrame
            prediction(1,1) = widthFrame;
        end
        
        if prediction(1,1) < 1
            prediction(1,1) = 1;
        end
        
        if prediction(1,2) > heightFrame
            prediction(1,2) = heightFrame;
        end
        
        if prediction(1,2) < 1
            prediction(1,2) = 1;
        end
        
        particles(i,:) = prediction;
    end
end