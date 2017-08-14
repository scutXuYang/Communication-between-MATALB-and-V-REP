% Copyright 2006-2016 Coppelia Robotics GmbH. All rights reserved. 
% marc@coppeliarobotics.com
% www.coppeliarobotics.com
% 
% -------------------------------------------------------------------
% THIS FILE IS DISTRIBUTED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
% WARRANTY. THE USER WILL USE IT AT HIS/HER OWN RISK. THE ORIGINAL
% AUTHORS AND COPPELIA ROBOTICS GMBH WILL NOT BE LIABLE FOR DATA LOSS,
% DAMAGES, LOSS OF PROFITS OR ANY OTHER KIND OF LOSS WHILE USING OR
% MISUSING THIS SOFTWARE.
% 
% You are free to use/modify/distribute this file for whatever purpose!
% -------------------------------------------------------------------
%
% This file was automatically created for V-REP release V3.3.1 Rev1 on May 17th 2016

% This example illustrates how to execute complex commands from
% a remote API client. You can also use a similar construct for
% commands that are not directly supported by the remote API.
%
% Load the demo scene 'remoteApiCommandServerExample.ttt' in V-REP, then 
% start the simulation and run this program.
%
% IMPORTANT: for each successful call to simxStart, there
% should be a corresponding call to simxFinish at the end!

function complexCommandTest()

	disp('Program started');
	% vrep=remApi('remoteApi','extApi.h'); % using the header (requires a compiler)
	vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
	vrep.simxFinish(-1); % just in case, close all opened connections
	clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);

	if (clientID>-1)
		disp('Connected to remote API server');
		
		% 1. First send a command to display a specific message in a dialog box:
		[res retInts retFloats retStrings retBuffer]=vrep.simxCallScriptFunction(clientID,'remoteApiCommandServer',vrep.sim_scripttype_childscript,'displayText_function',[],[],'Hello world!',[],vrep.simx_opmode_blocking);
		if (res==vrep.simx_return_ok)
			fprintf('Returned message: %s\n',retStrings);
		else
			fprintf('Remote function call failed\n');
		end

		% 2. Now create a dummy object at coordinate 0.1,0.2,0.3 with name 'MyDummyName':
		[res retInts retFloats retStrings retBuffer]=vrep.simxCallScriptFunction(clientID,'remoteApiCommandServer',vrep.sim_scripttype_childscript,'createDummy_function',[],[0.1 0.2 0.3],'MyDummyName',[],vrep.simx_opmode_blocking);
		if (res==vrep.simx_return_ok)
			fprintf('Dummy handle: %d\n',retInts(1));
		else
			fprintf('Remote function call failed\n');
		end

		% 3. Now send a code string to execute some random functions:
		code=['local octreeHandle=simCreateOctree(0.5,0,1)', char(10), ...
			'simInsertVoxelsIntoOctree(octreeHandle,0,{0.1,0.1,0.1},{255,0,255})', char(10), ...
			'return ''done'''];
		[res retInts retFloats retStrings retBuffer]=vrep.simxCallScriptFunction(clientID,'remoteApiCommandServer',vrep.sim_scripttype_childscript,'executeCode_function',[],[],code,[],vrep.simx_opmode_blocking);
		if (res==vrep.simx_return_ok)
			fprintf('Code execution returned: %s\n',retStrings);
		else
			fprintf('Remote function call failed\n');
		end

        % Now close the connection to V-REP:	
		vrep.simxFinish(clientID);
	else
		disp('Failed connecting to remote API server');
	end
	vrep.delete(); % call the destructor!
	
	disp('Program ended');
end
