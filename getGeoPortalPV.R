getGeoPortalPV = function(last12 = FALSE){
  
  print("making site cat connections")
  
  suppressMessages(library(RSiteCatalyst))
  suppressMessages(library(stringr))
  key = "christopher.brossman:Dominion Enterprises"
  secret = "a12552cbea82f242e0f93f2317fb0516"
  SCAuth(key = key, secret = secret)

  print('downloading reports')
  reportS <- GetReportSuites()
  report_Suite <- 'demidas'
  
  print('downloading elements')
  elements <- GetElements(report_Suite)
  # evars <- GetEvars(report_Suite)
  # props <- GetProps(report_Suite)
  # metrics <- GetMetrics(report_Suite)
  print('downloading elements')
  segments <- GetSegments(report_Suite)
  #usefule segments
  
  geoSegments <- segments[grepl('geographical area',segments$name, ignore.case = TRUE),1:2]
  portals <- c('Portal - YachtWorld','Portal - Boat Trader Online', 'Portal - boats.com')
  portalSegments <- segments[segments$name %in% portals,1:2]
  
  
  
  print("downloading site cat reports")
  allData <- NULL
  cnt = 1
  # for(i in 1:length(usefulSegments$id)){
  for(i in 1:nrow(portalSegments)){
    for(j in 1:nrow(geoSegments)){
      
      tempDat = NULL
      
      print(paste0(cnt," of ",nrow(portalSegments)*nrow(geoSegments)))
      
      #get data for all months page views for geography-portal combination
      report <- QueueOvertime(reportsuite.id= report_Suite,
                              date.from = as.Date('2015-07-01'), 
                              date.to = Sys.Date()-1,
                              metrics = "pageviews",
                              date.granularity = "month",
                              segment.id= c(geoSegments[j,1],portalSegments[i,1]),
                              interval.seconds=20,
                              max.attempts=60
                              
      )
      
      #remove last value as this wil be a partial month
      report <- head(report,NROW(report$name) - 1)
      
      if(last12){
        report <- tail(report, 12)
      }
      
      
      tempDat = cbind.data.frame(portal = portalSegments$name[i], geo = geoSegments$name[j], date = report$datetime, 
                                 YM = paste0(report$year,'-',str_pad(report$month,2,"left", 0)), 
                                 year = report$year, month = report$month, day = report$day,
                                 pageViews = report$pageviews)
      
      allData = rbind(allData, tempDat)
      cnt = cnt + 1
      
    }
  }
  
  
  return(allData)
}
