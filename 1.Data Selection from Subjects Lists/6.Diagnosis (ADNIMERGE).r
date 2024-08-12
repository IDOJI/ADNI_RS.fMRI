# 🟥 packages ##########################################################################
filter = dplyr::filter
select = dplyr::select




# 🟥 Load data ########################################################################### 
# rm(list=ls())
path_save =  "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments"
data = readRDS(paste0(path_save, "/5.NFQ.rds"))




# 🟥 Dictionary ###########################################################################
# adnimerge %>% names
# dic("IMAGEUID")
RS.fMRI_0_Data.Dictionary = function(colname, path_Dic = NULL, which.OS = c("Windows", "Mac")){
  # install_package("Hmisc")
  # install.packages("C:/Users/lleii/Dropbox/Github/Rpkgs/ADNIprep/ADNIMERGE/ADNIMERGE_0.0.1.tar.gz", repose = NULL, type="source")
  # install.packages("/Users/Ido/Library/CloudStorage/Dropbox/Github/Rpkgs/ADNIprep/ADNIMERGE/ADNIMERGE_0.0.1.tar.gz")
  # require(ADNIMERGE)
  #=============================================================================
  # path Setting
  #=============================================================================
  if(is.null(path_Dic)){
    which.OS = match.arg(which.OS, which.OS)
    if(which.OS == "Windows"){
      path_OS = "C:/Users/lleii/"
    }else{
      path_OS = "/Users/Ido/"
    }
    path_Dic = paste0(path_OS, "Dropbox/Github/Rpkgs/ADNIprep/Data") %>% list.files(full.names = T, pattern = "dictionary")
  }
  
  
  
  
  
  #=============================================================================
  # Read data
  #=============================================================================
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
  path_dic = "/Users/Ido/Library/CloudStorage/Dropbox/2.DataAnalysis/ADNI/SubjectsList/DATADIC_04Apr2024.csv"
  RS.fMRI_0_Data.Dictionary(colname = col, path_Dic = path_dic, which.OS = "Mac")  
}





# 🟥 Check REGISTRY___USERDATE ###########################################################################
data$REGISTRY___USERDATE %>% is.na %>% sum
data = data %>% dplyr::relocate(REGISTRY___USERDATE, .after = REGISTRY___VISORDER)
# View(data)

data$REGISTRY___VISORDER

# REGISTRY___USERDATE를 Date 타입으로 변환
data <- data %>%
  dplyr::mutate(REGISTRY___USERDATE = ymd(REGISTRY___USERDATE))



# 날짜가 동일한 경우 VISORDER를 동일한 순서로 처리
test <- data %>%
  dplyr::group_by(RID, PHASE) %>%
  dplyr::arrange(RID, 
                 PHASE, 
                 REGISTRY___USERDATE,
                 REGISTRY___VISORDER) %>%
  dplyr::mutate(
    # 날짜별로 그룹화하여 고유 그룹 ID 생성
    date_group = cumsum(c(1, diff(REGISTRY___USERDATE) != 0)),
    # 날짜 그룹 내에서 VISORDER의 연속성을 확인하기 위한 순서
    visorder_rank = rank(REGISTRY___VISORDER)
  ) %>%
  dplyr::ungroup()

# 각 날짜 그룹 내에서 VISORDER 연속성과 날짜 순서 일치 여부 확인
order_check <- test %>%
  dplyr::group_by(RID, PHASE, date_group) %>%
  dplyr::summarise(
    is_order_matching = all(diff(visorder_rank) == 1),
    .groups = "drop"
  )

# 결과 확인
print(order_check)
order_check$is_order_matching %>% sum == nrow(order_check)

# 결과 확인
print(order_check)
test_21 = data %>% dplyr::filter(RID==21)
View(test_21)

data$REGISTRY___USERDATE %>% is.na %>% sum




# 🟥 Check diagnosis NA ###########################################################################
data$ADNIMERGE___DX %>% table %>% names
data$ADNIMERGE___DX = ifelse(data$ADNIMERGE___DX == "", NA, data$ADNIMERGE___DX)
data = data %>% dplyr::relocate(ADNIMERGE___DX, .after = RID)

data %>% View
names(data)




