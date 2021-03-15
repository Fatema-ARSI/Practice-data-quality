library("dcmodify")

filename= 'reinsurance stock price nepal.csv'
hasheader = TRUE

data=read.csv(filename,header=hasHeader,na.strings="")
data




# unit of measure errors

modifiers<-modifier(if(!all_unique(Date)) data<-unique(data),
                    
                    if (  Closing.Price-Prev..Closing!= Difference.Rs.) Difference.Rs. <- Closing.Price-Prev..Closing,
                    if (  No.of.Transactions==0) Traded.Shares <- 0,
                    
                    if ( No.of.Transactions==0) Total.Amount <- 0,
                    
                    
                    if ( X..Change!=(Difference.Rs./Prev..Closing)*100) X..Change<-round(((data$Difference.Rs./data$Prev..Closing)*100),digit=2),
                    
                    if ( Difference.Rs.!=Closing.Price-data$Prev..Closing) Difference.Rs. <- Closing.Price-data$Prev..Closing
                    )
                    



export_yaml(modifiers,'modifiers.txt')
     