clear all ;
clc; 


% Meshlab roto-tran matrix format
% RRRT
% RRRT
% RRRT
% 0001

load('Camera_param\Camera_calib_matlab.mat')

A = zeros(4,4);
 
%%%%% ICP Roto-tran of CT onto Reconstructed Mesh      PLY to PLY
A(1,1)= cos(0.96);  A(1,2)= -sin(-0.25); A(1,3)= -sin(0.14);    % RRR
A(2,1)= sin(-0.05);  A(2,2)= cos(0.34); A(2,3)= sin(0.94);  % RRR  
A(3,1)= sin(-0.28);  A(3,2)= -sin(-0.91); A(3,3)= cos(0.31);   % RRR
A(4,1)= -98.01 ; A(4,2)= -200.98 ; A(4,3)= -328.10; A(4,4)= 1;  % translation
Atran = affine3d(A);


% %%%%% ICP Roto-tran of CT onto Reconstructed Mesh   PLY to STL
% A(1,1)= 0.96;  A(1,2)= -0.25; A(1,3)= 0.14;    % RRR
% A(2,1)= -0.05;  A(2,2)= 0.34; A(2,3)= 0.94;  % RRR  
% A(3,1)= -0.28;  A(3,2)= -0.91; A(3,3)= 0.31;   % RRR
% A(4,1)=-98.01 ; A(4,2)=-200.98 ; A(4,3)=-328.10; A(4,4)= 1;  % translation
% Atran = affine3d(A);
% TF = isTranslation(Atran);

% For STL to PLY conversion axis swap/flip
% B = zeros(4,4);
% B(1,1)= 1;  B(2,2)= 0.88; B(2,3)= -0.48; B(3,2)= 0.48; B(3,3)= 0.88; B(4,3)= 10; B(4,4)= 1;
% Btran = affine3d(B);


ptcloud_recon = pcread('Undistorted_Matlab_Metashape_Recon_full_New.ply');
%RGB = ptcloud_recon.Color;
% 
% 
ptcloud_CT = pcread('CT_Seg_P42_PLY_Aligned.ply');
% %ptcloud_ct_xyz = ptcloud_ct.Location;
% %ptcloud_ct (:,4)=1; 
% ptcloud_ct_tran = pctransform(ptcloud_ct,Atran);
% %pcshow(ptcloud_ct_tran)


ptcloud_Duct = pcread('Duct_Segmentation_PLY_Aligned_New.ply');


% 
% stl_point = stlread('CT_Seg_P42_STL.stl');
% pointcloud_xyz = stl_point.Points;
% pointcloud_xyz (:,4)=1; 
% %pointcloud_xyz = Atran*pointcloud_xyz; 


%ptcloudnew = pctransform(ptcloud,Btran);


%pcshow(ptcloudnew)

%ptcloudfinal = pctransform(ptcloud,Btran);    %% Aligned point cloud
% figure()
% pcshow(ptcloudfinal)
%pcwrite(ptcloudfinal,'teapotOut','PLYFormat','binary');
% ptcloudfinal = pctransform(ptcloud,Atran);
% figure()
% pcshow(ptcloudfinal);

images = imread('95.jpg');    % loading every frame
%images = undistortImage(images,calibrationSession.CameraParameters);
%imshow(images)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Implementation based on Agisoft Documentation

% Agisoft Lens software uses a pinhole camera model for lens calibration. The distortions are modeled using
% Brown's distortion model as suggested in the documentation.

fx = 517;

fy = 517;

Cx =-375; % -375
%Cx = -49.555903667465863;

Cy = 288;  % 270
%Cy = -192.82901837149151;

%k1= -0.25586258907009762 ;
k1 = -0.324521937734337;
 
%k2 = 0.058383888464398355 ;
k2= -0.162050795732565;

%k3 = -0.0084001047972883554 ;
k3 = 0.383938440190102 ;

%p1 = 0.0036923115945077119 ;
p1 = -0.00363997921206260;

%p2 = 0.011111732376842839 ;
p2 = -0.00140094545875112;

%skew = 0 ;
skew = 1.9966;




worldXYZ_recon(:,1) = ptcloud_recon.Location(:,1);
worldXYZ_recon (:,2)= ptcloud_recon.Location(:,2);
worldXYZ_recon(:,3)= ptcloud_recon.Location(:,3);
% 
worldXYZ_ct(:,1) = ptcloud_CT.Location(:,1);
worldXYZ_ct(:,2) = ptcloud_CT.Location(:,2);
worldXYZ_ct(:,3) = ptcloud_CT.Location(:,3);


worldXYZ_Duct(:,1) = ptcloud_Duct.Location(:,1) ;
worldXYZ_Duct(:,2) = ptcloud_Duct.Location(:,2) ;
worldXYZ_Duct (:,3)= ptcloud_Duct.Location(:,3) ;



