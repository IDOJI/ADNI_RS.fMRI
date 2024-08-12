# 🟥 Load data ##################################################################
# rm(list=ls())
path_save = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments"
setwd(path_save)
data = readRDS("7.Full History.rds")

setwd("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️R코드/attachments")
old = read.csv("[Final_Selected]_Subjects_list_(Full_History).csv")

old$DIAGNOSIS_OLD %>% table


# 🟥 ❄️dplyr ##################################################################
filter = dplyr::filter
select = dplyr::select







# 🟥 Dic ############################################################################
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
  path_dic = "/Users/Ido/Library/CloudStorage/Dropbox/1.GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅🌟다운받은 파일들/attachments/DATADIC_04Apr2024.csv"
  RS.fMRI_0_Data.Dictionary(colname = col, path_Dic = path_dic, which.OS = "Mac")  
}



# 🟥 Only VISCODE2==sc? ##################################################################
library(dplyr)
# 각 RID별로 VISCODE2가 오직 "sc"만 존재하는지 확인하고 해당 RID 추출
sc_only_rids <- data %>%
  group_by(RID) %>%
  # 모든 VISCODE2가 "sc"인지 확인
  summarise(all_sc = all(VISCODE2 == "sc")) %>%
  # all_sc가 TRUE인 경우만 필터링
  filter(all_sc) %>%
  # 해당 RID만 선택
  pull(RID)

# 결과 출력
print(sc_only_rids)


filter = dplyr::filter
select = dplyr::select



# 🟥 Diagnosis check ##################################################################
## 🟩 ⭐️data =====================================================================
## 🟧 Relocate cols ===============================================
data <- data %>% 
  relocate(ADNIMERGE___DX, QC___LONI_STUDY, QC___LONI_SERIES, REGISTRY___USERDATE, .after = last_col())


## 🟧 VISCODE2가 NA를 포함할 때 DX가 없는가  ===============================================
# 어떤 RID가 같은 VISCODE2에 DIAGNOSIS NA가 포함되어 있는가
# 각 RID 및 VISCODE2 그룹 내에서 DIAGNOSIS_FINAL에 NA가 포함되어 있으나 모두 NA는 아닌 경우의 RID 추출
# 조건을 만족하는 RID, PHASE, VISCODE2 추출
# VISCODE2가 NA인 경우 VISCODE로 대체하는 새 변수 VISCODE_FINAL 생성
data <- data %>%
  mutate(VISCODE_FINAL = ifelse(is.na(VISCODE2), VISCODE, VISCODE2)) %>% 
  relocate(VISCODE_FINAL, .after=VISCODE2)
# RID, PHASE, VISCODE_FINAL 조합으로 그룹화하고 조건에 맞는 조합 추출
satisfying_combinations <- data %>%
  group_by(RID, PHASE, VISCODE_FINAL) %>%
  # DIAGNOSIS_FINAL에 NA가 있으나 모두 NA가 아닌 그룹 필터링
  filter(any(is.na(DIAGNOSIS_FINAL)) & !all(is.na(DIAGNOSIS_FINAL))) %>%
  ungroup() %>%
  # 조건을 만족하는 조합 선택
  select(RID, PHASE, VISCODE_FINAL) %>%
  # 중복 제거
  distinct()

# 결과 확인
print(satisfying_combinations)


data$VISCODE_FINAL = NULL


# 🟥 Both MT1, EPB ##################################################################
## 🟧 check viscode2  =====================================================================
data$VISCODE2 %>% is.na %>% sum
test = data %>% dplyr::filter(VISCODE2 %>% is.na)
test_4520 = data %>% dplyr::filter(RID == 4520)
View(test_4520)




## 🟧 ⭐️filtered_data: subset =====================================================================
library(dplyr)

