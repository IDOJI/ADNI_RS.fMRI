# 🟥 Load data =================================================================
path_save = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas"
file_name = "Brain Atlas_MNI_resampled.rds"


# atlas path
path_Schaefer2018_LocalGlobal_Parcellations_MNI = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/Schaefer2018_LocalGlobal_Parcellations_MNI/Schaefer2018_LocalGlobal_Parcellations_MNI_Resampled.rds"
path_AAL3 = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/AAL3/FCROI_AAL3_resampled.nii"


#  combined data & export it
Combined_data <- readRDS(path_Schaefer2018_LocalGlobal_Parcellations_MNI) %>%
  list_modify(AAL3 = readNIfTI(path_AAL3)) %>%
  saveRDS(file = file.path(path_save, file_name))


  
  
