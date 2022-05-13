install.packages("remotes")

library(remotes) 
install_url("https://gitlab.oceantrack.org/GreatLakes/glatos/-/archive/master/glatos-master.zip",
            build_opts = c("--no-resave-data", "--no-manual"))


library(glatos)

R49<- read.csv("VR2Tx_487549_20220414.csv")
R50<- read.csv("VR2Tx_487550_20220414.csv")
R51<- read.csv("VR2Tx_487551_20220414.csv")

unique(R49$Transmitter)
Detections<- rbind(R49,R50)
Detections<- rbind(Detections,R51)

Spatial<- data.frame("Station.name" =c("487549-NE","487550-SE","487551-W","Release Site"),
                     "Latitude"= c(28.625770, 28.622297, 28.623436,28.627559),
                     "Longitude"= c(-80.787908,-80.786255,-80.790266,-80.787070),
                     "Section"= c("Max Brewer","Max Brewer","Max Brewer","Max Brewer"),
                     "Array" =c("A1","A1","A1","A1"),
                     "Type"= c("Hydrophone","Hydrophone","Hydrophone","Release"))

Deployment<- data.frame("Receiver"=c("VR2Tx_487549","VR2Tx_487550","VR2Tx_487551"),
                        "Station.name"=c("487549-NE","487550-SE","487551-W"),
                        "Start" = c("2022-01-13 13:00","2022-01-13 13:00","2022-01-13 13:00"),
                        "Stop" = c("2022-05-13 13:00","2022-05-13 13:00","2022-05-13 13:00"))


