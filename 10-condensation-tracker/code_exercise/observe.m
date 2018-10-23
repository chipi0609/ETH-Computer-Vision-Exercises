function particles_w = observe(particles,frame,H,W,hist_bin,hist_target,sigma_observe)
    particles_w = zeros(size(particles,1),1);
    
    sizeFrame = size(frame);
    heightFrame = sizeFrame(1);
    widthFrame = sizeFrame(2);
    
    for i = 1:size(particles,1)
        % Compute color histogram for each particle
        xMin = round(min(max(1,particles(i,1)-0.5*W),widthFrame));
        xMax = round(min(max(1,particles(i,1)+0.5*W),widthFrame));
        yMin = round(min(max(1,particles(i,2)-0.5*H),heightFrame));
        yMax = round(min(max(1,particles(i,2)+0.5*H),heightFrame));
        hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin);
        
        % Update particle weights
        distance = chi2_cost(hist,hist_target);
        particles_w(i) = 1/(sqrt(2*pi) * sigma_observe) * exp(-distance/(2*sigma_observe*sigma_observe));
        if isnan(particles_w(i))
            particles_w(i) = 0;
        end
    end
end
