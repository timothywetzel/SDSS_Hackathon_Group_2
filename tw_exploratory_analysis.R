library(tidyverse)
library(tidycensus)
library(car)

census_api_key("9a0425beda1e3422155a87028b50451b5483b2f2", install = TRUE)
readRenviron("~/.Renviron")
acs_data_2010 = get_acs(geography = "tract", year = 2010, state = "WA", county = "King", geometry = TRUE, variables = "B19013_001")
acs_data_2011 = get_acs(geography = "tract", year = 2011, state = "WA", county = "King", geometry = TRUE, variables = "B19013_001")
acs_data_2012 = get_acs(geography = "tract", year = 2012, state = "WA", county = "King", geometry = TRUE, variables = "B19013_001")
acs_data_2013 = get_acs(geography = "tract", year = 2013, state = "WA", county = "King", geometry = TRUE, variables = "B19013_001")
acs_data_2014 = get_acs(geography = "tract", year = 2014, state = "WA", county = "King", geometry = TRUE, variables = "B19013_001")
acs_data_2015 = get_acs(geography = "tract", year = 2015, state = "WA", county = "King", geometry = TRUE, variables = "B19013_001")
acs_data_2016 = get_acs(geography = "tract", year = 2016, state = "WA", county = "King", geometry = TRUE, variables = "B19013_001")

acs_data_2010 = subset(acs_data_2010, select = c(GEOID, NAME, variable, estimate, moe))
acs_data_2011 = subset(acs_data_2011, select = c(GEOID, NAME, variable, estimate, moe))
acs_data_2012 = subset(acs_data_2012, select = c(GEOID, NAME, variable, estimate, moe))
acs_data_2013 = subset(acs_data_2013, select = c(GEOID, NAME, variable, estimate, moe))
acs_data_2014 = subset(acs_data_2014, select = c(GEOID, NAME, variable, estimate, moe))
acs_data_2015 = subset(acs_data_2015, select = c(GEOID, NAME, variable, estimate, moe))
acs_data_2016 = subset(acs_data_2016, select = c(GEOID, NAME, variable, estimate, moe))

acs_data_2010 = data.frame(acs_data_2010)
acs_data_2011 = data.frame(acs_data_2011)
acs_data_2012 = data.frame(acs_data_2012)
acs_data_2013 = data.frame(acs_data_2013)
acs_data_2014 = data.frame(acs_data_2014)
acs_data_2015 = data.frame(acs_data_2015)
acs_data_2016 = data.frame(acs_data_2016)

acs_data_2010<- acs_data_2010 %>% select(-geometry)
acs_data_2011<- acs_data_2011 %>% select(-geometry)
acs_data_2012<- acs_data_2012 %>% select(-geometry)
acs_data_2013<- acs_data_2013 %>% select(-geometry)
acs_data_2014<- acs_data_2014 %>% select(-geometry)
acs_data_2015<- acs_data_2015 %>% select(-geometry)
acs_data_2016<- acs_data_2016 %>% select(-geometry)

acs_data = bind_rows(acs_data_2010, acs_data_2011, acs_data_2012, acs_data_2013, acs_data_2014, acs_data_2015, acs_data_2016)

write.csv(acs_data, file = "../Desktop/sdss2019_data_hack/Datasets/acs_data_2010-2016.csv")

colnames(acs_data_2016)

head(acs_data_2010)

acs_data_ng = read.csv("../Desktop/sdss2019_data_hack/Datasets/acs_data_2010-2016_no_geom.csv")
colnames(acs_data_ng)

head(acs_data_2016)
structure(acs_data_2016)

zillow_data = read_csv("../Desktop/sdss2019_data_hack/Datasets/king_zillow.csv")
head(zillow_data)
summary(zillow_data)
ggplot(data = zillow_data, mapping = aes(x = ZHVI, y = ZRI)) + geom_point()

eviction_data = read_csv("../Desktop/sdss2019_data_hack/Datasets/evictions.csv")
head(eviction_data)
summary(eviction_data)

evics_acs = merge(eviction_data, acs_data, by = "GEOID")
head(evics_acs)

evics_acs$GEOID = factor(evics_acs$GEOID)
evics_acs$year = factor(evics_acs$year)
evics_acs$name = factor(evics_acs$name)
evics_acs$variable = factor(evics_acs$variable)
evics_acs

lmod = lm(formula = evics_acs$`eviction-rate` ~ evics_acs$`poverty-rate` + evics_acs$`median-property-value`)
lmod

residualPlots(lmod)
marginalModelPlots(lmod)
avPlots(lmod)
crPlots(lmod)
ceresPlots(lmod)


housing_inventory_data = readxl::read_xlsx("../Desktop/sdss2019_data_hack/Datasets/2018-Housing-Inventory-Count-Raw-File.xlsx")
housing_inventory_data = housing_inventory_data[housing_inventory_data$'HudNum' == "WA-500",]
head(h_inv_data)

x = merge(h_inv_data, acs_data_ng)
head(x)

acs_data = read.csv("../Desktop/sdss2019_data_hack/Datasets/acs_data_2010-2016_NG_Update.csv")
summary(acs_data)
