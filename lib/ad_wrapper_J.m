function [obj,jac] = ad_wrapper_J(x, settings)
    [obj,jac] = eval_AD(settings.f, x, settings);
end
