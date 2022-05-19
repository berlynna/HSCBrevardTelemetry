#Use the Actel package to analyze the HSC telemetry data,
#this package works better with arrays that move in a linear direction
#but we can still use a lot of the tools for our study

#install.packages("actel")
library(actel)
library(lubridate)
library(tidyverse)
#install.packages(c("gWidgets2","gWidgets2RGtk2","RGtk2"))
library(gWidgets2)

#To use the Actel package we need a biometics, spatial, and deployment data frame, plus the actual detection data frame

#Read in the biometrics data and clean it up
b<- read.csv("HSCTagData.csv")
biometrics<- b %>% mutate(Signal=as.integer(gsub("A69-9007-","",Tag)),
                  Date= as.Date(Tag.Date,"%m/%d/%Y"),
                  Release.date= Date+ hours(12)+ minutes(0)+seconds(0),
                  Group="2022",
                  Release.site="Gator Creek") %>% select(Release.date,Signal,Sex,Age,Group,Release.site)




#Organize the spatial data (pulled coords from Google earth)
#Some of these columns don't matter it depends on the analysis
spatial<- data.frame("Station.name" =c("Gator Creek","487549-NE","487550-SE","487551-W"),
                     "Latitude"= c(28.627559,28.625770, 28.622297, 28.623436),
                     "Longitude"= c(-80.787070,-80.787908,-80.786255,-80.790266),
                     "Section"= c("","Max Brewer","Max Brewer","Max Brewer"),
                     "Array" =c("GC","GC","GC","GC"),
                     "Type"= c("Release","Hydrophone","Hydrophone","Hydrophone"))



#organize the deployment data, not that Station.name is the same in the Spatial and Deployment Data Frames
deployment<- data.frame("Receiver"=c("487549","487550","487551"),
                        "Station.name"=c("487549-NE","487550-SE","487551-W"),
                        "Start" = c("2022-01-25 01:00","2022-01-25 01:00","2022-01-25 01:00"),
                        "Stop" = c("2022-04-14 13:00","2022-04-14 13:00","2022-04-14 13:00"))



#Read in the Receiver Data
R49<- read.csv("VR2Tx_487549_20220414.csv")
R50<- read.csv("VR2Tx_487550_20220414.csv")
R51<- read.csv("VR2Tx_487551_20220414.csv")

#Combine into one Data Frame
Detections<- rbind(R49,R50)
Detections<- rbind(Detections,R51)

detections<- Detections %>% 
  mutate(Timestamp= as.POSIXct(Date.and.Time..UTC.,format="%m/%d/%Y %H:%M", tz="UTC"),
                          Receiver= gsub("VR2Tx-","",Receiver),
                          CodeSpace="A69-9007",
                          Sensor.Value="0.5",
                          Sensor.Unit = "X",
                          Signal=as.numeric(str_extract(Transmitter, '\\b\\w+$'))) %>% 
  select(Timestamp,Receiver,CodeSpace, Signal, Sensor.Value,Sensor.Unit)



x <- preload(biometrics = biometrics, spatial = spatial, deployments = deployments, 
             detections = detections, tz = "EST")


results<- explore(datapack = x, report= TRUE, auto.open= TRUE)

explore(tz="EST",report = TRUE, 
        auto.open = TRUE)

residency(tz="EST",report = TRUE, 
          auto.open = TRUE)





#Create the spatial.txt file rather than reading in the spatial.txt

#dot<-
#  "A -- B -- C
#A -- C -- B
#B -- A -- C
#B -- C -- A
#C -- A -- B
#C -- B -- A
#A -- B
#B -- A
#A -- C
#C -- A
#B -- C
#C -- B
#"
#x <- preload(biometrics = biometrics, spatial = spatial, deployments = deployments, 
#             detections = detections, dot= dot, tz = "EST")
#write.csv(deployment,"deployments.csv")
#write.csv(detections,"detections.csv")
#write.csv(spatial,"spatial.csv")
#write.csv(biometrics,"biometrics.csv")