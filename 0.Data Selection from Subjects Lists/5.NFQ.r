# rm(list=ls())
# 🟥 Load Functions & Packages ##########################################################################
## 🟧Loading my functions ======================================================
# Check my OS/
os <- Sys.info()["sysname"]
if(os ==  "Darwin"){
  
  path_OS = "/Users/Ido" # mac
  
}else if(os ==  "Window"){
  
  path_OS = "C:/Users/lleii"  
  
}
path_Dropbox = paste0(path_OS, "/Dropbox")
path_GitHub = list.files(path_Dropbox, pattern = "GitHub", full.names = T)
path_GitHub_Code = paste0(path_GitHub, "/GitHub___Code")
Rpkgs = c("ADNIprep", "StatsR", "refineR", "dimR")
Load = sapply(Rpkgs, function(y){
  list.files(path = path_GitHub_Code, pattern = y, full.names = T) %>% 
    paste0(., "/", y,"/R") %>% 
    list.files(., full.names = T) %>% 
    purrr::walk(source)
})



## 🟧dplyr =======================================================
filter = dplyr::filter
select = dplyr::select




## 🟧Install and loading Packages ================================
install_packages = function(packages, load=TRUE) {
  # load : load the packages after installation?
  for(pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg)
    }
    
    if(load){
      library(pkg, character.only = TRUE)
    }
  }
}

List.list = list()
List.list[[1]] = visual = c("ggpubr", "ggplot2", "ggstatsplot", "ggsignif", "rlang", "RColorBrewer")
List.list[[2]] = stat = c("fda", "MASS")
List.list[[3]] = data_handling = c("tidyverse", "dplyr", "clipr", "tidyr")
List.list[[4]] = qmd = c("janitor", "knitr")
List.list[[5]] = texts = c("stringr")
List.list[[6]] = misc = c("devtools")
List.list[[7]] = db = c("RMySQL", "DBI", "odbc", "RSQL", "RSQLite")

packages_to_install_and_load = unlist(List.list)
install_packages(packages_to_install_and_load)




# 🟥 Dictionary ###########################################################################
# adnimerge %>% names
# dic("IMAGEUID")
RS.fMRI_0_Data.Dictionary = function(colname, path_Dic = NULL, which.OS = c("Windows", "Mac")){
  # install_package("Hmisc")
  # install.packages("C:/Users/lleii/Dropbox/Github/Rpkgs/ADNIprep/ADNIMERGE/ADNIMERGE_0.0.1.tar.gz", repose = NULL, type="source")
  # install.packages("/Users/Ido/Library/CloudStorage/Dropbox/Github/Rpkgs/ADNIprep/ADNIMERGE/ADNIMERGE_0.0.1.tar.gz")
  # require(ADNIMERGE)
  
  if(is.null(path_Dic)){
    which.OS = match.arg(which.OS, which.OS)
    if(which.OS == "Windows"){
      path_OS = "C:/Users/lleii/"
    }else{
      path_OS = "/Users/Ido/"
    }
    path_Dic = paste0(path_OS, "Dropbox/Github/Rpkgs/ADNIprep/Data") %>% list.files(full.names = T, pattern = "dictionary")
  }
  
  
  Dic = read.csv(path_Dic)
  
  colname = toupper(colname)
  
  selected_col = Dic %>% dplyr::filter(FLDNAME == colname)
  if(nrow(selected_col)>0){
    return(selected_col)
  }else{
    cat("\n", crayon::red("There is no such colname!"),"\n")
  }
}

dic = function(col){
  path_dic = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️다운받은 파일들/attachments/DATADIC_04Apr2024.csv"
  RS.fMRI_0_Data.Dictionary(colname = col, path_Dic = path_dic, which.OS = "Mac")  
}






# 🟥 Load data ###########################################################################
path_nfq = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️다운받은 파일들/attachments/MAYOADIRL_MRI_FMRI_NFQ_15Apr2024.csv"
nfq = read.csv(path_nfq)
path_viscode = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments/4.VISCODE.rds"
viscode = readRDS(path_viscode)




# 🟥 NFQ ###########################################################################
## 🟧 Check col names ============================================================================
names(nfq)
View(nfq)

rid = intersect(nfq$RID, viscode$RID) %>% unique
length(rid)



