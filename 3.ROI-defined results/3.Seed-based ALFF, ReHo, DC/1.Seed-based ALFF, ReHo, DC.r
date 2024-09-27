# 🟥 Brain Atlas ==========================================================================================
check_resampling_results = readRDS("/Users/Ido/Documents/✴️DataAnalysis/ADNI/RS.fMRI/@@@2.Brain Atlas/1.Check Atlas and Resampling using FSL/Brain Atlas_MNI_resampled.rds")
# check_resampling_results $Schaefer2018_1000Parcels_17Networks_order_FSLMNI152__resampled.nii.gz
# test_data = readNIfTI("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/ALFFMap/ALFFMap_RID_0021.nii")
# check_resampling_results[["AAL3"]]

atlas_list = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/✅✴️2.Brain Atlas/2.Extract Coordinates of ROIs for each Atals/extracted coordinates for each ROI.rds")
# atlas$Schaefer2018_1000Parcels_17Networks_order_FSLMNI152__resampled.nii.gz %>% head




# 🟥 공통된 경로 설정 ====================================================================================================
base_fmri_rds_paths <- list(
  "FunImgARCWSF" = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/✅✴️1.Extracted Results/✅✴️FunImgARCWSF",
  "FunImgARglobalCWSF" = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/✅✴️1.Extracted Results/✅✴️FunImgARglobalCWSF"
)

base_export_paths <- list(
  "FunImgARCWSF" = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/3.Seed-based ALFF, ReHo, DC/FunImgARCWSF",
  "FunImgARglobalCWSF" = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/3.ROI-defined results/3.Seed-based ALFF, ReHo, DC/FunImgARglobalCWSF"
)



# 🟨 공통 함수 정의 =====================================================================================================
process_atlas_for_pipeline <- function(pipeline, data_type, file_names, base_fmri_rds_paths, base_export_paths, atlas_list) {
  fmri_base_path <- base_fmri_rds_paths[[pipeline]]
  export_base_path <- base_export_paths[[pipeline]]
  
  sub_fmri_rds_path <- file.path(fmri_base_path, paste0(data_type, "_", pipeline))
  export_path <- file.path(export_base_path, data_type)
  
  for (file_name in file_names) {
    # file_name = file_names[1]
    fmri_rds_file <- file.path(sub_fmri_rds_path, paste0(file_name, "Map.rds"))
    process_fmri_rds_with_atlas(atlas_list, fmri_rds_file, export_path, file_name)
  }
}

process_dc_for_pipeline <- function(pipeline, base_fmri_rds_paths, base_export_paths, atlas_list) {
  fmri_base_path <- base_fmri_rds_paths[[pipeline]]
  export_base_path <- base_export_paths[[pipeline]]
  
  sub_fmri_rds_path <- file.path(fmri_base_path, paste0("DegreeCentrality_", pipeline))
  export_path <- file.path(export_base_path, "DegreeCentrality")
  
  file_names <- c("DegreeCentrality", "mDegreeCentrality", "zDegreeCentrality")
  
  for (file_name in file_names) {
    fmri_rds_file_binarized <- file.path(sub_fmri_rds_path, paste0(file_name, "_PositiveBinarizedSumBrainMap.rds"))
    fmri_rds_file_weighted <- file.path(sub_fmri_rds_path, paste0(file_name, "_PositiveWeightedSumBrainMap.rds"))
    
    process_fmri_rds_with_atlas(atlas_list, fmri_rds_file_binarized, export_path, paste0(file_name, "_Binarized"))
    process_fmri_rds_with_atlas(atlas_list, fmri_rds_file_weighted, export_path, paste0(file_name, "_Weighted"))
  }
}




# 🟨 fMRI 파이프라인 및 데이터 처리 =====================================================================================================
# 각 파이프라인(FunImgARCWSF, FunImgARglobalCWSF)과 각 데이터 유형(ALFF, fALFF, DegreeCentrality, ReHo) 처리
file_names_common <- list(
  "ALFF" = c("ALFF", "mALFF", "zALFF"),
  "fALFF" = c("fALFF", "mfALFF", "zfALFF"),
  "ReHo" = c("ReHo", "mReHo", "zReHo")
)

pipelines <- names(base_fmri_rds_paths)  # "FunImgARCWSF"와 "FunImgARglobalCWSF"

# ALFF, fALFF, ReHo 공통 처리
for (pipeline in pipelines) {
  for (data_type in names(file_names_common)) {
    process_atlas_for_pipeline(pipeline,
                               data_type,
                               file_names = file_names_common[[data_type]],
                               base_fmri_rds_paths,
                               base_export_paths,
                               atlas_list)

  }
  
  # DegreeCentrality 처리
  process_dc_for_pipeline(pipeline, base_fmri_rds_paths, base_export_paths, atlas_list)
}
