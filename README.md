# 2DKD
Two-Dimensional Krawtchouk Descriptors

Copyright (C) 2019, Julian S DeVille, Daisuke Kihara, Atilla Sit, Purdue University, and Eastern Kentucky University.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

All of codes were implemented by Julian DeVille and Atilla Sit, and checked and run by Daisuke Kihara.

Octave Release: 5.1.0 (or MATLAB Release: 9.6.0 (R2019a)).

If you use these programs, please cite the following references:

[1] Julian S DeVille, Daisuke Kihara, and Atilla Sit. 2DKD: A Toolkit for Content Based Local Image Search. Source Code for Biology and Medicine, BMC, submitted, 2019.

[2] Atilla Sit and Daisuke Kihara. Comparison of Image Patches Using Local Moment Invariants. IEEE Transactions on Image Processing, 23(5), 2369-2379, 2014.

To download the current version of this code, please visit the website:
<https://github.com/kiharalab/2DKD>.

In order to use 2DKD, GNU Octave (or MATLAB) must be installed. To download Octave, please visit the website https://www.gnu.org/software/octave/, click 'Download', and then follow the instructions under the operating system that you are using.

After you install and launch Octave (or MATLAB), change the current directory to /2DKD-master/.

Usage examples:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXAMPLE 1.

% In this example, we show how to compute 2DKD for a particular image, given the path to the image file and the point-of-interest location. Here, we use the file 'image1.jpg' from Experiment I as an example and specify the center of a particular local image (which is a cat in image1.jpg). We then compute the 2DKD's (six invariant descriptors) given by Eqn. (3) in the reference [1] for this example. The output is saved to 'output2DKD.txt' in the /outputs folder. To view the output, you may use Octave's (or MATLAB's) editor. This example is also shown on page 3 of the reference [1].

% Type the following commands (lines with >>) on the command window. Alternatively, you may run the file 'example2DKD.m' directly.

% Change directory to the scripts folder.

>> cd scripts;

% Full path to the sample image file.

>> impath = '../Exp1/DB/image1.jpg';

% Point-of-interest location (the center of the local image).

>> xp = 180; yp = 480;

% Read the image to an N-by-M density data.

>> [f,S] = readImage(impath);

% Compute the constants for later use.

>> const = prepStep(S);

% Crop the image data to a square S-by-S data.

>> [fs,xs,ys] = squareCrop(f,xp,yp,S);

% Compute 2DKD corresponding to (xp,yp).

>> V = compDesc(fs, xs, ys, const);

% Save the output to file.

>> save ../outputs/output2DKD.txt V;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXAMPLE 2.

% In this example, we show how to index one of the databases in Experiment I. We index four .jpg images in the folder /Exp1/DB_30_per_noise/. The result is stored in a matrix with rows of the form <Image number,xp,yp,V>, where (xp,yp) is the center of local region-of-interest and V the vector of 2DKD's at that location. This needs to be performed for easy access later when a subimage is queried. Note that unless there is a change in the database, this only needs to be run once offline to save computational time. The output 'indexedDB.mat' will be saved to the 'dbPath' provided by user. See the workflow section in the manuscript [1] for more details.

% Type the following commands (lines with >>) on the command window. Alternatively, you may run the file 'exampleDBindexExp1.m' directly.

% Start with closing open figures, clearing memory and the command window.

>> close all; clear; clc;

% Change directory to the scripts folder.

>> cd scripts;

% Path to the database (one of the database folders under /Exp1).

>> dbPath = '../Exp1/DB_30_per_noise/';

% The size of the square subimages to be cropped.

>> S = 150;

% The number of pixels between two consecutive point-of-interest locations (how thorough the database will be indexed).

>> inc = 60;

% Use local variance as a criterion or not. 0 means no, else means yes. Local variance criterion is only used in Experiment II. See the reference [1] for details.

>> lv_check = 0;

% The size of square subimages that will be used to compute local variance and/or to plot top rankings.

>> frameSize = 60;

% Index the database with the above parameters. 'indexedDB.mat' will be saved to 'dbPath' after executing the following command.

>> dbIndex(dbPath,S,inc,frameSize,lv_check);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXAMPLE 3.

% In this example, we show how to index one of the databases in Experiment II. We index one .jpg image in the folder /Exp2/DB/. The result is stored in a matrix with rows of the form <Image number,xp,yp,V>, where (xp,yp) is the center of local region-of-interest and V the vector of 2DKD's at that location. This needs to be performed for easy access later when a subimage is queried. Note that unless there is a change in the database, this only needs to be run once offline to save computational time. The output 'indexedDB.mat' will be saved to the 'dbPath' provided by user. See the workflow section in the manuscript [1] for more details.

% Type the following commands (lines with >>) on the command window. Alternatively, you may run the file 'exampleDBindexExp2.m' directly.

% Start with closing open figures, clearing memory and the command window.

>> close all; clear; clc;

% Change directory to the scripts folder.

>> cd scripts;

% Path to the database.

>> dbPath = '../Exp2/DB/';

% The size of the square subimages to be cropped.

>> S = 40;

% The number of pixels between two consecutive point-of-interest locations (how thorough the database will be indexed).

>> inc = 5;

% Use local variance as a criterion or not. 0 means no, else means yes. Local variance criterion is only used in Experiment II. See the reference [1] for details.

>> lv_check = 1;

% The size of square subimages that will be used to compute local variance and/or to plot top rankings.

>> frameSize = 40;

% Index the database with the above parameters. 'indexedDB.mat' will be saved to 'dbPath' after executing the following command.

>> dbIndex(dbPath,S,inc,frameSize,lv_check);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXAMPLE 4.

% In this example, we show how to search an indexed database in Experiment I for given a query image. Here, we query a guitar image and then search for similar images in the database /Exp1/DB_30_per_noise/, which contains a total of 4 images containing nine different subimages in random orientations, using the index file 'indexedDB.mat'. The output shows the top 15 matches from the indexed database, which are listed in the following format:

% ' rankingNumber imageFileName  xLocation  yLocation '.

% The text output and the figure output are saved to 'outputDBsearchExp1.txt' and 'figureDBsearchExp1.pdf', respectively, under the /outputs folder. To view the text output, you may use Octave's (or MATLAB's) editor. This example is discussed in the Results section of the reference [1] as Experiment I and a part of the figure output is demonstrated in Fig. 4.

