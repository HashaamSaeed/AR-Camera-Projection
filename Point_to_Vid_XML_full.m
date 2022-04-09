clc;
clear all;


srcFiles = natsortfiles(dir('Frames_Undistorted_Metashape\Frames_Undistorted_Metashape_ALL_new\*.jpg'));




ptcloud_recon = pcread('Undistorted_Matlab_Metashape_Recon_full_New.ply');

ptcloud_CT = pcread('CT_Seg_P42_PLY_Aligned.ply');

ptcloud_Duct = pcread('Duct_Segmentation_PLY_Aligned_New.ply');


worldXYZ_recon(:,1) = ptcloud_recon.Location(:,1);
worldXYZ_recon(:,2)= ptcloud_recon.Location(:,2);
worldXYZ_recon(:,3)= ptcloud_recon.Location(:,3);

worldXYZ_recon(:,4)=1;  % pointcloud to homogeneous coordinate

worldXYZ_ct(:,1) = ptcloud_CT.Location(:,1);
worldXYZ_ct(:,2) = ptcloud_CT.Location(:,2);
worldXYZ_ct(:,3) = ptcloud_CT.Location(:,3);

worldXYZ_ct(:,4) =1;


worldXYZ_Duct(:,1) = ptcloud_Duct.Location(:,1) ;
worldXYZ_Duct(:,2) = ptcloud_Duct.Location(:,2) ;
worldXYZ_Duct (:,3)= ptcloud_Duct.Location(:,3) ;

worldXYZ_Duct(:,4) =1;

sampleXMLfile = 'P_42_cameras_XML_New.xml';
mlStruct = parseXML(sampleXMLfile);
XML_sensors_data = mlStruct.Children(2).Children(4).Children  ;  % fine



% k = intrinsic matrix 
K = zeros(3,3);

K(1,1) = 517 ;
K(2,1) = -0.34 ; K(2,2) = 517 ;  % From colmap/metashape  % focal length
K(3,1) = 375 ; K(3,2) = 270 ; K(3,3) = 1;   % Cx Cy 





for i = 1 : length(srcFiles)
    filename = strcat('Frames_Undistorted_Metashape\Frames_Undistorted_Metashape_ALL_new\',srcFiles(i).name);
    disp(filename);
    disp(i)
    
    images = imread(filename);
    
    % v = i*2 ;
    

    
    if i == 1 
        v = i +1 ;
    else 
        v= i*2;
    end
    
    
    Camera_ID = XML_sensors_data(v).Attributes(2).Value ; % XML_sensors_data(i+1).Attributes(2).Value
    Camera_ID = str2double(Camera_ID);
    
    newStr = erase(srcFiles(i).name,".jpg");
    image_number = str2double(newStr);
    
    

    
    if Camera_ID == image_number
        Camera_ROTO_TRAN_char = XML_sensors_data(v).Children(2).Children.Data; %%  XML_sensors_data(i+1).Children(2).Children.Data
        
        C= 0;
        C = textscan(Camera_ROTO_TRAN_char,'%n');
        
        D = 0;
        D = cell2mat(C);
        
        Camera_ROTO_TRAN = zeros(4,4);
        Camera_ROTO_TRAN(1,1) = D(1,1) ; Camera_ROTO_TRAN(1,2) = D(2,1) ; Camera_ROTO_TRAN(1,3) = D(3,1) ; Camera_ROTO_TRAN(1,4) = 0 ;
        Camera_ROTO_TRAN(2,1) = D(5,1) ; Camera_ROTO_TRAN(2,2) = D(6,1) ; Camera_ROTO_TRAN(2,3) = D(7,1) ; Camera_ROTO_TRAN(2,4) = 0 ;
        Camera_ROTO_TRAN(3,1) = D(9,1) ; Camera_ROTO_TRAN(3,2) = D(10,1) ; Camera_ROTO_TRAN(3,3) = D(11,1) ; Camera_ROTO_TRAN(3,4) = 0 ;
        Camera_ROTO_TRAN(4,1) = D(4,1) ; Camera_ROTO_TRAN(4,2) = D(8,1) ; Camera_ROTO_TRAN(4,3) = D(12,1) ; Camera_ROTO_TRAN(4,4) = 1 ;
        
        rotationMat = zeros(3,3);
        rotationMat =  Camera_ROTO_TRAN(1:3,1:3);
        
        
        translation = zeros(1,3);
        translation = Camera_ROTO_TRAN(4:4,1:3);
        
        
        
        
        cameraMatrix = K' * [rotationMat, translation']; % Generating projection matrix
        
        
        
        
        imagePoints = cameraMatrix * worldXYZ_Duct';
        
        imagePoints = imagePoints';
        imagePoints(:,1) = imagePoints(:,1) ./ imagePoints(:,3);
        imagePoints(:,2) = imagePoints(:,2) ./ imagePoints(:,3);
        imagePoints(:,3) = imagePoints(:,3) ./ imagePoints(:,3);
        imagePoints(:,3) = [];
        
        
        
        
        %f= figure();
        figure('visible', 'off')
        Frames = getframe ;
        image(images);   %display image
        hold on   %% with hold the scatter plot is inverted !!!!!!
        axis off
        scatter(imagePoints(:,1) ,imagePoints(:,2),0.01, 'g*');
        hold off
        dst_name = srcFiles(i).name;
        saveas(gca, fullfile("Projection_images\" , char(dst_name)), 'jpeg');
        % imwrite(F.cdata,)
        %close(f)
        close()
        
        
    else 
        break 
        
        
    end
        

    
 
    




end






