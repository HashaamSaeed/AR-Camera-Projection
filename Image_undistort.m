clc;
clear all;
srcFiles = dir('F:\P42\Frames\*.jpg');



mkdir Frames_Undistorted_Matlab
mkdir Frames_Undistorted_Metashape

load('Camera_param\Camera_calib_matlab.mat');



Metashape_Overwrite = toStruct(calibrationSession.CameraParameters);


% <f>548.48201911278852</f>
% <cx>38.951252723615404</cx>
% <cy>-98.813367119418643</cy>
% <b2>-4.448238077156021</b2>
% <k1>-0.57905569748793384</k1>
% <k2>0.18848340999374916</k2>
% <k3>0.034217932483614391</k3>
% <p1>-0.0014949327128749462</p1>
% <p2>0.073989509490404448</p2>


%Metashape_Overwrite.FocalLength = [548.48201911278852,548.48201911278852] ;
%Metashape_Overwrite.PrincipalPoint = [38.951252723615404,-98.813367119418643] ; 
Metashape_Overwrite.IntrinsicMatrix = [495.48201911278852 0 0; 1.948238077156021 495.48201911278852 0; 31.951252723615404 8.813367119418643 1];
%Metashape_Overwrite.RadialDistortion = [-0.57905569748793384,0.18848340999374916,0.034217932483614391] ;
%Metashape_Overwrite.TangentialDistortion = [-0.0014949327128749462,0.073989509490404448] ;
%Metashape_Overwrite.Skew = [-4.448238077156021] ;


cameraParams_Metashape = cameraParameters(Metashape_Overwrite);

image=imread('69.jpg');
images_undistort_Metashape = undistortImage(image,cameraParams_Metashape);
imshow(images_undistort_Metashape);


% for i = 1 : length(srcFiles)
%     filename = strcat('F:\P42\Frames\',srcFiles(i).name);
%     
%     image = imread(filename);
%     
%     %images_undistort_Matlab = undistortImage(image,calibrationSession.CameraParameters);
%     
%     images_undistort_Metashape = undistortImage(image,cameraParams_Metashape);
% 
%     %dst= "Frames_Undistorted_Matlab\" + srcFiles(i).name;
%     
%     dst_2 = "Frames_Undistorted_Metashape\" + srcFiles(i).name;
%     
%     %imwrite(images_undistort_Matlab,char(dst));
%     
%     imwrite(images_undistort_Metashape,char(dst_2))
% 
%     
% end


