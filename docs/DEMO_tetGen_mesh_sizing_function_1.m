%% DEMO_tetGen_mesh_sizing_function_1
% Below is a demonstration for:
% 
% * The use of TetGen for meshing based on surface geometry
% * Biasing the mesh density using a size function specified on the
% boundary nodes

%%

clear; close all; clc;

%%
% Plot settings
fontSize=15;
faceAlpha1=0.5;
faceAlpha2=0.5;
edgeColor='k';
edgeWidth=1.5; 

% path names
defaultFolder = fileparts(fileparts(fileparts(mfilename('fullpath'))));
savePath=fullfile(defaultFolder,'data','temp');

%%
%Specifying dimensions and number of elements
sampleWidth=32*4;
sampleThickness=32; 
sampleHeight=16;
pointSpacing=8;

numElementsWidth=round(sampleWidth/pointSpacing);
numElementsThickness=round(sampleThickness/pointSpacing);
numElementsHeight=round(sampleHeight/pointSpacing);

%% Defining the surface models
% The model will consists of two spheres one contained within the other
% defining two material regions. A stiff core and a soft outer later.

% Creating a meshed box (4-node tetrahedral elements)
boxDim=[sampleWidth sampleThickness sampleHeight]; %Dimensions
boxEl=[numElementsWidth numElementsThickness numElementsHeight]; %Number of elements
[Fq,Vq,faceBoundaryMarker_q]=quadBox(boxDim,boxEl);
[F,V]=quad2tri(Fq,Vq,'f');

faceBoundMarker1=2; 
faceBoundaryMarker=faceBoundMarker1*ones(size(F,1),1); %Create boundary markers for faces

%%
% Plotting surface models
hf=cFigure;
title('The surface model','FontSize',fontSize);
xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize);
hold on;

patch('Faces',F,'Vertices',V,'FaceColor','flat','CData',faceBoundaryMarker,'FaceAlpha',faceAlpha1,'lineWidth',edgeWidth,'edgeColor',edgeColor);
% [hp]=patchNormPlot(F,V,0.25);

colormap(gjet(2));
colorbar;
camlight headlight;
set(gca,'FontSize',fontSize);
view(3); axis tight;  axis equal;  grid on;

%% Defining a size function on the boundary nodes

%Get edge lengths and base minimum size on input edge lengths
[edgeLengths]=patchEdgeLengths(F,V);
minEdgeSize=mean(edgeLengths)/5; %The smallest element size

n=5; %The largest element edge length is n times minEdgeSize
edgeSizeField=V(:,1);
edgeSizeField=edgeSizeField-min(edgeSizeField(:));
edgeSizeField=edgeSizeField./max(edgeSizeField(:));
edgeSizeField=(edgeSizeField*(n-1))+1; %Range from 0-n depending on V(:,1) i.e. X-dir
edgeSizeField=(edgeSizeField*minEdgeSize);

%%
% Plotting surface models
hf=cFigure;
title('Boundary points where desired element size is specified','FontSize',fontSize);
xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize);
hold on;

patch('Faces',F,'Vertices',V,'FaceColor',0.5*ones(1,3),'FaceAlpha',0.1,'edgeColor','none');
scatter3(V(:,1),V(:,2),V(:,3),75,edgeSizeField,'fill')

colormap(gjet(250));
colorbar;
camlight headlight;
set(gca,'FontSize',fontSize);
view(3); axis tight;  axis equal;  grid on;

%% CREATING A SOLID TETRAHEDRAL MESH USING TETGEN

inputStruct.stringOpt='-pq1.1Aa';
inputStruct.Faces=F;
inputStruct.Nodes=V;
inputStruct.sizeData=edgeSizeField;
inputStruct.holePoints=[];
inputStruct.faceBoundaryMarker=faceBoundaryMarker; %Face boundary markers
inputStruct.regionPoints=[0 0 0]; %region points

%%
% Mesh model using tetrahedral elements using tetGen 
[meshOutput]=runTetGen(inputStruct); %Run tetGen

%%
% Accessing the model element and patch data

FT=meshOutput.faces;
Fb=meshOutput.facesBoundary;
Cb=meshOutput.boundaryMarker;
VT=meshOutput.nodes;
E=meshOutput.elements;
elementMaterialIndices=meshOutput.elementMaterialID;

%%
% Calculate element volumes for display purposes
C=tetVol(E,VT);

%%
% Plotting the meshed geometry

%Selecting half of the model to see interior
X=VT(:,3); XE=mean(X(E),2);
L=XE<mean(X(:));
[Fs,Cs]=element2patch(E(L,:),C(L),'tet4');

hf1=cFigure;

title('Cut view of biased mesh','FontSize',fontSize);
xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize); hold on;

[CV]=faceToVertexMeasure(Fs,VT,Cs);
hps=patch('Faces',Fs,'Vertices',VT,'FaceColor','flat','CData',CV,'lineWidth',edgeWidth);
shading interp; 
set(hps,'edgeColor',edgeColor);

view(3); axis tight;  axis equal;  grid on;
colormap(gjet(250)); colorbar; 
camlight headlight;
set(gca,'FontSize',fontSize);
drawnow;

%% 
%
% <<gibbVerySmall.gif>>
% 
% _*GIBBON*_ 
% <www.gibboncode.org>
% 
% _Kevin Mattheus Moerman_, <gibbon.toolbox@gmail.com>
 
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