% worldXYZ(:,1) = pointcloud_xyz(:,1);
% worldXYZ (:,2)= pointcloud_xyz(:,2);
% worldXYZ(:,3)= pointcloud_xyz(:,3);

% figure()
% plot3(worldXYZ(:,1),worldXYZ(:,2),worldXYZ(:,3),'o');



worldHom_recon(:,1) = worldXYZ_recon(:,1) ./ worldXYZ_recon(:,3);
worldHom_recon(:,2) = worldXYZ_recon(:,2) ./ worldXYZ_recon(:,3);
% 
% 
worldHom_ct(:,1) = worldXYZ_ct(:,1) ./ worldXYZ_ct(:,3);
worldHom_ct(:,2) = worldXYZ_ct(:,2) ./ worldXYZ_ct(:,3);

% 
worldHom_Duct(:,1) = worldXYZ_Duct(:,1) ./ worldXYZ_Duct(:,3) ;
worldHom_Duct(:,2) = worldXYZ_Duct(:,2) ./ worldXYZ_Duct(:,3) ;

% % figure()
% % plot(worldHom(:,1),worldHom(:,2),'o');
% 
% % r = sqrt(x2 + y2)
% r_rad = sqrt(worldHom_recon(:,1).^2 + worldHom_recon(:,2).^2) ; 
% 
% % x' = x(1 + K1r^2 + K2r^4 + K3r^6) + P2(r^2+2x^2) + 2P1xy
% 
% x_rect_recon = worldHom_recon(:,1).*( 1 + (r_rad.^2).*k1 + (r_rad.^4).*k2 + (r_rad.^6).*k3 ) + ( (r_rad.^2) + ( worldHom_recon(:,1).^2 ).* 2 ).*p2 + (worldHom_recon(:,1).* worldHom_recon(:,2)).*(2 * p1) ;
% 
% 
% % y' = y(1 + K1r^2 + K2r^4 + K3r^6) + P1(r^2+2y^2) + 2P2xy
% 
% y_rect = worldHom_recon(:,2).*( 1 + (r_rad.^2).*k1 + (r_rad.^4).*k2 + (r_rad.^6).*k3 ) + ( (r_rad.^2) + ( worldHom_recon(:,2).^2 ).* 2 ).*p1 + (worldHom_recon(:,2).* worldHom_recon(:,1)).*(2 * p2) ;
% 
x_rect_recon = worldHom_recon(:,1);
y_rect_recon = worldHom_recon(:,2);
% 
% 
x_rect_ct = worldHom_ct(:,1);
y_rect_ct = worldHom_ct(:,2);


x_rect_Duct = worldHom_Duct(:,1);
y_rect_Duct = worldHom_Duct(:,2);

% % u = Cx + x'fx + y'skew
u_img_recon = Cx + x_rect_recon.* fx ;
% %v = Cy + y'fy
v_img_recon = Cy + y_rect_recon.*fy ;


 
 
u_img_ct = Cx + x_rect_ct.*fx;
v_img_ct =  Cy + y_rect_ct.*fy;


u_img_Duct = Cx + x_rect_Duct.*fx;
v_img_Duct = Cy + y_rect_Duct.*fy;

%patch(u_img_Duct,v_img_Duct,'red');
%shp = alphaShape(u_img_Duct,v_img_Duct);




f = figure();

image(images);   %display image
hold on   %% with hold the scatter plot is inverted !!!!!!
%axis off 
%scatter(-u_img_recon(:,1) ,v_img_recon(:,1),0.01, 'g*'); %% mirrored axis for image 
%patch(-u_img_Duct,v_img_Duct,'green');
%scatter(-u_img_ct(:,1) ,v_img_ct(:,1),0.01, 'm*');   %overlay some points   
scatter(-u_img_Duct(:,1) ,v_img_Duct(:,1),0.01, 'y*');   %overlay some points   
hold off
%saveas(f,sprintf('FIG.png'))


%scatter(-u_img_recon(:,1) ,v_img_recon(:,1),0.1,RGB,'filled'); %% mirrored axis for image 


















