library(tidyverse)
library(tidycensus)

census_api_key("9a0425beda1e3422155a87028b50451b5483b2f2", install = TRUE)
readRenviron("~/.Renviron")
acs_data = get_acs(geography = "tract", year = 2013, state = "WA", county = "King", geometry = TRUE, variables = "B19013_001")

zillow_data = read_csv("../Desktop/sdss2019_data_hack/Datasets/king_zillow.csv")

head(zillow_data)

summary(zillow_data)

ggplot(data = zillow_data, mapping = aes(x = ZHVI, y = ZRI)) + geom_point()

eviction_data = read_csv("../Desktop/sdss2019_data_hack/Datasets/evictions.csv")

head(eviction_data)

summary(eviction_data)

