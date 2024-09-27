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
## 🟧 Static FC ========================================================================================================================
### 🟨 Fisher Z 변환 함수 정의 ===========================================================================================================
fisher_z <- function(r) {
  0.5 * log((1 + r) / (1 - r))
}



### 🟨 static functional connectivity 계산 함수 ===========================================================================================================
calculate_static_fc <- function(data) {
  # 데이터프레임을 행렬로 변환
  if (is.data.frame(data) || inherits(data, "tbl_df")) {
    data <- as.matrix(data)
  }
  # Pearson correlation 계산
  fc <- cor(data, method = "pearson", use = "pairwise.complete.obs")
  
  # 결과 반환
  return(fc)
}


### 🟨 모든 atlas에 대해 Pearson correlation과 Fisher Z 변환을 따로 저장하는 함수 ===========================================================================================================
# output_dir = "/Users/Ido/Documents/✴️DataAnalysis/ADNI/RS.fMRI/3.ROI-defined results/2.Functional Connectivity"
library(arrow)  # Feather 포맷 사용을 위해 arrow 패키지 필요
library(tictoc)
library(crayon)

process_all_atlas <- function(atlas_files, output_dir) {
  for (file in atlas_files) {
    # atlas 파일 이름을 추출
    atlas_name <- tools::file_path_sans_ext(basename(file))
    
    # 병합된 데이터 파일 경로 설정
    combined_fisher_z_output_file <- file.path(output_dir, paste0(atlas_name, "_combined_fisher_z_fc.rds"))
    combined_pearson_output_file <- file.path(output_dir, paste0(atlas_name, "_combined_pearson_fc.rds"))
    
    # 병합된 파일이 이미 존재하면 처리 건너뜀
    if (file.exists(combined_fisher_z_output_file) && file.exists(combined_pearson_output_file)) {
      cat(crayon::yellow("Combined files already exist for atlas:"), crayon::blue(atlas_name), "- Skipping.\n")
      next
    }
    
    # 처리 시작 시각 측정
    tictoc::tic()
    
    # atlas 파일 읽기
    atlas_data <- readRDS(file)
    
    # 각 사람의 데이터를 처리하여 rds 파일로 저장
    individual_output_files_fisher_z <- c()
    individual_output_files_pearson <- c()
    
    for (person_id in names(atlas_data)) {
      # Feather 파일 경로 설정 (Pearson과 Fisher Z 변환 각각에 대해)
      fisher_z_output_file <- file.path(output_dir, paste0(atlas_name, "_", person_id, "_fisher_z_fc.rds"))
      pearson_output_file <- file.path(output_dir, paste0(atlas_name, "_", person_id, "_pearson_fc.rds"))
      
      # 저장된 파일을 추적하기 위해 리스트에 추가
      individual_output_files_fisher_z <- c(individual_output_files_fisher_z, fisher_z_output_file)
      individual_output_files_pearson <- c(individual_output_files_pearson, pearson_output_file)
      
      # 이미 파일이 존재하면 건너뜀
      if (file.exists(fisher_z_output_file) && file.exists(pearson_output_file)) {
        cat(crayon::yellow("Files already exist for atlas:"), crayon::blue(atlas_name), 
            crayon::yellow("Person:"), crayon::magenta(person_id), "- Skipping.\n")
        next
      }
      
      # 각 사람의 데이터 처리
      person_data <- atlas_data[[person_id]]
      
      # Pearson correlation 계산
      pearson_fc <- calculate_static_fc(person_data)
      
      # Pearson correlation 행렬의 각 원소에 대해 Fisher Z 변환 적용
      fisher_z_fc <- apply(pearson_fc, c(1, 2), fisher_z)
      
      # Pearson correlation 데이터 저장
      saveRDS(pearson_fc, pearson_output_file)
      
      # Fisher Z 변환 데이터 저장
      saveRDS(fisher_z_fc, fisher_z_output_file)
      
      # 완료된 메시지 출력
      cat(crayon::green("Processing completed for atlas:"), crayon::blue(atlas_name), 
          crayon::yellow("Person:"), crayon::magenta(person_id), "\n")
      
      # 중간 데이터 메모리 해제
      rm(pearson_fc, fisher_z_fc, person_data)
      gc()
    }
    
    # Fisher Z 데이터 병합 (에러 핸들링 추가)
    combined_fisher_z_data <- list()
    for (file in individual_output_files_fisher_z) {
      if (file.exists(file)) {
        tryCatch({
          combined_fisher_z_data[[file]] <- readRDS(file)
        }, error = function(e) {
          cat(crayon::red("Error reading Fisher Z file:"), file, "\n")
          cat(crayon::red("Error message:"), e$message, "\n")
        })
      } else {
        cat(crayon::yellow("File does not exist:"), file, "\n")
      }
    }
    
    # Pearson raw correlation 데이터 병합 (에러 핸들링 추가)
    combined_pearson_data <- list()
    for (file in individual_output_files_pearson) {
      if (file.exists(file)) {
        tryCatch({
          combined_pearson_data[[file]] <- readRDS(file)
        }, error = function(e) {
          cat(crayon::red("Error reading Pearson file:"), file, "\n")
          cat(crayon::red("Error message:"), e$message, "\n")
        })
      } else {
        cat(crayon::yellow("File does not exist:"), file, "\n")
      }
    }
    
    # 병합된 데이터를 RDS 형식으로 저장 (리스트로 유지)
    saveRDS(combined_fisher_z_data, combined_fisher_z_output_file)
    saveRDS(combined_pearson_data, combined_pearson_output_file)
    
    # 파일 삭제 및 삭제 성공 여부 출력
    deleted_fisher_z_files <- file.remove(individual_output_files_fisher_z)
    cat("Deleted Fisher Z files:", sum(deleted_fisher_z_files), "out of", length(individual_output_files_fisher_z), "\n")
    
    deleted_pearson_files <- file.remove(individual_output_files_pearson)
    cat("Deleted Pearson files:", sum(deleted_pearson_files), "out of", length(individual_output_files_pearson), "\n")
    
    # 처리 종료 시각 측정 및 결과 출력
    elapsed_time <- tictoc::toc(quiet = TRUE)
    cat("\n", atlas_name, crayon::green("is done!"), crayon::yellow(sprintf("Time taken: %.2f seconds", elapsed_time$toc - elapsed_time$tic)), "\n")
    
    # 메모리 해제
    rm(atlas_data, combined_fisher_z_data, combined_pearson_data)
    gc()
  }
}


