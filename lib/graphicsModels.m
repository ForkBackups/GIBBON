function [F,V]=graphicsModels(varargin)

% function [F,V]=graphicsModels(modelID)
% ------------------------------------------------------------------------
% 
%
% Kevin Mattheus Moerman
% gibbon.toolbox@gmail.com
% 
% 2015/04/25 Added to GIBBON
%------------------------------------------------------------------------

%% Parse input

switch nargin
    case 0
        modelID=1;
    case 1
        modelID=varargin{1};
end

%%
defaultFolder = fileparts(fileparts(mfilename('fullpath')));
pathName=fullfile(defaultFolder,'data','libSurf');
switch modelID
    case 1
        fileName=fullfile(pathName,'stanford_bunny_closed.mat');
        D=load(fileName);
    case 2
        fileName=fullfile(pathName,'utah_teapot.mat');
        D=load(fileName);
    case 3
        fileName=fullfile(pathName,'cow.mat');
        D=load(fileName);
    case 4
        fileName=fullfile(pathName,'parasaurolophus.mat');
        D=load(fileName);
    case 5
        fileName=fullfile(pathName,'femur.mat');
        D=load(fileName);
    case 6
        fileName=fullfile(pathName,'hip_implant.mat');
        D=load(fileName);
    case 7 
        fileName=fullfile(pathName,'elephant.mat');
        D=load(fileName);
end

F=D.F;
V=D.V;
 
%% 
% _*GIBBON footer text*_ 
% 
% License: <https://github.com/gibbonCode/GIBBON/blob/master/LICENSE>
% 
% GIBBON: The Geometry and Image-based Bioengineering add-On. A toolbox for
% image segmentation, image-based modeling, meshing, and finite element
% analysis.
% 
% Copyright (C) 2018  Kevin Mattheus Moerman
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
