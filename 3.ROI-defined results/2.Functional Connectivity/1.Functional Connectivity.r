# 🟥 global ==========================================================================================
## 🟨 computation ====================================================================================================
# 경로 설정 및 atlas 파일 리스트 불러오기
# dir_base <- "/Users/Ido/Documents/✴️DataAnalysis/ADNI/RS.fMRI/3.ROI-defined results/@@@1.Extracting BOLD signal/FunImgARglobalCWSF"
# output_dir <- "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARglobalCWSF"
# atlas_files <- list.files(dir_base, pattern = "\\.rds$", full.names = TRUE)
# 
# # 모든 atlas에 대해 처리
# process_all_atlas(atlas_files, output_dir)
# 
# # 실수로 Fisher Z transformation을 지운 경우
# apply_fisher_z_transformation("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARglobalCWSF/Pearson Correlation",
#                               "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARglobalCWSF/Fisher Z Transformation")
# 
# 
# 
## 🟨 Change names ==========================================================================================
# path_fisher_z = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARglobalCWSF/Fisher Z Transformation"
# process_rds_files(path_fisher_z)
# # move files
# move_files_with_string(source_dir = output_dir, 
#                        target_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation",
#                        search_string = "_fisher_z_fc")
# move_files_with_string(source_dir = output_dir, 
#                        target_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Pearson Correlation",
#                        search_string = "pearson_fc")





## 🟨 Test ====================================================================================================
# AAL3
BOLD_AAL3 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/✅✴️1.Extracting BOLD signal/FunImgARglobalCWSF/AAL3.rds")
FC_AAL3_21 = cor(BOLD_AAL3$RID_0021, method = "pearson", use = "pairwise.complete.obs")
Fisher_FC_AAL3_21 = FC_AAL3_21 %>% apply(c(1,2), fisher_z)
Fisher_FC_AAL3_21[1,2] == fisher_z(FC_AAL3_21[1,2])

Results_AAL3 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARglobalCWSF/Fisher Z Transformation/AAL3_combined_Fisher_Z_fc.rds")
Fisher_FC_AAL3_21[1,2] == Results_AAL3$RID_0021[1,2]


BOLD_AAL3 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/✅✴️1.Extracting BOLD signal/FunImgARglobalCWSF/AAL3.rds")
FC_AAL3_7072 = cor(BOLD_AAL3$RID_7072, method = "pearson", use = "pairwise.complete.obs")
Fisher_FC_AAL3_7072 = FC_AAL3_7072 %>% apply(c(1,2), fisher_z)
Fisher_FC_AAL3_7072[1,2] == fisher_z(FC_AAL3_7072[1,2])

Results_AAL3 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARglobalCWSF/Fisher Z Transformation/AAL3_combined_Fisher_Z_fc.rds")
Fisher_FC_AAL3_7072[1,2] == Results_AAL3$RID_7072[1,2]



# Schaefer2018_1000Parcels_Kong2022_17Networks_order_FSLMNI152__resampled
BOLD_1000 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/✅✴️1.Extracting BOLD signal/FunImgARglobalSFW/Schaefer2018_1000Parcels_Kong2022_17Networks_order_FSLMNI152__resampled.nii.gz.rds")
FC_BOLD_1000 = cor(BOLD_1000$RID_0021, method = "pearson", use = "pairwise.complete.obs")
Fisher_FC_BOLD_1000 = FC_BOLD_1000 %>% apply(c(1,2), fisher_z)
Fisher_FC_BOLD_1000[1,2]  == FC_BOLD_1000[1,2] %>% fisher_z

Fisher_FC_1000_2 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation/Schaefer2018_1000Parcels_Kong2022_17Networks_order_FSLMNI152__resampled.nii.gz_combined_Fisher_Z_fc.rds")
Fisher_FC_1000_2$RID_0021[1,2] == Fisher_FC_BOLD_1000[1,2]



BOLD_1000 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/✅✴️1.Extracting BOLD signal/FunImgARglobalCWSF/Schaefer2018_1000Parcels_Kong2022_17Networks_order_FSLMNI152__resampled.nii.gz.rds")
FC_BOLD_1000 = cor(BOLD_1000$RID_7042, method = "pearson", use = "pairwise.complete.obs")
Fisher_FC_BOLD_1000 = FC_BOLD_1000 %>% apply(c(1,2), fisher_z)
Fisher_FC_BOLD_1000[1,2]  == FC_BOLD_1000[1,2] %>% fisher_z

