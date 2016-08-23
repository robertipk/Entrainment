fdrtest <- function(pvec){
  psort <- sort(pvec)
  res <- NULL
  for (i in 1:length(pvec)){
    res<-c(res,pvec[i] < match(pvec[i],psort)*.05/length(pvec))
  }
  res
}3
