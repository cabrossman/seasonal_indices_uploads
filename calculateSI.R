#this funciton calculates the seasonal indicies
# pvData = getGeoPortalPV(last12 = TRUE)

seasonalCalc <- function(df){
  #today I am just calculating the last 12M pct of total
  #when more data becomes available I will alter this method
  suppressMessages(library(dplyr))
  
  #calculate key
  df <- df %>% mutate(key = paste0(portal,"-",geo)) 
  #get average page views per key
  df2 <- df %>% group_by(key) %>% summarise(avgPerKey = mean(pageViews))
  #get ratio of PV in key at time t to avg pv per key
  df3 <- df %>% inner_join(df2,by="key") %>% mutate(SI = pageViews/avgPerKey, keyMon = paste0(key,"-",month)) %>%
    group_by(key,keyMon) %>% summarise(avgSIKeyMonth = mean(SI))
  #get totals per keyMon
  df4 <- df3 %>% group_by(key) %>% summarise(totSIKeyMonth = sum(avgSIKeyMonth))
  #Normalize SI
  df5 <- df3 %>% inner_join(df4, by = "key") %>% mutate(NormalizedSI = (avgSIKeyMonth*12)/totSIKeyMonth)
  #join with data
  df6 <- df %>% mutate(keyMon = paste0(key,"-",month)) %>% distinct(keyMon, portal, geo, month) %>%
    inner_join(df5, by = "keyMon") %>% select(portal, geo, month,NormalizedSI) %>% arrange(portal, geo, month)
  
  return(df6)
}