### 🟨 Moving files ============================================================================
move_files_with_string <- function(source_dir, target_dir, search_string) {
  # source_dir에서 search_string을 포함한 파일 목록을 검색
  matching_files <- list.files(source_dir, pattern = search_string, full.names = TRUE, recursive = FALSE)
  
  # 대상 경로가 존재하지 않으면 생성
  if (!dir.exists(target_dir)) {
    dir.create(target_dir, recursive = TRUE)
  }
  
  # 파일을 target_dir로 이동
  if (length(matching_files) == 0) {
    cat(crayon::red("No files found with search string:"), search_string, "\n")
  } else {
    for (file in matching_files) {
      tryCatch({
        # 파일 이름 추출
        file_name <- basename(file)
        
        # 대상 파일 경로
        target_file <- file.path(target_dir, file_name)
        
        # 파일 이동 시도
        if (file.rename(file, target_file)) {
          # 성공 메시지 출력
          cat(crayon::green("Successfully moved file:"), crayon::blue(file_name), "to", crayon::yellow(target_dir), "\n")
        } else {
          cat(crayon::red("Failed to move file:"), crayon::blue(file_name), "\n")
        }
        
      }, error = function(e) {
        # 에러 발생 시 메시지 출력
        cat(crayon::red("Error moving file:"), file, "\n")
        cat(crayon::red("Error message:"), e$message, "\n")
      })
    }
    cat(crayon::green("File moving completed."), "\n")
  }
}