# EPB와 MT1이 둘 다 존재하는 행만 추출
filtered_data <- data %>%
  # 먼저 QC___SERIES_TYPE이 EPB 또는 MT1인 행만 필터링
  filter(QC___SERIES_TYPE %in% c("EPB", "MT1")) %>%
  # RID와 VISCODE2로 그룹화
  group_by(RID, PHASE, VISCODE2) %>%
  # 각 그룹 내에서 EPB와 MT1이 모두 존재하는지 확인
  filter(sum(QC___SERIES_TYPE == "EPB") >= 1 & sum(QC___SERIES_TYPE == "MT1") >= 1) %>%
  # 각 RID와 VISCODE2 그룹 내에서 모든 조건을 만족하는 경우에만 선택
  distinct() %>%
  ungroup()

# 결과 확인
filtered_data$QC___SERIES_TYPE %>% is.na %>% sum
table(filtered_data$QC___SERIES_TYPE)
test2238 = filtered_data %>% filter(RID==2238)
# View(test2238)
# data %>% filter(RID==2238) %>% View

data %>% filter(IMAGE.ID=="I1162711")
# data %>% filter(RID==6716) %>% View




# 🟥 ⭐️Add band type #############################################################################
band_data <- filtered_data %>%
  mutate(QC___BAND_TYPE = case_when(
    QC___SERIES_TYPE != "EPB" ~ NA_character_, # QC___SERIES_TYPE가 EPB가 아닌 경우 NA 할당
    QC___SERIES_TYPE == "EPB" & str_detect(QC___SERIES_DESCRIPTION, " MB ") ~ "MB", # QC___SERIES_DESCRIPTION에 " MB "가 포함된 경우 "MB" 할당
    QC___SERIES_TYPE == "EPB" & !str_detect(QC___SERIES_DESCRIPTION, " MB ") ~ "SB", # 그렇지 않은 경우 "SB" 할당
    TRUE ~ NA_character_ # 안전을 위한 기본 조건
  ))








# 🟥 Scanner information ##################################################################
## 🟧 Check ==========================================================================
band_data$SEARCH___IMAGING.PROTOCOL %>% head


## 🟧 ⭐️New cols ==========================================================================
# ";"를 기준으로 나눈 후, "="를 기준으로 키와 값을 분리하여 피벗
# View(scan_data)

scan_data <- band_data %>%
  # 각 행을 ";" 기준으로 분할하여 긴 형식으로 변경
  separate_rows(SEARCH___IMAGING.PROTOCOL, sep = ";\\s*") %>%
  # "=" 기준으로 키와 값을 분리
  separate(SEARCH___IMAGING.PROTOCOL, into = c("Key", "Value"), sep = "=") %>%
  # Key 열의 값에 "SEARCH___" 문자열을 추가
  mutate(Key = paste0("SEARCH___", str_trim(Key))) %>%
  # 넓은 형식으로 변환하여 새 열을 생성
  pivot_wider(names_from = Key, values_from = Value)

# 결과 확인
dim(scan_data)
dim(band_data)
names(scan_data)


## 🟧 ⭐️scan_data_2: toupper ================================================================
scan_data_2 = scan_data
names(scan_data_2) = names(scan_data) %>% toupper




## 🟧 Manufacturer ================================================================
scan_data_2$SEARCH___MANUFACTURER %>% table
# MANUFACTURER_NEW 열을 생성하고 "Philips"나 "Siemens" 문자열이 포함된 경우 해당 문자열로 대체
scan_data_2 <- scan_data_2 %>%
  mutate(MANUFACTURER_NEW = case_when(
    str_detect(SEARCH___MANUFACTURER, "Philips") ~ "Philips",
    str_detect(SEARCH___MANUFACTURER, "Siemens") ~ "SIEMENS",
    str_detect(SEARCH___MANUFACTURER, "GE ") ~ "GE.MEDICAL.SYSTEMS",
    TRUE ~ SEARCH___MANUFACTURER  # 위 조건에 해당하지 않는 경우 원래 값을 유지
  ))

# 결과 확인
head(scan_data_2)
scan_data_2$MANUFACTURER_NEW %>% table
scan_data_2 = scan_data_2 %>% 
  dplyr::relocate("QC___SERIES_DESCRIPTION", MANUFACTURER_NEW, .after = "QC___SERIES_TYPE")






