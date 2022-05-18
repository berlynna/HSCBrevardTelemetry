#install.packages("actel")
library(actel)
library(lubridate)
library(tidyverse)

#install.packages(c("gWidgets2","gWidgets2RGtk2","RGtk2"))
library(gWidgets2)

#To use the Actel package we need a biometics, spatial, and deployment data frame, plus the actuall detections data frame

#Read in the biometrics data and clean it up
b<- read.csv("HSCTagData.csv")
biometrics<- b %>% mutate(Signal=as.numeric(gsub("A69-9007-","",Tag)),
                  Date= as.Date(Tag.Date,"%m/%d/%Y"),
                  Release.date= Date+ hours(12)+ minutes(0)+seconds(0),
                  Group="2022",
                  Release.site="Gator Creek") %>% select(Release.date,Signal,Sex,Age,Group,Release.site)

write.csv(biometrics,"biometrics.csv")


#organize the spatial data (pulled coords from Google earth)
#Some of these columns don't matter
Spatial<- data.frame("Station.name" =c("Gator Creek","487549-NE","487550-SE","487551-W"),
                     "Latitude"= c(28.627559,28.625770, 28.622297, 28.623436),
                     "Longitude"= c(-80.787070,-80.787908,-80.786255,-80.790266),
                     "Section"= c("","Max Brewer","Max Brewer","Max Brewer"),
                     "Array" =c("A","A","B","C"),
                     "Type"= c("Release","Hydrophone","Hydrophone","Hydrophone"))

write.csv(Spatial,"spatial.csv")

#organize the deployment data, not that Station.name is the same in the Spatial and Deployment Data Frames
Deployment<- data.frame("Receiver"=c("487549","487550","487551"),
                        "Station.name"=c("487549-NE","487550-SE","487551-W"),
                        "Start" = c("2022-01-25 01:00","2022-01-25 01:00","2022-01-25 01:00"),
                        "Stop" = c("2022-04-14 13:00","2022-04-14 13:00","2022-04-14 13:00"))

write.csv(Deployment,"deployments.csv")

#Read in the Receiver Data
R49<- read.csv("VR2Tx_487549_20220414.csv")
R50<- read.csv("VR2Tx_487550_20220414.csv")
R51<- read.csv("VR2Tx_487551_20220414.csv")

#Combine into one Data Frame
Detections<- rbind(R49,R50)
Detections<- rbind(Detections,R51)

Detections<- Detections %>% mutate(Timestamp= as.POSIXct(Date.and.Time..UTC.,format="%m/%d/%Y %H:%M", tz="UTC"),
                          Receiver= gsub("VR2Tx-","",Receiver),
                          CodeSpace="CodeSpace",
                          Sensor.Value="0",
                          Sensor.Unit = "X",
                          Signal=as.numeric(str_extract(Transmitter, '\\b\\w+$'))) %>% 
  select(Timestamp,Receiver,CodeSpace, Signal, Sensor.Value,Sensor.Unit)

write.csv(Detections,"detections.csv")



explore(tz="EST")
