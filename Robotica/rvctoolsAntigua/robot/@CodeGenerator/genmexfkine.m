%CODEGENERATOR.GENMEXFKINE Generate C-MEX-function for forward kinematics
%
% CGEN.GENMEXFKINE() generates a robot-specific MEX-function to compute
% forward kinematics.
%
% Notes::
% - Is called by CodeGenerator.genfkine if cGen has active flag genmex
% - The MEX file uses the .c and .h files generated in the directory 
%   specified by the ccodepath property of the CodeGenerator object.
% - Access to generated function is provided via subclass of SerialLink
%   whose class definition is stored in cGen.robjpath.
% - You will need a C compiler to use the generated MEX-functions. See the 
%   MATLAB documentation on how to setup the compiler in MATLAB. 
%   Nevertheless the basic C-MEX-code as such may be generated without a
%   compiler. In this case switch the cGen flag compilemex to false.
%
% Author::
%  Joern Malzahn, (joern.malzahn@tu-dortmund.de)
%
% See also CodeGenerator.CodeGenerator, CodeGenerator.genfkine.

% Copyright (C) 2012-2014, by Joern Malzahn
%
% This file is part of The Robotics Toolbox for Matlab (RTB).
%
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
%
% You should have received a copy of the GNU Leser General Public License
% along with RTB. If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

function [] = genmexfkine(CGen)

%% Forward kinematics up to tool center point
CGen.logmsg([datestr(now),'\tGenerating forward kinematics MEX-function up to the end-effector frame: ']);
symname = 'fkine';
fname = fullfile(CGen.sympath,[symname,'.mat']);

if exist(fname,'file')
    tmpStruct = load(fname);
else
    error ('genmfunfkine:SymbolicsNotFound','Save symbolic expressions to disk first!')
end

funfilename = fullfile(CGen.robjpath,[symname,'.c']);
Q = CGen.rob.gencoords;

% Function description header
hStruct = createHeaderStructFkine(CGen.rob,symname); 

% Generate and compile MEX function 
CGen.mexfunction(tmpStruct.(symname), 'funfilename',funfilename,'funname',[CGen.getrobfname,'_',symname],'vars',{Q},'output','T','header',hStruct)

CGen.logmsg('\t%s\n',' done!');

%% Individual joint forward kinematics
CGen.logmsg([datestr(now),'\tGenerating forward kinematics MEX-function up to joint: ']);
for iJoints=1:CGen.rob.n
    
    CGen.logmsg(' %i ',iJoints);
    symname = ['T0_',num2str(iJoints)];
    fname = fullfile(CGen.sympath,[symname,'.mat']);
    
    tmpStruct = load(fname);
    
    funfilename = fullfile(CGen.robjpath,[symname,'.c']);
    Q = CGen.rob.gencoords;
    
    % Function description header
    hStruct = createHeaderStruct(CGen.rob,iJoints,symname); % create header
    
    % Generate and compile MEX function 
    CGen.mexfunction(tmpStruct.(symname),'funfilename',funfilename,'funname',[CGen.getrobfname,'_',symname],'vars',{Q},'output','T','header',hStruct);
    
end
CGen.logmsg('\t%s\n',' done!');

end

%% Definition of the header contents for each generated file
function hStruct = createHeaderStruct(rob,curBody,fname)
[~,hStruct.funName] = fileparts(fname);
hStruct.calls = '';
hStruct.shortDescription = ['C version of the forward kinematics for the ',rob.name,' arm up to frame ',int2str(curBody),' of ',int2str(rob.n),'.'];
hStruct.detailedDescription = {['Given a set of joint variables up to joint number ',int2str(curBody),' the function'],...
    'computes the pose belonging to that joint with respect to the base frame.'};
hStruct.inputs = { 'input1 Vector of generalized coordinates. Angles have to be given in radians!'};
hStruct.outputs = {'T [4x4] Homogenous transformation matrix relating the pose of the tool for the given joint values to the base frame.'};
hStruct.references = {'Robot Modeling and Control - Spong, Hutchinson, Vidyasagar',...
    'Modelling and Control of Robot Manipulators - Sciavicco, Siciliano',...
    'Introduction to Robotics, Mechanics and Control - Craig',...
    'Modeling, Identification & Control of Robots - Khalil & Dombre'};
hStruct.authors = {'This is an autogenerated function!<BR>',...
    'Code generator written by:<BR>',...
    'Joern Malzahn (joern.malzahn@tu-dortmund.de)<BR>'};
hStruct.seeAlso = {rob.name};
end

%% Definition of the header contents for each generated file
function hStruct = createHeaderStructFkine(rob,fname)
[~,hStruct.funName] = fileparts(fname);
hStruct.calls = '';
hStruct.shortDescription = ['C version of the forward kinematics solution including tool transformation for the ',rob.name,' arm.'];
hStruct.detailedDescription = {['Given a full set of joint variables the function'],...
    'computes the pose belonging to that joint with respect to the base frame.'};
hStruct.inputs = { 'input1 Vector of generalized coordinates. Angles have to be given in radians!'};
hStruct.outputs = {'T [4x4] Homogenous transformation matrix relating the pose of the tool for the given joint values to the base frame.'};
hStruct.references = {'Robot Modeling and Control - Spong, Hutchinson, Vidyasagar',...
    'Modelling and Control of Robot Manipulators - Sciavicco, Siciliano',...
    'Introduction to Robotics, Mechanics and Control - Craig',...
    'Modeling, Identification & Control of Robots - Khalil & Dombre'};
hStruct.authors = {'This is an autogenerated function!<BR>',...
    'Code generator written by:<BR>',...
    'Joern Malzahn (joern.malzahn@tu-dortmund.de)<BR>'};
hStruct.seeAlso = {'jacob0'};
end