### 🟨⭐️MB SB =======================================================
# MB info
# MANUFACTURER_NEW 값을 조건에 따라 대치
scan_data_3 <- scan_data_2 %>%
  mutate(MANUFACTURER_NEW = case_when(
    MANUFACTURER_NEW == "SIEMENS" & QC___BAND_TYPE == "SB" ~ "SIEMENS_SB",
    MANUFACTURER_NEW == "SIEMENS" & QC___BAND_TYPE == "MB" ~ "SIEMENS_MB",
    MANUFACTURER_NEW == "GE.MEDICAL.SYSTEMS" & QC___BAND_TYPE == "SB" ~ "GE.MEDICAL.SYSTEMS_SB",
    MANUFACTURER_NEW == "Philips" & QC___BAND_TYPE == "SB" ~ "Philips_SB",
    TRUE ~ MANUFACTURER_NEW  # 위 조건에 해당하지 않는 경우 기존 값을 유지
  ))






### 🟨 Compare with NFQ =======================================================
epb = scan_data_3 %>% filter(QC___SERIES_TYPE == "EPB")
epb$NFQ___MANUFACTURER %>% table
epb$SEARCH___MANUFACTURER %>% table
library(dplyr)

# 데이터 예시
# epb <- data.frame(NFQ___MANUFACTURER = c("GE_MEDICAL_SYSTEMS", "Philips_Healthcare", "SIEMENS"),
#                   SEARCH___MANUFACTURER = c("GE MEDICAL SYSTEMS", "Philips Healthcare", "Siemens"))

# 1. 데이터 정제: 띄어쓰기와 밑줄을 통일하고, 대문자를 소문자로 변환
epb_new <- epb %>%
  mutate(
    Cleaned_NFQ = toupper(gsub("_", " ", NFQ___MANUFACTURER)),
    Cleaned_SEARCH = toupper(gsub("_", " ", SEARCH___MANUFACTURER))
  )

# 2. 값이 다르고, NA가 아닌 행 찾기
different_rows <- epb_new %>%
  filter(!is.na(Cleaned_NFQ) & !is.na(Cleaned_SEARCH) & Cleaned_NFQ != Cleaned_SEARCH)



# 3. 결과 출력
print(different_rows)

epb_new[,c("Cleaned_NFQ", "Cleaned_SEARCH")] %>% View

rm_na_nfq = epb_new %>% filter(!is.na(Cleaned_NFQ))
sum(rm_na_nfq$Cleaned_NFQ == rm_na_nfq$Cleaned_SEARCH) == length(rm_na_nfq$Cleaned_SEARCH)


# NA in search?
epb_new$Cleaned_SEARCH %>% is.na %>% sum
# -> search manu를 기준으로 하면 됨








# 🟥 Check diagnosis ##################################################################
## 🟧 선택된 데이터의 경우 ===========================================================
# sc와 bl의 diagnosis가 동일?
# 각 RID에 대해 VISCODE2의 값이 'sc'와 'bl'에 해당하는 행들의 DIAGNOSIS_FINAL 값이 동일한지 확인
diagnosis_check <- scan_data_3 %>%
  # 'sc'와 'bl'에 해당하는 행들만 필터링
  filter(VISCODE2 %in% c("sc", "bl")) %>%
  # RID로 그룹화하여 각 그룹 내 DIAGNOSIS_FINAL 값의 동일성 확인
  group_by(RID) %>%
  summarise(same_diagnosis = n_distinct(DIAGNOSIS_FINAL) == 1)

# 결과 확인
head(diagnosis_check)
# -> EPB, MT1 전부 있는 개체에 대해선 sc, bl 전부 있는 개체는 DX가 동일.









# 🟥 ⭐️Remove NA diagnosis ##################################################################
# DIAGNOSIS_FINAL이 전부 NA인 그룹을 제외하고 데이터를 필터링
rm_na_dx_data <- scan_data_3 %>%
  group_by(RID, PHASE, VISCODE2) %>%
  # 각 그룹 내에서 DIAGNOSIS_FINAL이 전부 NA가 아닌 그룹만 필터링
  filter(any(!is.na(DIAGNOSIS_FINAL))) %>%
  ungroup()


