# 🟥 Brain Atlas ==========================================================================================
check_resampling_results = readRDS("/Users/Ido/Documents/✴️DataAnalysis/ADNI/RS.fMRI/@@@2.Brain Atlas/1.Check Atlas and Resampling using FSL/Brain Atlas_MNI_resampled.rds")
# check_resampling_results $Schaefer2018_1000Parcels_17Networks_order_FSLMNI152__resampled.nii.gz
# test_data = readNIfTI("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/ALFFMap/ALFFMap_RID_0021.nii")
# check_resampling_results[["AAL3"]]

atlas = readRDS("/Users/Ido/Documents/✴️DataAnalysis/ADNI/RS.fMRI/@@@2.Brain Atlas/2.Extract Coordinates of ROIs for each Atals/extracted coordinates for each ROI.rds")
# atlas$Schaefer2018_1000Parcels_17Networks_order_FSLMNI152__resampled.nii.gz %>% head
atlas[[1]]




# 🟥 BOLD signals ==========================================================================================


fmri_file_path <- "path/to/your/fmri_file.nii.gz"
atlasexport_path <- "path/to/export/result.csv"

# 함수 실행
result <- process_fmri_with_atlas(atlas_list, fmri_file_path, export_path)

# 결과 출력
print(result)