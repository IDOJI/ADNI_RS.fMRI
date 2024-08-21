# 🟥 Load Functions & Packages ##########################################################################

Sys.setlocale("LC_ALL", "en_US.UTF-8")

## 🟨Install and loading Packages ================================
# rm(list = ls())
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
List.list[[3]] = data_handling = c("tidyverse", "dplyr", "clipr", "tidyr", "readr", "caret", "readxl")
List.list[[4]] = qmd = c("janitor", "knitr")
List.list[[5]] = texts = c("stringr", "stringi")
List.list[[6]] = misc = c("devtools")
List.list[[7]] = db = c("RMySQL", "DBI", "odbc", "RSQL", "RSQLite")
List.list[[8]] = sampling = c("rsample")
List.list[[9]] = excel = c("openxlsx")
List.list[[10]] = others = c("beepr")

packages_to_install_and_load = unlist(List.list)
install_packages(packages_to_install_and_load)

## 🟧dplyr ==================================================================================================
filter = dplyr::filter
select = dplyr::select





# 🟥 copy results =========================================================================================================
library(crayon)

library(crayon)

copy_data_with_rename <- function(path_from, path_to) {
  
  # 1. path_from에서 폴더 리스트 읽기
  folders <- list.files(path_from, full.names = TRUE)
  
  # 2. 각 폴더에 대해서 작업 수행
  for (folder in folders) {
    # 폴더명 추출
    folder_name <- basename(folder)
    
    # folder_name에서 Sub_xxx와 RID_xxxx 추출
    sub_id <- regmatches(folder_name, regexpr("Sub_[0-9]+", folder_name))
    rid_id <- regmatches(folder_name, regexpr("RID_[0-9]+", folder_name))
    
    # 3. results 폴더에서 서브 폴더 읽기
    results_folder <- file.path(folder, "results")
    subfolders <- list.files(results_folder, full.names = TRUE)
    
    # "FC_FunImgARCWSF"와 "FC_FunImgARglobalCWSF" 제외
    excluded_folders <- c("FC_FunImgARCWSF", "FC_FunImgARglobalCWSF")
    subfolders <- subfolders[!basename(subfolders) %in% excluded_folders]
    
    # 4. path_to에 서브 폴더 생성 및 파일 복사
    for (subfolder in subfolders) {
      subfolder_name <- basename(subfolder)
      
      # path_to에 해당 서브 폴더가 없으면 생성
      dest_subfolder <- file.path(path_to, subfolder_name)
      if (!dir.exists(dest_subfolder)) {
        dir.create(dest_subfolder, recursive = TRUE)
      }
      
      # 해당 서브 폴더 안의 파일들 읽기
      files <- list.files(subfolder, full.names = TRUE)
      
      # 5. 각 파일을 복사하면서 파일명 변경 및 새로운 폴더 생성
      for (file in files) {
        file_name <- basename(file)
        
        # 파일명에서 Sub_xxx를 RID_xxxx로 변경
        new_file_name <- gsub(sub_id, rid_id, file_name)
        
        # 파일명에서 RID 부분을 제외한 앞부분 추출 (예: "ALFFMap")
        base_file_name <- gsub(paste0("_", rid_id), "", tools::file_path_sans_ext(new_file_name))
        
        # 새 폴더 생성 (path_to/subfolder_name/base_file_name)
        new_folder_path <- file.path(dest_subfolder, base_file_name)
        if (!dir.exists(new_folder_path)) {
          dir.create(new_folder_path, recursive = TRUE)
        }
        
        # 새 경로 설정 (새로운 폴더로 파일 복사)
        dest_file <- file.path(new_folder_path, new_file_name)
        
        # 파일 복사 (overwrite 옵션 추가 가능)
        file.copy(file, dest_file, overwrite = TRUE)
      }
    }
    
    # 환자의 데이터 복사가 완료되면 메시지 출력
    cat(crayon::green(paste("환자 데이터 복사 완료:", rid_id, "\n")))
  }
  
  cat(crayon::bgMagenta("모든 파일 복사가 완료되었습니다.\n"))
}




# 🟥 copy 4D volumes =========================================================================================================
library(crayon)

copy_4D_volume_files_with_rid <- function(path_from, path_to, folder_names) {
  
  # 1. path_from에서 폴더 리스트 읽기
  folders <- list.files(path_from, full.names = TRUE)
  
  # 2. 각 폴더에 대해서 작업 수행
  for (folder in folders) {
    
    # 폴더명 추출
    folder_name <- basename(folder)
    
    # folder_name에서 Sub_xxx와 RID_xxxx 추출
    sub_id <- regmatches(folder_name, regexpr("Sub_[0-9]+", folder_name))
    rid_id <- regmatches(folder_name, regexpr("RID_[0-9]+", folder_name))
    
    # 환자 데이터 복사 시작 시간 체크
    cat(crayon::yellow(paste("환자 데이터 복사 시작:", rid_id, "\n")))
    tictoc::tic(paste("환자", rid_id, "의 데이터 복사 시간"))
    
    # 각 폴더에서 특정한 이름의 서브 폴더 경로를 찾음
    for (target_folder_name in folder_names) {
      # target_folder_name = folder_names[1]
      target_folder_path <- file.path(folder, target_folder_name)
      
      # 해당 폴더가 존재하는지 확인
      if (dir.exists(target_folder_path)) {
        # 해당 폴더 안의 Sub_XXX 폴더 읽기
        sub_folders <- list.files(target_folder_path, full.names = TRUE)
        
        # 각 Sub_XXX 폴더 안의 파일들을 복사
        for (sub_folder in sub_folders) {
          # sub_folder = sub_folders[1]
          sub_folder_name <- basename(sub_folder)
          
          # 복사할 파일 읽기 (각 Sub 폴더 안에 파일이 하나라고 가정)
          files <- list.files(sub_folder, full.names = TRUE)
          
          for (file in files) {
            # file = files[1]
            file_name <- basename(file)
            
            # 새 파일명 생성 (파일명에 RID 추가)
            new_file_name <- gsub("(.*)(\\.\\w+)$", paste0("\\1_", rid_id, "\\2"), file_name)
            
            # 새로운 경로 설정 (path_to에 folder_name 하위 경로)
            dest_folder <- file.path(path_to, target_folder_name)
            
            # 경로에 해당 폴더가 없으면 생성
            if (!dir.exists(dest_folder)) {
              dir.create(dest_folder, recursive = TRUE)
            }
            
            # 새 파일 경로
            dest_file <- file.path(dest_folder, new_file_name)
            
            # 파일 복사
            file.copy(file, dest_file)
          }
        }
      }
    }
    
    # 환자의 데이터 복사 완료 및 시간 측정 종료
    tictoc::toc()
    cat(green(paste("환자 데이터 복사 완료:", rid_id, "\n")))
  }
  
  # 모든 작업이 완료된 후 출력
  cat(crayon::bgMagenta("모든 파일 복사가 완료되었습니다.\n"))
}