# 결과 확인
dim(rm_na_dx_data)
dim(scan_data_2)







# 🟥 Select the first date ##################################################################
## 🟧 Check  =======================================================
rm_na_dx_data$REGISTRY___VISORDER %>% class
rm_na_dx_data$PHASE %>% table


## 🟧 arrange  =======================================================
rm_na_dx_data = rm_na_dx_data %>% arrange(RID, PHASE, REGISTRY___VISORDER)



## 🟧 ⭐️select  REGISTRY___VISORDER minimum =======================================================
# Minimum이 전부 있는지 확인
rm_na_dx_data$REGISTRY___VISORDER %>% is.na %>% sum
# -> NA 없음

# 종류 확인
rm_na_dx_data$REGISTRY___VISORDER %>% table

# 각 RID에 대해 REGISTRY___VISORDER의 최소값에 해당하는 행만 추출
filtered_data <- rm_na_dx_data %>%
  group_by(RID) %>%
  # 각 RID 그룹 내에서 REGISTRY___VISORDER가 최소값인 행을 필터링
  filter(REGISTRY___VISORDER == min(REGISTRY___VISORDER)) %>%
  ungroup()


# 결과 확인
head(filtered_data)
View(filtered_data)
"I1645676" %in% filtered_data$IMAGE.ID
"I1162711" %in% filtered_data$IMAGE.ID
filtered_data %>% filter(RID==6716)
old %>% filter(RID==6716)


## 🟧 check RID =======================================================
# RID?
sum(filtered_data$RID %>% table == 2) == filtered_data$RID %>% unique %>% length

# RID에 따라 EPB, MT1이 각각 1개 씩 있는가
library(dplyr)

# RID 별로 QC___SERIES_TYPE 변수의 값이 EPB, MT1 각각 한 개씩 존재하며,
# 동일한 VISCODE2 값을 가지는지 확인
check_data <- filtered_data %>%
  filter(QC___SERIES_TYPE %in% c("EPB", "MT1")) %>%
  group_by(RID) %>%
  # 각 RID 별로 EPB와 MT1의 개수를 세고, VISCODE2가 동일한지 확인
  summarise(
    epb_count = sum(QC___SERIES_TYPE == "EPB"),
    mt1_count = sum(QC___SERIES_TYPE == "MT1"),
    # 동일한 VISCODE2 값을 가지는지 확인하기 위해 VISCODE2의 고유값 개수를 세어봄
    unique_viscode2_count = n_distinct(VISCODE2)
  ) %>%
  filter(epb_count != 1 | mt1_count != 1 | unique_viscode2_count != 1)

# 결과 확인
print(check_data)





## 🟧 check series quality =======================================================
filtered_data$QC___SERIES_QUALITY %>% table



# diagnosis 확인
filtered_data$DIAGNOSIS_FINAL %>% is.na %>% sum










# 🟥 Add DPABI order for each scanner ##################################################################
## 🟧⭐️ dpabi_data ========================================================================
dpabi_data = filtered_data
dpabi_data$MANUFACTURER_NEW %>% table
 


## 🟧 ⭐️subset EPB, MT1 ========================================================================
dpabi_data$MANUFACTURER_NEW %>% table
dpabi_data$MANUFACTURER_NEW = factor(dpabi_data$MANUFACTURER_NEW, dpabi_data$MANUFACTURER_NEW %>% table %>% names)
epb = dpabi_data %>% filter(QC___SERIES_TYPE == "EPB")
mt1 = dpabi_data %>% filter(QC___SERIES_TYPE == "MT1")


epb %>% filter(RID==6716)
mt1 %>% filter(RID==6716)
# check
sum(epb$RID == mt1$RID) == nrow(epb)





