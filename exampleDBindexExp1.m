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
% exampleDBindexExp1.m -- This file is part of 2DKD.
% 
% In this example, we show how to index one of the databases in Experiment I. We
% index four .jpg images in the folder /Exp1/DB_30_per_noise/. The result is
% stored in a matrix with rows of the form <Image number,xp,yp,V>, where (xp,yp)
% is the center of local region-of-interest and V the vector of 2DKD's at that
% location. This needs to be performed for easy access later when a subimage is
% queried. Note that unless there is a change in the database, this only needs
% to be run once offline to save computational time. The output 'indexedDB.mat'
% will be saved to the 'dbPath' provided by user. See the workflow section in
% the manuscript [1] for more details.
% 
% See the references [1] and [2] for details.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start with closing open figures, clearing memory and the command window.
close all; clear; clc;

% Change directory to the scripts folder.
cd scripts;

% Path to the database (one of the database folders under /Exp1).
dbPath = '../Exp1/DB_30_per_noise/';

% The size of the square subimages to be cropped.
S = 150;

% The number of pixels between two consecutive point-of-interest locations
% (how thorough the database will be indexed).
inc = 60;

% Use local variance as a criterion or not. 0 means no, else means yes. Local
% variance criterion is only used in Experiment II. See the reference [1] for
% details.
lv_check = 0;

% The size of square subimages that will be used to compute local variance
% and/or to plot top rankings.
frameSize = 60;

% Index the database with the above parameters. 'indexedDB.mat' will be saved
% to 'dbPath' after executing the following command.
dbIndex(dbPath,S,inc,frameSize,lv_check);
