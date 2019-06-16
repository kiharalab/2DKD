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
% squareCrop.m -- This file is part of 2DKD.
% 
% This script crops an N-by-M image density function f(x,y) to a perfect SxS 
% square image data fs(x,y). The point-of-interest location (xp,yp) in the input
% image is updated to its relative location (xs,ys) in the square image.
% 
% See the references [1] and [2] for details.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fs,xs,ys] = squareCrop(f,xp,yp,S)
    
    % Size of the input image
    [N,M] = size(f);
    
    % Error message to ensure the input point-of-interest is appropriate
    if mod(xp,1)~=0  ||  xp<0  ||  xp>=N
        fprintf('\nError: xp must be an integer satisfying 0 <= xp < %i \n\n',N);
        return
    end
    if mod(yp,1)~=0  ||  yp<0  ||  yp>=M
        fprintf('\nError: yp must be an integer satisfying 0 <= yp < %i \n\n',M);
        return
    end
    if mod(S,2)~=0
        fprintf('\nError: S must be an even integer <= %i \n\n',min([N M]));
        return
    end
    
    if (S ~= N) || (S ~= M)  % square crop is needed
        
        % The beginnning and ending horizontal pixel number of the subimage
        if xp <= S/2
            istart = 1;
            iend =  S;
        else
            if N-xp <= S/2
                istart = N - S + 1;
                iend = N;
            else 
                istart = xp - S/2 + 1;
                iend = xp + S/2;
            end
        end
        
        % The beginnning and ending vertical pixel number of the subimage
        if yp <= S/2
            jstart = 1;
            jend = S;
        else
            if M-yp <= S/2
                jstart = M - S + 1;
                jend = M;
            else
                jstart = yp - S/2 + 1;
                jend = yp + S/2;
            end
        end
        
        % Cropped subimage fs(x,y) is now of size S-by-S
        fs = f(istart:iend , jstart:jend);
        
        % Relative locations (xs,ys) of the point of interest
        xs = xp - istart + 1;
        ys = yp - jstart + 1;
        
    else  % square crop is not needed
        
        fs = f;
        xs = xp;
        ys = yp;
        
    end
    