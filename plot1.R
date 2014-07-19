# Read NEI data.
NEI <- readRDS("summarySCC_PM25.rds")

# Aggregate NEI data by year.
NEIByYear <- aggregate(data=NEI, Emissions ~ year, FUN=sum)

# Plot of total PM2.5 emissions by year.
png("plot1.png", height=500, width=600, units="px")
with(NEIByYear, {
  plot(
    type="p",
    pch=16,
    col="black",
    x=year,
    y=Emissions,
    xlab="",
    ylab="",
    main="",
    axes=FALSE
  )
  lines(
    x=year,
    y=Emissions
  )
  title(
    main="Total PM2.5 Emissions by Year",
    xlab="Year",
    ylab="PM2.5 Emissions"
  ) 
  axis(1, at=year)
  axis(2)
  text(x=year, y=Emissions, labels=ceiling(Emissions), pos=3, cex=0.6)
})
dev.off()

# Remove all data from environment
remove(list=ls())