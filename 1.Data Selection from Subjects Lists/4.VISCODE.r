# 🟥 Load data ##################################################################
# rm(list=ls())
viscode2 = readRDS("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments/2.VISCODE2.rds")
image = readRDS("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments/3.ImageID.rds")


# 🟥 dplyr ##################################################################
filter = dplyr::filter
select = dplyr::select



# 🟥 Check VISCODE ##################################################################
# NA?
viscode2$REGISTRY___VISCODE %>% is.na %>% sum
image$VISCODE %>% is.na %>% sum



# 🟥 Check dim ##################################################################
dim(viscode2) # 전체 방문 데이터
dim(image) # 일부 방문 데이터



# 🟥 Check names ##################################################################
names(viscode2)
names(image)


# 🟥 Rename ##################################################################
image_2 = image %>% 
  dplyr::rename(PHASE := SEARCH___PHASE) %>% 
  dplyr::relocate(PHASE)
names(image_2)
viscode3 = viscode2 %>% 
  dplyr::rename(VISCODE := REGISTRY___VISCODE)


# 🟥 Merge ##################################################################
merged_data = full_join(image_2, viscode3, c("RID", "PHASE", "VISCODE")) %>% 
  dplyr::arrange(RID, PHASE, REGISTRY___VISORDER)


# 🟥 Check image ID length ##################################################################
test = merged_data %>% 
  dplyr::filter(!is.na(IMAGE.ID))
dim(test)



# 🟥 relocate ##################################################################
test = merged_data %>% 
  dplyr::filter(RID==21)

merged_data = merged_data %>% 
  dplyr::relocate(VISCODE2, .after=VISCODE) %>% 
  dplyr::relocate(REGISTRY___VISNAME, .after=VISCODE2) %>% 
  dplyr::relocate(REGISTRY___VISORDER, .before=VISCODE)





# 🟥 arrange ##################################################################
# check VISORDER
merged_data$REGISTRY___VISORDER %>% is.na %>% sum
test = merged_data %>% dplyr::filter(is.na(REGISTRY___VISORDER))
View(test)

# Phase
merged_data$PHASE = factor(merged_data$PHASE, c("ADNI1", "ADNIGO", "ADNI2", "ADNI3"))

merged_data$RID %>% class

# arrange
merged_data = merged_data %>% arrange(RID, PHASE, REGISTRY___VISORDER)
View(merged_data)

test = merged_data %>% dplyr::filter(RID==21)
View(test)

merged_data = merged_data %>% 
  dplyr::relocate(QC___SERIES_TYPE, .after = "IMAGE.ID")


# 🟥 Remove RID without ImageID ##################################################################
# 각 RID별로 ImageID 열에 NA가 아닌 값이 있는지 확인하고, NA가 아닌 값이 하나라도 있는 RID만 필터링
filtered_RID <- merged_data %>%
  dplyr::group_by(RID) %>%
  dplyr::summarise(has_non_na_imageid = any(!is.na(IMAGE.ID))) %>%
  dplyr::filter(has_non_na_imageid) %>%
  dplyr::ungroup() %>%
  dplyr::select(RID) %>%
  dplyr::semi_join(merged_data, by = "RID") %>% 
  dplyr::pull(RID)

filtered_data = merged_data %>% 
  dplyr::filter(RID %in% filtered_RID) %>% 
  dplyr::arrange(RID, PHASE, REGISTRY___VISORDER)
View(filtered_data)







# 🟥 VISORDER ##################################################################
## 🟧 factorize =================================================================
filtered_data$REGISTRY___VISORDER %>% is.na %>% sum
# 각 PHASE별 VISCODE의 순서를 정의하는 리스트
viscode_order_mapping <- list(
  ADNI1 = c("sc", "bl", "m06", "m12", "m18", "m24", "m30", "m36", "m42", "m48", "m54"),
  ADNIGO = c("sc", "scmri", "bl", "m03", "m06", "m12", "m18", "m36", "m42", "m48", "m54", "m60", "m66", "m72", "m78"),
  ADNI2 = c("v01", "v02", "v03", "v04", "v05", "v06", "v07", "v11", "v12", "v21", "v22", "v31", "v32", "v41", "v42", "v51", "v52"),
  ADNI3 = c("reg", "sc", "bl", "init", "y1", "y2", "y3", "y4", "y5", "y6")
)