# 🟥 Check diagnosis at scanning date ###########################################################################
# filter search description with no NA
dim(data)
test = data %>% 
  dplyr::filter(!is.na(IMAGE.ID))


# NA is DX?
test$ADNIMERGE___DX %>% table
test$ADNIMERGE___DX %>% is.na %>% sum
test$ADNIMERGE___DX %>% unique






# 🟥 DXSUM ###########################################################################
## 🟧 Check data ============================================================================================
dxsum = read.csv("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️다운받은 파일들/attachments/DXSUM_PDXCONV_06Apr2024.csv")




## 🟧 colnames ============================================================================================
dxsum_col <- dxsum %>%
  rename_with(function(x) paste0("DXSUM___", x), -c("PHASE", "PTID", "RID", "VISCODE", "VISCODE2"))





## 🟧 Diagnosis ============================================================================================
class(dxsum_col$DXSUM___DIAGNOSIS)
dxsum_col$DXSUM___DIAGNOSIS_2 = ifelse(dxsum_col$DXSUM___DIAGNOSIS == 1, "CN",
                                       ifelse(dxsum_col$DXSUM___DIAGNOSIS == 2, "MCI", 
                                              ifelse(dxsum_col$DXSUM___DIAGNOSIS == 3, "Dementia", dxsum_col$DXSUM___DIAGNOSIS)))
table(dxsum_col$DXSUM___DIAGNOSIS_2)
dxsum_col = dxsum_col %>% dplyr::relocate(DXSUM___DIAGNOSIS_2, .after = DXSUM___DIAGNOSIS)



## 🟧 Diagnosis for check ============================================================================================
### 🟨 Check ==========================================================================
"DXSUM___DXNORM"
"DXSUM___DXMCI"
# dic("DXAD") : ADNI1 = AD 1(yes)
# dic("DXPARK") : Parkinson symptom? 1 yes
# dic("DXAPROB"): If Probable AD, select box(es) for other symptoms present
# dic("DXAPP"): If Dementia due to Alzheimer's Disease, indicate likelihood
"DXSUM___DXAD"
"DXSUM___DXAPP"                       
"DXSUM___DXAPROB"
"DXSUM___DXPARK"


# relocate
dxsum_col = dxsum_col %>% 
  dplyr::relocate(DXSUM___DXNORM, DXSUM___DXMCI, DXSUM___DXAD, DXSUM___DXAPROB, .after = DXSUM___DIAGNOSIS_2)


# check overlapped 1?
# 한 행에 DXSUM___DXNORM, DXSUM___DXMCI, DXSUM___DXAD 열에서 1이 두 개 이상 있는지 체크
check_rows <- dxsum_col %>%
  rowwise() %>%
  mutate(multiple_ones = sum(c_across(c(DXSUM___DXNORM, DXSUM___DXMCI, DXSUM___DXAD)) == 1, na.rm = TRUE) >= 2) %>%
  ungroup()
# 결과 확인 - multiple_ones 열이 TRUE인 행이 1을 두 개 이상 가지고 있는 행
filtered_rows <- check_rows %>%
  dplyr::filter(multiple_ones == TRUE)
print(filtered_rows)
# -> 1이 여러 개인 경우는 없음




### 🟨 Treat diagnosis info ==========================================================================
# 데이터프레임 예시 (실제 사용시 merged_data 데이터프레임 사용)
# merged_data <- read.csv("your_data.csv")

# 결측값 처리
dxsum_col$DXSUM___DXNORM[dxsum_col$DXSUM___DXNORM == -4] <- NA
dxsum_col$DXSUM___DXMCI[dxsum_col$DXSUM___DXMCI == -4] <- NA
dxsum_col$DXSUM___DXAD[dxsum_col$DXSUM___DXAD == -4] <- NA



# check
table(dxsum_col$DXSUM___DXAD)
table(dxsum_col$DXSUM___DXMCI)
table(dxsum_col$DXSUM___DXNORM)



### 🟨DX info as new diagnosis ==========================================================
dxsum_col <- dxsum_col %>%
  mutate(DIAGNOSIS_by_DXSUM = case_when(
    DXSUM___DXAD == 1 ~ "Dementia",
    DXSUM___DXMCI == 1 ~ "MCI",
    DXSUM___DXNORM == 1 ~ "CN",
    TRUE ~ NA_character_ # 그 외의 경우 NA 할당
  ))
