# Load required libraries
library("ggplot2")
library("scales")

# Read NEI/SCC data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Extract Motor Vehicle data from entire SCC
SCCMotorVeh <- subset(x=SCC, grepl("(Veh)+", Short.Name))

# Extract NEI Data where SCC matches Motor Vehicles
NEIMotorVeh <- NEI[NEI$SCC %in% SCCMotorVeh$SCC,]

# Aggregate NEI data by year.
NEIMotorVehByYear <- aggregate(data=NEIMotorVeh, Emissions ~ year, FUN=sum)
colnames(NEIMotorVehByYear) <- c("Year", "Emissions")

# Plot of total PM2.5 emissions by year.
png("plot5.png", height=600, width=600, units="px")
  ggplot(
    data=NEIMotorVehByYear,
    aes(
      x=Year,
      y=Emissions,
    )
  ) +
  ggtitle("PM2.5 Emissions from Motor Vehicle Sources by Year") +
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