## 🟧 ⭐️Generate "Sub_xxx" ========================================================================
# dpabi_data 또는 여기서는 epb라고 명명된 데이터프레임을 사용
dpabi_data_sorted <- epb %>%
  arrange(MANUFACTURER_NEW, RID) %>%
  # MANUFACTURER_NEW별로 그룹화하고 RID 순서대로 DPABI 열 생성
  group_by(MANUFACTURER_NEW) %>%
  mutate(DPABI = sprintf("Sub_%03d", row_number())) %>%
  ungroup() %>%
  # DPABI 열을 데이터 프레임의 맨 앞으로 옮기기
  relocate(DPABI, .before = RID) %>%
  # PHASE 열을 DIAGNOSIS_FINAL 바로 뒤로 옮기기
  relocate(PHASE, .after = DIAGNOSIS_FINAL)

dpabi_data_sorted %>% filter(RID == 6716)
# check
dpabi_data_sorted %>% filter(MANUFACTURER_NEW == "GE MEDICAL SYSTEMS") %>% View
dpabi_data_sorted %>% filter(MANUFACTURER_NEW == "SIEMENS") %>% View


# check diagnosis
dpabi_data_sorted$DIAGNOSIS_FINAL %>% table


## 🟧 ⭐️Filename ========================================================================
fit_length = function(x.vec, fit.num){
  if(class(x.vec)=="numeric"){
    x.vec = as.character(x.vec)
  }
  
  New_x.vec = sapply(x.vec, function(y){
    if(nchar(y)>fit.num){
      stop("fit.num should larger!")
    }else{
      while(nchar(y) != fit.num){
        y = paste("0", y, collapse = "", sep = "")
      }
      return(y)
    }
  })
  
  return(New_x.vec)
}



# check
mt1 = mt1 %>% arrange(RID)
dpabi_data_sorted = dpabi_data_sorted %>% arrange(RID)
sum(dpabi_data_sorted$RID == mt1$RID) == nrow(mt1)
sum(dpabi_data_sorted$MANUFACTURER_NEW == mt1$MANUFACTURER_NEW) == nrow(mt1)


# MB 추가
mt1$MANUFACTURER_NEW =  dpabi_data_sorted$MANUFACTURER_NEW




# add file name
filename_data = dpabi_data_sorted
filename_data$FILE.NAME = paste(filename_data$MANUFACTURER_NEW, 
                                filename_data$DPABI,
                                paste0("RID", "_", fit_length(filename_data$RID, 4)),
                                paste0("EPB", "_", filename_data$IMAGE.ID),
                                paste0("MT1", "_", mt1$IMAGE.ID), sep="___")
mt1$FILE.NAME = filename_data$FILE.NAME

mt1 = mt1 %>% 
  relocate(FILE.NAME) %>% 
  arrange(FILE.NAME)
filename_data = filename_data %>% 
  relocate(FILE.NAME) %>% 
  arrange(FILE.NAME)
View(mt1)




## 🟧 ⭐️Combine data ========================================================================
Combined_data = list(epb = filename_data, mt1 = mt1)
Combined_data$epb %>% View

epb = Combined_data$epb
mt1 = Combined_data$mt1



## 🟧 ⭐️Check imageID ========================================================================
"I1162711" %in% epb$IMAGE.ID
"I1645676" %in% epb$IMAGE.ID



# 🟥 Compare with old ##################################################################
## 🟧 diagnosis? ====================================================================================
old_2 = old
old_2$DIAGNOSIS_NEW %>% table
old_2$DIAGNOSIS_OLD %>% table
# 조건에 따라 값 변경
old_2$DIAGNOSIS_NEW <- ifelse(grepl("AD", old$DIAGNOSIS_OLD), "Dementia",
                              ifelse(old$DIAGNOSIS_OLD %in% c("EMCI", "LMCI"), "MCI",
                                      old$DIAGNOSIS_OLD))

# 결과 확인
table(old_2$DIAGNOSIS_NEW)
old_2$DIAGNOSIS_NEW %>% is.na %>% sum


### 🟨 EPB =================================================================
epb_old = old_2 %>% select(RID, EPI___IMAGE_ID, DIAGNOSIS_NEW)
epb_new = epb %>% select(RID, IMAGE.ID, DIAGNOSIS_FINAL)

# 먼저 두 데이터 프레임을 RID와 Image ID를 기준으로 조인
merged_data <- inner_join(epb_old, epb_new, by = c("RID", "EPI___IMAGE_ID" = "IMAGE.ID"))

