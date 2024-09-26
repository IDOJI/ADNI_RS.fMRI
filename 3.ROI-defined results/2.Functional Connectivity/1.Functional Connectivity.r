# 🟥 global ==========================================================================================
# 경로 설정 및 atlas 파일 리스트 불러오기
dir_base <- "/Users/Ido/Documents/✴️DataAnalysis/ADNI/RS.fMRI/3.ROI-defined results/@@@1.Extracting BOLD signal/FunImgARglobalCWSF"
output_dir <- "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARglobalCWSF"
atlas_files <- list.files(dir_base, pattern = "\\.rds$", full.names = TRUE)

# 모든 atlas에 대해 처리
process_all_atlas(atlas_files, output_dir)

# 실수로 Fisher Z transformation을 지운 경우
apply_fisher_z_transformation("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARglobalCWSF/Pearson Correlation",
                              "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARglobalCWSF/Fisher Z Transformation")




# move files
move_files_with_string(source_dir = output_dir, 
                       target_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation",
                       search_string = "_fisher_z_fc")
move_files_with_string(source_dir = output_dir, 
                       target_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Pearson Correlation",
                       search_string = "pearson_fc")








# 🟥 non-global ==========================================================================================
# 경로 설정 및 atlas 파일 리스트 불러오기
dir_base <- "/Users/Ido/Documents/✴️DataAnalysis/ADNI/RS.fMRI/3.ROI-defined results/@@@1.Extracting BOLD signal/FunImgARSFW"
output_dir <- "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF"
atlas_files <- list.files(dir_base, pattern = "\\.rds$", full.names = TRUE)

# 모든 atlas에 대해 처리
process_all_atlas(atlas_files, output_dir)

# 실수로 Fisher Z transformation을 지운 경우
apply_fisher_z_transformation("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Pearson Correlation",
                              "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation")



# move files
move_files_with_string(source_dir = output_dir, 
                       target_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Fisher Z Transformation",
                       search_string = "_fisher_z_fc")
move_files_with_string(source_dir = output_dir, 
                       target_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/2.Functional Connectivity/FunImgARCWSF/Pearson Correlation",
                       search_string = "pearson_fc")






