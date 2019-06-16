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
% computeDesc.m -- This file is part of 2DKD.
% 
% This script computes the two-dimensional Krawtchouk descriptors (2DKD) of 
% order up to 3. The inputs are an image density function f(x,y) and the 
% point-of-interest location (xp,yp). The output vector V contains the six 
% invariant local descriptors.
% 
% See the references [1] and [2] for details.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function V = compDesc(fs,xs,ys,const)
    
    S = size(const.Wc,1);
    
    % Translate const.Wc computed in prepStep so its geometric center moves from 
    % ((S-1)/2,(S-1)/2) to the point-of-interest (xs,ys).
    W = zeros(S,S);
    xmove = round( xs - (S-1)/2 );
    if xmove > 0
        W( 1+xmove : S , : ) = const.Wc( 1 : S-xmove , : );
    elseif xmove < 0
        W( 1 : S+xmove , : ) = const.Wc( 1-xmove : S , : );
    else
        W = const.Wc;
    end
    
    Ws = zeros(S,S);
    ymove = round( ys - (S-1)/2 );
    if ymove > 0
        Ws( : , 1+ymove : S ) = W( : , 1 : S-ymove );
    elseif ymove < 0
        Ws( : , 1 : S+ymove ) = W( : , 1-ymove : S );
    else
        Ws = W;
    end
    clear W;
    
%    % To see a plot of the translated weight
%    pcolor(Ws');
    
    % Compute the weighted (auxiliary) image ftilde. See equation (22) in [2].
    ftilde = fs .* Ws;
    clear fs Ws;
    
    % Compute the first three geometric moments M_00, M_10, and M_01 of ftilde.
    % See equation (24) in [2].
    x = 0:1:S-1;
    y = 0:1:S-1;
    sumftilde1 = sum(ftilde,1);
    sumftilde2 = sum(ftilde,2);
    M00 = sum(sumftilde1);
    M10 = sum(x'.*sumftilde2);
    M01 = sum(y .*sumftilde1);
    
    % Compute the center of mass of ftilde. See the reference [2] for details.
    xtilde = M10 / M00;
    ytilde = M01 / M00;
    
    % Compute the central moments mu_20, mu_02, and mu_11 of ftilde.
    % See the reference [2] for details.
    xMinuSxtilde = x - xtilde;
    clear x;
    yMinuSytilde = y - ytilde;
    clear y;
    mu20 = sum( (xMinuSxtilde.^2)' .* sumftilde2 );
    mu02 = sum( (yMinuSytilde.^2)  .* sumftilde1 );
    mu11 = sum(sum( xMinuSxtilde'*yMinuSytilde.*ftilde ));
    clear sumftilde1 sumftilde2;
    
    % Find the unique angle theta required for building the rotation invariant
    % descriptors. See the reference [2] for details.
    mu20MinuSmu02 = mu20 - mu02;
    if mu11 == 0
        if mu20MinuSmu02 == 0
            theta = 0;
        else
            if mu20MinuSmu02 > 0
                theta = 0;
            else
                theta = -pi/2;
            end
        end
    end
    
    if mu11 > 0
        if mu20MinuSmu02 == 0
            theta = pi/4;
        else
            if mu20MinuSmu02 > 0
                ksi = 2 * mu11 / mu20MinuSmu02;
                theta = (1/2)*atan(ksi);
            else
                ksi = 2 * mu11 / mu20MinuSmu02;
        	    theta = (1/2)*atan(ksi) + pi/2;
            end
        end
    end
    
    if mu11 < 0
        if mu20MinuSmu02 == 0
            theta = -pi/4;
        else
            if mu20MinuSmu02 > 0
                ksi = 2 * mu11 / mu20MinuSmu02;
                theta = (1/2)*atan(ksi);
            else
                ksi = 2 * mu11 / mu20MinuSmu02;
                theta = (1/2)*atan(ksi) - pi/2;
            end
        end
    end
    
    % Compute geometric invariants lambdatilde_ij. See equation (26) in [2].
    sqrtM00 = sqrt(M00);
    
    costhetaOverSqrtM00 = cos(theta) / sqrtM00;
    sinthetaOverSqrtM00 = sin(theta) / sqrtM00;
    
    xMinuSxtilde11 =  xMinuSxtilde *  costhetaOverSqrtM00;
    yMinuSytilde12 =  yMinuSytilde *  sinthetaOverSqrtM00;
    xMinuSxtilde21 =  xMinuSxtilde *(-sinthetaOverSqrtM00);
    yMinuSytilde22 =  yMinuSytilde *  costhetaOverSqrtM00;
    clear xMinuSxtilde yMinuSytilde;
    
    X = repmat((xMinuSxtilde11)', [1 length(yMinuSytilde12)]);
    Y = repmat( yMinuSytilde12  , [length(xMinuSxtilde11) 1]);
    A = X + Y + (S-1)/2;
    clear xMinuSxtilde11 yMinuSytilde12;
    
    X = repmat((xMinuSxtilde21)', [1 length(yMinuSytilde22)]);
    Y = repmat( yMinuSytilde22  , [length(xMinuSxtilde21) 1]);
    B = X + Y + (S-1)/2;
    clear xMinuSxtilde21 yMinuSytilde22 X Y;
    
    lambdatilde = zeros(4,4);
    ftildeAi = ftilde;
    for i = 0:3
        if i ~= 0
            ftildeAi = A.*ftildeAi;
        end
        ftildeAiBj = ftildeAi;
        for j = 0:3
            if i+j <= 3
                if j ~= 0
                    ftildeAiBj = B.*ftildeAiBj;
                end
                lambdatilde(i+1,j+1) = sum( sum( ftildeAiBj ) );
            end
        end
    end
    clear A B ftilde ftildeAi ftildeAiBj
    lambdatilde = lambdatilde / M00;
    
    % Compute Qtilde_ij. See equation (27) in [2]
    Qtilde = zeros(4,4);
    for n = 0:3
        for m = 0:3
            if n+m <= 3
                Qtilde(n+1,m+1) = const.a(1:n+1,n+1)' * lambdatilde(1:n+1,1:m+1) * const.a(1:m+1,m+1);
            end
        end
    end
    clear lambdatilde;
    Qtilde = Qtilde ./ sqrt(const.rho'*const.rho);
    
%    % 2D Krawtchouk descriptors in which the first four are theoretically [1 0 0 0]
%     V = [ Qtilde(1,1) Qtilde(1,2) Qtilde(2,1) Qtilde(2,2) ...
%           Qtilde(3,1) Qtilde(1,3) Qtilde(2,3) Qtilde(3,2) Qtilde(4,1) Qtilde(1,4) ];
%    % So we use the nonredundant local image descriptors of order up to 3
    
    V = [ Qtilde(3,1) Qtilde(1,3) Qtilde(2,3) Qtilde(3,2) Qtilde(4,1) Qtilde(1,4) ];
    