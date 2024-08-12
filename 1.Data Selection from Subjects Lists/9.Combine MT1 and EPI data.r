# 🟥 Load Functions & Packages ##########################################################################
## 🟧Install and loading Packages ================================
install_packages = function(packages, load=TRUE) {
  # load : load the packages after installation?
  for(pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg)
    }
    
    if(load){
      library(pkg, character.only = TRUE, quietly = T)
    }
  }
}

List.list = list()
List.list[[1]] = visual = c("ggpubr", "ggplot2", "ggstatsplot", "ggsignif", "rlang", "RColorBrewer")
List.list[[2]] = stat = c("fda", "MASS")
List.list[[3]] = data_handling = c("tidyverse", "dplyr", "clipr", "tidyr", "readr", "caret", "readxl")
List.list[[4]] = qmd = c("janitor", "knitr")
List.list[[5]] = texts = c("stringr")
List.list[[6]] = misc = c("devtools")
List.list[[7]] = db = c("RMySQL", "DBI", "odbc", "RSQL", "RSQLite")
List.list[[8]] = sampling = c("rsample")

packages_to_install_and_load = unlist(List.list)
install_packages(packages_to_install_and_load)

## 🟧dplyr =======================================================
filter = dplyr::filter
select = dplyr::select




# 🟥 Load data ##########################################################################
# 깨진 한글 경로를 UTF-8로 변환
file_path <- "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments/8.Selected_Data(The first visit with fMRI).rds"
utf8_path <- iconv(file_path, from = "UTF-8", to = "UTF-8")

# 파일 읽기
data <- readRDS(utf8_path)


# 
epb = data$epb
mt1 = data$mt1



# 🟥 함수 정의 #################################################################################################################
remove_matching_columns <- function(mt1, epb, prefix) {
  # 특정 문자열로 시작하는 열 이름 추출
  cols_to_check <- grep(paste0("^", prefix), names(mt1), value = TRUE)
  
  # 공통 열 이름만 추출
  common_cols <- intersect(cols_to_check, names(epb))
  
  # 동일한 값을 가진 열 이름을 저장할 벡터
  cols_to_remove <- c()
  
  # 각 공통 열에 대해 값 비교
  for (col in common_cols) {
    if (identical(mt1[[col]], epb[[col]])) {
      cols_to_remove <- c(cols_to_remove, col)
    }
  }
  
  # 동일한 값을 가진 열 이름을 mt1에서 제거
  mt1 <- mt1 %>% select(-one_of(cols_to_remove))
  
  return(mt1)
}


remove_matching_columns_with_exclude <- function(mt1, epb, exclude = NULL) {
  # 비교할 열 이름 추출 (exclude에 포함된 열 이름 제외)
  cols_to_check <- setdiff(intersect(names(mt1), names(epb)), exclude)
  
  # 동일한 값을 가진 열 이름을 저장할 벡터
  cols_to_remove <- c()
  
  # 각 공통 열에 대해 값 비교
  for (col in cols_to_check) {
    if (identical(mt1[[col]], epb[[col]])) {
      cols_to_remove <- c(cols_to_remove, col)
    }
  }
  
  # 동일한 값을 가진 열 이름을 mt1에서 제거
  mt1 <- mt1 %>% select(-one_of(cols_to_remove))
  
  return(mt1)
}



# 특정 문자열로 시작하는 열 이름들을 맨 뒤로 이동시키는 함수
move_columns_to_end <- function(df, prefix) {
  # 특정 문자열로 시작하는 열 이름 추출
  cols_to_move <- grep(paste0("^", prefix), names(df), value = TRUE)
  
  # 이동할 열을 제외한 나머지 열 이름 추출
  remaining_cols <- setdiff(names(df), cols_to_move)
  
  # 열 순서 재배치
  df <- df %>% select(all_of(remaining_cols), all_of(cols_to_move))
  
  return(df)
}

# 열 이름을 변경하는 함수 정의
modify_specified_columns <- function(df, col_names, add_string) {
  # 데이터 프레임의 열 이름 가져오기
  new_names <- names(df)
  
  # 지정된 열 이름 앞에 문자열 추가
  new_names <- ifelse(new_names %in% col_names, 
                      paste0(add_string, new_names), 
                      new_names)
  
  # 수정된 열 이름을 데이터 프레임에 할당
  names(df) <- new_names
  
  return(df)
}





# 🟥 MT1 #################################################################################################################
## 🟧 NFQ 열이름 제거 ====================================================================================================
mt1_filtered = remove_matching_columns(mt1, epb, prefix = "NFQ___")
names(mt1_filtered)




## 🟧 REGISTRY 열이름 제거 ====================================================================================================
mt1_filtered_2 = remove_matching_columns(mt1_filtered, epb, prefix = "REGISTRY___")
names(mt1_filtered_2)



## 🟧 QC 열이름 제거 ====================================================================================================
mt1_filtered_3 = remove_matching_columns(mt1_filtered_2, epb, prefix = "QC___")
names(mt1_filtered_3)



## 🟧 SEARCH 열이름 제거 ====================================================================================================
mt1_filtered_4 = remove_matching_columns(mt1_filtered_3, epb, prefix = "SEARCH___")
names(mt1_filtered_4)


## 🟧 DXSUM 열이름 제거 ====================================================================================================
mt1_filtered_5 = remove_matching_columns(mt1_filtered_4, epb, prefix = "DXSUM___")
names(mt1_filtered_5)


