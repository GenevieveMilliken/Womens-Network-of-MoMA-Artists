#bring data into R as an object. File path is relative to your computer and file location.
data <- read.csv("YOURCSV.csv")

#head function allows you to view the first few rows of data 
head(data)    

#create a data frame 
data <- data.frame(data)

#transpose data into one vector so it can be co-related
tdata <- t(data)

#check the first few rows of the transposed data to see if it looks okay 

head(tdata)

#Create a list to hold value of pairs
edges <- list()

#Iterate a grid expansion over the number of columns in the dataset, pairing all values of the first column with each other, then proceeding to the next column and appending results to the list object.
for (i in 1:ncol(tdata)) { edges[[i]] <- expand.grid(tdata[,i],tdata[,i]) }

#transform the text listed in edges into genuine edgelist data using a row bind 
edgelist <- do.call(rbind,edges)

#set any blanks in your data to NA (if they occur)
edgelist[edgelist==""] <- NA

#remove any rows with NAs
edgelist <- na.omit(edgelist)

#Remove self-references, if they occur (i.e. when source and target are the same)
edgelist <- subset(edgelist, Var1!=Var2)

#add new row called Count and sets it to 1
edgelist["Count"] <- 1

#use head function to make sure everything looks correct
head(edgelist)

#create a weighted edge list by adding together all matching source and target edges 
weighted <- aggregate(edgelist$Count, by=list(source=edgelist$Var1, target=edgelist$Var2), FUN = sum)

#write out weighted edgelist as a CSV. Make sure to use a unique file name so you do not overwrite your original file!
write.csv(weighted,"YOURCSV_NETWORK.csv")

