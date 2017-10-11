function [J, grad] = lrCostFunction(theta, X, y, lambda)

m = length(y); 
J = 0;
grad = zeros(size(theta));
temp = theta;   
temp(1) = 0;

z = sigmoid(X * theta);

J = (-y' * log(z) - (1 - y)' * log(1 - z)) / m ;
grad = X' * (z - y) / m;

J = J + lambda /(2*m) * temp'* temp;
grad = grad + temp * lambda/m;


grad = grad(:);

end
