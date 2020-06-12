library("data.table")
path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# aggregate emission by year
total_em_yr <- aggregate(Emissions ~ year, NEI, sum)

# plot
png("plot1.png", width=480, height=480)
with(total_em_yr, barplot(Emissions/1000, year,
                          names.arg = year,
                          xlab = "Year",
                          ylab = "Aggregated Emissions (kilotons)",
                          ylim = c(0,8000),
                          main = expression('Aggregated PM'[2.5]*' Emmissions by Year'),
                          col = c("blue", "red", "green", "yellow"))
)
dev.off()