library(tidyverse)
library(readxl)

args <- commandArgs()
input_file <- args[1]
bridge_name <- args[2]
bikecounts <- read_excel(input_file,        #path - the path to the input excel file
                         sheet=bridge_name, #name/number of the sheet, it uses name of the bridge
                         skip=1)            #since each worksheet has a two-row header, skip the first row
#names(bikecounts) <- c("date", "westbound", "eastbound", "total")
bikecounts$bridge <- bridge_name

head(bikecounts)
