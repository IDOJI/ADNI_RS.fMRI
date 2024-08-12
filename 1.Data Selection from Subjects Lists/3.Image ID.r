# 🟥 Load data ##################################################################
# rm(list=ls())
qc = readRDS("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments/1.QC.rds")
viscode = readRDS("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments/2.VISCODE2.rds")

# search_mri = read.csv("/Users/Ido/Library/CloudStorage/Dropbox/@DataAnalysis/㊙️CommonData___ADNI___SubjectsList/idaSearch_4_07_2024_MRI.csv")
# search_fmri = read.csv("/Users/Ido/Library/CloudStorage/Dropbox/@DataAnalysis/㊙️CommonData___ADNI___SubjectsList/idaSearch_4_07_2024_fMRI.csv")
search = read.csv("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️다운받은 파일들/attachments/idaSearch_4_09_2024.csv")




# 🟥 search data ##################################################################
## 🟧 remove cols =============================================================================
search$Project = NULL




## 🟧 Check dates ##################################################################
# Search
search$Study.Date %>% head
search$Archive.Date

# 날짜를 yyyy-mm-dd 형식으로 변환
search$Study.Date <- as.Date(search$Study.Date, format = "%m/%d/%Y")
search$Archive.Date <- as.Date(search$Archive.Date, format = "%m/%d/%Y")




## 🟧 colnames to upper =============================================================================
names(search) = names(search) %>% toupper




## 🟧 RID =============================================================================
# SUBJECT.ID 열에서 마지막 4자리 추출 및 integer 변환하여 RID 열 생성, 데이터프레임 맨 앞으로 옮김
search <- search %>%
  dplyr::mutate(RID = as.integer(str_sub(SUBJECT.ID, -4))) %>%
  dplyr::relocate(RID, .before = 1) # RID 열을 데이터프레임의 맨 앞으로 이동






## 🟧 ImageID "I" =============================================================================
# Add I
search$IMAGE.ID = paste0("I", search$IMAGE.ID)




## 🟧 ImageID intersection: QC =============================================================================
search = search %>% 
  dplyr::filter(IMAGE.ID %in% qc$LONI_IMAGE)



## 🟧 Change Modality ##################################################################
qc$MODALITY = NA

# qc 데이터프레임의 SERIES_TYPE이 MT1인 경우 MODALITY를 MRI로 변경
qc$MODALITY[qc$SERIES_TYPE == "MT1"] <- "MRI"
# qc 데이터프레임의 SERIES_TYPE이 EPB인 경우 MODALITY를 fMRI로 변경
qc$MODALITY[qc$SERIES_TYPE == "EPB"] <- "fMRI"

# relocate
qc = qc %>% relocate(MODALITY, .after=SERIES_TYPE)

# 이미지 ID와 RID가 일치하는 행을 찾아 search 데이터프레임의 MODALITY를 업데이트
for (i in 1:nrow(qc)) {
  
  ith_image_condition = search$IMAGE.ID == qc$LONI_IMAGE[i]
  ith_rid_condition = search$RID == qc$RID[i]
  
  ith_condition = ith_image_condition & ith_rid_condition
  
  search$MODALITY[ith_condition] <- qc$MODALITY[i]
}

test = search %>% dplyr::filter(MODALITY == "MRI")
test$DESCRIPTION %>% table

test = search %>% dplyr::filter(MODALITY == "fMRI")
test$DESCRIPTION %>% table




## 🟧 VISCODE ##################################################################
search_new = search

### 🟨 ADNI GO ==============================================================
# ADNIGO
# Phase	ID	VISCODE	VISNAME	VISORDER
# ADNIGO	1	sc	Screening	1
# ADNIGO	3	bl	Baseline	3
# ADNIGO	16	nv	No Visit Defined
# Search %>% dplyr::filter(PHASE == "ADNI GO") %>% dplyr::select(VISIT) %>% unlist %>% table
Search_GO = search_new %>%
  dplyr::filter(PHASE == "ADNI GO")

