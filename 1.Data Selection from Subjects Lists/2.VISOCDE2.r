# 🟥 Load data ##################################################################
# rm(list=ls())
qc = readRDS("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments/1.QC.rds")

registry = read.csv("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️다운받은 파일들/attachments/REGISTRY_04Apr2024.csv")

visits = read.csv("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️다운받은 파일들/attachments/VISITS_05Apr2024.csv")

adnimerge = read.csv("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️다운받은 파일들/attachments/ADNIMERGE_04Apr2024.csv")



# 🟥 Registry & VISIT  ##################################################################
# VISIT 파일에서 VISCODE 추출
## 🟧 Rearrange by RID, dates, PHASE ===============================================================
# EXAMDATE
registry$EXAMDATE = as.Date(registry$EXAMDATE)
registry = registry %>% 
  dplyr::arrange(RID, EXAMDATE)
test_21 = registry %>% dplyr::filter(RID==21)
registry$EXAMDATE %>% is.na




# USERDATE
registry$USERDATE %>% is.na %>% sum
registry$USERDATE = as.Date(registry$USERDATE)
class(registry$USERDATE)
# -> userdate는 logitudinal data랑 관련 없음



# rearange by USERDATE &  RID
registry = registry %>% 
  dplyr::arrange(RID, USERDATE)
View(registry)


# Phase
registry$Phase %>% table
registry$Phase = factor(registry$Phase, levels = c("ADNI1", "ADNIGO", "ADNI2", "ADNI3"))



# Arrange registry
# dic('USERDATE')
registry = registry %>% 
  dplyr::arrange(RID, Phase, USERDATE) %>% 
  dplyr::relocate(EXAMDATE, .after = USERDATE)

test_31 = registry %>% dplyr::filter(RID==31)
View(test_31)




## 🟧 🍀merge: visits (Add VISNAME) ===============================================================
# registry$VISCODE 열의 결측값 확인
missing_VISCODE <- sum(is.na(registry$VISCODE) | registry$VISCODE == "")
cat("결측값이 있는 VISCODE 열의 수:", missing_VISCODE, "\n")


# registry$VISCODE2 열의 결측값 확인
missing_VISCODE2 <- sum(is.na(registry$VISCODE2) | registry$VISCODE2 == "")
cat("결측값이 있는 VISCODE2 열의 수:", missing_VISCODE2, "\n")

# VISCODE2 열에서 결측값이 있는 행의 VISCODE 값을 확인
missing_VISCODE2_indices <- which(is.na(registry$VISCODE2) | registry$VISCODE2 == "")
missing_VISCODE_values <- registry$VISCODE[missing_VISCODE2_indices]
cat("VISCODE2 열의 결측값에 해당하는 VISCODE 값:", missing_VISCODE_values, "\n")


# VISCODE를 기준으로 VISCODE2 채우기
registry_with_visname <- registry %>% 
  merge(visits, by = c("Phase", "VISCODE"), all.x = TRUE) %>% 
  dplyr::relocate("VISNAME", .before = "VISCODE") %>% 
  dplyr::relocate("VISCODE2", .after = "VISCODE") %>% 
  dplyr::relocate("EXAMDATE", .before = "VISNAME") %>% 
  dplyr::relocate("RID", .after = "Phase") %>% 
  dplyr::arrange(RID, USERDATE) %>% 
  dplyr::relocate(EXAMDATE, .after = USERDATE)



## 🟧 Check cols after merging ===============================================================
# VISNAME NA?
class(registry_with_visname$VISNAME)
registry_with_visname$VISNAME %>% is.na %>% sum
"-4" %in% registry_with_visname$VISNAME
"" %in% registry_with_visname$VISNAME


# VISCODE NA?
registry_with_visname$VISCODE %>% is.na %>% sum
"-4" %in% registry_with_visname$VISCODE
registry_with_visname$VISCODE = ifelse(registry_with_visname$VISCODE == "-4", NA, registry_with_visname$VISCODE)
"" %in% registry_with_visname$VISCODE 
registry_with_visname$VISCODE %>% is.na %>% sum

na_row = registry_with_visname %>% 
  dplyr::filter(is.na(VISCODE))




## 🟧 colnames to upper ===============================================================
names(registry_with_visname) = names(registry_with_visname) %>% toupper
names(registry_with_visname)