# 결과 확인
dxsum_col$DIAGNOSIS_by_DXSUM %>% table
table(dxsum_col$DXSUM___DXAD)
table(dxsum_col$DXSUM___DXMCI)
table(dxsum_col$DXSUM___DXNORM)

dxsum_col = dxsum_col %>% dplyr::relocate(DIAGNOSIS_by_DXSUM, .after = DXSUM___DIAGNOSIS_2)



# compare
identical(dxsum_col$DIAGNOSIS_by_DXSUM, dxsum_col$DXSUM___DIAGNOSIS_2)



### 🟨 Combine Diagnosis ==========================================================
# DIAGNOSIS 열 각각에서 NA 값들 채우기
dxsum_col <- dxsum_col %>%
  mutate(DIAGNOSIS_COMBINED = case_when(
    is.na(DIAGNOSIS_by_DXSUM) & is.na(DXSUM___DIAGNOSIS_2) ~ NA_character_,
    !is.na(DIAGNOSIS_by_DXSUM) & is.na(DXSUM___DIAGNOSIS_2) ~ DIAGNOSIS_by_DXSUM,
    is.na(DIAGNOSIS_by_DXSUM) & !is.na(DXSUM___DIAGNOSIS_2) ~ DXSUM___DIAGNOSIS_2,
    DIAGNOSIS_by_DXSUM == DXSUM___DIAGNOSIS_2 ~ DIAGNOSIS_by_DXSUM,
    TRUE ~ NA_character_  # 일단 에러 대신 NA 할당, 추후 에러 처리
  ))
# 둘 다 NA가 아니고 서로 다른 값을 가지는 경우 에러 발생
conflicting_cases <- dxsum_col %>%
  dplyr::filter(!is.na(DIAGNOSIS_by_DXSUM) & !is.na(DXSUM___DIAGNOSIS_2) & DIAGNOSIS_by_DXSUM != DXSUM___DIAGNOSIS_2)

if(nrow(conflicting_cases) > 0) {
  stop("Conflicting values found in DIAGNOSIS_by_DXSUM and DXSUM___DIAGNOSIS_2.")
}

dxsum_col = dxsum_col %>% relocate(DIAGNOSIS_COMBINED, .after = RID)
# -> 결론 DXSUM___DIAGNOSIS_2과 DIAGNOSIS_by_DXSUM는 다르지만,
# NA합쳐서 diag_full를 사용

# Check 
identical(dxsum_col$DIAGNOSIS_COMBINED, dxsum_col$DIAGNOSIS_by_DXSUM)
is.na(dxsum_col$DIAGNOSIS_COMBINED) %>% sum




# arrange
dxsum_col_2 = dxsum_col %>% arrange(RID, PHASE)




## 🟧 RID ============================================================================================
class(dxsum_col_2$RID) == class(data$RID)
data$RID = as.integer(data$RID)
class(dxsum_col_2$RID) == class(data$RID)




## 🟧 arrange ============================================================================================
table(dxsum_col_2$PHASE)
# phase?
dxsum_col_2$PHASE = factor(dxsum_col_2$PHASE, levels = c("ADNI1", "ADNIGO", "ADNI2", "ADNI3", "ADNI4"))

# dates na?
dxsum_col_2$DXSUM___EXAMDATE %>% is.na %>% sum

# dates
dxsum_col_2$DXSUM___EXAMDATE = dxsum_col_2$DXSUM___EXAMDATE %>% as.Date()

# arrange
dxsum_col_2 = dxsum_col_2 %>% dplyr::arrange(RID, PHASE, DXSUM___EXAMDATE)
View(dxsum_col_2)





# 🟥 merge with DXSUM ###########################################################################
## 🟧 Merge data  ============================================================================================
names(data)
names(dxsum_col_2)

data$VISCODE2 %>% is.na %>% sum
data[which(data$VISCODE2 %>% is.na),] %>% View
dxsum_4520 = dxsum_col_2 %>% dplyr::filter(RID==4520)


# data와 dxsum_col 데이터프레임을 PHASE, RID, VISCODE2 열을 기준으로 조인합니다.
merged_data <- left_join(data, dxsum_col_2, by = c("PHASE", "RID", "VISCODE", "VISCODE2"))



