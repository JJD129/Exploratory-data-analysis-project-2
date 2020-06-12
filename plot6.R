library("data.table")
library("ggplot2")
path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources
# in Los Angeles County, California (\color{red}{\verb|fips == 06037|}fips == 06037). Which city has 
# seen greater changes over time in motor vehicle emissions?

# subset SCC and NEI to get motor vehicle data and combine into df
MV <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
MVSCC <- SCC[MV,]$SCC
MVNEI <- NEI[NEI$SCC %in% MVSCC,]
baltimoreMV_NEI <- MVNEI[MVNEI$fips==24510,]
baltimoreMV_NEI$city <- "Baltimore City"
LA_MV_NEI <- MVNEI[MVNEI$fips=="06037",]
LA_MV_NEI$city <- "Los Angeles County"
bothNEI <- rbind(baltimoreMV_NEI,LA_MV_NEI)

# plot
png(filename = "plot6.png",width = 480, height = 480)
ggplot(data= bothNEI, aes(fill = year, y=Emissions, x=as.factor(year))) + 
  geom_bar(stat="identity") +
  facet_wrap(~city) +
  ggtitle(expression('Aggregated PM'[2.5]*' Emmissions by Year in Baltimore'), subtitle = "By Motor Vehicle") +
  labs(x = "Year", y = "Aggregated Emissions in Baltimore(tons)"
  )
dev.off()
