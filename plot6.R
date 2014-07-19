# Load required libraries
library("ggplot2")
library("scales")

# Read NEI data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subsetting data for Baltimore City, Maryland
NEIBCLA <- NEI[NEI$fips == "24510" | NEI$fips == "06037",]

# Create location name table for friendly-referencing
countryDataMatrix <- matrix(
  c(
    "24510", "Baltimore City, Maryland",
    "06037", "Los Angeles County, California"),
  ncol=2,
  byrow=TRUE
  )

countryNames <- data.frame(countryDataMatrix)
colnames(countryNames) <- c("Fips","Location")

# Extract Motor Vehicle data from entire SCC
SCCMV <- subset(x=SCC, grepl("(Veh)+", Short.Name))

# Extract NEI Data for Baltimore City and Los Angeles
# where SCC matches Motor vehicles
NEIBCLAMV <- NEIBCLA[NEIBCLA$SCC %in% SCCMV$SCC,]

# Aggregate NEI data by year.
NEIBCLAMVByYear <- aggregate(data=NEIBCLAMV, Emissions ~ fips + year, FUN=sum)
colnames(NEIBCLAMVByYear) <- c("Fips", "Year", "Emissions")

# Merge Country Names to Aggregate Data
NEIBCLAMVByYear <- merge(x=NEIBCLAMVByYear, y=countryNames, by="Fips")

# Plot of total PM2.5 emissions by year.
png("plot6.png", height=600, width=600, units="px")
  ggplot(
    data=NEIBCLAMVByYear,
    aes(
      x=Year,
      y=Emissions,
      group=Location,
      color=Location
    )
  ) +
  ggtitle("PM2.5 Emissions from Motor Vehicles by Year filtered through Location") +
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