## 🟧 Check the results ===========================================================
dim(merged_data)
dim(data)
data$PHASE %>% is.na %>% sum
merged_data$PHASE %>% is.na %>% sum
merged_data$RID %>% is.na %>% sum
merged_data$RID %>% is.na %>% sum
View(merged_data)
merged_data %>% names




## 🟧 DX ===============================================================================
# relocate
merged_data = merged_data %>% 
  dplyr::relocate(ADNIMERGE___DX, .after = RID)



# Compare ADNIMERGE___DX, DIAGNOSIS_COMBINED
merged_data$DIAGNOSIS_COMBINED %>% is.na %>% sum
merged_data$ADNIMERGE___DX %>% is.na %>% sum


# 조건에 따라 DIAGNOSIS_FINAL 열 생성
merged_data <- merged_data %>%
  mutate(DIAGNOSIS_FINAL = case_when(
    is.na(DIAGNOSIS_COMBINED) & !is.na(ADNIMERGE___DX) ~ ADNIMERGE___DX,
    !is.na(DIAGNOSIS_COMBINED) & is.na(ADNIMERGE___DX) ~ DIAGNOSIS_COMBINED,
    is.na(DIAGNOSIS_COMBINED) & is.na(ADNIMERGE___DX) ~ NA_character_,
    DIAGNOSIS_COMBINED == ADNIMERGE___DX ~ DIAGNOSIS_COMBINED,
    TRUE ~ NA_character_  # 일단 NA 할당, 추후 에러 처리
  )) %>% 
  relocate(DIAGNOSIS_FINAL, .after = RID)

# 둘 다 NA가 아니면서 서로 다른 값을 가지는 경우 에러 처리
conflict_rows <- dplyr::filter(merged_data, !is.na(DIAGNOSIS_COMBINED) & !is.na(ADNIMERGE___DX) & DIAGNOSIS_COMBINED != ADNIMERGE___DX)
if(nrow(conflict_rows) > 0) {
  # conflict_rows를 출력하거나 로그로 남겨 에러 상황 파악
  print(conflict_rows)
  stop("Conflicting values found between DIAGNOSIS_COMBINED and ADNIMERGE___DX.")
}

# 결과 확인
# head(merged_data)
identical(merged_data$DIAGNOSIS_FINAL, merged_data$ADNIMERGE___DX)
identical(merged_data$DIAGNOSIS_FINAL, merged_data$DIAGNOSIS_COMBINED)
table(merged_data$DIAGNOSIS_FINAL) %>% sum
merged_data$DIAGNOSIS_FINAL %>% is.na %>% sum
test_21 = merged_data %>% dplyr::filter(RID==21) 


  








# 🟥 Check ###########################################################################
merged_data = merged_data %>% 
  relocate(DXSUM___DIAGNOSIS, DXSUM___DIAGNOSIS_2, .after = DIAGNOSIS_FINAL)


merged_data %>% filter(RID==21) %>% View
merged_data %>% filter(RID==6788) %>% View


# 🟥 save ###########################################################################
saveRDS(merged_data, paste0(path_save, "/6.Diagnosis.rds"))










