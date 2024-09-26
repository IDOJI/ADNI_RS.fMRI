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
library(oro.nifti)
library(dplyr)

# fMRI 파일 목록에 대해 ROI의 평균값을 계산하는 함수 정의
process_fmri_files_with_atlas <- function(atlas_list, fmri_dir, export_dir) {
  
  # fMRI 디렉토리에서 모든 .nii 파일 목록 가져오기
  fmri_files <- list.files(fmri_dir, pattern = "\\.nii.gz$", full.names = TRUE)
  
  # 각 fMRI 파일에 대해 반복
  for (fmri_file in fmri_files) {
    
    # fMRI NIfTI 파일 읽기
    fmri_img <- readNIfTI(fmri_file)
    
    # atlas 리스트를 순회하면서 처리
    result_list <- lapply(atlas_list, function(atlas) {
      # atlas 내의 ROI를 순회
      ROI_avg_list <- lapply(names(atlas), function(roi_name) {
        # 해당 ROI 좌표 가져오기
        roi_coords <- atlas[[roi_name]]
        
        # fMRI 데이터에서 ROI 좌표에 해당하는 복셀 값 가져오기
        roi_values <- mapply(function(x, y, z) {
          fmri_img[x, y, z]
        }, roi_coords$dim1, roi_coords$dim2, roi_coords$dim3)
        
        # ROI의 평균 값 계산
        roi_avg <- mean(roi_values, na.rm = TRUE)
        
        # 결과 저장
        data.frame(ROI = roi_name, AverageValue = roi_avg)
      })
      
      # 각 ROI 결과 합치기
      do.call(rbind, ROI_avg_list)
    })
    
    # 각 atlas에 대한 결과 합치기
    result_df <- bind_rows(result_list, .id = "Atlas")
    
    # 결과를 파일명에 맞춰 CSV로 저장 (fmri 파일명에서 확장자를 제거하고 사용)
    file_base_name <- tools::file_path_sans_ext(basename(fmri_file))
    export_path <- file.path(export_dir, paste0(file_base_name, "_result.csv"))
    write.csv(result_df, file = export_path, row.names = FALSE)
    
    # 진행 상황 출력
    message(paste("Processed:", fmri_file))
  }
  
  message("All files processed.")
}

# 사용 예시
# atlas_list: 여러 atlas 파일이 포함된 리스트
# fmri_dir: 여러 fMRI NIfTI 파일들이 있는 디렉토리 경로
# export_dir: 결과를 저장할 디렉토리 경로

atlas_list <- list(Schaefer2018_1000Parcels_17Networks_order_FSLMNI152 = atlas$Schaefer2018_1000Parcels_17Networks_order_FSLMNI152__resampled)
fmri_dir <- "path/to/your/fmri_files"
export_dir <- "path/to/export/results"

# 함수 실행
process_fmri_files_with_atlas(atlas_list, fmri_dir, export_dir)
