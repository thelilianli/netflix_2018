#clear environment
rm(list=ls()) ; options(java.parameters = c("-XX:+UseConcMarkSweepGC", "-Xmx4g")); 

##########################################################################################
# initializing
##########################################################################################

# determining the latest scripts to call
f <- paste0("C:/Users/theli/Documents/git/netflix_2018/")

# inputs data folder
d <- paste0(f,"Inputs/")

# code directory path
s <- paste0(f,"Scripts/")
latest_s <- paste0("C:/Users/theli/Documents/git/Lib_Helpers/")

# Helpers
source(paste0(s,"_lib.R")) #reading libraries
source(paste0(latest_s,"helper_func.R"))
source(paste0(latest_s,"helper_unpac.R"))


# output folder
oPath <- paste0(f,"Outputs/")
dir.create(oPath)
oPath <- paste0(oPath,"run 1/")
dir.create(oPath)

##########################################################################################
# reading in raw data
##########################################################################################  

fulldata <- fread(paste0(d,"netflix_titles.csv"))
fulldata <- as.data.frame(fulldata)
names(fulldata)
nrow(fulldata)

# checking data fields
sort(sapply(fulldata, function(x) round(sum(is.na(x)|(x %in% ""))/nrow(fulldata),2)), decreasing = TRUE) # checking for unreliable attributes
sort(sapply(fulldata, function(x) length(unique(x))), decreasing = TRUE) # checking for useless factors

# View(ftable(fulldata$show_id))#current dataset is unique on show id
fulldata <- fulldata[!duplicated(fulldata$show_id),]# dedupping anyways for good measure
# unique(fulldata$listed_in)#many in one field - needs to be broken down
# unique(fulldata$country)#many in one field - needs to be broken down


##########################################################################################
# data cleaning
##########################################################################################  
# split, melt, merge (done outside the function)
smm <- function(df, fid, fs){
  # this function takes in a dataset and field and performs split, melt
  # df - dataset
  # fs - field in dataset with combined values that need to be split
  # fid - id field in dataset used to merge back to original dataset
  # if fs contains multiple values, resulting dataset will be  
  df0 <- fulldata[,c(fid,fs)]
    fs_dat <- data.frame(do.call('rbind', strsplit(as.character(df0[[fs]]), ',', fixed=TRUE))) #separating field
    names(fs_dat) <- gsub("X","fs",names(fs_dat))#just keeping the names
  
  # splitting field in table
  df0 <-separate(df0, fs,into = names(fs_dat),sep = ",",remove = TRUE)# using the names to define separated column names and transform fulldata
  
  df0 <- melt(data = df0, id.vars = fid, variable_name = paste0(fs,"_scount"), na.rm = TRUE)
  df0 <- df0[!(df0$value %in% ""),]#removing missing
  df0$value <- trimws(df0$value)
  df0[[paste0(fs,"_scount")]] <- as.numeric(gsub("fs","",df0[[paste0(fs,"_scount")]]))
  names(df0)[names(df0) %in% "value"] <- paste0(fs,"_svalue")
  
  return(df0)
}
  
fulldata_country <- smm(fulldata,"show_id","country")
fulldata_country <- fulldata_country[!duplicated(fulldata_country),]
nrow(fulldata_country)/length(unique(fulldata_country$show_id)) 
# each show on avg is avail in 1 country
fulldata_category <- smm(fulldata,"show_id","listed_in")
fulldata_category <- fulldata_category[!duplicated(fulldata_category),]
nrow(fulldata_category)/length(unique(fulldata_country$show_id)) 
# each show on avg fall into 2 categories

fulldata <- merge.data.frame(fulldata,fulldata_country,by = "show_id",all.x = TRUE)
nrow(fulldata)

fulldata <- merge.data.frame(fulldata,fulldata_category,by = "show_id",all.x = TRUE)
nrow(fulldata)

fulldata <- fulldata[!duplicated(fulldata),]# dedupping anyways for good measure
fulldata <- fulldata[!(fulldata$country_svalue %in% c("",NA)),]# dedupping anyways for good measure
fulldata <- fulldata[!(fulldata$listed_in_svalue %in% c("",NA)),]# dedupping anyways for good measure

# View(ftable(fulldata$listed_in_svalue))
# View(ftable(fulldata$country_svalue))


# fwrite(as.data.frame((ftable(fulldata$listed_in_svalue))),paste0(oPath,"preferences.csv"))
fwrite(fulldata,paste0(oPath,"netflix_tableau.csv"))

##########################################################################################
# calculated fields
##########################################################################################  
# sum(fulldata$date_added %in% c(NA,""))#19
fulldata$date_added <- as.Date(trimws(fulldata$date_added),"%B %d, %Y")
# head(fulldata$date_added)
# head(as.Date(trimws(fulldata$date_added),"%B %d, %Y"))
# sum(is.na(fulldata$date_added1))#19
# View(fulldata$date_added[is.na(fulldata$date_added1)])
fulldata <- fulldata[!is.na(fulldata$date_added),]#removing the records with no date added

##########################################################################################
# supplementary datasets 
##########################################################################################  

# layer in my own preferences

  pdat <- fread(paste0(d,"preferences.csv"))
  pdat <- as.data.frame(pdat)
  # names(pdat)
  # nrow(pdat)
  fulldata <- merge.data.frame(fulldata,pdat,by.x = "listed_in_svalue",by.y = "Var1",all.x = TRUE)
  nrow(fulldata)

# imdb data / ratings - scraped TV and movies separately
  rdat <- fread(paste0(d,"netflix_rottent.csv"))
  rdat <- as.data.frame(rdat)
  names(rdat)
  nrow(rdat)
  rdat <- rdat[!duplicated(rdat$show_id),]
  fulldata <- merge.data.frame(fulldata,rdat,by = "show_id",all.x = TRUE)
  nrow(fulldata)
# plotlines to avoid in description? NLP?

fwrite(fulldata,paste0(oPath,"netflix_tableau.csv"))

##########################################################################################
# next steps - would be great if data was live 
##########################################################################################  
# layer in my watched list and personal ratings
# layer in other user ratings - implement item-based collab model to reconmend movies/shows for myself
# notify via email/sms especially with new titles added fitting my preferences
# in reality though ... I don't need to be spending more time watching TV
