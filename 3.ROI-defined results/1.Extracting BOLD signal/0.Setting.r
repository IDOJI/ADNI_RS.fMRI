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
## 🟧 Misc ============================================================================================================
fit_length <- function(number, digits) {
  # Convert the number to a string and pad with leading zeros
  formatted_number <- sprintf(paste0("%0", digits, "d"), number)
  return(formatted_number)
}






## 🟧 Generate 4D volume file for test =====================================================================================================
# NIfTI 파일 생성 함수
generate_nifti_file <- function(path_save, filename = "volume", 
                                dim_x = 61, dim_y = 73, dim_z = 61, dim_time = 120,
                                voxel_dims = c(3, 3, 3), # Voxel 크기
                                data_min = -32768, data_max = 32767) {
  # 필요한 패키지 설치
  if (!requireNamespace("oro.nifti", quietly = TRUE)) {
    install.packages("oro.nifti")
  }
  require(oro.nifti)
  
  # 4D 배열 생성 (임의의 데이터)
  data_array <- array(as.integer(runif(dim_x * dim_y * dim_z * dim_time, min = data_min, max = data_max)), 
                      dim = c(dim_x, dim_y, dim_z, dim_time))
  
  # NIfTI 객체 생성
  nifti_obj <- nifti(data_array)
  
  # 메타데이터 설정
  nifti_obj@datatype <- 4  # INT16
  nifti_obj@bitpix <- 16   # 16 bits per pixel
  nifti_obj@pixdim <- c(1, voxel_dims[1], voxel_dims[2], voxel_dims[3], 1, 0, 0, 0)  # Voxel dimensions: 3x3x3 mm, time dimension in seconds
  
  # qform 및 sform 코드 설정
  nifti_obj@qform_code <- 2
  nifti_obj@sform_code <- 2
  
  # NIfTI 파일로 저장
  writeNIfTI(nifti_obj, file.path(path_save, filename))
  cat(paste("NIfTI 파일이 생성되었습니다:", filename, "\n"))
}





## 🟧 Extract coordinates ===========================================================================
extract_xyz_coordinate = function(ith_atlas){
  # Get unique ROI numbers in the atlas, excluding background (0)
  roi_numbers <- unique(ith_atlas[ith_atlas > 0]) %>% sort
  
  # Store the data frame in the list
  tictoc::tic()
  roi_coordinates_list = lapply(roi_numbers, function(roi){
    # Find voxel positions for the current ROI
    voxel_coords <- which(ith_atlas == roi, arr.ind = TRUE)
    
    # Convert to a data frame
    roi_df <- as.data.frame(voxel_coords)
    
  }) %>% setNames(fit_length(roi_numbers, roi_numbers %>% max %>% nchar) %>% paste0("ROI_", .))
  tictoc::toc()
  
  return(roi_coordinates_list)
}






## 🟧 Extract BOLD =====================================================================================================
### 🟨 one volume, one atlas =========================================================================================================
extract_bold_using_atlas = function(volume,
                                    atlas = NULL, 
                                    coordinates = NULL,
                                    path_save = NULL, 
                                    file_name = NULL){
  # CRAN 미러를 변경하고 다시 설치 시도
  # chooseCRANmirror()
  if (!requireNamespace("arrow", quietly = TRUE)) {
    install.packages("arrow")
  }
  
  # Extract coordinates of each ROI
  if(is.null(coordinates)){
    coordinates = extract_xyz_coordinate(atlas)
  }
  
  # Initialize a list to store averaged BOLD signals
  tictoc::tic()
  bold_signals_df <- coordinates %>% 
    lapply(function(each_roi_coords) {
      # Extract time series data for the coordinates of the current ROI
      apply(each_roi_coords, 1, function(coord) {
      coord = coord %>% unlist
      
      # print(paste(coord[1], coord[2], coord[3], sep = "_"))
      volume[coord[1], coord[2], coord[3], ]
    }) %>% 
    # Compute the mean BOLD signal across all voxels in the ROI
    rowMeans
    }) %>% 
    do.call(rbind, .) %>% # Convert the list to a data frame
    t() %>% 
    as.data.frame() %>% 
    setNames(names(coordinates))
  tictoc::toc()
   
  tictoc::tic()
  if(!is.null(path_save) && !is.null(file_name)){
    dir.create(path_save, showWarnings = F, recursive = T)
    # file_name = paste0(file_name, ".csv")
    # write.csv(bold_signals_df, file.path(path_save, file_name))  
    # file_name = paste0(file_name, ".txt")
    # write.table(as.data.frame(bold_signals_df), file.path(path_save, file_name), row.names = F, col.names = T)
    # Feather 파일로 내보내기
    file_name <- paste0(file_name, ".feather")
    arrow::write_feather(bold_signals_df, file.path(path_save, file_name))
    
  }
  tictoc::toc()
  
  return(bold_signals_df) 
}





