# 🟥 load coords ==========================================================================================
path_coords = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/2.Extract Coordinates of ROIs for each Atals/extracted coordinates for each ROI.rds"
coordinates = readRDS(path_coords)






# 🟥 Test ==========================================================================================
# RID_21_AAL3_1 = read.table("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/⭐️Preprocessing Backup/Completed_SIEMENS_SB/SIEMENS_SB___Sub_021___RID_2184___EPB_I920084___MT1_I920082/Results/ROISignals_FunImgARCWSF/ROISignals_Sub_021.txt")
# dim(RID_21_AAL3_1)
# class(RID_21_AAL3_1)
# names(RID_21_AAL3_1)
# path_save = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New"
# 
# volume = readNIfTI("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/⭐️Preprocessing Backup/Completed_SIEMENS_SB/SIEMENS_SB___Sub_021___RID_2184___EPB_I920084___MT1_I920082/FunImgARCWSF/Sub_021/Filtered_4DVolume.nii")
# atlas = readNIfTI("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/⭐️Preprocessing Backup/Completed_SIEMENS_SB/SIEMENS_SB___Sub_021___RID_2184___EPB_I920084___MT1_I920082/Masks/FCROI_1_Sub_021.nii")






# 🟥 BOLD signals ==========================================================================================
## 🟧 @Test using simuation data  ===================================================================================
### 🟨 Generate tmp 4d volume file ================================================================================
# path_save = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/2.Extracting data by the defined Atlas"
# file_name = "0.4D volume test"
# generate_nifti_file(path_save, file_name)



### 🟨 Load the data ================================================================================
# test_4d_volume = readNIfTI("/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/2.Extracting data by the defined Atlas/4D volume test/4D volume files/test_RID_0021.nii.gz")





### 🟨 Compute BOLD signals ================================================================================
# path_4d_volumes = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/3.ROI-defined results/1.Extracting BOLD signal/4D volume test/4D volume files"
# path_save_bold = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/3.ROI-defined results/1.Extracting BOLD signal/4D volume test/BOLD signals"
# bold = extract_bold_using_atlas_multi(path_4d_volumes, path_save_bold, coordinates)
# test_aal3 = read.table("/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/3.ROI-defined results/1.Extracting BOLD signal/4D volume test/BOLD signals/Schaefer2018_1000Parcels_17Networks_order_FSLMNI152__resampled.nii.gz/RID_0021.txt")
# View(test_aal3)





## 🟧 pipeline 1 ===================================================================================
# A Folder containing 4D volume files
path_4d_volumes = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/2.4D Volume/FunImgARCWSF"
# A Folder to save the results
path_save_bold = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/3.ROI-defined results/1.Extracting BOLD signal/FunImgARSFW"
bold = extract_bold_using_atlas_multi(path_4d_volumes, 
                                      path_save_bold, 
                                      coordinates, 
                                      use_multicore = F)








## 🟧 pipeline 2 ===================================================================================
# A Folder containing 4D volume files
path_4d_volumes = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/Extracted Results/2.4D Volume/FunImgARglobalCWSF"
# A Folder to save the results
path_save_bold = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/3.ROI-defined results/1.Extracting BOLD signal/FunImgARglobalCWSF"
bold = extract_bold_using_atlas_multi(path_4d_volumes, path_save_bold, coordinates, use_multicore = F)





# 🟥 Check the results ===============================================================================================================================
# RID_7105 = arrow::read_feather("/Users/Ido/Documents/✴️Data/ADNI/RS.fMRI/3.ROI-defined results/1.Extracting BOLD signal/FunImgARglobalCWSF/Schaefer2018_1000Parcels_17Networks_order_FSLMNI152__resampled.nii.gz/RID_7105.feather")
# 
# coord = readRDS("/Users/Ido/Documents/✴️Data/ADNI/RS.fMRI/@@@2.Brain Atlas/2.Extract Coordinates of ROIs for each Atals/extracted coordinates for each ROI.rds")
# 
# 
# RID_7105_2 = extract_bold_using_atlas(volume = readNIfTI("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/2.4D Volume/FunImgARglobalCWSF/Filtered_4DVolume_RID_7105.nii"),
#                          coordinates = coord[["Schaefer2018_1000Parcels_17Networks_order_FSLMNI152__resampled.nii.gz"]])
# 
# RID_7105_2== RID_7105








