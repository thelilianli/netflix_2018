if("xtable" %in% rownames(installed.packages())==FALSE){install.packages("xtable",dependencies = TRUE)}
library(xtable)
if("broom" %in% rownames(installed.packages())==FALSE){install.packages("broom",dependencies = TRUE)}
library("broom")
if("purrr" %in% rownames(installed.packages())==FALSE){install.packages("purrr",dependencies = TRUE)}
library("purrr")
if("chron" %in% rownames(installed.packages())==FALSE){install.packages("chron",dependencies = TRUE)}
library("chron")
if("dplyr" %in% rownames(installed.packages())==FALSE){install.packages("dplyr",dependencies = TRUE)}
library("dplyr")
if("tidyr" %in% rownames(installed.packages())==FALSE){install.packages("tidyr",dependencies = TRUE)}
library("tidyr")
if("reshape" %in% rownames(installed.packages())==FALSE){install.packages("reshape")}
library("reshape")
if("reshape2" %in% rownames(installed.packages())==FALSE){install.packages("reshape2")}
library("reshape2")
if("package:plyr" %in% search()==TRUE){detach("package:plyr")}
if("gtools" %in% rownames(installed.packages())==FALSE){install.packages("gtools")}
library("gtools")
if("gdata" %in% rownames(installed.packages())==FALSE){install.packages("gdata")}
library("gdata")
if("data.table" %in% rownames(installed.packages())==FALSE){install.packages("data.table")}
library("data.table")
if("splitstackshape" %in% rownames(installed.packages())==FALSE){install.packages("splitstackshape")}
library("splitstackshape")
if("stringr" %in% rownames(installed.packages())==FALSE){install.packages("stringr")}
library("stringr")
if("descr" %in% rownames(installed.packages())==FALSE){install.packages("descr")}
library("descr")
if("readr" %in% rownames(installed.packages())==FALSE){install.packages("readr")}
library("readr")
if("ROCR" %in% rownames(installed.packages())==FALSE){install.packages("ROCR")}
library("ROCR")
if("ggplot2" %in% rownames(installed.packages())==FALSE){install.packages("ggplot2")}
library("ggplot2")
if("zoo" %in% rownames(installed.packages())==FALSE){install.packages("zoo")}
library("zoo")
if("stringr" %in% rownames(installed.packages())==FALSE){install.packages("stringr")}
library("stringr")
if("lubridate" %in% rownames(installed.packages())==FALSE){install.packages("lubridate")}
library("lubridate")
if("R.utils" %in% rownames(installed.packages())==FALSE){install.packages("R.utils")}
library("R.utils")
