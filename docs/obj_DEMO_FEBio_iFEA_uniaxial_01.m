function [Fopt,OPT_stats_out]=obj_DEMO_FEBio_iFEA_uniaxial_01(Pn,objectiveStruct)

%% Unnormalize and constrain parameters

P=Pn.*objectiveStruct.parNormFactors; %Scale back, undo normalization
P_in=P; %Proposed P

%Constraining parameters
for q=1:1:numel(P);
    [P(q)]=parLimNat(objectiveStruct.Pb_struct.xx_c(q),objectiveStruct.Pb_struct.xxlim(q,:),P(q));
end

%% SETTING MATERIAL PARAMETERS

%Acces material parameters
mat_struct=objectiveStruct.mat_struct;
mat_struct.par_values={P(1) P(2) P(1) -P(2) P(1)*objectiveStruct.k_factor}; 

disp('SETTING MATERIAL PARAMETERS...');
disp(['Proposed (norm.): ',sprintf(repmat('%6.16e ',[1,numel(Pn)]),Pn)]);
disp(['Proposed        : ',sprintf(repmat('%6.16e ',[1,numel(P_in)]),P_in)]);
disp(['Set (constr.)   : ',sprintf(repmat('%6.16e ',[1,numel(P)]),P)]);

%Assign material parameters
set_mat_par_FEBIO(objectiveStruct.FEB_struct.run_filename,objectiveStruct.FEB_struct.run_filename,{mat_struct});

disp('Done')

%% START FEBio NOW

[runFlag]=runMonitorFEBio(objectiveStruct.FEBioRunStruct);

pause(0.1); 

bcPrescribeList=objectiveStruct.bcPrescribeList;
sampleHeight=objectiveStruct.sampleHeight;
initialArea=objectiveStruct.initialArea;
stretch_exp=objectiveStruct.stretch_exp;
stress_cauchy_exp=objectiveStruct.stress_cauchy_exp;

if runFlag==1    
    
    %Importing displacement
    [~,N_disp_mat,~]=importFEBio_logfile(objectiveStruct.FEB_struct.run_output_names{1}); %Nodal displacements

    %Importing force
    [~,N_force_mat,~]=importFEBio_logfile(objectiveStruct.FEB_struct.run_output_names{2}); %Nodal displacements
    
    %Get Z forces
    FZ=sum(N_force_mat(bcPrescribeList,end,:),1);
    FZ=[0; FZ(:)]; %Mean top surface nodal forces
    
    %Derive applied stretch
    DZ_set=N_disp_mat(bcPrescribeList,end,:); %Final nodal displacements
    DZ_set=mean(DZ_set,1);
    stretch_sim=(DZ_set+sampleHeight)./sampleHeight;
    stretch_sim=[1; stretch_sim(:)];
    
    %Derive simulated Cauchy stress 
    currentArea=initialArea./stretch_sim;
    stress_cauchy_sim=FZ./currentArea; %Cauchy stress
    stress_cauchy_sim=stress_cauchy_sim.*1e3; %Scale to kPa
    
    %Interpolate experiment onto simulated points
    stress_cauchy_sim_exp = interp1(stretch_sim,stress_cauchy_sim,stretch_exp,'pchip');
    
    %Derive Fopt
    stressDev=stress_cauchy_exp-stress_cauchy_sim_exp;  
       
    switch objectiveStruct.method
        case 1
            Fopt=sum((stressDev).^2); %Sum of squared differences
        case 2
            Fopt=stressDev;%(stressDev).^2; %Squared differences
    end
    
    OPT_stats_out.stress_cauchy_sim=stress_cauchy_sim;
    OPT_stats_out.stretch_sim=stretch_sim;
    OPT_stats_out.stressDev=stressDev;
    OPT_stats_out.Fopt=Fopt;
    
else %Output NaN
    switch objectiveStruct.method
        case 1
            Fopt=NaN; 
        case 2
            Fopt=NaN(size(stress_cauchy_exp)); %Squared differences
    end
    OPT_stats_out=[];
end

%%


 
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
