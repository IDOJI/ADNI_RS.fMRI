# 🟥 Extracting ROI Signals for each atlas ==========================================================================================
## 🟧 pipeline 1 ===================================================================================
path_pipeline = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/2.4D Volume/FunImgARCWSF"
path_save = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/3.ROI Signals"
bold_signals_list_1 = extract_bold_for_each_subject(path_pipeline, 
                                                    coordinates, 
                                                    path_save)





## 🟧 pipeline 2 ===================================================================================
path_pipeline = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/2.4D Volume/FunImgARglobalCWSF"
path_save = "/Volumes/ADNI_SB_SSD_NTFS_4TB_Sandisk/New/Extracted Results/3.ROI Signals"
bold_signals_list_2 = extract_bold_for_each_atlas_coordinate(path_pipeline, 
                                                             coordinates, 
                                                             path_save)