# 🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩==========================================
# # 🟥 Fill in the missing values ###########################################################################
# merged_data_4 = merged_data_3
# 
# ## 🟧 NA 제외 모든 진단이 전부 똑같은 경우 통일 =========================================================
# # 고유한 DIAGNOSIS 값의 수가 1인 RID 식별
# unique_diagnosis_rids = merged_data_4 %>% 
#   dplyr::filter(!is.na(DIAGNOSIS_NEW)) %>% 
#   dplyr::group_by(RID) %>% 
#   dplyr::summarise(unique_diagnosis_count = n_distinct(DIAGNOSIS_NEW)) %>% 
#   dplyr::filter(unique_diagnosis_count == 1) %>% 
#   dplyr::pull(RID)
# 
# 
# 
# # 해당 RID의 모든 NA를 동일한 DIAGNOSIS로 채움
# # merged_data_3 데이터프레임에 DIAGNOSIS_PSEUDO 열 생성 및 초기화
# merged_data_4 <- merged_data_4 %>%
#   dplyr::mutate(DIAGNOSIS_PSEUDO = DIAGNOSIS_NEW) %>% 
#   dplyr::relocate(DIAGNOSIS_PSEUDO, .before=DIAGNOSIS_NEW)
# 
# merged_data_4 %>% dplyr::filter(RID==56) %>% View()
# 
# 
# 
# # unique_diagnosis_rids 벡터에 있는 각 RID에 대해 반복
# for (rid in unique_diagnosis_rids) {
#   # 해당 RID의 NA가 아닌 DIAGNOSIS 값 추출
#   diagnosis_value <- merged_data_4 %>%
#     dplyr::filter(RID == rid & !is.na(DIAGNOSIS_NEW)) %>%
#     dplyr::pull(DIAGNOSIS_NEW) %>% 
#     unique()
#   
#   
#   # unique 함수 적용 후 길이가 1인 경우 해당 값을 DIAGNOSIS_PSEUDO 열에 적용
#   if (length(diagnosis_value ) == 1) {
#     merged_data_4 <- merged_data_4 %>%
#       mutate(DIAGNOSIS_PSEUDO = ifelse(RID == rid, diagnosis_value , DIAGNOSIS_PSEUDO))
#     
#   }
# }
# 
# View(merged_data_4)
# 
# 
# 
# ## 🟧 특정 시점의 앞뒤가 똑같은 DX인 경우 =========================================================
# # 사용자 정의 함수: NA 값에 대한 조건부 채우기
# fill_na <- function(dx) {
#   n <- length(dx)
#   # NA 인덱스 찾기
#   na_idx <- which(is.na(dx))
#   
#   for (i in na_idx) {
#     # NA 주변의 값이 동일하면 NA를 해당 값으로 대체
#     if(!is.na(dx[i+1])){
#       if (i > 1 && i < n && !is.na(dx[i-1]) && dx[i-1] == dx[i+1]) {
#         dx[i] <- dx[i-1]
#       }
#       # 첫 번째나 마지막 값이 NA인 경우는 별도 로직 필요에 따라 추가
#     }
#   }
#   
#   return(dx)
# }
# 
# 
# 
# 
# # 각 RID별로 함수 적용
# merged_data_4$DIAGNOSIS_PSEUDO
# filled_data <- merged_data_4 %>%
#   group_by(RID) %>%
#   mutate(DIAGNOSIS_PSEUDO_2 = fill_na(DIAGNOSIS_PSEUDO)) %>%
#   ungroup() %>% 
#   relocate(DIAGNOSIS_PSEUDO_2, .after = RID)
# 
# 
# 
# 
# 
# ## 🟧 Check ========================================================================
# only_fmri_data = filled_data %>%
#   dplyr::filter(!is.na(IMAGE.ID)) %>%
#   dplyr::filter(SEARCH___MODALITY == "fMRI")
# only_fmri_data$ADNIMERGE___DX %>% is.na %>% sum
# only_fmri_data$DIAGNOSIS_PSEUDO_2 %>% is.na %>% sum
# 
# 
# 
# 
# 
# # 🟥 (TMP)BLACHAGE ###########################################################################
# blchange = read.csv("/Users/Ido/Library/CloudStorage/Dropbox/@DataAnalysis/㊙️CommonData___ADNI___SubjectsList/BLCHANGE_07Apr2024.csv")
# names(blchange)
# blchange$BCCORCOG
# blchange$RID %>% table
# blchange$VISCODE %>% table
# blchange %>% View()
# names(blchange)
# test_21 = blchange %>% dplyr::filter(RID==21)
# dic("BCPREDX")
# dic("BCPREDX")
# dic("BCCORADL")
# dic("DXMDES")
# 
# 
# 
# # 🟥 Exclude MRI ###########################################################################
# # QC___SERIES_TYPE이 NA이거나 EPB인 행만 추출
# dim(data)
# ind = which(data$QC___SERIES_TYPE == "MT1")
# 
# mt1 = data[ind,]
# filtered_data = data[-ind,]
# 
# 
# #  VISCODE2에 NA 존재?
# filtered_data$VISCODE2 %>% is.na %>% sum
# na_viscode = filtered_data %>% dplyr::filter(is.na(VISCODE2))
# View(na_viscode)
# # -> NA인 경우 없음
# 
# 
# 
# 
# 
# # 🟥 Compare DX in MRI and fMRI ###########################################################################
# epb = data[which(data$QC___SERIES_TYPE == "EPB"), ]
# epb$QC___SERIES_TYPE %>% table
# mt1$QC___SERIES_TYPE %>% table
# mt1$ADNIMERGE___DX %>% table
# epb$ADNIMERGE___DX %>% table
# epb$VISCODE
# 
# library(dplyr)
# 
# # 두 데이터 프레임을 합치기
# combined_data <- bind_rows(epb, mt1)
# 
# # RID, PHASE, VISCODE, VISCODE2를 기준으로 정렬
# combined_data_sorted <- combined_data %>%
#   arrange(RID, PHASE, VISCODE, VISCODE2)
# 
# # 각 RID와 PHASE별로 ADNIMERGE___DX 값이 모두 동일한지 확인
# dx_consistency <- combined_data_sorted %>%
#   group_by(RID, PHASE) %>%
#   summarise(is_dx_consistent = n_distinct(ADNIMERGE___DX) == 1, 
#             .groups = 'drop')
# 
# # 결과 확인
# print(dx_consistency)
# 
# dx_consistency$is_dx_consistent %>% sum == nrow(dx_consistency)
# dx_consistency$is_dx_consistent = dx_consistency$is_dx_consistent %>% as.numeric
# dx_consistency$RID[dx_consistency$is_dx_consistent==0]
# 
# combined_data_sorted %>% dplyr::filter(RID==7073) %>% View
# View(combined_data_sorted)
# data %>% dplyr::filter(RID==7073) %>% View
# adnimerge = read.csv("/Users/Ido/Library/CloudStorage/Dropbox/@DataAnalysis/㊙️CommonData___ADNI___SubjectsList/ADNIMERGE_04Apr2024.csv")
# adnimerge %>% dplyr::filter(RID==7073) %>% View
# # -> MRI 데이터는 제외하지 않는 것이 좋음
# 
# 
# 
# 
# # 🟥 Check VISCODE2 unity ###########################################################################
# ## 🟧 VISCODE2 unique? ==================================================================
# # filtered_data %>% View
# filtered_data$VISCODE2 %>% is.na %>% sum
# "" %in% filtered_data$VISCODE2
# filtered_data$VISCODE2 = ifelse(filtered_data$VISCODE2 == "", NA, filtered_data$VISCODE2)
# 
# 
# # 각 RID별로 VISCODE2 열에서 NA와 "sc"를 제외한 나머지 값들이 하나씩만 존재하는지 확인
# results <- filtered_data %>%
#   dplyr::filter(!is.na(VISCODE2), VISCODE2 != "sc") %>%
#   dplyr::group_by(RID) %>%
#   dplyr::summarise(unique_visits_count = n_distinct(VISCODE2),
#                    total_visits_count = n()) %>%
#   dplyr::mutate(all_unique_visits = unique_visits_count == total_visits_count) %>%
#   dplyr::select(RID, all_unique_visits) %>% 
#   dplyr::filter(all_unique_visits == 0)
# rid = results$RID
# 
# 
# # filtered_data %>% dplyr::filter(RID==200) %>% View
# # -> 결론: PHASE도 함께 고려해야 중복을 방지할 수 있음
# 
# 
# 
# ## 🟧 VISCODE2 unique? (RID, Phase) ==================================================================
# # PHASE까지 고려해서 각 RID에 대해 VISCODE2에 중복인 값이 있는지 확인
# # PHASE 열을 factor로 설정하고 순서 지정
# filtered_data$PHASE <- factor(filtered_data$PHASE, levels = c("ADNI1", "ADNIGO", "ADNI2", "ADNI3"))
# 
# # 각 RID 및 PHASE 그룹별로 VISCODE2 값의 중복 여부 확인
# results <- filtered_data %>%
#   # NA 제외
#   dplyr::filter(!is.na(VISCODE2)) %>% 
#   dplyr::group_by(RID, PHASE) %>%
#   dplyr::summarise(DuplicateExists = any(duplicated(VISCODE2)), .groups = 'drop') %>% 
#   dplyr::filter(isTRUE(DuplicateExists))
# results 
# # -> 각 RID의 각 PHASE의 VISCODE2에 중복 없음!
# # -> RID, VISCODE2와 PHASE 기준으로 DXSUM과 합쳐도 됨.
# 







