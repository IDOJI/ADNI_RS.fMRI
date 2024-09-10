# save.image(file = "TMP.RData")
# load("/Users/Ido/Library/CloudStorage/Dropbox/@GitHub/Github___Obsidian/Obsidian/☔️Papers_Writing/㊙️MS Thesis_FC Curves using FDA/♏️⭐️분석 코드/attachments/TMP.RData")
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

filter = dplyr::filter
select = dplyr::select




# 🟥 Data Load ############################################################################
# 경로 1
path_ADNI2 <- "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️다운받은 파일들/attachments/MAYOADIRL_MRI_IMAGEQC_12_08_15_04Apr2024.csv"

# 경로 2
path_ADNI3 <- "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️다운받은 파일들/attachments/MAYOADIRL_MRI_QUALITY_ADNI3_04Apr2024.csv"

ADNI2 = read.csv(path_ADNI2)
ADNI3 = read.csv(path_ADNI3)


# 🟥 Data selection by MRI, fMRI scanning on the same dates ############################################################################
## 🟧 Data cleaning ############################################################################
## change colnames
colnames(ADNI2) <- toupper(colnames(ADNI2))

## only EPI, fMRI , T1, MT1
ADNI2 = ADNI2[ADNI2$SERIES_TYPE %in% c("T1", "fMRI"), ]
ADNI3 = ADNI3[ADNI3$SERIES_TYPE %in% c("EPB", "MT1"), ]

# ADNI2 데이터프레임의 SERIES_TYPE 변수 값 변경
ADNI2$SERIES_TYPE <- ifelse(ADNI2$SERIES_TYPE == "T1", "MT1",
                            ifelse(ADNI2$SERIES_TYPE == "fMRI", "EPB", ADNI2$SERIES_TYPE))


# 날짜 형식 변경
ADNI2$SERIES_DATE <- as.Date(as.character(ADNI2$SERIES_DATE), format = "%Y%m%d")
# 뒤에 있는 시간 부분 제거하고 날짜 형식으로 변경
ADNI3$SERIES_DATE <- as.Date(ADNI3$SERIES_DATE, format = "%Y-%m-%d")





## 🟧 Select RID having both EPB, MT1 at the same date  ############################################################################
extract_same_day_data <- function(data) {
  library(dplyr)
  
  # RID를 기준으로 그룹화하고, 같은 날짜에 SERIES_TYPE가 MT1과 EPB인 RID를 추출
  same_day_data <- data %>%
    dplyr::group_by(RID, SERIES_DATE) %>%
    dplyr::filter(all(c("MT1", "EPB") %in% SERIES_TYPE)) %>%
    dplyr::ungroup() %>% 
    dplyr::arrange(RID)
  
  return(same_day_data)
}


ADNI2_selected = extract_same_day_data(ADNI2)
ADNI3_selected = extract_same_day_data(ADNI3)



# 🟥 Combine Data ###############################################################################
## 🟧 Image ID Cols  ############################################################################
# LONI IMAGE
ADNI2 = ADNI2_selected %>% relocate(LONI_IMAGE)
ADNI3 = ADNI3_selected %>% relocate(LONI_IMAGE)
ADNI3$LONI_IMAGE = paste0("I", ADNI3$LONI_IMAGE) %>% as.character


# LONI SERIES
ADNI2$LONI_SERIES
ADNI3$LONI_SERIES = paste0("S", ADNI3$LONI_SERIES)


## 🟧 Check Image ID Intersection  ############################################################################
intersect(ADNI2$LONI_IMAGE, ADNI3$LONI_IMAGE)



## 🟧 Combine: RID  ############################################################################
Combined = bind_rows(ADNI2, ADNI3) %>% dplyr::arrange(RID, SERIES_DATE)



## 🟧 Remove MocoSeries  ############################################################################
Combined <- Combined[!grepl("(?i)MoCoSeries", Combined$SERIES_DESCRIPTION), ]