if(nrow(Search_GO)>0){
  Search_GO = search_new %>%
    dplyr::filter(PHASE == "ADNI GO") %>%
    dplyr::mutate(VISCODE = case_when(
      VISIT == "ADNIGO Screening MRI" ~ "scmri",
      VISIT == "ADNIGO Month 3 MRI" ~ "m03",
      VISIT == "ADNI1/GO Month 6" ~ "m06",
      VISIT == "ADNI1/GO Month 12" ~ "m12",
      VISIT == "ADNI1/GO Month 18" ~ "m18",
      VISIT == "ADNI1/GO Month 36" ~ "m36",
      VISIT == "ADNI1/GO Month 42" ~ "m42",
      VISIT == "ADNI1/GO Month 48" ~ "m48",
      VISIT == "ADNI1/GO Month 54" ~ "m54",
      VISIT == "ADNIGO Month 60" ~ "m60",
      VISIT == "ADNIGO Month 66" ~ "m66",
      VISIT == "ADNIGO Month 72" ~ "m72",
      VISIT == "ADNIGO Month 78" ~ "m78",
      TRUE ~ NA # Default case to return NA when none of the above conditions are met
    ))
  
  
  
  allowed_visits <- c(
    "ADNIGO Screening MRI",
    "ADNIGO Month 3 MRI",
    "ADNI1/GO Month 6",
    "ADNI1/GO Month 12",
    "ADNI1/GO Month 18",
    "ADNI1/GO Month 36",
    "ADNI1/GO Month 42",
    "ADNI1/GO Month 48",
    "ADNI1/GO Month 54",
    "ADNIGO Month 60",
    "ADNIGO Month 66",
    "ADNIGO Month 72",
    "ADNIGO Month 78"
  )
  # Check for any VISIT types not in the allowed list and stop if found
  Search_GO %>%
    dplyr::filter(PHASE == "ADNI GO") %>%
    {. ->> filtered_search} # Store the filtered dataframe for later use
  if(any(!(filtered_search$VISIT %in% allowed_visits))) {
    stop("Found VISIT types not in the allowed for ADNI GO.")
  }
}





### 🟨 ADNI 2 ==============================================================
# ADNI2
# Phase	ID	VISCODE	VISNAME	VISORDER
# ADNI2	1	v01	Screening - New Pt	1
# ADNI2	2	v02	Screening MRI - New Pt	2
# ADNI2	3	v03	Baseline - New Pt	3
# ADNI2	4	v04	Month 3 MRI - New Pt	4
# ADNI2	7	v07	ADNI2 Initial TelCheck - Continuing Pt	7
# ADNI2	9	v12	ADNI2 Year 1 TelCheck	9
# ADNI2	11	v22	ADNI2 Year 2 TelCheck	11
# ADNI2	13	v32	ADNI2 Year 3 TelCheck	13
# ADNI2	15	v42	ADNI2 Year 4 TelCheck	15
# ADNI2	17	v52	ADNI2 Year 5 TelCheck	17
# ADNI2	18	nv	No Visit Defined
# Filter for ADNI2 phase and create VISCODE based on VISIT
# Search %>% dplyr::filter(PHASE == "ADNI 2") %>% dplyr::select(VISIT) %>% unlist %>% table
Search_2 = search_new %>%
  dplyr::filter(PHASE == "ADNI 2")


