library(tidyverse)
library(lubridate)
library(sp)
#install.packages('sf')
library(sf)
library(mapview)
#install.packages("devtools")
#devtools::install_github("16EAGLE/moveVis")
library(moveVis)
#install.packages('move2')
library(move2)
library(move)
#remove.packages("basemaps")
#.rs.restartR()
#remotes::install_github("zross/basemap-fork")
library(basemaps)
library(leaflet)
library(telemetR)

local_tz <- "EST"

fish <- telemetR::fish
setwd("C:/Users/Berlynna.Heres/OneDrive - Florida Fish and Wildlife Conservation/FACTS/FACTSData2023/RawData")

T1<- read.csv("FactsAllraw.csv")

Tags<- read.csv("C:/Users/Berlynna.Heres/OneDrive - Florida Fish and Wildlife Conservation/FACTS/HCTSTagFACTS.csv")

Recievers<- read.csv("C:/Users/Berlynna.Heres/OneDrive - Florida Fish and Wildlife Conservation/FACTS/ReceiverFACTS.csv")

crab<- format_org(Tags,
                  var_Id= "TAG_CODE_SPACE",
                  var_release = "TAG_ACTIVATION_DATE",
                  var_tag_life = "EST_TAG_LIFE",
                  var_ping_rate = "PRI",
                  local_time_zone = local_tz,
                  time_format = "%Y-%m-%d %H:%M:%S")