## 🟧 Phase별로 VISCODE 유일? ===============================================================
# 데이터 프레임을 RID와 PHASE별로 그룹화하고, 각 그룹 내에서 VISCODE의 고유성 확인
viscode_uniqueness <- registry_with_visname %>%
  dplyr::group_by(RID, PHASE) %>%
  dplyr::summarise(
    is_unique = all(n_distinct(VISCODE) == length(VISCODE)),
    .groups = "drop"
  )
# 고유하지 않은 경우(중복이 있는 경우) 필터링하여 출력
non_unique_viscode_cases <- viscode_uniqueness %>%
  dplyr::filter(!is_unique)
# 결과 출력
print(non_unique_viscode_cases)
# -> 유일



## 🟧 Add "REGISTRY___" to colnames  ===============================================================
# "PHASE", "RID"를 제외한 모든 열 이름 앞에 "REGISTRY___" 추가
registry_with_visname_2 <- registry_with_visname %>%
  rename_with(~ifelse(.x %in% c("PHASE", "RID"), .x, paste0("REGISTRY___", .x)), .cols = -c(PHASE, RID))

# 결과 확인을 위한 열 이름 출력
names(registry_with_visname_2)


## 🟧 VISORDER ===============================================================
registry_with_visname_2 = registry_with_visname_2 %>% 
  dplyr::relocate(REGISTRY___VISORDER, .after=REGISTRY___VISCODE2) 
View(registry_with_visname_2 )

# remove where VISORDER is NA
registry_with_visname_2 = registry_with_visname_2 %>% 
  dplyr::filter(!is.na(REGISTRY___VISORDER))
registry_with_visname_2$REGISTRY___VISORDER %>% is.na %>% sum
"" %in% registry_with_visname_2$REGISTRY___VISORDER
registry_with_visname_2$REGISTRY___VISORDER %>% class




# 🟥adnimerge ##################################################################
## 🟧 test =====================================================================
test_31 = adnimerge %>% dplyr::filter(RID==31)
View(test_31)

## 🟧 Change Class =====================================================================
adnimerge$RID %>% class
adnimerge$EXAMDATE %>% class
adnimerge$EXAMDATE = adnimerge$EXAMDATE %>% as.Date
adnimerge = adnimerge %>% dplyr::arrange(RID, EXAMDATE)




## 🟧 Phase factor =====================================================================
adnimerge %>% names
adnimerge_2 = adnimerge %>% 
  dplyr::rename(PHASE:=COLPROT)
adnimerge_2$PHASE = factor(adnimerge_2$PHASE, levels = c("ADNI1", "ADNIGO", "ADNI2", "ADNI3", "ADNI4"))




## 🟧 Phase마다 VISCODE 유일성 확인=====================================================================
# adnimerge_2 데이터 프레임을 RID와 PHASE별로 그룹화하고, 각 그룹 내에서 VISCODE의 고유성 확인
viscode_uniqueness <- adnimerge_2 %>%
  group_by(RID, PHASE) %>%
  summarise(
    is_unique = all(n_distinct(VISCODE) == length(VISCODE)),
    .groups = "drop"
  )
# 고유하지 않은 경우(중복이 있는 경우) 필터링하여 출력
non_unique_viscode_cases <- viscode_uniqueness %>%
  dplyr::filter(!is_unique)
# 결과 출력
print(non_unique_viscode_cases)
# -> 각 Phase마다 유일함



## 🟧 rename VISCODE to VISCODE2 ========================================================================
adnimerge_2$VISCODE %>% table %>% names %>% sort
# rename to VISCODE2
adnimerge_3 = adnimerge_2 %>% dplyr::rename(VISCODE2 := VISCODE)



## 🟧 check Exam date NA ========================================================================
# check NA
adnimerge_3$EXAMDATE %>% is.na %>% sum
"" %in% adnimerge_3$EXAMDATE %>% sum

# class
adnimerge_3$EXAMDATE %>% class


## 🟧 adnimerge: Check NA Phase =========================================================
"" %in% adnimerge_3$PHASE %>% sum
adnimerge_3$PHASE %>% is.na %>% sum
# -> Phase에서 NA인 것은 없다.




## 🟧 adnimerge: Check bl (only one for each RID?)  =========================================================
# adnimerge_3 데이터프레임에서 VISCODE2가 "bl"인 행만 필터링
bl_rows <- adnimerge_3 %>% 
  dplyr::filter(VISCODE2 == "bl")

