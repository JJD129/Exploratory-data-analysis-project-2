library("data.table")
library("ggplot2")
path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset SCC and NEI to get motor vehicle data and combine into df
MV <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
MVSCC <- SCC[MV,]$SCC
MVNEI <- NEI[NEI$SCC %in% MVSCC,]
baltimoreMV_NEI <- MVNEI[MVNEI$fips==24510,]

# plot
png(filename = "plot5.png",width = 480, height = 480)
ggplot(data=baltimoreMV_NEI, aes(fill = year, y=Emissions, x=as.factor(year))) + 
  geom_bar(stat="identity") +
  ggtitle(expression('Aggregated PM'[2.5]*' Emmissions by Year in Baltimore'), subtitle = "By Motor Vehicle") +
  labs(x = "Year", y = "Aggregated Emissions in Baltimore(tons)"
)
dev.off()
