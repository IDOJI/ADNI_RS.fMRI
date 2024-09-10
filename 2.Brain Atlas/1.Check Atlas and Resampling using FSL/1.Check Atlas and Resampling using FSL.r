# 🟥 Load functions =================================================================
# rm(list = ls())
require(dplyr)
require(oro.nifti)
library(fslr)
library(neurobase)
library(purrr)





# 🟥 Define functions =================================================================
save_atlas_image = function(path_save, atlas_name, atlas){
  # PNG 파일로 저장하기 위한 파일명과 해상도 설정
  png(filename = file.path(path_save, paste0(atlas_name, ".png")), width = 1200, height = 1000)
  
  # Atlas 시각화
  neurobase::ortho2(atlas)
  
  # 저장 종료
  dev.off()
}



# Resampling function with conversion to UINT8 format
resampling_by_fsl <- function(path_input_file, path_reference_nii, output_filename, path_export) {
  # Set environment variables for FSL
  Sys.setenv(FSLDIR = "/Users/Ido/Documents/GitHub/fsl")
  Sys.setenv(PATH = paste(Sys.getenv("FSLDIR"), "bin", Sys.getenv("PATH"), sep = ":"))
  Sys.setenv(FSLOUTPUTTYPE = "NIFTI_GZ")
  
  # Set final output path
  output_file_path <- file.path(path_export, output_filename)
  
  # Remove existing output file if it exists
  if (file.exists(output_file_path)) {
    file.remove(output_file_path)
  }
  
  # Test FSL command
  system("/Users/Ido/Documents/GitHub/fsl/bin/flirt -version")
  
  # Command for resampling with nearest neighbor interpolation
  cmd <- sprintf("%s/bin/flirt -in %s -ref %s -out %s -applyxfm -usesqform -interp nearestneighbour", 
                 Sys.getenv("FSLDIR"), shQuote(path_input_file), shQuote(path_reference_nii), shQuote(output_file_path))
  
  # Print the command
  cat("Running command: ", cmd, "\n")
  
  # Execute the resampling command
  system(cmd)
  
  # Load the resampled atlas
  resampled_atlas <- readNIfTI(output_file_path)
  
  # Convert data to UINT8 format
  resampled_atlas_data <- as.numeric(round(resampled_atlas))
  resampled_atlas_data[resampled_atlas_data < 0] <- 0  # UINT8 does not support negative values
  resampled_atlas_data[resampled_atlas_data > 255] <- 255  # UINT8 has a maximum value of 255
  
  # Assign converted data back to the NIfTI object
  resampled_atlas[] <- as.integer(resampled_atlas_data)
  
  # Save the converted NIfTI object back to the output path
  writeNIfTI(resampled_atlas, filename = sub(".nii.gz$", "_UINT8.nii.gz", output_file_path))
}







# 🟥 Load atlas ========================================================================
## 🟨 Check 4D volume ==============================================================================
# path_volume_4d <- "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/2.4D Volume/FunImgARCWSF/Filtered_4DVolume_RID_0021.nii"
# volume_4d = readnii(path_volume_4d)
# dim(volume_4d)
# volume_4d




# [1]  61  73  61 187
# > volume_4d
# NIfTI-1 format
# Type            : nifti
# Data Type       : 16 (FLOAT32)
# Bits per Pixel  : 32
# Slice Code      : 0 (Unknown)
# Intent Code     : 0 (None)
# Qform Code      : 2 (Aligned_Anat)
# Sform Code      : 2 (Aligned_Anat)
# Dimension       : 61 x 73 x 61 x 187
# Pixel Dimension : 3 x 3 x 3 x 3
# Voxel Units     : mm
# Time Units      : sec
# volume_4d[,,,100]





## 🟨 AAL3 ==============================================================================
atlas_name = "AAL3"
path_atlas = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/AAL3/FCROI_AAL3_resampled.nii"
atlas = readnii(path_atlas)
print(atlas)
atlas[35,35,30]
table(atlas)










## 🟨 Test : schaefer_2018_100_7 ==============================================================
# 🟩 load the atlas
# path_atlas = "/Users/Ido/Documents/GitHub/FunCurv/Brain Atlas/Schaefer2018_LocalGlobal_Parcellations_MNI/Schaefer2018_100Parcels_7Networks_order_FSLMNI152_1mm.nii.gz"
# atlas = readnii(path_atlas)

# 🟩 export the image
# atlas_name = "schaefer_2018_100_7"
# path_save = "/Users/Ido/Documents/GitHub/FunCurv/Code/1.Check Atlas"
# save_atlas_image(atlas_name, atlas)

# 🟩 check the data
# atlas %>% dim
# atlas %>% table


# 🟩 resampling
# input_file <- path_atlas
# output_file <- "Schaefer2018_100Parcels_7Networks_resampled.nii.gz"
# reference_file <- "/Users/Ido/Documents/GitHub/FunCurv/Brain Atlas/AAL3/FCROI_AAL3_resampled.nii"
# path_export = "/Users/Ido/Documents/GitHub/FunCurv/Brain Atlas/Schaefer2018_LocalGlobal_Parcellations_MNI"
# resampling_by_fsl(input_file, reference_file, output_file, path_export)

# check the result
# path_resampled = "/Users/Ido/Documents/GitHub/FunCurv/Brain Atlas/Schaefer2018_LocalGlobal_Parcellations_MNI/Schaefer2018_100Parcels_7Networks_resampled.nii.gz"
# resampled = readnii(path_resampled)
# print(resampled)
# table(resampled)
# resampled[30,40,50]









## 🟨 Resampling ===============================================================================
# 파일 경로 설정
path <- "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/Schaefer2018_LocalGlobal_Parcellations_MNI"
reference_file <- "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/AAL3/FCROI_AAL3_resampled.nii"


# 리샘플링 후 파일 읽기 및 이름 설정
resampled_atlas <- path %>% 
  list.files(pattern = "1mm\\.nii\\.gz$", full.names = TRUE) %>%
  map(~ {
    # 출력 파일 이름 생성
    output_filename <- sub("1mm\\.nii\\.gz$", "_resampled.nii.gz", basename(.x))
    
    # 리샘플링 수행
    resampling_by_fsl(path_input_file = .x,
                      path_reference_nii = reference_file,
                      output_filename = output_filename,
                      path_export = path)
    
    # 리샘플링된 파일 읽기
    file.path(path, output_filename) %>% readnii()
  }) %>% 
  # 파일 이름으로 결과의 원소 이름 설정
  set_names(path %>% 
              list.files(pattern = "1mm\\.nii\\.gz$", full.names = TRUE) %>% 
              basename() %>% 
              sub("1mm\\.nii\\.gz$", "_resampled.nii.gz", .))

# 결과 확인
resampled_atlas %>% names()
resampled_atlas$Schaefer2018_1000Parcels_17Networks_order_FSLMNI152__resampled.nii.gz %>% table
resampled_atlas$Schaefer2018_900Parcels_7Networks_order_FSLMNI152__resampled.nii.gz %>% table
resampled_atlas[[1]]


# save as RDS
saveRDS(resampled_atlas, file.path(path, "Schaefer2018_LocalGlobal_Parcellations_MNI_Resampled.rds"))

































