findValueSelf <- function(dataset, row){
	sub<-dataset %>% filter(name==row["participant"])
		return (sub[1,2])
}

findValuePartner <- function(dataset, row){
	sub<-dataset %>% filter(name==row["partner"])
		return (sub[1,2])
}

calcPartnerDifference <- function(row){
       difference<- abs(as.numeric(row["self_feature"])-as.numeric(row["partner_feature"]))
       return(difference)

}


findDifference<-function(valOne,row)
{
  val1=as.numeric(valOne)
  val2=as.numeric(as.character(row["self_feature"]))
  return (abs(val1-val2))
}

calcNonPartnerDifferenceMeanOfDifferences<- function(dataset,row)
{
  self_mean = row["self_feature"]
  nonpartners<- dataset %>%
    filter(num != row["num"]) %>%
    filter(num != row["partner_num"])%>%
    filter(gender==row["partner_gender"])
    #take absolute difference of self_mean and the self_feature value of each row
    differences<-apply(nonpartners,MARGIN=1,function(x)findDifference(valOne=self_mean,x))
    return(mean(differences[1]))
}

calcNonPartnerDifferenceDifferenceInMeans<- function(dataset,row)
{
  nonpartners<- dataset %>%
    filter(num != row["num"]) %>%
    filter(num != row["partner_num"])%>%
    filter(gender==row["partner_gender"])
  nonpartnermean = mean(nonpartners[["self_feature"]])
  result <- abs(nonpartnermean-as.numeric(row["self_feature"]))
  return(result)
}




# Find outliers for a feature X
# Finding cut-off values for top 100, top 50, bottom 100, bottom 50

findBoundaries <-function(feature_table){
	sorted_features <- sort(feature_table[,2], decreasing = TRUE)
	size <- length(sorted_features)
	outlier_boundaries = data.frame(top50 = numeric(1),top100 = numeric(1), bottom100 = numeric(1), bottom50 = numeric(1))
	outlier_boundaries$top50 <- sorted_features[50]
	outlier_boundaries$top100 <- sorted_features[100]
	outlier_boundaries$bottom100 <- sorted_features[size-100]
	outlier_boundaries$bottom50 <- sorted_features[size-50]
	return(outlier_boundaries)
}

labelOutliers<- function(outlier_boundaries,row)
{

       if ( row["self_feature"] > outlier_boundaries["top50"] ){
	type = "vhigh"
	return (type)
       }
       else if (row["self_feature"] >= outlier_boundaries["top100"] && row["self_feature"] < outlier_boundaries["top50"] ){
	type = "high"
	return (type)
       }
       else if (row["self_feature"] >  outlier_boundaries["bottom50"] &&  row["self_feature"] <=  outlier_boundaries["bottom100"]){
	type = "low"
	return (type)
       }
         else if (row["self_feature"] <= outlier_boundaries["bottom50"]){
	type = "vlow"
	return (type)
       }
         else{
		type = "no"
            return (type)
	}
}

addOutlierColumn <- function(feature_table, template){
	boundaries <- findBoundaries(feature_table)
	outlier_column<-apply(template,MARGIN=1,function(x) labelOutliers(outlier_boundaries=boundaries,x))
	return(outlier_column)
}

calcNormdiff<-function(row)
{
      partner_diff = as.numeric(unlist((row["partner_diff"])))
	nonpartner_diff = as.numeric(unlist((row["nonpartner_diff"])))
	return(partner_diff/nonpartner_diff)
}

genTopLevelTable<-function(template,feature_table){
	template$self_feature<-apply(template,MARGIN=1,function(x) findValueSelf(dataset=feature_table,x))
	template$partner_feature<-apply(template,MARGIN=1,function(x) findValuePartner(dataset=template,x))
	template$partner_diff<-apply(template,MARGIN=1,function(x)calcPartnerDifference(x))
	template$nonpartner_diff<- apply(template,MARGIN=1,function(x) calcNonPartnerDifferenceMeanOfDifferences(dataset=template,x))
	template$outlier <- addOutlierColumn(loudness,t)
	template$normdiff <- apply(template,MARGIN=1,function(x)calcNormdiff(x))
	return(template)
}


runTtest<-function(num,table){
	if(num==1){
	  one<-table%>%filter(grepl("high",outlier))
	}else if(num==2){
	  one<-table%>%filter(grepl("vhigh",outlier))
	}else if(num==3)
	  one<-table%>%filter(grepl("low",outlier))
	else if(num==4){
	  one<-table%>%filter(grepl("vlow",outlier))
	}else if(num==5){
	  one<-table%>%filter(grepl("low|high",outlier))
	}
	 else if(num==6){
	 one<-table%>%filter(grepl("vhigh|vlow",outlier))
	 }
	two<-table%>%filter(grepl("no",outlier))
	results=t.test(one$normdiff,two$normdiff)
	return(results)
	}

print_to_table <-function(one,two,three,four,five,six,table){
	table[nrow(table)+1,]<-c(one$null.value,one$statistic,one$p.value)
	table[nrow(table)+1,]<-c(two$null.value,two$statistic,two$p.value)
	table[nrow(table)+1,]<-c(three$null.value,three$statistic,three$p.value)
	table[nrow(table)+1,]<-c(four$null.value,four$statistic,four$p.value)
	table[nrow(table)+1,]<-c(five$null.value,five$statistic,five$p.value)
	table[nrow(table)+1,]<-c(six$null.value,six$statistic,six$p.value)
	write.table(table,"ttestresults.csv")
	return(table)
}

# Adds results of t-tests to table as a new column
all_ttests<-function(table){

	results_table = data.frame(difference = numeric(),tstatistic = numeric(), pvalue = numeric())
	one = runTtest(1,table)
	two = runTtest(2,table)
	three = runTtest(3,table)
	four = runTtest(4,table)
	five = runTtest(5,table)
	six = runTtest(6,table)
	results_table <- print_to_table(one,two,three,four,five,six,results_table)

	return(results_table)
}