### 🟨 multi volume, multi atlas =========================================================================================================
# 패키지 로드
if (!requireNamespace("parallel", quietly = TRUE)) {
  install.packages("parallel")
}
library(parallel)
extract_bold_using_atlas_multi <- function(path_4d_volumes, path_save_bold, coordinates, range = NULL, use_multicore = TRUE) {
  # 모든 폴더에서 공통적으로 존재하는 RID 파일 목록 가져오기
  common_rids <- find_common_rids(path_save_bold)
  
  # 폴더 내의 파일 목록 가져오기
  files <- list.files(path_4d_volumes, full.names = TRUE)
  
  # 파일 범위 제한 옵션 적용 (range가 NULL이 아니면 해당 범위의 파일만 선택)
  if (!is.null(range)) {
    files <- files[range]
  }
  
  # 파일명에서 RID 추출 및 공통 RID 제외
  rid_files <- sapply(files, function(file) sub("^Filtered_4DVolume_RID_", "RID_", basename(file)))
  rid_files <- sapply(rid_files, function(file) sub("\\.nii$", "", file))
  
  files_to_process <- files[!rid_files %in% common_rids]
  
  # 파일에서 RID 추출
  RID <- files_to_process %>% basename() %>% str_extract("RID_\\d+")
  
  # 멀티 코어 사용 여부에 따라 다른 함수 사용
  if (use_multicore) {
    # 사용 가능한 코어 수를 확인하여 병렬 작업 준비
    num_cores <- detectCores() - 1 # 시스템에 있는 코어 수 - 1 (여유를 두기 위해)
    
    # 병렬로 BOLD 신호 추출 작업 실행
    result <- mclapply(files_to_process, function(path_ith_volume) {
      process_single_file(path_ith_volume, path_save_bold, coordinates)
    }, mc.cores = num_cores) # 병렬 코어 수 설정
  } else {
    # 단일 코어로 BOLD 신호 추출 작업 실행
    result <- lapply(files_to_process, function(path_ith_volume) {
      process_single_file(path_ith_volume, path_save_bold, coordinates)
    })
  }
  
  # NULL 값 제거 (에러 발생 파일)
  result <- result[!sapply(result, is.null)]
  
  names(result) <- RID[!sapply(result, is.null)] # 결과에 이름을 지정
  return(result)
}

# 각 파일의 BOLD 신호 추출을 처리하는 보조 함수
process_single_file <- function(path_ith_volume, path_save_bold, coordinates) {
  ith_RID <- basename(path_ith_volume) %>% str_extract("RID_\\d+")
  
  tryCatch({
    # 각 좌표 그룹에 대해 BOLD 신호를 추출하고 저장
    lapply(seq_along(coordinates), function(k) {
      extract_bold_using_atlas(
        volume = oro.nifti::readNIfTI(path_ith_volume),
        coordinates = coordinates[[k]],
        path_save = file.path(path_save_bold, names(coordinates)[k]),
        file_name = ith_RID
      )
    }) %>% setNames(names(coordinates))
    
    cat("\n", crayon::bgMagenta(ith_RID), crayon::green("is done"), "\n")
    return(ith_RID)
    
  }, error = function(e) {
    cat("\n", crayon::bgRed(ith_RID), "encountered an error:", e$message, "\n")
    return(NULL)
  })
}


### 각 atlas의 공통 RID 추출 ============================================================================================
find_common_rids <- function(path_save_bold) {
  # 모든 폴더 목록 가져오기
  atlas_folders <- list.dirs(path_save_bold, full.names = TRUE, recursive = FALSE)
  
  # 각 폴더 내 파일 목록을 저장할 리스트 생성
  file_lists <- lapply(atlas_folders, function(folder) {
    # 각 폴더의 파일 목록 가져오기 (파일 이름만)
    files <- list.files(folder, pattern = "RID_\\d+\\.feather$")
    # 파일 이름에서 RID 부분만 추출
    rid_list <- sub("\\.feather$", "", files) # ".feather" 부분 제거
    return(rid_list)
  })
  
  # 모든 폴더에 공통적으로 있는 RID 찾기
  common_rids <- Reduce(intersect, file_lists)
  
  return(common_rids)
}







## 🟧 combine files ==================================================================================================
# 각 atlas 폴더 내 feather 파일을 모두 합치고 rds 파일로 저장하는 함수
process_atlas_files <- function(base_dir, atlas_folder) {
  # atlas의 파일 경로
  folder_path <- file.path(base_dir, atlas_folder)
  
  # 해당 atlas 폴더 내 모든 feather 파일 리스트 불러오기
  feather_files <- list.files(folder_path, pattern = "*.feather", full.names = TRUE)
  
  filenames = list.files(folder_path, pattern = "*feather") %>% 
    tools::file_path_sans_ext()
  
  
  # 모든 feather 파일을 읽어와 리스트에 결합
  combined_data <- lapply(feather_files, read_feather) %>% 
    setNames(filenames)
  
  # 결합된 데이터를 .rds 파일로 저장
  saveRDS(combined_data, file.path(base_dir, paste0(atlas_folder, ".rds")))
  
  cat("\n", "Saved:", crayon::green(atlas_folder), "as RDS file.", "\n")
}

# 모든 atlas 폴더에 대해 처리하는 함수
process_all_atlases <- function(base_dir) {
  # atlas 폴더 리스트
  atlas_folders <- list.files(base_dir)
  
  # 각 atlas 폴더에 대해 feather 파일 결합 후 rds로 저장
  lapply(atlas_folders, function(atlas_folder) {
    process_atlas_files(base_dir, atlas_folder)
  })
}

