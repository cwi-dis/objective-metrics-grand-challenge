function [pooledSamples] = pool_across_samples(samples)

samples(~isfinite(samples)) = [];
pooledSamples = real(nanmean(samples));
