# 🟥 Load the atlas ==========================================================================================
path_resampled_atlas = "/Users/Ido/Documents/✴️Data/ADNI/RS.fMRI/2.Brain Atlas/1.Check Atlas and Resampling using FSL/Brain Atlas_MNI_resampled.rds"
atlas = readRDS(path_resampled_atlas)

# atlas$Schaefer2018_1000Parcels_17Networks_order_FSLMNI152__resampled.nii.gz
# atlas$AAL3


# 🟥 Extract coordinates ==========================================================================================
# path_save = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/2.Extract Coordinates of ROIs for each Atals"
# coords = atlas %>% 
#   lapply(extract_xyz_coordinate) %>% 
#   setNames(names(atlas)) %>% 
#   saveRDS(file.path(path_save, "extracted coordinates for each ROI.rds"))

path_coord = "/Users/Ido/Documents/GitHub/ADNI_RS.fMRI_Data/2.Brain Atlas/2.Extract Coordinates of ROIs for each Atals/extracted coordinates for each ROI.rds"
coords = readRDS(path_coord)
