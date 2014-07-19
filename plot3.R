# Load required libraries
library("ggplot2")
library("scales")

# Read NEI data.
NEI <- readRDS("summarySCC_PM25.rds")

# Aggregate NEI data by year.
NEITypeByYear <- aggregate(data=NEI, Emissions ~ type + year, FUN=sum)
colnames(NEITypeByYear) <- c("Type", "Year", "Emissions")

# Plot of total PM2.5 emissions by year.
png("plot3.png", height=600, width=600, units="px")
  ggplot(
    data=NEITypeByYear,
    aes(
      x=Year,
      y=Emissions,
      group=Type,
      color=Type
      )
  ) +
  ggtitle("PM2.5 Emissions by Year filtered through Type") +
  geom_line() +
  geom_point() +
  geom_text(
      aes(
        label=ceiling(Emissions),
        hjust=0.5,
        vjust=-0.5
      )
    ) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10))
dev.off()

# Remove all data from environment
remove(list=ls())