# 조인된 데이터에서 진단이 서로 다른 경우를 필터링
mismatched_diagnosis <- merged_data %>%
  filter(DIAGNOSIS_NEW != DIAGNOSIS_FINAL) %>%
  select(RID, Old_Diagnosis = DIAGNOSIS_NEW, New_Diagnosis = DIAGNOSIS_FINAL)

# 결과 출력
# View(merged_data)
print(mismatched_diagnosis)
# -> 다른 diagnosis 있었음 (1개)
old %>% filter(RID == 6788) %>% pull(VISCODE)
epb %>% filter(RID == 6788) %>% pull(VISCODE)




## 🟧 imageID ====================================================================================
imageID_old = c(old$MT1___IMAGE_ID, old$EPI___IMAGE_ID)
imageID_new = c(epb$IMAGE.ID, mt1$IMAGE.ID)
newly_selected = imageID_new[!imageID_new %in% imageID_old]
"I1645676" %in% imageID_new
"I1645676" %in% newly_selected





# check RID
## 🟧 새로 선택된 RID 동일한가 ==============================================
new_epb = epb %>% filter(IMAGE.ID %in% newly_selected )
new_mt1 = mt1 %>% filter(IMAGE.ID %in% newly_selected )
# View(new_epb)
# View(new_mt1)
new_epb$RID == new_mt1$RID
# -> 다행히도 RID는 동일하다.
table(new_epb$QC___STUDY_COMMENTS) %>% names
new_epb$QC___SERIES_COMMENTS %>% table %>% names





## 🟧 motion RID? ==============================================
# 가정: 'new_epb'라는 이름의 데이터 프레임이 이미 있고, 해당 데이터 프레임에는 'QC___SERIES_COMMENTS'와 'RID' 열이 포함되어 있습니다.
# 'motion' 문자열을 포함하는 행을 필터링하고 'RID' 열의 값을 추출합니다
result <- new_epb %>%
  filter(grepl("motion", QC___SERIES_COMMENTS)) %>%
  pull(RID)

# 결과 출력
cat(result, sep=", ")
new_epb %>% filter(RID %in% result) %>% select(c("RID", "VISCODE", "VISCODE2", "QC___SERIES_COMMENTS", "QC___STUDY_OVERALLPASS", "NFQ___OVERALLQC"))
new_epb %>% filter(RID %in% result) %>% View

new_epb %>% select(c("RID", "IMAGE.ID", "MANUFACTURER_NEW","VISCODE", "VISCODE2", "QC___SERIES_COMMENTS", "QC___STUDY_OVERALLPASS", "NFQ___OVERALLQC")) %>% View
"I1645676" %in%  new_epb$IMAGE.ID



## 🟧 새로 선택된 RID 비교 ==============================================
epb$RID[!epb$RID %in% old$RID]
# ->새로운 RID 존재



## 🟧 이전 RID는 전부 포함되는가? ==============================================
old$RID %in% epb$RID


## 🟧 같은 RID에 대해 imageID가 동일한가 확인 ============================================
intersect_RID = intersect(epb_old$RID, epb$RID) %>% sort
result = sapply(intersect_RID, function(ith_RID){
  old_imageID = epb_old %>% filter(RID == ith_RID) %>% pull(EPI___IMAGE_ID)
  new_imageID = epb %>% filter(RID == ith_RID) %>% pull(IMAGE.ID)
  old_imageID == new_imageID
})
# sum(!result)
# -> 동일하지 않은 이미지 아이디가 존재
epb %>% dplyr::filter(!RID %in% old$RID) %>% pull(RID)





## 🟧 Check data on ADNI site ##################################################################
# 새로 선별된 image ID의 경우 ADNI 사이트에서 확인해 볼 것.



## 🟧 같은 RID, 다른 ImageID ##################################################################
old %>% class
dim(old)





### 🟨 EPB =============================================================================
old$RID
old$EPI___IMAGE_ID

# epb
epb = Combined_data$epb
epb$IMAGE.ID
epb$RID


library(dplyr)

