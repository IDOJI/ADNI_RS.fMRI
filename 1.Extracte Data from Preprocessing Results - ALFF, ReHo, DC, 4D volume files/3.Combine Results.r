# 🟥 ALFF =============================================================================================
## 🟧 FunImgARCWS ===========================================================================
### 🟨 ALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/ALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS"
file_name = "ALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)

# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()

test_1[20,30,20] == combined[[1]][20,30,20]

test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]


### 🟨 mALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/mALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS"
file_name = "mALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)

# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()

test_1[20,30,20] == combined[[1]][20,30,20]

test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]



### 🟨 zALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/zALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS"
file_name = "zALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)


# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()

test_1[20,30,20] == combined[[1]][20,30,20]

test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]




## 🟧 FunImgARglobalCWS ===========================================================================
### 🟨 ALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARglobalCWS/ALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARglobalCWS"
file_name = "ALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# test = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/ALFFMap.rds")
# length(test)

# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()

test_1[20,30,20] == combined[[1]][20,30,20]

test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]





### 🟨 mALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARglobalCWS/mALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARglobalCWS"
file_name = "mALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)

# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()

test_1[20,30,20] == combined[[1]][20,30,20]

test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]





### 🟨 zALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARglobalCWS/zALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARglobalCWS"
file_name = "zALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)


# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()

test_1[20,30,20] == combined[[1]][20,30,20]

test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]




# 🟥 DegreeCentrality =============================================================================================
## 🟧 FunImgARCWS ===========================================================================
### 🟨 DegreeCentrality_PositiveBinarizedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF/DegreeCentrality_PositiveBinarizedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF"
file_name = "DegreeCentrality_PositiveBinarizedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# test = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/ALFFMap.rds")
# length(test)


# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]




### 🟨 DegreeCentrality_PositiveWeightedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF/DegreeCentrality_PositiveWeightedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF"
file_name = "DegreeCentrality_PositiveWeightedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]



### 🟨 mDegreeCentrality_PositiveBinarizedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF/mDegreeCentrality_PositiveBinarizedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF"
file_name = "mDegreeCentrality_PositiveBinarizedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]



### 🟨 mDegreeCentrality_PositiveWeightedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF/mDegreeCentrality_PositiveWeightedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF"
file_name = "mDegreeCentrality_PositiveWeightedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]



### 🟨 zDegreeCentrality_PositiveBinarizedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF/zDegreeCentrality_PositiveBinarizedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF"
file_name = "zDegreeCentrality_PositiveBinarizedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]



### 🟨 zDegreeCentrality_PositiveWeightedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF/zDegreeCentrality_PositiveWeightedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARCWSF"
file_name = "zDegreeCentrality_PositiveWeightedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]




## 🟧 FunImgARglobalCWSF ===========================================================================
### 🟨 DegreeCentrality_PositiveBinarizedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF/DegreeCentrality_PositiveBinarizedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF"
file_name = "DegreeCentrality_PositiveBinarizedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# test = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/ALFFMap.rds")
# length(test)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]




### 🟨 DegreeCentrality_PositiveWeightedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF/DegreeCentrality_PositiveWeightedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF"
file_name = "DegreeCentrality_PositiveWeightedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]




### 🟨 mDegreeCentrality_PositiveBinarizedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF/mDegreeCentrality_PositiveBinarizedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF"
file_name = "mDegreeCentrality_PositiveBinarizedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]






### 🟨 mDegreeCentrality_PositiveWeightedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF/mDegreeCentrality_PositiveWeightedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF"
file_name = "mDegreeCentrality_PositiveWeightedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]






### 🟨 zDegreeCentrality_PositiveBinarizedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF/zDegreeCentrality_PositiveBinarizedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF"
file_name = "zDegreeCentrality_PositiveBinarizedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]





### 🟨 zDegreeCentrality_PositiveWeightedSumBrainMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF/zDegreeCentrality_PositiveWeightedSumBrainMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/DegreeCentrality/DegreeCentrality_FunImgARglobalCWSF"
file_name = "zDegreeCentrality_PositiveWeightedSumBrainMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]





# 🟥 fALFF =============================================================================================
## 🟧 FunImgARCWS ===========================================================================
### 🟨 fALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARCWS/fALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARCWS"
file_name = "fALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# test = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/ALFFMap.rds")
# length(test)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]






### 🟨 mfALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARCWS/mfALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARCWS"
file_name = "mfALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]






### 🟨 zfALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARCWS/zfALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARCWS"
file_name = "zfALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]






## 🟧 FunImgARglobalCWS ===========================================================================
### 🟨 fALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARglobalCWS/fALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARglobalCWS"
file_name = "fALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# test = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/ALFFMap.rds")
# length(test)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]




### 🟨 mfALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARglobalCWS/mfALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARglobalCWS"
file_name = "mfALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]





### 🟨 zfALFFMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARglobalCWS/zfALFFMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/fALFF/fALFF_FunImgARglobalCWS"
file_name = "zfALFFMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]







# 🟥 ReHo =============================================================================================
## 🟧 FunImgARCWS ===========================================================================
### 🟨 mReHoMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARCWSF/mReHoMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARCWSF"
file_name = "mReHoMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# test = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/ALFFMap.rds")
# length(test)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]





### 🟨 ReHoMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARCWSF/ReHoMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARCWSF"
file_name = "ReHoMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]




### 🟨 zReHoMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARCWSF/zReHoMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARCWSF"
file_name = "zReHoMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]







## 🟧 FunImgARglobalCWS ===========================================================================
### 🟨 mReHoMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARglobalCWSF/mReHoMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARglobalCWSF"
file_name = "mReHoMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# test = readRDS("/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ALFF/ALFF_FunImgARCWS/ALFFMap.rds")
# length(test)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]






### 🟨 ReHoMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARglobalCWSF/ReHoMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARglobalCWSF"
file_name = "ReHoMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]






### 🟨 zReHoMap =================================================================================
input_dir = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARglobalCWSF/zReHoMap"
export_path = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/1.Extracted Results/ReHo/ReHo_FunImgARglobalCWSF"
file_name = "zReHoMap"
# save_nii_files_as_rds(input_dir, export_path, file_name)
# Test
combined = file.path(export_path, paste0(file_name, ".rds")) %>% readRDS()
names(combined)[1]
test_1 = list.files(input_dir, full.names = T)[1] %>% readNIfTI()
test_1[20,30,20] == combined[[1]][20,30,20]
test_2 = list.files(input_dir, full.names = T)[658] %>% readNIfTI()
test_2[20,30,20] == combined[[658]][20,30,20]











