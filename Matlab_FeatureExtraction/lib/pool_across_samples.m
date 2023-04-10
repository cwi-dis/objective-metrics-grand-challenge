function [pooledSamples] = pool_across_samples(samples, type)

samples(~isfinite(samples)) = [];

if strcmp(type, 'Sum')
    pooledSamples = nansum(samples);

elseif strcmp(type, 'Mean')
    pooledSamples = nanmean(samples);

elseif strcmp(type, 'MS')
    pooledSamples = nanmean(samples.^2);

elseif strcmp(type, 'RMS')
    pooledSamples = sqrt(nanmean(samples.^2));

else
    error('Wrong input.');
end
pooledSamples = real(pooledSamples);
