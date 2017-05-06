function c = portfolio_constraint(x, Prob)
    c = (1/2)*sum( log(Prob.sigma.^2) - log(x.^2) ) - Prob.kappa;
end