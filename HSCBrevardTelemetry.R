#Use the Actel package to analyze the HSC telemetry data,
#this package works better with arrays that move in a linear direction
#but we can still use a lot of the tools for our study

#install.packages("actel")
#install.packages("lubridate")
#install.packages("tidyverse")
#install.packages("gWidgets2")
library(actel)
library(lubridate)
library(tidyverse)
library(gWidgets2)

#To use the Actel package we need a biometics, spatial, and deployment data frame, plus the actual detection data frame

#Read in the biometrics data and clean it up
b<- read.csv("HSCTagData.csv")
biometrics<- b %>% mutate(Signal=as.integer(gsub("A69-9007-","",Tag)),
                  Date= as.Date(Tag.Date,"%m/%d/%Y"),
                  Release.date= Date+ hours(12)+ minutes(0)+seconds(0),
                  Group="2022",
                  Release.site="GatorCreek") %>% select(Release.date,Signal,Sex,Age,Group,Release.site)




#Organize the spatial data (pulled coords from Google earth)
#Some of these columns don't matter it depends on the analysis
spatial<- data.frame("Station.name" =c("GatorCreek","487549-NE","487550-SE","487551-W"),
                     "Latitude"= c(28.627559,28.625770, 28.622297, 28.623436),
                     "Longitude"= c(-80.787070,-80.787908,-80.786255,-80.790266),
                     "Section"= c("","MaxBrewer","MaxBrewer","MaxBrewer"),
                     "Array" =c("A","A","B","C"),
                     "Type"= c("Release","Hydrophone","Hydrophone","Hydrophone"))



#organize the deployment data, not that Station.name is the same in the Spatial and Deployment Data Frames
deployments<- data.frame("Receiver"=c("487549","487550","487551"),
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

#Create the spatial.dot file rather than reading in the spatial.txt
#This represents all the ways the horseshoe crab can move through the receivers
dot<-
  "A -- B -- C
A -- C -- B
B -- A -- C
B -- C -- A
C -- A -- B
C -- B -- A
A -- B
B -- A
A -- C
C -- A
B -- C
C -- B
"

#put all the data into a datapack that can be run in explore, migration,or residency analysis
#this is easier than creating individual csv files for each element. 

x <- preload(biometrics = biometrics, spatial = spatial, deployments = deployments, 
             detections = detections, dot=dot, tz = "EST")


#check Explore first to get an idea of how the data looks

explore(datapack = x,report = TRUE, 
        auto.open = TRUE)

#check Migration

migration(datapack = x,report = TRUE, 
          auto.open = TRUE)


#check Residency, still cant figure out the error
#residency(datapack = x,report = TRUE, 
#          auto.open = TRUE)


