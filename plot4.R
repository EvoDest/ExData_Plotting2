# Load required libraries
library("ggplot2")
library("scales")

# Read NEI/SCC data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Extract Coal Combustion data from entire SCC
SCCCoalComb <- subset(x=SCC, grepl("(Comb)+.*(Coal)+", Short.Name))

#Extract NEI Data where SCC matches Coal Combustion
NEICoalComb <- NEI[NEI$SCC %in% SCCCoalComb$SCC,]

# Aggregate NEI data by year.
NEICoalCombByYear <- aggregate(data=NEICoalComb, Emissions ~ year, FUN=sum)
colnames(NEICoalCombByYear) <- c("Year", "Emissions")

# Plot of total PM2.5 emissions by year.
png("plot4.png", height=600, width=600, units="px")
  ggplot(
    data=NEICoalCombByYear,
    aes(
      x=Year,
      y=Emissions,
    )
  ) +
  ggtitle("PM2.5 Emissions from Coal Combustion-related Sources by Year") +
  geom_line() +
  geom_point() +
  geom_text(
    aes(
      label=ceiling(Emissions),
      hjust=0.5,
      vjust=-0.
    )
  ) +
  scale_x_continuous(breaks=pretty_breaks(n=10)) +
  scale_y_continuous(breaks=pretty_breaks(n=10))
dev.off()

# Remove all data from environment
remove(list=ls())