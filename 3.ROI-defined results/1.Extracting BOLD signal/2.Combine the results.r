# 🟥 Combined data ==========================================================================================
## 🟨FunImgARSFW =========================================================================================================
base_dir = "/Users/Ido/Documents/✴️Data/ADNI/RS.fMRI/3.ROI-defined results/1.Extracting BOLD signal/FunImgARSFW"
process_all_atlases("/Users/Ido/Documents/✴️Data/ADNI/RS.fMRI/3.ROI-defined results/1.Extracting BOLD signal/FunImgARSFW")

# check
aal = readRDS("/Users/Ido/Documents/✴️Data/ADNI/RS.fMRI/3.ROI-defined results/1.Extracting BOLD signal/FunImgARSFW/AAL3.rds")
class(aal)
View(aal)



## 🟨FunImgARglobalSFW =========================================================================================================
base_dir = "/Users/Ido/Documents/✴️Data/ADNI/RS.fMRI/3.ROI-defined results/1.Extracting BOLD signal/FunImgARglobalCWSF"
process_all_atlases(base_dir)



