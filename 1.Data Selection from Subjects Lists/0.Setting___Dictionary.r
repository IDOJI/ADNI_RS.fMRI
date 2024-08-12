dic = function(col){
  path_dic = "/Users/Ido/Library/CloudStorage/Dropbox/@DataAnalysis/㊙️CommonData___ADNI___SubjectsList/DATADIC_04Apr2024.csv"
  RS.fMRI_0_Data.Dictionary(colname = col, path_Dic = path_dic, which.OS = "Mac")  
}




RS.fMRI_0_Data.Dictionary = function(colname, path_Dic = NULL, which.OS = c("Windows", "Mac")){
  # install_package("Hmisc")
  # install.packages("C:/Users/lleii/Dropbox/Github/Rpkgs/ADNIprep/ADNIMERGE/ADNIMERGE_0.0.1.tar.gz", repose = NULL, type="source")
  # install.packages("/Users/Ido/Library/CloudStorage/Dropbox/Github/Rpkgs/ADNIprep/ADNIMERGE/ADNIMERGE_0.0.1.tar.gz")
  # require(ADNIMERGE)
  #=============================================================================
  # path Setting
  #=============================================================================
  if(is.null(path_Dic)){
    which.OS = match.arg(which.OS, which.OS)
    if(which.OS == "Windows"){
      path_OS = "C:/Users/lleii/"
    }else{
      path_OS = "/Users/Ido/"
    }
    path_Dic = paste0(path_OS, "Dropbox/Github/Rpkgs/ADNIprep/Data") %>% list.files(full.names = T, pattern = "dictionary")
  }





  #=============================================================================
  # Read data
  #=============================================================================
  Dic = read.csv(path_Dic)

  colname = toupper(colname)

  selected_col = Dic %>% dplyr::filter(FLDNAME == colname)
  if(nrow(selected_col)>0){
    return(selected_col)
  }else{
    cat("\n", crayon::red("There is no such colname!"),"\n")
  }
}

