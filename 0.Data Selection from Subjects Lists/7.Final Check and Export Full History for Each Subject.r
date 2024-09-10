# 🟥 Load data ##################################################################
# rm(list=ls())
# path_diagnosis = "/Users/Ido/Library/CloudStorage/Dropbox/2.DataAnalysis/ADNI/SubjectsList/Results/6.Diagnosis.rds"
path_diagnosis = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments/6.Diagnosis.rds"
data = readRDS(path_diagnosis)








# 🟥 APOE ##################################################################
## 🟧 APOE 동일성 여부 판단 ==============================================
# ADNIMERGE___APOE4 열의 NA가 아닌 값들이 전부 동일한지 확인하고,
# 동일하지 않은 값을 가진 RID 추출
non_unique_rid <- data %>%
  # NA가 아닌 ADNIMERGE___APOE4 값만 필터링
  dplyr::filter(!is.na(ADNIMERGE___APOE4)) %>%
  # RID로 그룹화
  group_by(RID) %>%
  # 각 RID별로 ADNIMERGE___APOE4 값의 고유 개수를 계산
  summarise(unique_apoe4_count = n_distinct(ADNIMERGE___APOE4)) %>%
  # 고유 개수가 1보다 큰 경우, 즉 동일하지 않은 값을 가진 RID 필터링
  dplyr::filter(unique_apoe4_count > 1) %>%
  # 필터링된 RID 선택
  pull(RID)

# 결과 출력
print(non_unique_rid)



## 🟧 APOE가 전부 NA인 경우 ==============================================
# APOE 열이 전부 NA인 RID 추출
apoena_rids <- data %>%
  group_by(RID) %>%
  summarise(all_na = all(is.na(ADNIMERGE___APOE4))) %>%
  dplyr::filter(all_na) %>%
  pull(RID)

# 결과 출력
print(apoena_rids)




## 🟧 APOE NA 대치 ==============================================
# ADNIMERGE___APOE4 열의 NA 값을 NA가 아닌 값으로 대치
data_2 <- data %>%
  group_by(RID) %>%
  mutate(ADNIMERGE___APOE4 = ifelse(is.na(ADNIMERGE___APOE4), 
                                    first(ADNIMERGE___APOE4[!is.na(ADNIMERGE___APOE4)]), 
                                    ADNIMERGE___APOE4)) %>%
  ungroup()

# 결과 확인
head(data)
data_2$ADNIMERGE___APOE4 %>% table
is.na(data_2$ADNIMERGE___APOE4) %>% sum
dim(data_2)
data_2$QC___SERIES_TYPE %>% table








# 🟥 Save data ##################################################################
path_save = "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments"
saveRDS(data_2, paste0(path_save, "/7.Full History.rds"))