% 
% 
% %%%%%%%%%%%%%%%%%%%%%%% Other implementation
% 
% images = imread('695.jpg');
% %J = imtranslate(images,[-125, -500],'FillValues',255,'OutputView','full');
% 
% ptcloud_recon = pcread('Undistorted_Matlab_Metashape_Recon_full.ply');
% 
% 
% 
% worldXYZ_recon(:,1) = ptcloud_recon.Location(:,1);
% worldXYZ_recon(:,2)= ptcloud_recon.Location(:,2);
% worldXYZ_recon(:,3)= ptcloud_recon.Location(:,3);
% 
% worldXYZ_recon(:,4)=1;  % pointcloud to homogeneous coordinate
% 
% 
% 
% % k = intrinsic matrix 
% K = zeros(3,3);
% 
% K(1,1) = 495 ;
% K(2,1) = 1.996 ; K(2,2) = 495 ;  % From colmap/metashape  % focal length
% K(3,1) = 32 ; K(3,2) = 8.9 ; K(3,3) = 1;   % Cx Cy % 390  260
% 
% 
% % Convert quaternion to rotation matrix using pose Rot data 
% % rotationMat = quat2rotm([0.9981, -0.0016739, -0.0614122, -0.00473246]);  % for every frame % done
% rotationMat = zeros(3,3) ;
% rotationMat(1,1) = 9.9990268436909746e-01 ;  rotationMat(1,2) = -1.3505330034826851e-02 ;  rotationMat(1,3) = 3.4968345860803473e-03 ;
% rotationMat(2,1) = -1.3370735242803824e-02 ;  rotationMat(2,2) = -9.9926190924417702e-01 ;  rotationMat(2,3) = -3.6011944862082854e-02 ;
% rotationMat(3,1) = 3.9806068053561345e-03 ;  rotationMat(3,2) = 3.5961685087510284e-02 ;  rotationMat(3,3) = -9.9934524163330452e-01;
% 
% 
% % Translation vector from colmap/metashape
% translation = [-1.8209790613950050e-01, 3.9120312745814106e-01,-2.1368642550600749e+00];   % every frame 
% 
% cameraMatrix = K' * [rotationMat, translation']; % Generating projection matrix
% 
% 
% 
% 
% imagePoints = cameraMatrix * worldXYZ_recon';
% imagePoints = imagePoints';
% imagePoints(:,1) = imagePoints(:,1) ./ imagePoints(:,3);
% imagePoints(:,2) = imagePoints(:,2) ./ imagePoints(:,3);
% imagePoints(:,3) = imagePoints(:,3) ./ imagePoints(:,3);
% imagePoints(:,3) = [];
% 
% 
% %image(J);   %display image
% image(images)
% hold on   %% with hold the scatter plot is inverted !!!!!!
% %axis off 
% scatter(imagePoints(:,1) ,imagePoints(:,2),0.001, 'g*'); %% mirrored axis for image 
% hold off
% %saveas(f,sprintf('FIG.png'))
% 
% 
% 

% 
% sampleXMLfile = 'P_42_cameras_XML.xml';
% %type(sampleXMLfile)
% mlStruct = parseXML(sampleXMLfile);
% 
% XML_sensors_data = mlStruct.Children(2).Children(4).Children  ;  % fine
% 
% 
% 
% Camera_ID = XML_sensors_data(4).Attributes(2).Value ; % XML_sensors_data(i+1).Attributes(2).Value
% Camera_ID = str2double(Camera_ID);
% 
% 
% Camera_ROTO_TRAN_char = XML_sensors_data(4).Children(2).Children.Data; %%  XML_sensors_data(i+1).Children(2).Children.Data
% % TF = isspace(Camera_ROTO_TRAN_char);
% C = textscan(Camera_ROTO_TRAN_char,'%n');
% % Camera_ROTO_TRAN_char = str2double(Camera_ROTO_TRAN_char);
% D = cell2mat(C);
% Camera_ROTO_TRAN(1,1) = D(1,1) ; Camera_ROTO_TRAN(1,2) = D(2,1) ; Camera_ROTO_TRAN(1,3) = D(3,1) ; Camera_ROTO_TRAN(1,4) = 0 ;
% Camera_ROTO_TRAN(2,1) = D(5,1) ; Camera_ROTO_TRAN(2,2) = D(6,1) ; Camera_ROTO_TRAN(2,3) = D(7,1) ; Camera_ROTO_TRAN(2,4) = 0 ;
% Camera_ROTO_TRAN(3,1) = D(9,1) ; Camera_ROTO_TRAN(3,2) = D(10,1) ; Camera_ROTO_TRAN(3,3) = D(11,1) ; Camera_ROTO_TRAN(3,4) = 0 ;
% Camera_ROTO_TRAN(4,1) = D(4,1) ; Camera_ROTO_TRAN(4,2) = D(8,1) ; Camera_ROTO_TRAN(4,3) = D(12,1) ; Camera_ROTO_TRAN(4,4) = 1 ;
% 
% rotationMat = zeros(3,3);
% rotationMat =  Camera_ROTO_TRAN(1:3,1:3);
% 
% 
% translation = zeros(1,3);
% translation = Camera_ROTO_TRAN(4:4,1:3);
% 
% 
% 
% 
% 
% 
