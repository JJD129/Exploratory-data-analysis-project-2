library("data.table")
library("ggplot2")
path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset to get baltimore emission data
baltimore <- subset(NEI, fips == "24510")
baltimore$year <- as.factor(baltimore$year)

# plot
png("plot3.png", width=480, height=480)
ggplot(data=baltimore, aes(fill = type, y=Emissions, x=year)) + 
  geom_bar(stat="identity") +
  facet_wrap(~type) +
  ggtitle(expression('Aggregated PM'[2.5]*' Emmissions by Year in Baltimore'), subtitle = "By Source Type") +
  labs(x = "Year", y = "Aggregated Emissions in Baltimore(tons)")
dev.off()