% Type the following commands (lines with >>) on the command window. Alternatively, you may run the file 'exampleDBsearchExp1.m' directly.

% Start with closing open figures, clearing memory and the command window.

>> close all; clear; clc;

% Change directory to the scripts folder.

>> cd scripts;

% Path to the query image (Use one of the query images under /Exp1/queries/).

>> queryPath = '../Exp1/queries/guitar.jpg';

% Path to the database.

>> dbPath = '../Exp1/DB_30_per_noise/';

% Load the database records already indexed by 'dbIndex.m'.

>> load([dbPath 'indexedDB.mat']);

% Point-of-interest location in the query image.

>> xp = S/2;  yp = S/2;

% Compute the 2DKD for the query image and search for similar images within the indexed database.

>> top_matches = dbSearch(queryPath,DB,dbPath,imageList,S,frameSize,xp,yp);

% Plot the figure showing top matches and save it to file.

>> set(gcf,'PaperSize',fliplr(get(gcf,'PaperSize')));

>> print -dpdf '-fillpage' ../outputs/figureDBsearchExp1.pdf

% Save the text output to file. The text output shows top matches from the indexed database. The results are listed in the following format:

% ' rankingNumber imageFileName  xLocation  yLocation '

>> numlines = size(top_matches,1);

>> fid = fopen ('../outputs/outputDBsearchExp1.txt','w');

>> for i = 1:numlines

>>    fprintf (fid, '%c', top_matches(i,:));  

>>    fprintf (fid, '\n');

>> end

>> fclose (fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXAMPLE 5.

% In this example, we show how to search an indexed database in Experiment II for given a query image. Here, we query the center of a local region in an image and then search for similar local regions in an image in the database /Exp2/DB/. This database contains only one image indexed as 'indexedDB.mat'. The output shows the top 15 matches from the indexed database, which are listed in the following format:

% ' rankingNumber imageFileName  xLocation  yLocation '.

% The text output and the figure output are saved to 'outputDBsearchExp2.txt' and 'figureDBsearchExp2.pdf', respectively, under the /outputs folder. To view the text output, you may use Octave's (or MATLAB's) editor. This example is discussed in the Results section of the reference [1] as Experiment II and a part of the figure output is demonstrated in Fig. 6.

% Type the following commands (lines with >>) on the command window. Alternatively, you may run the file 'exampleDBsearchExp2.m' directly.

% Start with closing open figures, clearing memory and the command window.

>> close all; clear; clc;

% Change directory to the scripts folder.

>> cd scripts;

% Path to the query image.

>> queryPath = '../Exp2/DB/cryoem_groel.jpg';

% Path to the database.

>> dbPath = '../Exp2/DB/';

% Load the database records already indexed by 'dbIndex.m'.

>> load([dbPath 'indexedDB.mat']);

% Point-of-interest location in the query image.

>> xp = 565;  yp = 780;

% Compute the 2DKD for the query image and search for similar images within the indexed database.

>> top_matches = dbSearch(queryPath,DB,dbPath,imageList,S,frameSize,xp,yp);

% Plot the figure showing top matches and save it to file.

>> set(gcf,'PaperSize',fliplr(get(gcf,'PaperSize')));

>> print -dpdf '-fillpage' ../outputs/figureDBsearchExp2.pdf

% Save the text output to file. The text output shows top matches from the indexed database. The results are listed in the following format:

% ' rankingNumber imageFileName  xLocation  yLocation '

>> numlines = size(top_matches,1);

>> fid = fopen ('../outputs/outputDBsearchExp2.txt','w');

>> for i = 1:numlines

>>    fprintf (fid, '%c', top_matches(i,:));  

>>    fprintf (fid, '\n');

>> end

>> fclose (fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