if(nrow(Search_2)>0){
  Search_2 = search_new %>%
    dplyr::filter(PHASE == "ADNI 2") %>%
    dplyr::mutate(VISCODE = case_when(
      VISIT == "ADNI2 Screening MRI-New Pt" ~ "v02",
      VISIT == "ADNI2 Month 3 MRI-New Pt" ~ "v04",
      VISIT == "ADNI2 Month 6-New Pt" ~ "v05",
      VISIT == "ADNI2 Initial Visit-Cont Pt" ~ "v06",
      VISIT == "ADNI2 Year 1 Visit" ~ "v11",
      VISIT == "ADNI2 Year 2 Visit" ~ "v21",
      VISIT == "ADNI2 Year 3 Visit" ~ "v31",
      VISIT == "ADNI2 Year 4 Visit" ~ "v41",
      VISIT == "ADNI2 Year 5 Visit" ~ "v51",
      VISIT == "ADNI2 Tau-only visit" ~ "tau",
      TRUE ~ NA # Default case to return "nv" when none of the above conditions are met
    ))
  # Define the allowed visits for ADNI2 phase based on the actual VISIT values in your dataframe
  allowed_visits_adni2 <- c(
    "ADNI2 Screening MRI-New Pt",
    "ADNI2 Month 3 MRI-New Pt",
    "ADNI2 Month 6-New Pt",
    "ADNI2 Initial Visit-Cont Pt",
    "ADNI2 Year 1 Visit",
    "ADNI2 Year 2 Visit",
    "ADNI2 Year 3 Visit",
    "ADNI2 Year 4 Visit",
    "ADNI2 Year 5 Visit",
    "ADNI2 Tau-only visit"
  )
  # Check for any VISIT types not in the allowed list and stop if found
  Search_2 %>%
    dplyr::filter(PHASE == "ADNI 2") %>%
    {. ->> filtered_search} # Store the filtered dataframe for later use
  # Check for any VISIT types not in the allowed list and stop if found
  if(any(!(filtered_search$VISIT %in% allowed_visits_adni2))) {
    stop("Found VISIT types not in the allowed list for ADNI2.")
  } 
}






### 🟨 ADNI 3 ==============================================================
# ADNI3
# Phase	ID	VISCODE	VISNAME	VISORDER
# ADNI3	1	reg	Participant Registration	1
# ADNI3	2	sc	Screening - New Pt	2
# ADNI3	3	bl	Baseline - New Pt	3
# ADNI3	4	init	ADNI3 Initial Visit - Continuing Pt	4
# ADNI3	5	y1	ADNI3 Year 1 Visit	5
# ADNI3	6	y2	ADNI3 Year 2 Visit	6
# ADNI3	7	y3	ADNI3 Year 3 Visit	7
# ADNI3	8	y4	ADNI3 Year 4 Visit	8
# ADNI3	9	y5	ADNI3 Year 5 Visit	9
# ADNI3	10	y6	ADNI3 Year 6 Visit	10
# Filter for ADNI3 phase and create VISCODE based on VISIT
# Search %>% dplyr::filter(PHASE == "ADNI 3") %>% dplyr::select(VISIT) %>% unlist %>% table
Search_3 <- search_new %>%
  dplyr::filter(PHASE == "ADNI 3") %>%
  dplyr::mutate(VISCODE = case_when(
    VISIT == "ADNI Screening" ~ "sc",
    VISIT == "ADNI3 Initial Visit-Cont Pt" ~ "init",
    VISIT == "ADNI3 Year 1 Visit" ~ "y1",
    VISIT == "ADNI3 Year 2 Visit" ~ "y2",
    VISIT == "ADNI3 Year 3 Visit" ~ "y3",
    VISIT == "ADNI3 Year 4 Visit" ~ "y4",
    VISIT == "ADNI3 Year 5 Visit" ~ "y5",
    TRUE ~ NA # Default case to return NA when none of the above conditions are met
  ))
# Define the allowed visits for ADNI3 phase based on the actual VISIT values in your dataframe
allowed_visits_adni3 <- c(
  "ADNI Screening",
  "ADNI3 Initial Visit-Cont Pt",
  "ADNI3 Year 1 Visit",
  "ADNI3 Year 2 Visit",
  "ADNI3 Year 3 Visit",
  "ADNI3 Year 4 Visit",
  "ADNI3 Year 5 Visit"
)

# Check for any VISIT types not in the allowed list and stop if found
filtered_search_adni3 <- Search_3 %>%
  dplyr::filter(PHASE == "ADNI 3")

if(any(!(filtered_search_adni3$VISIT %in% allowed_visits_adni3))) {
  stop("Found VISIT types not in the allowed list for ADNI3.")
}