# 각 RID별로 "bl" 값의 수를 계산
bl_counts <- bl_rows %>% 
  dplyr::group_by(RID) %>% 
  dplyr::summarise(bl_count = n())

# "bl" 값이 1이 아닌 경우를 필터링하여 유일하지 않은 RID를 찾음
non_unique_bl_rids <- bl_counts %>% 
  dplyr::filter(bl_count != 1) %>%
  dplyr::pull(RID)

# 결과 출력
non_unique_bl_rids %>% length
# -> adnimerge에서의 bl은 유일하다.



## 🟧 arrange  =========================================================
adnimerge_3 = adnimerge_3 %>% dplyr::arrange(RID, PHASE, EXAMDATE)



## 🟧 add "ADNIMERGE___" to colnames  =========================================================
adnimerge_4 = adnimerge_3 %>% dplyr::rename_with(~paste0("ADNIMERGE___", .), -c(RID, ORIGPROT, PHASE, VISCODE2))
View(adnimerge_4)


## 🟧🍀 Merge with Registry  =========================================================
# 이미 이전에 VISCODE2가 유일함
test_31_registry = registry_with_visname_2 %>% dplyr::filter(RID==31)
test_31_adnimerge = adnimerge_4 %>% dplyr::filter(RID==31)
# adnimerge_4와 registry_with_visname 데이터프레임을 full_join 실행
registry_with_visname_3 = registry_with_visname_2 %>% dplyr::rename(VISCODE2 := REGISTRY___VISCODE2)
full_joined_data <- adnimerge_4 %>%
  dplyr::full_join(registry_with_visname_3, by = c("RID", "PHASE", "VISCODE2"))



## 🟧 Generate new DATE col to sort =========================================================
# USERDATE + EXAMDATE
full_joined_data_2 <- full_joined_data %>%
  mutate(NEW_USERDATE = coalesce(REGISTRY___USERDATE, ADNIMERGE___EXAMDATE, REGISTRY___EXAMDATE)) %>% 
  dplyr::relocate(NEW_USERDATE, .after = VISCODE2)



## 🟧 relocate cols =========================================================
full_joined_data_3 <- full_joined_data_2 %>%
  dplyr::relocate(REGISTRY___VISCODE, .before = VISCODE2) %>% 
  dplyr::relocate(REGISTRY___VISNAME, .before = REGISTRY___VISCODE) %>% 
  dplyr::relocate(REGISTRY___USERDATE, .after = VISCODE2) %>% 
  dplyr::relocate(REGISTRY___USERDATE2, .after = REGISTRY___USERDATE)

# full_joined_data에서 DATE로 끝나는 열 추출
date_columns <- grep("DATE$", names(full_joined_data_3), value = TRUE)

# VISCODE2 열 다음에 DATE로 끝나는 열 추가
full_joined_data_3 <- full_joined_data_3 %>%
  dplyr::relocate(!!date_columns, .after=VISCODE2) %>% 
  dplyr::relocate(NEW_USERDATE, .after = VISCODE2)




## 🟧 VISCODE2 NA? =========================================================
full_joined_data_3$VISCODE2 %>% is.na %>% sum
# -> 없음


## 🟧 sort : VISORER =========================================================
full_joined_data_3 = full_joined_data_3 %>% 
  dplyr::relocate(REGISTRY___VISORDER, .after = VISCODE2)
full_joined_data_3$REGISTRY___VISORDER %>% is.na %>% sum

# sort
full_joined_data_3$PHASE %>% class
full_joined_data_3 = full_joined_data_3 %>% 
  dplyr::arrange(RID, PHASE, REGISTRY___VISORDER, NEW_USERDATE)


# VISORER 없는 곳?
test = full_joined_data_3 %>% 
  dplyr::filter(is.na(REGISTRY___VISORDER))
View(test)

test_4813 = full_joined_data_3 %>% 
  dplyr::filter(RID==4813)
View(test_4813)

test_6014 = full_joined_data_3 %>% 
  dplyr::filter(RID==6014)
View(test_6014)


# VISORDER 없는 곳 제외
full_joined_data_3$REGISTRY___VISORDER %>% is.na %>% sum
full_joined_data_4 = full_joined_data_3 %>% 
  dplyr::filter(!is.na(REGISTRY___VISORDER))




# 🟥 Export data ###################################################################
path_save = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments"
saveRDS(full_joined_data_4, paste0(path_save, "/2.VISCODE2.rds"))











