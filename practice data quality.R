#packages
install.packages("validate")
install.packages("dcmodify")
install.packages("errorlocate")
install.packages("simputation")
install.packages("rspa")


#library
library("validate")
library("dcmodify")
library("errorlocate")
library("simputation")
library("rspa")

library("zoo")
library("rts")
library("ggplot2")
library("gdata")
library("PCAmixdata")
library("EHRtemporalVariability")




filename= 'reinsurance stock price nepal.csv'
hasheader = TRUE

data=read.csv(filename,header=hasHeader,na.strings="")
data
str(data)
data[2:10]<-lapply(data[2:10],as.numeric)

dateColumn=1


# completeness of each column of the dataset

dimCompletenessByColumn <- function(repository){
  N = dim(repository)[1]
  NAmatrix <- !is.na(repository)
  sumNAmatrix <- apply(NAmatrix,2,sum)
  completenessByColumn <- round(sumNAmatrix/N*100,2)
  return(completenessByColumn)
}





dqFramework <- function(data,hasHeader,dateColumn){
  
  repository <- data
  N <- nrow(repository)
  D <- ncol(repository)
  
  
  repositoryDates <- as.Date(repository$Date)
  repository = repository[order(repositoryDates),]
  minDate = min(repositoryDates)
  maxDate = max(repositoryDates)
  dateBatches = seq(as.Date(minDate),as.Date(maxDate),by = "month")
  zooRepository <- read.zoo(repository,index.column = dateColumn)
  
  resCompletenessByColumn = apply.monthly(zooRepository, FUN=dimCompletenessByColumn)
  png("resCompletenessByColumn.png", width=900, height=1000)
  
  plot(resCompletenessByColumn, xlab = "Date", ylab = names(resCompletenessByColumn),
       main = "Completeness (%)", ylim=c(0,100), cex.lab=0.5)
  dev.off()  
  
  NAmatrix <- !is.na(repository)
  sumNAmatrix <- sum(NAmatrix)
  completenessDataSet <- round(sumNAmatrix/(N*D)*100,2)
  return(completenessDataSet)
}

#check completeness

dqFramework(data, hasHeader, dateColumn)



########################"

# validity of the dataset

rules <- validator(.file="rules.txt")  ##rules created in text to comply with data set quality
voptions(rules, lin.eq.eps=0.01)
rules[c(3,7)] # show a few examples


check<-confront(data, rules,key='Date')
summary(check)



plot(check, main='data')

modifiers <- dcmodify::modifier(.file="modifiers.txt") ##" modifiers created in text to modify the data as per rules
modifiers[c(1,4)]

data_mod <- dcmodify::modify(data, modifiers)

compare(rules, raw = data, modified=data_mod)



colSums(summary(confront(data_mod, rules))[3:5])


data_adj <- rspa::match_restrictions(data_imp, rules,adjust = is.na(data_el), weight=W, maxiter=1e4)

all(confront(data_mod, rules))

plot(compare(rules, raw= data, modified = data_mod,  how="sequential"))


plot(cells(raw= data, modified = data_mod ,  compare="sequential"))




##################


#PCAmix plot

quantidx = 2:10;
qualiidx = 1;

mca <- PCAmix(X.quanti=data[quantidx],X.quali=data[qualiidx],graph=FALSE)
png("score.png", width=800, height=800)
plot<-plot(mca,choice="ind",main="Scores")

dev.off()

data[qualiidx]



######################################




