# old와 epb 데이터 프레임을 RID를 기준으로 내부 조인 실행
combined_data <- inner_join(old, epb, by = "RID", suffix = c(".old", ".epb"))


# 조인된 데이터에서 image ID가 다른 행을 필터링
mismatched_images <- combined_data %>%
  filter(EPI___IMAGE_ID != IMAGE.ID)


# 결과 확인 - image ID가 다른 RID만 출력
distinct_rids_with_different_images <- distinct(mismatched_images, RID)

# 결과 출력
print(distinct_rids_with_different_images)


# check : RID == 59
rid = 59
rid = 4229
old_test = old %>% filter(RID==rid) %>% select(RID, EPI___IMAGE_ID, VISCODE, VISCODE2)
new_test = epb %>% filter(RID==rid) %>% select(RID, IMAGE.ID, VISCODE, VISCODE2)
print(old_test)
print(new_test)
epb %>% filter(RID==rid) %>% View
epb$DIAGNOSIS_FINAL %>% is.na %>% sum




### 🟨 MT1 =============================================================================
old$RID
old$MT1___IMAGE_ID

mt1 = Combined_data$mt1

mt1$IMAGE.ID
mt1$RID


### 🟨 MT1 =============================================================================



# 🟥 Export image ID ##################################################################
"I1645676" %in%  new_epb$IMAGE.ID
"I1645676" %in% newly_selected
newly_selected %>% head
length(newly_selected)
cat(newly_selected, sep=", ")

"1162711" %in% newly_selected
"1645676" %in% old$EPB___IMAGE_ID
"1162711" %in% old$EPB___IMAGE_ID
270/2


# 🟥 Check new data ##################################################################
epb_new = Combined_data$epb %>% filter(IMAGE.ID %in% newly_selected)
mt1_new = Combined_data$mt1 %>% filter(IMAGE.ID %in% newly_selected)
View(epb_new)
# RID ==178
epb_new %>% filter(RID==178) %>% select(IMAGE.ID)
mt1_new %>% filter(RID==178) %>% select(IMAGE.ID)
cat(c("I887707", "I844772"), sep = ", ")


# 🟥 7071 ##################################################################
Combined_data$epb %>% filter(RID == 7071) %>% View
Combined_data$mt1 %>% filter(RID == 7071) %>% View
epb_new %>% filter(RID==7071) %>% View

# I1576855, I1576854







# 🟥 Manufacturer ##################################################################
Combined_data$epb$MANUFACTURER_NEW = Combined_data$epb$MANUFACTURER_NEW %>% as.character
Combined_data$mt1$MANUFACTURER_NEW = Combined_data$mt1$MANUFACTURER_NEW %>% as.character


# 🟥 BAND.TYPE ##################################################################
all(Combined_data$epb$RID==Combined_data$mt1$RID)
# Combined_data$epb 데이터 프레임에 BAND.TYPE 열 추가
Combined_data$mt1$BAND.TYPE =  Combined_data$epb$BAND.TYPE <- ifelse(grepl(" MB ", Combined_data$epb$QC___SERIES_DESCRIPTION), "MB", "SB")



# 🟥 New image ID ##################################################################
# 이전 파일들 exFat때문에 삭제되어서 다시 받아야 하는 파일들
total_imageID = c(Combined_data$epb$IMAGE.ID, Combined_data$mt1$IMAGE.ID)
new_id = total_imageID[!total_imageID %in% newly_selected]
cat(new_id, sep = ", ")






# 🟥 Export data ##################################################################
Combined_data[[3]] = newly_selected
names(Combined_data)[3] = "NewlySelectedImageID"

"I1645676" %in% Combined_data$epb$IMAGE.ID

path_save = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments"
setwd(path_save)
saveRDS(Combined_data, "8.Selected_Data(The first visit with fMRI).rds")


Combined_data$epb %>% dim
Combined_data$mt1 %>% dim

Combined_data$epb %>% filter(RID==6716) %>% pull(IMAGE.ID)
Combined_data$mt1 %>% filter(RID==6716) %>% pull(IMAGE.ID)














