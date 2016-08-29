uploadFileToKeboolaFTP <- function(folder,fname = NA){
  
  suppressMessages(library(RCurl))
  
  host <- 'ftp.cloudgates.net'
  user <- 'gate-vuxiss'
  password <- '1sS6rE6vzFsQ'
  
  if(is.na(fname)){
    files <- list.files(folder)
    
    for(i in 1:length(files)){
      print(paste0(i," of ",length(files)))
      ftpText <- paste0('ftp://',user,':',password,'@',host,'/',files[i])
      filepath <- paste0(folder,"/",files[i])
      ftpUpload(filepath, ftpText)
    }
    
  } else {
    ftpText <- paste0('ftp://',user,':',password,'@',host,'/',fname)
    filepath <- paste0(folder,"/",fname)
    ftpUpload(filepath, ftpText)
  }
  

}

