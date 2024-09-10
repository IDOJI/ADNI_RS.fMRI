# 🟥 load coords ==========================================================================================
path_coords = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/2.Extract Coordinates of ROIs for each Atals/extracted coordinates for each ROI.rds"
coordinates = readRDS(path_coords)





# 🟥 BOLD signals ==========================================================================================
## 🟧 @Test using simuation data  ===================================================================================
### 🟨 Generate tmp 4d volume file ================================================================================
# path_save = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/2.Extracting data by the defined Atlas"
# file_name = "0.4D volume test"
# generate_nifti_file(path_save, file_name)



### 🟨 Load the data ================================================================================
# test_4d_volume = readNIfTI("/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/2.Extracting data by the defined Atlas/4D volume test/4D volume files/test_RID_0021.nii.gz")



### 🟨 Compute BOLD signals ================================================================================
path_4d_volumes = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/3.Extracting data by the defined Atlas/4D volume test/4D volume files"
path_save_bold = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/3.Extracting data by the defined Atlas/4D volume test/BOLD signals"
bold = extract_bold_using_atlas_multi(path_4d_volumes, path_save_bold, coordinates)




## 🟧 pipeline 1 ===================================================================================
# path_pipeline = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/2.4D Volume/FunImgARCWSF"
# path_save = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/3.ROI Signals"
# bold_signals_list_1 = extract_bold_for_each_subject(path_pipeline, 
#                                                     coordinates, 
#                                                     path_save)





## 🟧 pipeline 2 ===================================================================================
# path_pipeline = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/2.4D Volume/FunImgARglobalCWSF"
# path_save = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/3.ROI Signals"
# bold_signals_list_2 = extract_bold_for_each_atlas_coordinate(path_pipeline, 
#                                                              coordinates, 
#                                                              path_save)









