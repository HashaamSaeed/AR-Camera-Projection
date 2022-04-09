clc
clear all


% fx = 513;
% 
% fy = 477;
% 
% Cx = -300;  % -392
% %Cx = -49.555903667465863;
% 
% Cy = 307;  % 275
% %Cy = -192.82901837149151;
% 
% %k1= -0.25586258907009762 ;
% k1 = -0.324521937734337;
%  
% %k2 = 0.058383888464398355 ;
% k2= -0.162050795732565;
% 
% %k3 = -0.0084001047972883554 ;
% k3 = 0.383938440190102 ;
% 
% %p1 = 0.0036923115945077119 ;
% p1 = -0.00363997921206260;
% 
% %p2 = 0.011111732376842839 ;
% p2 = -0.00140094545875112;
% 
% %skew = 0 ;
% skew = 1.9966;







srcFiles = natsortfiles(dir('Projection_images\*.jpg'));


%mkdir Projection_Video
%mkdir Projection_images

% 
% load('Camera_param\Camera_calib_matlab.mat');
% 
% 
% ptcloud = pcread('Undistorted_Matlab_Metashape_Recon.ply');
% 
% 
% worldXYZ(:,1) = ptcloud.Location(:,1);
% worldXYZ (:,2)= ptcloud.Location(:,2);
% worldXYZ(:,3)= ptcloud.Location(:,3);
% 
% 
% worldHom(:,1) = worldXYZ(:,1) ./ worldXYZ(:,3);
% worldHom(:,2) = worldXYZ(:,2) ./ worldXYZ(:,3);
% 
% 
% 
% images = imread('695.jpg');
% 
% 
% x_rect=worldHom(:,1);
% y_rect=worldHom(:,2);
% 
% % u = Cx + x'fx + y'skew
% u_img = Cx + x_rect.* fx + y_rect.*skew ;
% 
% %v = Cy + y'fy
% v_img = Cy + y_rect.*fy ;

% 
% figure()
% image(images);   %display image
% F = getframe ;
% hold on   %% with hold the scatter plot is inverted !!!!!!
% axis off
% scatter(-u_img(:,1) ,v_img(:,1),0.1, 'g*'); %% mirrored axis for image
% hold off
% %imwrite(F.cdata,'ekgjnn.jpg')







% for i = 1 : length(srcFiles)
%     filename = strcat('Frames_Undistorted_Matlab\',srcFiles(i).name);
%     
%     images = imread(filename);
% 
%     f= figure();
%     figure('visible', 'off')
%     %Frames = getframe ;
%     image(images);   %display image
%     hold on   %% with hold the scatter plot is inverted !!!!!!
%     axis off
%     scatter(-u_img(:,1) ,v_img(:,1),0.1, 'g*'); %% mirrored axis for image
%     hold off
%     dst_name = srcFiles(i).name;
%     saveas(gca, fullfile("Projection_images\" , char(dst_name)), 'jpeg');
%    % imwrite(F.cdata,)
%     close(f)
%     
% 
% 
% 
% 
% 
% end




 
% create the video writer with 1 fps
writerObj = VideoWriter('Projection_Video.avi');
writerObj.FrameRate = 10;
% set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video


for ii = 1:length(srcFiles)
    
    filename = strcat('Projection_images\',srcFiles(ii).name);
    
    Frames = imread(filename);
    
    writeVideo(writerObj, Frames);
    

 
    
end

close(writerObj);


