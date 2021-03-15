library("validate")

filename= 'reinsurance stock price nepal.csv'
hasheader = TRUE

data=read.csv(filename,header=hasHeader,na.strings="")
data

data$Date=as.Date(data$Date)
typeof(data$Date)



###################


rules<-validator( data[2:8]>0,
                  data$Max.Price>data$Min.Price,
                  all_unique(data$Date),
                  data$Min.Price<data$Max.Price,
                  data$Closing.Price-data$Prev..Closing==data$Difference.Rs.,
                  if (data$No.of.Transactions==0)data$Traded.Shares==0,
                  if (data$No.of.Transactions==0)data$Total.Amount==0,
                  X..Change==(Difference.Rs./Prev..Closing)*100
                   )



help("export_yaml")

export_yaml(rules,'rules.txt')

