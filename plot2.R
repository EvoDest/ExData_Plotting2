# Read NEI data.
NEI <- readRDS("summarySCC_PM25.rds")

# Subsetting data for Baltimore City, Maryland
NEIBaltimoreCity <- NEI[NEI$fips == "24510",]

# Aggregate NEI data by year.
NEIBaltimoreCityByYear <- aggregate(data=NEIBaltimoreCity, Emissions ~ year, FUN=sum)

# Plot of total PM2.5 emissions by year.
png("plot2.png", height=600, width=600, units="px")
with(NEIBaltimoreCityByYear, {
  dataPlot <- barplot(
    height=Emissions,
    xlab="Year",
    ylab="PM2.5 Emissions",
    main="Total PM2.5 Emissions by Year in Baltimore City, Maryland",
    names.arg=year,
    las=1,
    mgp = c(3, 0.6, 0)
  )
  text(x=dataPlot, y=Emissions, labels=ceiling(Emissions), pos=1)
})
dev.off()

# Remove all data from environment
remove(list=ls())