### 🟨 Combine data ==============================================================
search_viscode = rbind(Search_GO, Search_2, Search_3) %>% 
  dplyr::relocate(VISCODE, .after = RID) %>% 
  dplyr::relocate(VISIT, .before = VISCODE) %>% 
  dplyr::relocate(STUDY.DATE, .after = VISCODE) %>% 
  dplyr::arrange(RID, STUDY.DATE) %>% 
  dplyr::relocate(IMAGE.ID) %>% 
  dplyr::relocate(VISCODE, .after = RID)



## 🟧 add "SEARCH___" to colnames ==============================================================
# RID와 VISCODE 열을 제외하고 나머지 열 이름 앞에 "SEARCH___" 추가
search_viscode_2 <- search_viscode %>%
  rename_with(~ifelse(.x %in% c("RID", "VISCODE"), .x, paste0("SEARCH___", .x)),
              .cols = -c(RID, VISCODE))
names(search_viscode_2)



## 🟧 PHASE ==============================================================
library(dplyr)
library(stringr)
# SEARCH___PHASE 열의 중간 공백 제거
search_viscode_2 <- search_viscode_2 %>%
  mutate(SEARCH___PHASE = str_replace_all(SEARCH___PHASE, " ", ""))

# 결과 확인
head(search_viscode_2$SEARCH___PHASE)
table(search_viscode_2$SEARCH___PHASE)








# 🟥 Merge: QC ###################################################################
## 🟧 "QC___" colnames =========================================================
# RID 열을 제외하고 모든 열 이름 앞에 "QC___" 추가
qc_2 <- qc %>%
  rename_with(~ifelse(.x == "RID", .x, paste0("QC___", .x)), .cols = -RID) %>% 
  dplyr::select(-QC___MODALITY)


## 🟧 Check dim =========================================================
dim(qc_2)
dim(search_viscode_2)


## 🟧 ImageID =========================================================
qc_3 = qc_2 %>% 
  dplyr::filter(QC___LONI_IMAGE %in% search_viscode_2$SEARCH___IMAGE.ID)
qc_3$QC___LONI_IMAGE %>% length

search_viscode_2 = search_viscode_2 %>% dplyr::filter(SEARCH___IMAGE.ID %in% qc_3$QC___LONI_IMAGE)
# dim 확인
dim(qc_3)
dim(search_viscode_2)

# na 확인
is.na(qc_3$QC___LONI_IMAGE) %>% sum
is.na(search_viscode_2) %>% sum

## 🟧 ImageID 중복확인 =========================================================
# 중복?
sum(search_viscode_2$SEARCH___IMAGE.ID %>% table ==1)
sum(qc_3$QC___LONI_IMAGE %>% table == 1)


# QC___LONI_IMAGE 열에서 중복된 값 찾기
duplicated_images <- qc_3 %>%
  dplyr::filter(duplicated(QC___LONI_IMAGE) | duplicated(QC___LONI_IMAGE, fromLast = TRUE)) %>%
  dplyr::arrange(QC___LONI_IMAGE) # 중복된 값을 갖는 행을 QC___LONI_IMAGE 기준으로 정렬


# 결과 출력
head(duplicated_images)
View(duplicated_images)


# 중복값 제외 : ImageID도 동일하고 다른 모든 값들도 동일한 경우
# 완전히 동일한 행을 제외하고 고유한 행만 남김
qc_3_unique <- qc_3 %>%
  distinct()

# dim 확인
qc_3_unique %>% dim
dim(search_viscode_2)





## 🟧🍀 Merge: search =========================================================
qc_3_unique_2 = qc_3_unique %>% 
  dplyr::rename(IMAGE.ID := QC___LONI_IMAGE)
search_viscode_3 = search_viscode_2 %>% 
  dplyr::rename(IMAGE.ID := SEARCH___IMAGE.ID)

merged_data = full_join(qc_3_unique_2, search_viscode_3, c("IMAGE.ID", "RID"))
View(merged_data)


## 🟧 relocate cols =========================================================
merged_data = merged_data %>% 
  dplyr::relocate(VISCODE, SEARCH___VISIT, SEARCH___STUDY.DATE, .before = QC___SERIES_DATE)





# 🟥 Export data ###################################################################
path_save = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments"
saveRDS(merged_data, paste0(path_save, "/3.ImageID.rds"))









