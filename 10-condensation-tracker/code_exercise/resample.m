function [particles particles_w] = resample(particles,particles_w)
    particles_ids = randsample(1:size(particles),size(particles,1),true,particles_w);
    particles = particles(particles_ids,:);
    particles_w = particles_w(particles_ids,:);
end