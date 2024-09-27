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
# 필요한 패키지 로드
library(tictoc)
library(crayon)

process_fmri_rds_with_atlas <- function(atlas_list, fmri_rds_path, export_path, file_name) {
  
  # 결과 저장 디렉토리 생성
  dir.create(export_path, showWarnings = FALSE, recursive = TRUE)
  
  # rds 파일에서 fMRI 데이터를 리스트로 읽어오기
  fmri_list <- readRDS(fmri_rds_path)
  
  # atlas별로 결과를 저장할 리스트 초기화
  atlas_results <- vector("list", length(atlas_list))
  names(atlas_results) <- names(atlas_list)
  
  # 각 fMRI 리스트의 원소에 대해 반복 (각 사람에 대해 반복)
  for (fmri_name in names(fmri_list)) {
    
    # 사람의 ID 추출 (예: "RID_0021")
    person_id <- sub(".*_(RID_\\d+).*", "\\1", fmri_name)
    
    # 각 atlas별 파일 이름 확인 및 존재 여부 체크
    skip_person <- TRUE
    for (atlas_name in names(atlas_list)) {
      person_export_path <- file.path(export_path, paste0(person_id, "_", atlas_name, ".rds"))
      if (!file.exists(person_export_path) || file.size(person_export_path) == 0) {
        skip_person <- FALSE
        break
      }
    }
    
    # 이미 계산된 경우 건너뛰기
    if (skip_person) {
      cat(yellow(paste0("Skipped ", fmri_name, " as results already exist.\n")))
      next
    }
    
    # 타이머 시작
    tic()
    
    # fMRI 이미지 데이터 가져오기
    fmri_img <- fmri_list[[fmri_name]]
    
    # atlas 리스트를 순회하면서 처리
    for (atlas_name in names(atlas_list)) {
      
      atlas <- atlas_list[[atlas_name]]
      
      # atlas 내의 ROI를 순회하여 처리
      ROI_avg_list <- lapply(names(atlas), function(roi_name) {
        # 해당 ROI 좌표 가져오기
        roi_coords <- atlas[[roi_name]]
        
        # 좌표값을 사용하여 fMRI 데이터에서 값 추출
        roi_values <- apply(roi_coords, 1, function(coord) {
          coord <- unlist(coord)
          fmri_img[coord[1], coord[2], coord[3]]
        })
        
        # NA가 있으면 루프 중단
        if (any(is.na(roi_values))) {
          stop("NA values found in ROI values. Stopping the loop.")
        } else {
          # ROI의 평균값 계산
          roi_avg <- mean(roi_values)
        }
        
        # ROI 이름을 열 이름으로 결과 저장
        data.frame(ROI = roi_name, AverageValue = roi_avg)
      })
      
      # 각 ROI 결과 합치기 (행렬 형태로 변환)
      result <- do.call(rbind, ROI_avg_list)
      
      # 데이터프레임을 가로 형태로 변환
      result_wide <- t(result$AverageValue)
      colnames(result_wide) <- result$ROI
      result_wide <- as.data.frame(result_wide)
      result_wide$RID <- person_id
      result_wide <- result_wide %>% relocate(RID)
      
      # 각 사람의 데이터 개별적으로 저장
      person_export_path <- file.path(export_path, paste0(person_id, "_", atlas_name, ".rds"))
      saveRDS(result_wide, file = person_export_path)
    }
    
    # 사람 당 처리 시간 계산
    elapsed_time <- toc(quiet = TRUE)
    
    # 처리 시간을 출력 (사람의 ID는 파란색, 처리 시간은 초록색으로 표시)
    cat(blue(paste0("Processed ", fmri_name)), " in ", green(paste0(round(elapsed_time$toc - elapsed_time$tic, 2), " seconds.\n")))
  }
  
  # atlas별로 결과를 합치고 파일 삭제
  for (atlas_name in names(atlas_list)) {
    # 해당 atlas에 대한 모든 사람의 결과 파일 불러오기 및 합치기
    person_files <- list.files(export_path, pattern = paste0("_", atlas_name, ".rds$"), full.names = TRUE)
    
    # 이미 파일이 존재하고 크기가 0이 아닌 경우 건너뛰기
    atlas_export_path <- file.path(export_path, paste0(file_name, "_", atlas_name, ".rds"))
    if (file.exists(atlas_export_path) && file.size(atlas_export_path) > 0) {
      cat(yellow(paste0("Skipped saving ", atlas_name, " as file already exists and is non-empty.\n")))
      next
    }
    
    # atlas별 결과 병합
    atlas_result <- do.call(rbind, lapply(person_files, readRDS))
    
    # atlas 결과 저장
    saveRDS(atlas_result, file = atlas_export_path)
    
    # 개별 사람의 결과 파일 삭제
    file.remove(person_files)
    
    # 저장 경로 출력
    cat(green(paste0("All results for ", atlas_name, " saved to: ", atlas_export_path, "\n")))
  }
  
  message("All files processed and saved.")
}
