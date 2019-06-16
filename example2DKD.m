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
% example2DKD.m -- This file is part of 2DKD.
% 
% In this example, we show how to compute 2DKD for a particular image, given the
% path to the image file and the point-of-interest location. Here, we use the
% file 'image1.jpg' from Experiment I as an example and specify the center of a
% particular local image (which is a cat in image1.jpg). We then compute the
% 2DKD's (six invariant descriptors) given by Eqn. (3) in the reference [1] for
% this example. The output is saved to 'output2DKD.txt' in the /outputs folder.
% To view the output, you may use Octave's (or MATLAB's) editor. This example is
% also shown on page 3 of the reference [1].
% 
% See the references [1] and [2] for details.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change directory to the scripts folder.
cd scripts;

% Full path to the sample image file.
impath = '../Exp1/DB/image1.jpg';

% Point-of-interest location (the center of the local image).
xp = 180;  yp = 480;

% Read the image to an N-by-M density data.
[f, S] = readImage(impath);

% Compute the constants for later use.
const = prepStep(S);

% Crop the image data to a square S-by-S data.
[fs, xs, ys] = squareCrop(f, xp, yp, S);

% Compute 2DKD corresponding to (xp,yp).
V = compDesc(fs, xs, ys, const);

% Save the output to file.
save -ascii ../outputs/output2DKD.txt V;
