function f = portfolio_objective(x, Prob)
    f = sum((x.^2).*(Prob.alpha .^2));
end