library("data.table")
path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset to get baltimore emission data
baltimore <- subset(NEI, fips == "24510")

# aggregate balitmore emission by year
total_b_em_yr <- aggregate(Emissions ~ year, baltimore, sum)

# plot
png("plot2.png", width=480, height=480)
with(total_b_em_yr, barplot(Emissions/1000, year,
                          names.arg = year,
                          xlab = "Year",
                          ylab = "Aggregated Emissions in Baltimore (kilotons)",
                          ylim=c(0,3.5),
                          main = expression('Aggregated PM'[2.5]*' Emmissions by Year in Baltimore'),
                          col = c("blue", "red", "green", "yellow"))
)
dev.off()