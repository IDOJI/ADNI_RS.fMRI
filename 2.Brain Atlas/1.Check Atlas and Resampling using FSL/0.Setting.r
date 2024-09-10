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












