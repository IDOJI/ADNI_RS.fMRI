# 🟥 Load Functions & Packages ##########################################################################
# rm(list = ls())
Sys.setlocale("LC_ALL", "en_US.UTF-8")

## 🟨Install and loading Packages ================================

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
List.list[[3]] = data_handling = c("tidyverse", "dplyr", "clipr", "tidyr", "readr", "caret", "readxl", "arrow")
List.list[[4]] = qmd = c("janitor", "knitr")
List.list[[5]] = texts = c("stringr", "stringi")
List.list[[6]] = misc = c("devtools")
List.list[[7]] = db = c("RMySQL", "DBI", "odbc", "RSQL", "RSQLite")
List.list[[8]] = sampling = c("rsample")
List.list[[9]] = excel = c("openxlsx")
List.list[[10]] = others = c("beepr")
List.list[[11]] = fmri = c("oro.nifti", "fslr")

packages_to_install_and_load = unlist(List.list)
install_packages(packages_to_install_and_load)

## 🟧dplyr =======================================================
filter = dplyr::filter
select = dplyr::select








# 🟥 Define Functions #################################################################################################
# 좌표에서 값을 추출하는 함수
extract_values <- function(nifti_img, coords) {
  sapply(1:nrow(coords), function(i) {
    x <- coords$dim1[i]
    y <- coords$dim2[i]
    z <- coords$dim3[i]
    nifti_img[x, y, z]
  })
}




# 🟨 공통 함수 정의 =====================================================================================================
extract_data_by_roi = function(path_data, path_export, path_atlas_list){
  atlas_list = readRDS(path_atlas_list)
  
  # 파일 이름에서 확장자 제외하고 이름만 추출하기
  file_names <- tools::file_path_sans_ext(list.files(path_data, pattern = "\\.rds$"))
  path_files = list.files(path_data, pattern = "\\.rds$", full.names = T)
  
  data_list = lapply(path_files, readRDS) %>% 
    setNames(file_names)
  
  
  for(data_type in names(data_list)){
    # data_type = names(data_list)[1]
    target_data = data_list[[data_type]]
    path_export_by_data_type = file.path(path_export, data_type)
    dir.create(path_export_by_data_type, showWarnings = F, recursive = T)
    
    for(atlas_name in names(atlas_list)){
      # atlas_name = names(atlas_list)[1]
      atlas = atlas_list[[atlas_name]]
      
      # 저장할 파일 경로 설정
      file_path_save_list <- file.path(path_export_by_data_type, paste0(atlas_name, ".rds"))
      file_path_mean_save_list <- file.path(path_export_by_data_type, paste0("Mean___", atlas_name, ".rds"))
      
      # 파일이 이미 존재하는지 확인
      if (file.exists(file_path_save_list) & file.exists(file_path_mean_save_list)) {
        # 이미 파일이 존재하는 경우 건너뛰기 메시지 출력
        cat(
          crayon::bgBlue$bold(" Data Type: "), crayon::yellow(data_type), "\n",
          crayon::bgGreen$bold(" Atlas Name: "), crayon::magenta(atlas_name), "\n",
          crayon::bgCyan$bold(" Status: "), crayon::red("Skipping, files already exist."), "\n\n"
        )
        next  # 다음 atlas로 건너뛰기
      }
      
      save_list = list()
      mean_save_list = list()
      
      for(rid in names(target_data)){
        # rid = names(target_data)[1]
        target_rid = target_data[[rid]]
        
        save_each_rid = list()
        mean_save_each_rid = list()
        start_time <- Sys.time()  # 각 RID 처리 시작 시간 기록
        
        for(roi in names(atlas)){
          # roi = names(atlas)[1]
          target_roi = atlas[[roi]]
          roi_values = apply(target_roi, 1, function(x){
            x = unlist(x)
            target_rid[x[1], x[2], x[3]]
          })
          
          save_each_rid[[roi]] = cbind(target_roi, values = roi_values)
          mean_save_each_rid[[roi]] <- data.frame(mean_value = mean(roi_values)) %>%
            rename(!!as.character(roi) := mean_value)  # mean_value 열을 roi 객체의 값으로 변경
          
        } # ROI
        
        # RID 처리 종료 시간 기록 및 소요 시간 계산
        rid_end_time <- Sys.time()
        rid_duration <- rid_end_time - start_time
        
        # crayon을 사용하여 각 메시지 부분마다 다른 색상으로 출력
        cat(
          crayon::bgBlue$bold(" Data Type: "), crayon::yellow(data_type), "\n",
          crayon::bgGreen$bold(" Atlas Name: "), crayon::magenta(atlas_name), "\n",
          crayon::bgCyan$bold(" RID: "), crayon::red(rid), "\n",
          crayon::bgWhite$bold(crayon::black(" Status: ")), crayon::bgRed$bold("RID Processing Completed"), "\n",
          crayon::bgBlack$bold(" RID Processing Duration: "), crayon::bgMagenta$bold(crayon::white(rid_duration)), "\n\n"
        )
        
        mean_save_list[[rid]] = do.call(cbind, mean_save_each_rid) %>% cbind(RID = rid, .)
        save_list[[rid]] = save_each_rid
        
      } # RID
      
      mean_save_df = do.call(rbind, mean_save_list)
      row.names(mean_save_df) = NULL
      
      
      # saveRDS 시간 측정
      save_start_time <- Sys.time()  # saveRDS 시작 시간 기록
      saveRDS(save_list, file_path_save_list)  # 파일 경로를 설정한 파일명으로 저장
      saveRDS(mean_save_df, file_path_mean_save_list)  # 평균 파일 저장
      save_end_time <- Sys.time()  # saveRDS 종료 시간 기록
      save_duration <- save_end_time - save_start_time  # saveRDS에 걸린 시간 계산
      
      # saveRDS 완료 메시지 출력 (각 부분마다 다른 색상 적용)
      cat(
        crayon::bgYellow$bold(" Data Type: "), crayon::blue(data_type), "\n",
        crayon::bgRed$bold(" Atlas Name: "), crayon::cyan(atlas_name), "\n",
        crayon::bgMagenta$bold(" Status: "), crayon::green("SaveRDS Completed"), "\n",
        crayon::bgWhite$bold(crayon::black(" SaveRDS Duration: ")), crayon::white(save_duration), "\n",
        crayon::bgBlack$bold(" Message: "), crayon::yellow("Saving completed successfully for "), 
        crayon::blue(data_type), " - ", crayon::cyan(atlas_name), "\n\n"
      )
      
    } # atlas
    
  } # data_type
}
