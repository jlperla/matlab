function index = closest_index(val, vector)
	[~, index] = min(abs(vector-val));
end