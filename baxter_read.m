function baxter_read()
   disp('Program started');
   % vrep=remApi('remoteApi','extApi.h'); % using the header (requires a compiler)
   vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
   vrep.simxFinish(-1); % just in case, close all opened connections
   clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
   r1=[];
   r2=[];
   r3=[];
   r4=[];
   r5=[];
   r6=[];
   r7=[];
   k=0;
   
   if (clientID>-1)
      disp('Connected to remote API server');
       % get handle for Baxter_rightArm_joint1
      [res,handle_rigArmjoint1] = vrep.simxGetObjectHandle(clientID,'Baxter_rightArm_joint1',vrep.simx_opmode_oneshot_wait); 
      [res,handle_rigArmjoint2] = vrep.simxGetObjectHandle(clientID,'Baxter_rightArm_joint2',vrep.simx_opmode_oneshot_wait); 
      [res,handle_rigArmjoint3] = vrep.simxGetObjectHandle(clientID,'Baxter_rightArm_joint3',vrep.simx_opmode_oneshot_wait); 
      [res,handle_rigArmjoint4] = vrep.simxGetObjectHandle(clientID,'Baxter_rightArm_joint4',vrep.simx_opmode_oneshot_wait); 
      [res,handle_rigArmjoint5] = vrep.simxGetObjectHandle(clientID,'Baxter_rightArm_joint5',vrep.simx_opmode_oneshot_wait); 
      [res,handle_rigArmjoint6] = vrep.simxGetObjectHandle(clientID,'Baxter_rightArm_joint6',vrep.simx_opmode_oneshot_wait); 
      [res,handle_rigArmjoint7] = vrep.simxGetObjectHandle(clientID,'Baxter_rightArm_joint7',vrep.simx_opmode_oneshot_wait); 
        while(vrep.simxGetConnectionId(clientID) ~= -1),  % while v-rep connection is still active
         t = vrep.simxGetLastCmdTime(clientID) / 1000.0;  % get current simulation time
         if (t > 1000) break; 
         end  % stop after t = 1000 seconds
         [res,r1angle]=vrep.simxGetJointPosition(clientID,handle_rigArmjoint1,vrep.simx_opmode_oneshot_wait);   
         [res,r2angle]=vrep.simxGetJointPosition(clientID,handle_rigArmjoint2,vrep.simx_opmode_oneshot_wait);
         [res,r3angle]=vrep.simxGetJointPosition(clientID,handle_rigArmjoint3,vrep.simx_opmode_oneshot_wait);
         [res,r4angle]=vrep.simxGetJointPosition(clientID,handle_rigArmjoint4,vrep.simx_opmode_oneshot_wait);
         [res,r5angle]=vrep.simxGetJointPosition(clientID,handle_rigArmjoint5,vrep.simx_opmode_oneshot_wait);
         [res,r6angle]=vrep.simxGetJointPosition(clientID,handle_rigArmjoint6,vrep.simx_opmode_oneshot_wait);
         [res,r7angle]=vrep.simxGetJointPosition(clientID,handle_rigArmjoint7,vrep.simx_opmode_oneshot_wait); 
          r1= [r1 r1angle];
          r2= [r2 r2angle];
          r3= [r3 r3angle];
          r4= [r4 r4angle];
          r5= [r5 r5angle];
          r6= [r6 r6angle];
          r7= [r7 r7angle];
          k=k+1 %to test
        end
       
       r=[r1' r2' r3' r4' r5' r6' r7'];
       fid=fopen('angle.txt','wt');
       [m,n]=size(r);
       for i=1:1:m
        for j=1:1:n
          if j==n 
          fprintf(fid,'%g\n',r(i,j));
          else
          fprintf(fid,'%g\t',r(i,j));
          end
        end
       end
      fclose(fid);           
       
     % Before closing the connection to V-REP, make sure that the last command sent out had time to arrive. You can guarantee this with (for example):
     vrep.simxGetPingTime(clientID);
     % Now close the connection to V-REP:
     vrep.simxFinish(clientID);
   else
      disp('Failed connecting to remote API server');
   end
   vrep.delete(); % call the destructor!
   
   disp('Program ended');
end

