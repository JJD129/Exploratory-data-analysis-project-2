library("data.table")
library("ggplot2")
path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset SCC and NEI to get coal combustion data and combine into df
combustion <- grepl(pattern = "combust",x = SCC$SCC.Level.One,ignore.case = TRUE)
coal <- grepl(pattern = "coal",x = SCC$SCC.Level.Four,ignore.case = TRUE)
combustioncoal <- (combustion & coal)
combustionSCC <- SCC[combustioncoal,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]

# plot
png(filename = "plot4.png",width = 480, height = 480)
ggplot(data = combustionNEI, aes(factor(year), Emissions/1000)) +
  geom_bar(stat = "identity") +
  ggtitle(expression('Aggregated PM'[2.5]*' Coal Combustion Source Emissions'), subtitle = "US 1999-2008") +
  labs(x="Year", y=expression("Total PM"[2.5]*" Emission (kilotons)")
)
dev.off()

