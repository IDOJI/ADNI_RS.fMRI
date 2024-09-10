## 🟨 test =======================================================================================================
path_from_test = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/test"
path_to_test = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/2.4D Volume"
copy_4D_volume_files_with_rid(path_from_test, 
                              path_to_test, 
                              folder_names = c("FunImgARCWSF", "FunImgARglobalCWSF"))



## 🟨 GE ===============================================================================================================
path_from = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Completed_GE.MEDICAL.SYSTEMS"
path_to = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/2.4D Volume"
copy_4D_volume_files_with_rid(path_from, path_to, folder_names = c("FunImgARCWSF", "FunImgARglobalCWSF"))



## 🟨 Philips ===============================================================================================================
path_from = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Completed_Philips"
path_to = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/2.4D Volume"
copy_4D_volume_files_with_rid(path_from, path_to, folder_names = c("FunImgARCWSF", "FunImgARglobalCWSF"))



## 🟨 Philips2 ===============================================================================================================
path_from = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Completed_Philips_Without-AutoMasks"
path_to = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/2.4D Volume"
copy_4D_volume_files_with_rid(path_from, path_to, folder_names = c("FunImgARCWSF", "FunImgARglobalCWSF"))




## 🟨 SIEMENS_SB ===============================================================================================================
path_from = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Completed_SIEMENS_SB"
path_to = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/2.4D Volume"
copy_4D_volume_files_with_rid(path_from, path_to, folder_names = c("FunImgARCWSF", "FunImgARglobalCWSF"))





