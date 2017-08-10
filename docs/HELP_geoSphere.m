%% geoSphere
% Below is a demonstration of the features of the |geoSphere| function

%% Syntax
% |[F,V,Vs]=geoSphere(n,r,solidType);|

%% Description
% Use |geoSphere| to generate triangulated spheres with nearly geodesic
% triangle distributions. The density of the triangulation can be
% controlled through a particular choice of n (number of mesh refinement
% steps).

%% Examples

clear; close all; clc;

%% 
% Plot Settings
fontSize=15;
faceAlpha=1;
edgeColor=0.2*ones(1,3);
edgeWidth=1.5;

%% Building a geodesic dome based on the icosahedron
% The function inputs are n and r which define the mesh refinement and
% radius respectively. The mesh refinement number n defines the number of
% subtriangulation (see function |subTri|) iterations performed on an
% icosahedron. Below is a visualisation for n=0:1:3. The function outputs
% the geodesic dome faces (F) and vertices (V) and also the spherical
% coordinates of the vertices (Vs) (this output is suppressed in the
% example below).

hf=cFigure; % Open figure for plotting

%Defining triangulated geodesic domes with different densities
r=1; %sphere radius
n=0:1:3; %Refinements   
pColors=autumn(numel(n));
for q=1:1:numel(n);
    [F,V,~]=geoSphere(n(q),r); 
    subplot(2,2,q); hold on;
    title([num2str(n(q)),' refinement iterations'],'FontSize',fontSize);
    xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize);
    hp=patch('Faces',F,'Vertices',V);
    patchNormPlot(F,V);
    set(hp,'FaceColor',pColors(q,:),'FaceAlpha',faceAlpha,'lineWidth',edgeWidth,'edgeColor',edgeColor);
    camlight headlight; 
    set(gca,'FontSize',fontSize);
    view(3); axis tight;  axis equal;  grid on;
end

%% Using other solid types
% Other platonic solids can also be used as a starting tesselation. However
% these may not be as geodesic as the result for the icosahedron and
% dodecahedron. 

%e.g. using a cube
solidTypes=1:5;

hf=cFigure; % Open figure for plotting
titleCell={'tetrahedron','cube','octahedron','icosahedron','dodecahedron'};
n=0; %Refinements   
pColors=autumn(numel(n));
for solidType=solidTypes;
    [F,V,~]=geoSphere(0,r,solidType); 
    subplot(2,3,solidType); hold on;
    title(['Based on: ',titleCell{solidType}],'FontSize',fontSize);
    xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize);
    hp=patch('Faces',F,'Vertices',V);
    set(hp,'FaceColor','b','FaceAlpha',faceAlpha,'lineWidth',edgeWidth,'edgeColor',edgeColor);
    camlight headlight; 
    set(gca,'FontSize',fontSize);
    view(3); axis tight;  axis equal;  grid on;
end

%% 
%
% <<gibbVerySmall.gif>>
% 
% _*GIBBON*_ 
% <www.gibboncode.org>
% 
% _Kevin Mattheus Moerman_, <gibbon.toolbox@gmail.com>
 
%% <-- GIBBON footer text --> 
% 
%     GIBBON: The Geometry and Image-based Bioengineering add-On. A toolbox for
%     image segmentation, image-based modeling, meshing, and finite element
%     analysis.
% 
%     Copyright (C) 2017  Kevin Mattheus Moerman
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
