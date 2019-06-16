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
% dbSearch.m -- This file is part of 2DKD.
% 
% This script is responsible for searching the output of 'dbIndex' for 
% descriptors similar to the ones corresponding the query. A query image is 
% supplied as input, then 'compDesc' is run on the query, producing descriptors 
% for it, and then the matrix from 'dbIndex' is sorted by Euclidean distance of 
% descriptors to the new ones obtained, giving a ranked list of the most similar
% regions to the query from all subimages in the database.
% 
% See the references [1] and [2] for details.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function top_matches = dbSearch(queryPath,DB,dbPath,imageList,S,frameSize,xp,yp)

% Read the query image file to 2D function fQuery(x,y)
[fQuery, ~] = readImage(queryPath);

% Precompute constants (norms, coefficients, central weight)
const = prepStep(S);

% Compute the 2DKD of the query corresponding to the location (xp,yp)
[fs, xs, ys] = squareCrop(fQuery, xp, yp, S);
Vquery = compDesc(fs, xs, ys, const);

% Number of entries in the database
dbSize = size(DB,1);

% Compute all (squared) Euclidean distances between 2DKDs: Query vs. entire database
EucDist = sum( ( repmat(Vquery,dbSize,1) - DB(:,4:9) ).^2 , 2 ) ;

% Concatenate Euclidean distances to dataset for sorting altogether
DB = [DB EucDist];

% Sort the database with respect to Euclidean distances column
DB = sortrows(DB,10);

% Remove redundancies in top 2000 (Same/overlapping regions)
k = min(dbSize,2000);
DB = DB( 1:k, : );
dbSize = size(DB,1);

k = dbSize;
Ind = ones(1,k);
for i = 1:k-1
    if Ind(i) == 1
        for j = i+1:k
            if ( (DB(i,1)==DB(j,1)) && (abs(DB(i,2) - DB(j,2)) <= 10)  &&  (abs(DB(i,3) - DB(j,3)) <= 10) )
                Ind(j) = 0;
            end
        end
    end
end
DB(Ind==0,:) = [];
dbSize = size(DB,1);

% Top k matches from the indexed database
% Results are listed in the following format:
% [ rankingNumber imageFileName  xLocation  yLocation ]
k = 15;
%fprintf('Top %i matches from the indexed database.\n',k);
%fprintf('Results are listed in the format:\n');
%fprintf('\n'' rankingNumber imageFileName  xLocation  yLocation ''\n\n');

top_matches = [ repmat('  ',[k 1]) num2str((1:k)') repmat('    ',[k 1]) ...
            imageList(DB(1:k,1),:)  repmat('  ',[k 1]) num2str(DB(1:k,2:3))];

% Plot the query subimage
X = 0:frameSize-1;    Y = X;
[X,Y] = ndgrid(X,Y);

[~,fileName,ext] = fileparts(queryPath);

s = get(0, 'ScreenSize');
figure('Position', [10 10 s(3)-100 s(4)-100]);

subplot(3,6,1)
[fQueryLocal,~,~] = squareCrop(fQuery,xp,yp,frameSize);
pl = pcolor(X,-Y,fQueryLocal);
axis equal tight
colormap gray
set(pl,'edgecolor','none')
axis off;
title({'Query',[fileName ext],['(x,y) = (' num2str(xp) ',' num2str(yp) ')']},'Interpreter', 'none','Fontsize',8);


% Plot top 15 retrievals from the database
for i = 1:15
    
    [~,fileName,ext] = fileparts(imageList(DB(i,1),:));
    [fMatch, ~] = readImage([dbPath fileName ext(1:4)]);
    
    xMatch = DB(i,2);    yMatch = DB(i,3);
    
    [fMatchLocal,~,~] = squareCrop(fMatch,xMatch,yMatch,frameSize);
    
    if i<=5
        subplot(3,6,i+1)
        pl = pcolor(X,-Y,fMatchLocal);
        axis equal tight
        colormap gray
        set(pl,'edgecolor','none')
        axis off;
        istr = num2str(i);
        title({['Top ' istr],[fileName ext],['(x,y) = (' num2str(xMatch) ',' num2str(yMatch) ')']},'Interpreter', 'none','Fontsize',8);
    end
    
    if i>5  &&  i<=10
        subplot(3,6,i+2)
        pl = pcolor(X,-Y,fMatchLocal);
        axis equal tight
        colormap gray
        set(pl,'edgecolor','none')
        axis off;
        istr = num2str(i);
        title({['Top ' istr],[fileName ext],['(x,y) = (' num2str(xMatch) ',' num2str(yMatch) ')']},'Interpreter', 'none','Fontsize',8);
    end
    
    if i>10
        subplot(3,6,i+3)
        pl = pcolor(X,-Y,fMatchLocal);
        axis equal tight
        colormap gray
        set(pl,'edgecolor','none')
        axis off;
        istr = num2str(i);
        title({['Top ' istr],[fileName ext],['(x,y) = (' num2str(xMatch) ',' num2str(yMatch) ')']},'Interpreter', 'none','Fontsize',8);
    end
    
end
