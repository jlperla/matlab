% $Rev: 56 $
% $Date: 2016-02-14 21:38:36 -0800 (Sun, 14 Feb 2016) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2008-2016
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

close all;
%clear classes; %Clears breakpoints for whatever reason.
%    clear functions; %This removes all .m files from memory, but clears breakpoints which is annoying.
clearvars -except  MADMaxDenseN MADMaxSparseFracForFull MADMinSparseN;
format compact;
clc;
tic;