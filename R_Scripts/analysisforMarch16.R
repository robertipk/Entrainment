library(dplyr)
source("superscript.R")

origTable <- read.csv("correcteddata.csv",header=TRUE)
origTable$speaker = paste(origTable$speaker,origTable$letter,sep="")
origTable$letter <- NULL
head(origTable)

loudness <- subset(origTable,select=c("speaker","loudness"))
F0finEnv <- subset(origTable,select=c("speaker","F0finEnv"))
jitterLocal <- subset(origTable,select=c("speaker","jitterLocal"))
shimmerLocal <- subset(origTable,select=c("speaker","shimmerLocal"))

F0finEnv <- F0finEnv %>%  filter(F0finEnv != 0)
jitterLocal <- jitterLocal %>%  filter(jitterLocal != 0) 
shimmerLocal <- shimmerLocal %>%  filter(shimmerLocal != 0) 

loudnessAvg <- aggregate(loudness$loudness, by=list(loudness$speaker), FUN=mean)
F0finEnvAvg <- aggregate(F0finEnv$F0finEnv, by=list(F0finEnv$speaker), FUN=mean)
jitterLocalAvg <- aggregate(jitterLocal$jitterLocal, by=list(jitterLocal$speaker), FUN=mean)
shimmerLocalAvg <- aggregate(shimmerLocal$shimmerLocal, by=list(shimmerLocal$speaker), FUN=mean)


template<-read.csv("newtoplevel.csv",header=TRUE)
Avg <- select(loudnessAvg,name,loudness)
colnames(Avg)[1]<-"name"
colnames(Avg)[2]<-"loudness"
loudnessAvg$name<-lapply(loudnessAvg$name,function(x)substr(x,4,8))

template$self_feature <- apply(template,MARGIN=1,function(x)findValueSelf(Avg,x))
template$partner_feature <- apply(template,MARGIN=1,function(x)findValuePartner(Avg,x))
template$partner_diff <- apply(template,MARGIN=1,function(x)calcPartnerDifference(x))
template$nonpartner_diff <- apply(template,MARGIN=1,function(x)calcNonPartnerDifferenceMeanOfDifferences(template,x))
template$outlier<-addOutlierColumn(Avg,template)
template$normdiff <-apply(template,MARGIN=1,function(x)calcNormdiff(x))
all_ttests(template)