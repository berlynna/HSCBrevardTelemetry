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

setwd("C:/Users/Berlynna.Heres/OneDrive - Florida Fish and Wildlife Conservation/FACTS/FACTSData2023/RawData")

T1<- read.csv("FactsAllraw.csv")

T1<- T1 %>% mutate(TagName= sub("^([^-]*-){2}", "", tagname))
T2 <- T1 %>% mutate(timestamp= ymd_hms(datecollected)) %>% distinct(timestamp, .keep_all = TRUE)%>% 
  filter(!longitude == -44.71258)%>% mutate(coords.x1= longitude, coords.x2 = latitude, trackId=as.numeric(TagName))%>%
  #arrange(trackId) %>% mutate(trackId=as.character(TagName))%>%
  dplyr::select(coords.x1,coords.x2,timestamp,trackId)

#Weird <- T1 %>% mutate(Timestamp= ymd_hms(datecollected)) %>% distinct(Timestamp, .keep_all = TRUE) %>% 
#  filter(longitude == -44.71258)

#write.csv(Weird, "WeirdPing.csv")


T3<-df2move(T2,proj = "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",
        x= "coords.x1", y= "coords.x2", time = "timestamp", track_id = "trackId")#, package = "moveVis") # move class object

#T3_1<- as.data.frame(T3)


# align move_data to a uniform time scale
m <- align_move(T3, res ="mean")# 4, unit = "hours")##

#view_spatial(T3)
ext <- extent(-80.831111, -80.712842, 28.518806, 29.907769)

#view_spatial(m)
#get_maptypes()

# create spatial frames with a OpenStreetMap watercolour map
frames <- frames_spatial(m, map_service = "carto",# "mapbox", 
                         map_type = "voyager_no_labels",#"satellite",
                         #map_token= "pk.eyJ1IjoiYmVybHlubmEiLCJhIjoiY2xyaHc2dHpmMDBjODJpbGEyZnFtODF3cCJ9.bwibF3MUXuV_g62bLZcKIg",
                         #alpha = 1.5,
                         path_colours = c("red","blue4","orangered",
                                          "mediumturquoise","orange",
                                          "greenyellow","darkmagenta",
                                          "tomato1","lightgoldenrod",
                                          "aquamarine","darkolivegreen",
                                          "forestgreen","plum1",
                                          "yellow"),
                         #path_colours = "hotpink",
                         path_legend = T,
                         path_legend_title = "Horseshoe Crab",
                         tail_colour = "white", tail_size = 0.8,
                         trace_show = T, trace_colour = "white", 
                         ext= ext,
                         equidistant = T) %>% 
  add_labels(x = "Longitude", y = "Latitude") %>% # add some customizations, such as axis labels
  add_northarrow(position= "upperright") %>% 
  add_scalebar() %>% 
  add_timestamps(type = "label") %>% 
  add_progress()





frames[[15]]

#Add a marker release location marker

#Closerelease <- data.frame(x = c(-80.787193,-80.786970,-80.787240,-80.787001,-80.787070),
#                   y = c(28.627734,28.627683,28.627605,28.627539,28.627662))

#WideRelease <- data.frame(x = c(-80.787575,-80.785549,-80.786751,-80.789045,-80.787575),
#                           y = c( 28.628232,  28.627273,   28.625778,  28.626800, 28.628232))

# just customize a single frame and have a look at it
#frames<- add_gg(frames1, gg= expr(geom_path(aes(x = x, y = y, group= 1), data = WideRelease,
#                                       colour = "black", linetype = "dashed")))

#frames<- add_text(frames1, "Release Site", x=-80.787105, y= 28.631976, colour= "black", size= 3)
frames<- add_text(frames, "Release Site", x = -80.787828, y =   28.629200,
           colour = "black", size = 3)


Recievers= data.frame(x = c(-80.78791,-80.79027,-80.78626,-80.72292,-80.72826,-80.80634,-80.76361,-80.73440),
                      y = c( 28.62577,28.62344,28.62230,28.59513,28.59366,28.64989,	28.52824,28.40443))


frames<- add_gg(frames, gg= expr(geom_point(aes(x= x, y= y),data= Recievers, color= "navy", size = 2)))



frames[[15]]


# animate frames
animate_frames(frames,out_file = "AllCrab.gif", overwrite = TRUE)

  