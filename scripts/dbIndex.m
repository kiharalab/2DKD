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
% dbIndex.m -- This file is part of 2DKD.
% 
% This script is responsible for producing descriptors for all subimages in a 
% database so a query can be compared with them. It scans each image in the 
% database by computing the 2DKD for each point-of-interest location, and saves 
% the descriptors with the image number and the location of the subimage in that 
% image. The result is stored in a potentially large matrix with rows of the 
% form  < Image number , xp , yp , V >  for easy access later when a subimage is 
% queried. Note that unless there is a change in the database, this only needs 
% to be run once offline to save computational time.
% 
% See the references [1] and [2] for details.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dbIndex(dbPath,S,inc,frameSize,lv_check)

% List of images in the database (specify all possible image extensions)
imageList = [dir([dbPath '*.jpg']);...
             dir([dbPath '*.png']);...
             dir([dbPath '*.gif'])];
imageList = char(imageList.name);
nImages = size(imageList,1);

% Initiate the database records (start with a large enough array; unused
% rows will be deleted at the end)
DB = zeros(nImages*200^2,9);

% Precompute constants (norms, coefficients, central weight)
const = prepStep(S);

% Counter for the number of rows in the indexed database
rowno = 0;

for imageNo = 1:nImages
    
    [~,fileName,ext] = fileparts(imageList(imageNo,:));
    impath = [dbPath fileName ext(1:4)];
    [f,~] = readImage(impath);
    
    [N,M] = size(f);
    
    xstart = max(inc,20);
    xend = N - xstart;
    
    ystart = max(inc,20);
    yend = M - ystart;
    
    GloVar = var(f(:));
    
    for xp = xstart:inc:xend
        for yp = ystart:inc:yend
            
            if lv_check~=0
                
                fLocal = f(xp-frameSize/2+1:xp+frameSize/2,...
                           yp-frameSize/2+1:yp+frameSize/2);
                
                % Local variation
                LocVar = var(fLocal(:));
                
                if LocVar >= GloVar
                
                    [fs,xs,ys] = squareCrop(f,xp,yp,S);
                
                    V = compDesc(fs,xs,ys,const);
                
                    if isempty(V)~=1
                        rowno = rowno + 1;
                        DB(rowno,:) = [ imageNo xp yp V ];
                    end
                    
                end
                
            else
                
                [fs,xs,ys] = squareCrop(f,xp,yp,S);
                
                V = compDesc(fs,xs,ys,const);
                
                if isempty(V)~=1
                	rowno = rowno + 1;
                    DB(rowno,:) = [ imageNo xp yp V ];
                end
                
            end
            
        end
    end
    
end

% Delete the unused rows at the bottom
DB(rowno+1:nImages*200^2,:) = [];

% Save the indexed database to file for later use
save('-mat',[dbPath 'indexedDB.mat'], 'DB', 'imageList', 'S', 'frameSize');