### 🟨 Fisher Z ============================================================================
apply_fisher_z_transformation <- function(input_dir, output_dir) {
  # 지정된 input_dir에서 모든 ".rds" 파일 목록 가져오기
  rds_files <- list.files(input_dir, pattern = "\\_combined_pearson_fc\\.rds$", full.names = TRUE)
  
  # 변환할 파일이 없으면 경고 메시지 출력
  if (length(rds_files) == 0) {
    cat(crayon::red("No Pearson correlation files found in the directory."), "\n")
    return()
  }
  
  # 각 파일에 대해 변환 수행
  for (file in rds_files) {
    tryCatch({
      # 파일 이름에서 atlas 이름 추출
      atlas_name <- tools::file_path_sans_ext(basename(file))
      atlas_name <- sub("_combined_pearson_fc", "", atlas_name)  # 파일 이름에서 필요 없는 부분 제거
      
      # 저장할 파일 경로 생성
      output_file <- file.path(output_dir, paste0(atlas_name, "_combined_Fisher_Z_fc.rds"))
      
      # 파일이 이미 존재하면 건너뛰기
      if (file.exists(output_file)) {
        cat(crayon::yellow("Fisher Z file already exists for atlas:"), crayon::blue(atlas_name), "- Skipping.\n")
        next
      }
      
      # 파일 처리 시작 시간 기록
      tictoc::tic()
      
      # Pearson correlation 파일 읽기
      pearson_data <- readRDS(file)
      
      # Fisher Z 변환을 적용할 리스트 생성
      fisher_z_data <- lapply(pearson_data, function(matrix) {
        apply(matrix, c(1, 2), fisher_z)
      }) %>% setNames(names(pearson_data))
      
      # 변환된 데이터를 .rds 파일로 저장
      saveRDS(fisher_z_data, output_file)
      
      # 파일 처리 완료 시간 기록
      elapsed_time <- tictoc::toc(quiet = TRUE)
      
      # 완료 메시지 및 소요 시간 출력
      cat(crayon::green("Successfully processed and saved Fisher Z transformation for atlas:"), crayon::blue(atlas_name), "\n")
      cat(crayon::yellow(sprintf("Time taken: %.2f seconds", elapsed_time$toc - elapsed_time$tic)), "\n")
      
    }, error = function(e) {
      # 에러 처리 및 에러 메시지 출력
      cat(crayon::red("Error processing file:"), file, "\n")
      cat(crayon::red("Error message:"), e$message, "\n")
    })
  }
  
  cat(crayon::green("Fisher Z transformation completed for all files."), "\n")
}



# 🟥 rename elements by each RID ================================================================================
# 필요한 패키지 로드
library(stringr)

# 원소 이름에서 "RID_XXXX" 부분만 추출하는 함수
extract_rid <- function(path) {
  # 경로에서 basename 추출
  file_name <- basename(path)
  
  # "RID_XXXX" 패턴 추출
  rid <- str_extract(file_name, "RID_\\d+")
  
  return(rid)
}

# rds 파일을 읽고 원소 이름을 변경한 후 다시 저장하는 함수 정의
process_rds_files <- function(rds_dir) {
  
  # 지정된 경로에서 .rds 파일 목록 가져오기
  rds_files <- list.files(rds_dir, pattern = "\\.rds$", full.names = TRUE)
  
  # 각 rds 파일에 대해 작업 수행
  for (rds_file in rds_files) {
    # rds_file = rds_files[1]
    # rds 파일 읽기
    atlas <- readRDS(rds_file)
    
    # 각 리스트 원소의 이름을 "RID_XXXX" 형태로 변경
    new_names <- sapply(names(atlas), extract_rid)
    names(atlas) <- new_names
    
    # 변경된 리스트를 다시 같은 파일에 저장
    saveRDS(atlas, rds_file)
    
    # 진행 상황 출력
    message(paste("Processed and saved:", rds_file))
  }
  
  message("All files processed and updated.")
}


