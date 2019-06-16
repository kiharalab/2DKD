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
% exampleDBsearchExp2.m -- This file is part of 2DKD.
% 
% In this example, we show how to search an indexed database in Experiment II
% for given a query image. Here, we query the center of a local region in an
% image and then search for similar local regions in an image in the database
% /Exp2/DB/. This database contains only one image indexed as 'indexedDB.mat'.
% The output shows the top 15 matches from the indexed database, which are
% listed in the following format:
% 
% ' rankingNumber imageFileName  xLocation  yLocation '.
% 
% The text output and the figure output are saved to 'outputDBsearchExp2.txt'
% and 'figureDBsearchExp2.pdf', respectively, under the /outputs folder. To view
% the text output, you may use Octave's (or MATLAB's) editor. This example is
% discussed in the Results section of the reference [1] as Experiment II and a
% part of the figure output is demonstrated in Fig. 6.
% 
% See the references [1] and [2] for details.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start with closing open figures, clearing memory and the command window.
close all; clear; clc;

% Change directory to the scripts folder.
cd scripts;

% Path to the query image.
queryPath = '../Exp2/DB/cryoem_groel.jpg';

% Path to the database.
dbPath = '../Exp2/DB/';

% Load the database records already indexed by 'dbIndex.m'.
load([dbPath 'indexedDB.mat']);

% Point-of-interest location in the query image.
xp = 565;  yp = 780;

% Compute the 2DKD for the query image and search for similar images within the
% indexed database.
top_matches = dbSearch(queryPath,DB,dbPath,imageList,S,frameSize,xp,yp);

% Plot the figure showing top matches and save it to file.
set(gcf,'PaperSize',fliplr(get(gcf,'PaperSize')));
print -dpdf '-fillpage' ../outputs/figureDBsearchExp2.pdf

% Save the text output to file. The text output shows top matches from the
% indexed database. The results are listed in the following format:
% ' rankingNumber imageFileName  xLocation  yLocation '
numlines = size(top_matches,1);
fid = fopen ('../outputs/outputDBsearchExp2.txt','w');
for i = 1:numlines
   fprintf (fid, '%c', top_matches(i,:));  
   fprintf (fid, '\n');
end
fclose (fid);
