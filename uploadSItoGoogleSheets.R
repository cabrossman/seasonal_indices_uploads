#this downloads data, calculates seasonal indicies and uploads to google sheets
suppressMessages(require('googlesheets'))
suppressMessages(require(optigrab))

##source all functions in folder to support this running file
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
print(paste0("The current directory: ",this.dir))
file.sources = list.files(this.dir,pattern = "*.R")
print(paste0("The current files in this directory: ",paste(file.sources, collapse = ", ")))

this_file_full_path <- this_file()
currentFileName <- gsub(paste0(this.dir,"/"),"",this_file_full_path)
print(paste0("The current files name: ",currentFileName))

file.sources <- file.sources[! file.sources %in% currentFileName]
for(i in 1:length(file.sources)){
  source(paste0(this.dir,'/',file.sources[i]))
  print(paste0("sourced: ", paste0(this.dir,'/',file.sources[i])))
}
print("..........................")
#download PV data per geo per month
pvData <- getGeoPortalPV()
#calculate SI
seasonal_indices <- seasonalCalc(pvData)
#writeCSV then upload to google sheets
write.csv(seasonal_indices,"seasonal_indices.csv",row.names = FALSE)
gs_upload("seasonal_indices.csv",verbose = FALSE)