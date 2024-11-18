library(pacman)
p_unlock(lib.loc= p_path())
library(tidyverse)
library(lubridate)
library(remotes)
library(glatos)


#Analyze the HSC Telemetry data using the Glatos package

VRLData<- system.file("extdata",
                      "G:/Groups/Crustacean/Horseshoe crab/Projects/Brevard Telemetry/Data/Vue offload 6.06.22/VR2Tx-RLD_487549_20220606_1.vrl",
                      package = "glatos")


vrl2csv(dirname(VRLData),FALSE)

vrl2csv(vrl = "C:/Users/Berlynna.Heres/Desktop/VR2Tx-RLD_487549_20220606_1",
        outDir = "VRLFilesToCSV",
        vueExePath ="C:/Users/Berlynna.Heres/Desktop")