function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words
p_Car = 0.5;
p_notCar = 0.5;

p_hist_Car = exp(nansum(log(normpdf(histogram,muPos,sigmaPos))));
p_hist_notCar = exp(nansum(log(normpdf(histogram,muNeg,sigmaNeg))));

p_Car_hist = p_hist_Car * p_Car;
p_notCar_hist = p_hist_notCar * p_notCar;

if p_Car_hist > p_notCar_hist
    label = 1;
else
    label = 0;
end

end