## 🟧 rename columns ============================================================================
# nfq 데이터 프레임의 열 이름 수정
nfq <- nfq %>%
  relocate(OVERALLQC) %>% 
  rename_with(.fn = ~paste0("NFQ___", .), 
              .cols = -c(RID, VISCODE, VISCODE2))
  

# 결과 확인
print(names(nfq))








## 🟧 Remove bad data ============================================================================
nfq_filtered = nfq %>% 
  filter(NFQ___OVERALLQC %in% c(1,2,3)) %>% 
  arrange(RID)


dim(nfq)
dim(nfq_filtered)




## 🟧 Filter data by EPB ============================================================================
library(dplyr)
epb = viscode %>% filter(QC___SERIES_TYPE == "EPB")

# epb의 고유한 조합을 찾기
unique_combinations <- distinct(epb, RID, VISCODE, VISCODE2)

# nfq_filtered에서 epb의 조합과 일치하는 행을 필터링
nfq_matched_rows <- nfq_filtered %>%
  semi_join(unique_combinations, by = c("RID", "VISCODE", "VISCODE2"))

# 결과 확인
View(nfq_matched_rows)
dim(nfq_matched_rows)
dim(nfq_filtered)





## 🟧 Check unique RID VISCODE ============================================================================
library(dplyr)

# 중복 행 찾기
duplicates <- nfq_matched_rows %>%
  group_by(RID, VISCODE, VISCODE2) %>%
  filter(n() > 1) %>%
  ungroup()

# 결과 출력
View(duplicates)



# # compare with epb
# epb = viscode %>% filter(QC___SERIES_TYPE == "EPB")
# epb_filtered = epb %>% filter(RID %in% duplicates$RID)
# View(epb_filtered)

# remove dup rows
# 중복 행을 찾고, 중복된 그룹 내에서 NFQ___OVERALLQC까지 동일한 경우 하나의 행만 남깁니다.
# 전체 데이터 프레임에서 중복 그룹을 찾아 그 중 첫 번째 행만 유지
nfq_matched_rows_2 <- nfq_matched_rows %>%
  group_by(RID, VISCODE, VISCODE2, NFQ___OVERALLQC) %>%  # 그룹화
  mutate(count = n()) %>%  # 각 그룹의 크기 계산
  ungroup() %>%  # 그룹 해제
  filter(count == 1 | row_number() == 1) %>%  # 유니크한 행 또는 중복 그룹의 첫 번째 행 선택
  select(-count)  # 계산된 count 열 제거


nfq_matched_rows_2 %>% filter(RID==6179) %>% View


#  Check the number of RID
nfq_matched_rows_2$RID %>% length == nrow(nfq_matched_rows_2)



#  Check distinct data
check_distinct = distinct(nfq_matched_rows_2, RID, VISCODE, VISCODE2, NFQ___OVERALLQC)
View(check_distinct)
dim(check_distinct)
dim(nfq_matched_rows_2)
# n_row가 동일







# 🟥 Merge with EPB ###########################################################################
# ## 🟧 Extract data ============================================================================
# viscode$QC___SERIES_TYPE %>% table
# # RID, VISCODE, VISCODE2가 EPB와 같은 MT1이 있으므로
# epb = viscode %>% filter(is.na(QC___SERIES_TYPE) | QC___SERIES_TYPE != "MT1")
# mt1 = viscode %>% filter(QC___SERIES_TYPE == "MT1")
# 
# # check
# epb$RID %>% table
# epb %>% filter(RID==21) %>% View
# viscode %>% filter(RID==21) %>% View



## 🟧 merge ============================================================================
# rename Phase
nfq_matched_rows_3 = nfq_matched_rows_2 %>% rename(PHASE := NFQ___COLPROT)
nfq_matched_rows_3$PHASE %>% is.na %>% sum
table(nfq_matched_rows_3$PHASE)


# epb와 nfq_filtered 데이터 프레임 합치기
merged_data <- viscode %>%
  filter(RID %in% nfq_matched_rows_3$RID) %>% 
  left_join(nfq_matched_rows_3, by = c("PHASE", "RID", "VISCODE", "VISCODE2"))


# overall qc
merged_data$NFQ___OVERALLQC %>% table





# 🟥 save data ###########################################################################
path_save = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments"
saveRDS(merged_data, paste0(path_save, "/5.NFQ.rds"))

