## 🟧 REGISTRY 열이름 제거 ====================================================================================================
mt1_filtered_6 = remove_matching_columns(mt1_filtered_5, epb, prefix = "REGISTRY___")
names(mt1_filtered_6)


## 🟧 ADNIMERGE 열이름 제거 ====================================================================================================
mt1_filtered_7 = remove_matching_columns(mt1_filtered_6, epb, prefix = "ADNIMERGE___")
names(mt1_filtered_7)


## 🟧 VISCODE 열이름 제거 ====================================================================================================
mt1_filtered_8 = remove_matching_columns(mt1_filtered_7, epb, prefix = "VISCODE")
names(mt1_filtered_8)



## 🟧 PHASE 열이름 제거 ====================================================================================================
mt1_filtered_9 = remove_matching_columns(mt1_filtered_8, epb, prefix = "PHASE")
names(mt1_filtered_9)


## 🟧 ORIGPROT 열이름 제거 ====================================================================================================
mt1_filtered_10 = remove_matching_columns(mt1_filtered_9, epb, prefix = "ORIGPROT")
names(mt1_filtered_10)



## 🟧⭐️ RID 제외 모든 열 비교해서 같은 값을 가지는 열 제거 ====================================================================================================
mt1_filtered_11 = remove_matching_columns_with_exclude(mt1_filtered_10, epb, "RID") %>% relocate(RID)
mt1_filtered_11 %>% names


## 🟧⭐️ MT1 이름 추가 ====================================================================================================
mt1_filtered_12 = mt1_filtered_11
names(mt1_filtered_12) = names(mt1_filtered_12) %>% paste0("MT1___", .)




# 🟥 EPB ##################################################################################################################
## 🟧 열들 맨 뒤로 옮기기 ====================================================================================================
for(ith_col_text in c("SEARCH___", "DXSUM___", "REGISTRY___", "NFQ___", "QC___", "ADNIMERGE___")){
  epb = move_columns_to_end(epb, ith_col_text)  
}
names(epb)



## 🟧 QC열에 EPI 추가 ====================================================================================================
# "QC___"로 시작하는 열 이름 앞에 "EPI___" 문자열 추가
new_names <- names(epb)
new_names <- ifelse(grepl("^QC___", new_names), paste0("EPI___", new_names), new_names)
names(epb) <- new_names



## 🟧 Image ID 열 앞에 EPI 추가  ====================================================================================================
epb_modified = modify_specified_columns(epb, c("IMAGE.ID", "BAND.TYPE", "MANUFACTURER_NEW", "NEW_USERDATE"), "EPI___")
names(epb_modified) %>% head(., 15)



# 🟥 데이터프레임 합치기 ##################################################################################################
# mt1_filtered_12의 mt1_RID와 epb의 RID를 기준으로 데이터 프레임 합치기
merged_df <- left_join(epb_modified, mt1_filtered_12, by = c("RID" = "MT1___RID"))








# 🟥 Change Series Description ##################################################################################################
# ( 또는 ) -> _
# 공백 -> _
# epb 데이터 프레임을 수정하고 QC___SERIES_DESCRIPTION 열을 변환
merged_df_2 = merged_df %>%
  mutate(EPI___QC___SERIES_DESCRIPTION_2 = gsub("\\(", "_", EPI___QC___SERIES_DESCRIPTION), # '('를 '_'로 변경
         EPI___QC___SERIES_DESCRIPTION_2 = gsub("\\)", "_", EPI___QC___SERIES_DESCRIPTION_2), # ')'를 '_'로 변경
         EPI___QC___SERIES_DESCRIPTION_2 = gsub(" ", "_", EPI___QC___SERIES_DESCRIPTION_2), # 공백을 '_'로 변경
         EPI___QC___SERIES_DESCRIPTION_2 = gsub(">", "_", EPI___QC___SERIES_DESCRIPTION_2)) %>% # '>'를 '_'로 변경
  relocate(EPI___QC___SERIES_DESCRIPTION_2, .before = EPI___QC___SERIES_DESCRIPTION) # 새 열을 원래 열 바로 앞으로 이동



# MT1
merged_df_3 <- merged_df_2 %>%
  mutate(MT1___QC___SERIES_DESCRIPTION_2 = gsub("\\(", "_", MT1___QC___SERIES_DESCRIPTION), # '('를 '_'로 변경
         MT1___QC___SERIES_DESCRIPTION_2 = gsub("\\)", "_", MT1___QC___SERIES_DESCRIPTION_2), # ')'를 '_'로 변경
         MT1___QC___SERIES_DESCRIPTION_2 = gsub(" ", "_", MT1___QC___SERIES_DESCRIPTION_2), # 공백을 '_'로 변경
         MT1___QC___SERIES_DESCRIPTION_2 = gsub(">", "_", MT1___QC___SERIES_DESCRIPTION_2)) %>% # '>'를 '_'로 변경
  relocate(MT1___QC___SERIES_DESCRIPTION_2, .before = MT1___QC___SERIES_DESCRIPTION) # 새 열을 원래 열 바로 앞으로 이동






# 🟥 Export ##################################################################################################
path_save = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments" %>% fix_korean_path
write.csv(merged_df_3, paste0(path_save, "/9.MT1-EPI-Merged-Subjects-List.csv"), row.names = F)