# 함수를 정의하여 각 VISCODE에 대한 순서를 할당하는 로직
assign_visorder <- function(viscode, phase) {
  # PHASE에 해당하는 순서 가져오기
  phase_order <- viscode_order_mapping[[phase]]
  
  # VISCODE가 기본 순서에 있는 경우, 해당 순서 반환
  if(viscode %in% phase_order) {
    return(match(viscode, phase_order))
  } else {
    # 정의되지 않은 VISCODE의 경우, 숫자 추출
    num_extract <- as.numeric(str_extract(viscode, "\\d+"))
    if(!is.na(num_extract)) {
      # 추출된 숫자와 가장 가까운 기존 순서의 위치 찾기
      closest_predefined_viscode <- sapply(phase_order, function(x) as.numeric(str_extract(x, "\\d+")))
      closest_predefined_viscode <- closest_predefined_viscode[!is.na(closest_predefined_viscode)]
      if(length(closest_predefined_viscode) > 0) {
        return(max(which(closest_predefined_viscode < num_extract)) + 1)
      }
    }
  }
  
  # 그 외의 경우는 NA 반환
  return(NA)
}

# filtered_data에 적용하여 새로운 열 생성
visorder_data <- filtered_data %>%
  rowwise() %>%
  mutate(REGISTRY___VISORDER = assign_visorder(VISCODE, as.character(PHASE)))

# 결과 확인
test_21 = visorder_data %>% dplyr::filter(RID==21)
View(test_21)

vis_na = filtered_data %>% dplyr::filter(is.na(VISCODE2))
test_4520 = visorder_data %>% dplyr::filter(RID == 4520)
View(test_4520)



# compare 
com_1 = filtered_data %>% dplyr::filter(!is.na(VISCODE2))
com_2 = visorder_data %>% dplyr::filter(!c(RID==4520 & VISCODE == "y4"))
identical(com_2$REGISTRY___VISORDER, com_1$REGISTRY___VISORDER)
# -> 제대로 만들어진 코드

















# 🟥 VISCODE2 ##################################################################
# 함수를 정의하여 ADNI3 Phase에서 VISCODE2 결측값을 채워 넣습니다.
visorder_data = visorder_data

# 결과 확인
test_4520 = visorder_data %>% dplyr::filter(RID == 4520)
View(test_4520)




# 🟥 Exclude data with only sc ##################################################################
#  relocate
visorder_data = visorder_data %>% relocate(NEW_USERDATE, .after = VISCODE2)


# check
test_6902 = visorder_data %>% dplyr::filter(RID == 6902)
View(test_6902)

# Exclude data
library(dplyr)
library(lubridate)

# 오늘 날짜를 설정
today <- Sys.Date()

# 각 RID 별로 필터링 조건을 확인
rids_to_exclude <- visorder_data %>%
  group_by(RID) %>%
  # VISCODE2가 "sc"만 포함하는지 확인
  filter(all(VISCODE2 == "sc")) %>%
  # NEW_USERDATE가 오늘로부터 100일 이상인지 확인
  filter(all(as.Date(NEW_USERDATE) <= today - 365)) %>%
  # 이 조건들을 만족하는 RID만 추출
  summarise() %>%
  pull(RID)

# check diagnosis
visorder_data %>% filter(RID %in% rids_to_exclude) %>% View


# 위에서 확인한 RID를 제외한 나머지 데이터를 가져오기
visorder_data_filtered <- visorder_data %>%
  filter(!(RID %in% rids_to_exclude))

# 결과 확인
visorder_data_filtered$RID %>% unique %>% length


# check
ch_7062 = visorder_data_filtered %>% filter(RID==7062)
View(ch_7062)
visorder_data_filtered %>% filter(RID==21) %>% View







# 🟥 VISCODE == "" ? ##################################################################
# NA
visorder_data_filtered$VISCODE %>% is.na %>% sum
visorder_data_filtered$VISCODE2 %>% is.na %>% sum

# ""
"" %in% visorder_data_filtered$VISCODE
"" %in% visorder_data_filtered$VISCODE2
visorder_data_filtered = visorder_data_filtered %>% 
  mutate(VISCODE2 = ifelse(VISCODE2=="", NA, VISCODE2))

"" %in% visorder_data_filtered$VISCODE2
visorder_data_filtered$VISCODE2 %>% is.na %>% sum



# 🟥 save data ##################################################################
path = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments"
saveRDS(visorder_data_filtered, paste0(path, "/4.VISCODE.rds"))