Fisher_FC_1000_2 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARglobalCWSF/Fisher Z Transformation/Schaefer2018_1000Parcels_Kong2022_17Networks_order_FSLMNI152__resampled.nii.gz_combined_Fisher_Z_fc.rds")
Fisher_FC_1000_2$RID_7042[1,2] == Fisher_FC_BOLD_1000[1,2]










# 🟥 non-global ==========================================================================================
## 🟨 computation ====================================================================================================
# # 경로 설정 및 atlas 파일 리스트 불러오기
# dir_base <- "/Users/Ido/Documents/✴️DataAnalysis/ADNI/RS.fMRI/3.ROI-defined results/@@@1.Extracting BOLD signal/FunImgARSFW"
# output_dir <- "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF"
# atlas_files <- list.files(dir_base, pattern = "\\.rds$", full.names = TRUE)
# 
# # 모든 atlas에 대해 처리
# process_all_atlas(atlas_files, output_dir)
# 
# # 실수로 Fisher Z transformation을 지운 경우
# apply_fisher_z_transformation("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Pearson Correlation",
#                               "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation")
# 
# 
# 
# # move files
# move_files_with_string(source_dir = output_dir, 
#                        target_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation",
#                        search_string = "_fisher_z_fc")
# move_files_with_string(source_dir = output_dir, 
#                        target_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Pearson Correlation",
#                        search_string = "pearson_fc")
# 
## 🟨 Change names ==========================================================================================
# path_fisher_z = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation"
# process_rds_files(path_fisher_z)



## 🟨 Test ====================================================================================================
# AAL3
BOLD_AAL3 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/✅✴️1.Extracting BOLD signal/FunImgARSFW/AAL3.rds")
FC_AAL3_21 = cor(BOLD_AAL3$RID_0021, method = "pearson", use = "pairwise.complete.obs")
Fisher_FC_AAL3_21 = FC_AAL3_21 %>% apply(c(1,2), fisher_z)
Fisher_FC_AAL3_21[1,2] == fisher_z(FC_AAL3_21[1,2])

Results_AAL3 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation/AAL3_combined_Fisher_Z_fc.rds")
Fisher_FC_AAL3_21[1,2] == Results_AAL3$RID_0021[1,2]


BOLD_AAL3 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/✅✴️1.Extracting BOLD signal/FunImgARSFW/AAL3.rds")
FC_AAL3_7072 = cor(BOLD_AAL3$RID_7072, method = "pearson", use = "pairwise.complete.obs")
Fisher_FC_AAL3_7072 = FC_AAL3_7072 %>% apply(c(1,2), fisher_z)
Fisher_FC_AAL3_7072[1,2] == fisher_z(FC_AAL3_7072[1,2])

Results_AAL3 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation/AAL3_combined_Fisher_Z_fc.rds")
Fisher_FC_AAL3_7072[1,2] == Results_AAL3$RID_7072[1,2]


# Schaefer2018_1000Parcels_Kong2022_17Networks_order_FSLMNI152__resampled
BOLD_1000 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/✅✴️1.Extracting BOLD signal/FunImgARSFW/Schaefer2018_1000Parcels_Kong2022_17Networks_order_FSLMNI152__resampled.nii.gz.rds")
FC_BOLD_1000 = cor(BOLD_1000$RID_0021, method = "pearson", use = "pairwise.complete.obs")
Fisher_FC_BOLD_1000 = FC_BOLD_1000 %>% apply(c(1,2), fisher_z)
Fisher_FC_BOLD_1000[1,2]  == FC_BOLD_1000[1,2] %>% fisher_z

Fisher_FC_1000_2 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation/Schaefer2018_1000Parcels_Kong2022_17Networks_order_FSLMNI152__resampled.nii.gz_combined_Fisher_Z_fc.rds")
Fisher_FC_1000_2$RID_0021[1,2] == Fisher_FC_BOLD_1000[1,2]



BOLD_1000 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/✅✴️1.Extracting BOLD signal/FunImgARSFW/Schaefer2018_1000Parcels_Kong2022_17Networks_order_FSLMNI152__resampled.nii.gz.rds")
FC_BOLD_1000 = cor(BOLD_1000$RID_7042, method = "pearson", use = "pairwise.complete.obs")
Fisher_FC_BOLD_1000 = FC_BOLD_1000 %>% apply(c(1,2), fisher_z)
Fisher_FC_BOLD_1000[1,2]  == FC_BOLD_1000[1,2] %>% fisher_z

Fisher_FC_1000_2 = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation/Schaefer2018_1000Parcels_Kong2022_17Networks_order_FSLMNI152__resampled.nii.gz_combined_Fisher_Z_fc.rds")
Fisher_FC_1000_2$RID_7042[1,2] == Fisher_FC_BOLD_1000[1,2]