# 🟥 Remove bad Data ########################################################################
## 🟧 Remove bad image ID ########################################################################
error_image_list = list()
error_image_list[[1]] = c("I952527", "I952530","I1173062", "I971099", "I1021034", "I1606245", "I1329385", "I1557905", "I1567175", "I1628478", "I1173060", "I971096", "I1021033", "I1606240", "I1329390", "I1557901", "I1567174", "I1628474")
error_image_list[[2]] = c("I1051713","I1051710","I928485","I928482","I882170","I882167","I1020140","I1020137","I996381","I996377","I1158788","I1158785","I1010737","I1010734","I1604231","I1604220","I879211","I879209","I1116736","I1116728","I994534","I994530","I1516267","I1516264","I1444304","I1444291","I992637","I992628","I1003966","I1003961","I1170567","I1170562","I1157074","I1157071","I998811","I998806")
error_image_list[[3]] = c("I1667466", "I1667469")
error_image_list[[4]] = c("I1221691", "I1221690", "I1058750", "I1058747", "I1068957", "I1068952", "I968584", "I968581", "I992801", "I992799", "I1020189", "I1020186", "I1177675", "I1177672", "I1283855", "I1283849", "I1344949", "I1344946", "I1237734", "I1237740")
error_image = unlist(error_image_list)
data = Combined %>% dplyr::filter(!LONI_IMAGE %in% error_image)




## 🟧 dictionary ########################################################################
create_column_description <- function(name){
  # 대소문자를 구분하지 않고 입력한 열의 역할을 찾아서 설명하는 함수
  data_dictionary = read.csv("/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️다운받은 파일들/attachments/DATADIC_04Apr2024.csv")
  
  
  # 데이터 딕셔너리 파일의 열 이름을 소문자로 변환
  data_dictionary$name <- tolower(data_dictionary$FLDNAME)
  
  # 입력한 열 이름을 소문자로 변환
  name <- tolower(name)
  
  # name을 기준으로 데이터 딕셔너리 파일에서 열의 설명을 찾음
  description <- data_dictionary[data_dictionary$name == name, c("TEXT", "CODE")]
  
  # 만약 해당 열의 설명이 없으면 메시지 출력
  if (nrow(description) == 0) {
    print("해당 열에 대한 설명이 데이터 딕셔너리 파일에 없습니다.")
  } else {
    # 해당 열의 설명 출력
    print(description)
  }
}



## 🟧 Check cols ########################################################################
data$MEDICAL_EXCLUSION %>% table
data$STUDY_OVERALLPASS %>% table # remove 0
data$STUDY_MEDICAL_ABNORMALITIES %>% table # remove 1
data$STUDY_RESCAN_REQUESTED %>% table # remove TRUE
data$PROTOCOL_COMMENTS %>% table
data$STUDY_MEDICAL_ABNORMALITIES


create_column_description("MEDICAL_EXCLUSION")
create_column_description("StuDy_oVerallPass")
create_column_description("study_medical_abnormalities")
create_column_description("study_rescan_requested")
create_column_description("protocol_comments")
create_column_description("StuDY_medical_abnormalities")





## 🟧 Remove rows ########################################################################
filtered_data <- data %>%
  dplyr::filter(STUDY_OVERALLPASS != 0,
                STUDY_MEDICAL_ABNORMALITIES != 1,
                !STUDY_RESCAN_REQUESTED)

## 🟧 Check description ########################################################################
filtered_data$SERIES_DESCRIPTION %>% table




## 🟧 SERIES_SELECTED ########################################################################
filtered_data$SERIES_SELECTED %>% table
filtered_data$SERIES_SELECTED %>% table %>% sum
dim(filtered_data)
filtered_data_2 = filtered_data %>% 
  dplyr::filter(SERIES_SELECTED==1)

filtered_data_2$SERIES_SELECTED %>% table







# 🟥 remove bad comments ###########################################################################
filtered_data_2$STUDY_COMMENTS %>% table
filtered_data_2$SERIES_COMMENTS %>% table


library(dplyr)

# filtered_data_2 데이터 프레임에서 "motion" 문자열을 포함하는 행을 제외
filtered_data_3 <- filtered_data_2 %>%
  filter(!grepl("motion", SERIES_COMMENTS, ignore.case = TRUE))  # 대소문자를 무시하고 "motion" 검색

filtered_data_3$SERIES_COMMENTS %>% table
filtered_data_3$PROTOCOL_COMMENTS %>% table


# 🟥 save ###########################################################################
path_save =  "/Users/Ido/Library/CloudStorage/GoogleDrive-clair.de.lune.404@gmail.com/My Drive/GitHub/Obsidian/☔️Data Preprocessing & Analysis/㊙️ADNI_RS-fMRI/✴️(~Ing)1.Subjects List/✅⭐️최종 선택 리스트/attachments"
saveRDS(filtered_data_3, paste0(path_save, "/1.QC.rds"))



















