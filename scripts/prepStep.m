%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 2DKD -- Two-Dimensional Krawtchouk Descriptors
% 
% Copyright (C) 2019, Julian S DeVille, Daisuke Kihara, Atilla Sit, Purdue 
% University, and Eastern Kentucky University.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% All of codes were implemented by Julian S DeVille and Atilla Sit, and checked 
% and run by Daisuke Kihara
% 
% Octave Release: 5.1.0 (or MATLAB Release: 9.6.0 (R2019a))
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% If you use these programs, please cite the following references:
% 
% [1] AUTHORS: Julian S DeVille, Daisuke Kihara, Atilla Sit
% TITLE: 2DKD: A Toolkit for Content Based Local Image Search
% JOURNAL: Source Code for Biology and Medicine, BMC, submitted, 2019.
% 
% [2] AUTHORS: Atilla Sit, Daisuke Kihara
% TITLE: Comparison of Image Patches Using Local Moment Invariants
% JOURNAL: IEEE Transactions on Image Processing, 23(5), 2369-2379, 2014.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% To download the current version of this code, please visit the website:
% <https://github.com/kiharalab/2DKD>
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% prepStep.m -- This file is part of 2DKD.
% 
% For a given positive integer S, this script first computes the 1D weight 
% function w(x;p,S-1) for p = 0.5 and then the 2D weight function 
% 
%                Wc(x,y) = sqrt{ w(x;px,S-1) * w(y;py,S-1) } 
% 
% corresponding to px = py = 0.5 (i.e., the center of an SxS image). It also 
% computes the norms rho(n;p,S-1) and the coefficients a_{i,n,p,S-1} 
% corresponding to the Krawtchouk polynomials K_n(x;p,S-1) where n=0,...,3 and 
% i=0,...,n. These initial constants computed in prepStep are for later use, so 
% the rest of the computations is performed on-the-fly.
% 
% See the references [1] and [2] for details.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function const = prepStep(S)
    
    % Recursively compute the square-root of the 1D weight function w(x;p,S-1) 
    % for p = 0.5
    w = zeros(S,1);
    w(1) = 1;
    for x = 0:floor((S-1)/2)-1
        w(x+2) = w(x+1) *  sqrt((S-1-x) / (x+1)) ;
    end
    w = w * (0.5)^((S-1)/2);
    
    % Use symmetry to produce the second half of w(x;p,S-1) from its first half
    w( S-floor(S/2)+1 : 1 : S ) = w( floor(S/2) : -1 : 1 );
    
    % Compute the 2D weight function for px = py = 0.5 defined on the discrete 
    % domain {0,1,...,S-1} x {0,1,...,S-1}
    const.Wc = w*w';
    
    % Compute the norms rho(n;p,S-1) for p = 0.5 and n = 0,...,3.
    % See equation (6) in [2]
    const.rho = zeros(1,4);
    const.rho(1) =  1;
    const.rho(2) =  1 / (S-1);
    const.rho(3) =  2 / ((S-1)*(S-2));
    const.rho(4) =  6 / ((S-1)*(S-2)*(S-3));
    
    % Compute the coefficients a(k,n,p,S-1) for p = 0.5, n = 0,...,3, and 
    % k = 0,...,n. See equation (1) in [2]
    const.a = zeros(4,4);
    const.a(1,1) = 1;
    const.a(1,2) = 1;
    const.a(2,2) = - 2/(S-1);
    const.a(1,3) = 1;
    const.a(2,3) = - 4/(S-1) - 4/((S-1)*(S-2));
    const.a(3,3) = 4/((S-1)*(S-2));
    const.a(1,4) = 1;
    const.a(2,4) = - 6/(S-1) - 12/((S-1)*(S-2)) - 16/((S-1)*(S-2)*(S-3));
    const.a(3,4) = 12/((S-1)*(S-2)) + 24/((S-1)*(S-2)*(S-3));
    const.a(4,4) = - 8/((S-1)*(S-2)*(S-3));
    