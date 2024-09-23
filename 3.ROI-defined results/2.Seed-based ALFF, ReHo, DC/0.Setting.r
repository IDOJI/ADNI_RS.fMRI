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
List.list[[3]] = data_handling = c("tidyverse", "dplyr", "clipr", "tidyr", "readr", "caret", "readxl")
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
  if(is.null(coordinates)){
    coordinates = extract_xyz_coordinate(atals)
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
   
  
  if(!is.null(path_save) && !is.null(file_name)){
    dir.create(path_save, showWarnings = F, recursive = T)
    # file_name = paste0(file_name, ".csv")
    # write.csv(bold_signals_df, file.path(path_save, file_name))  
    file_name = paste0(file_name, ".txt")
    write.table(bold_signals_df, file.path(path_save, file_name), row.names = F)
  }
  
  return(bold_signals_df) 
}





### 🟨 multi volume, multi atlas =========================================================================================================
extract_bold_using_atlas_multi = function(path_4d_volumes, path_save_bold, coordinates){
  
  RID = path_4d_volumes %>% 
    list.files() %>% 
    str_extract("RID_\\d+")
  
  path_4d_volumes %>% 
    list.files(full.names = T) %>% 
    #  each volume
    lapply(function(path_ith_volume){
      
      ith_RID = basename(path_ith_volume) %>% str_extract("RID_\\d+")
      
      # each coords
      lapply(seq_along(coordinates), function(k){
        
        # Extract BOLD & save
        extract_bold_using_atlas(volume = readNIfTI(path_ith_volume),
                                 coordinates = coordinates[[k]],
                                 path_save = file.path(path_save_bold, names(coordinates)[k]),
                                 file_name = ith_RID)
        
      }) %>% setNames(names(coordinates))
      
      cat("\n", crayon::bgMagenta(ith_RID), crayon::green("is done"),"\n")
      
    }) %>% setNames(RID) # RID 형태의 문자열을 원소 이름으로
}






