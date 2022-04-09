clc
clear all

ptcloud_undistorted_recon = pcread('Undistorted_recon.ply');

ptcloud_P42_undistort_Align = pcread('Undistort_aligned.ply');

worldXYZ_recon(:,1) = ptcloud_undistorted_recon.Location(:,1);
worldXYZ_recon (:,2)= ptcloud_undistorted_recon.Location(:,2);
worldXYZ_recon(:,3)= ptcloud_undistorted_recon.Location(:,3);

worldXYZ_undistort_Align(:,1) = ptcloud_P42_undistort_Align.Location(:,1);
worldXYZ_undistort_Align(:,2) = ptcloud_P42_undistort_Align.Location(:,2);
worldXYZ_undistort_Align(:,3) = ptcloud_P42_undistort_Align.Location(:,3);




figure(1)
scatter3(worldXYZ_recon(:,1),worldXYZ_recon(:,2),worldXYZ_recon(:,3),1,'g')
hold on
scatter3(worldXYZ_undistort_Align(:,1),worldXYZ_undistort_Align(:,2),worldXYZ_undistort_Align(:,3),0.5,'r')
hold off
grid on
legend('Undistort Reconstruction', 'Aligned with CT')