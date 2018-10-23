function meanState = estimate(particles,particles_w)
    particles_w = particles_w / sum(particles_w);
    meanState = sum(particles .* particles_w);
end