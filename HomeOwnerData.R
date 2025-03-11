HomeOwner <- read.csv("Metro_new_homeowner_affordability_downpayment.csv")
head(HomeOwner)
str(HomeOwner)
colnames(HomeOwner)
glimpse(HomeOwner)
summary(HomeOwner)
dim(HomeOwner)
View(HomeOwner)
skim_without_charts(HomeOwner)

clean_names(HomeOwner_Clean)
print(colnames(HomeOwner))

# Removing the 2012-2014 as we dont need this data

HomeOwner_Clean <- HomeOwner %>% 
  select(-X1.31.2012, -X2.29.2012, -X3.31.2012, -X4.30.2012, -X5.31.2012, -X6.30.2012, -X7.31.2012, -X8.31.2012, -X9.30.2012, -X10.31.2012, -X11.30.2012, -X12.31.2012, -X1.31.2013, -X2.28.2013, -X3.31.2013, -X4.30.2013, -X5.31.2013, -X6.30.2013, -X7.31.2013, -X8.31.2013, -X9.30.2013, -X10.31.2013, -X11.30.2013, -X12.31.2013, -X1.31.2014, -X2.28.2014, -X3.31.2014, -X4.30.2014, -X5.31.2014, -X6.30.2014, -X7.31.2014, -X8.31.2014, -X9.30.2014, -X10.31.2014, -X11.30.2014, -X12.31.2014)
colnames(HomeOwner_Clean)
View(HomeOwner_Clean)

# New Data Frame and mutating columns to clean and organize
# Calculate the mean of the specified columns
# More efficient way of getting the mean and removing the unwanted rows, above is the long version, below is the short efficient version

HomeOwner_Clean <- HomeOwner_Clean %>%
  rowwise() %>%
  mutate(AVG_2015_ = mean(c_across(ends_with("2015")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(-ends_with("2015")) %>% 
  rowwise() %>%
  mutate(AVG_2016_ = mean(c_across(ends_with("2016")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(-ends_with("2016")) %>% 
  rowwise() %>%
  mutate(AVG_2017_ = mean(c_across(ends_with("2017")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(-ends_with("2017")) %>% 
  rowwise() %>%
  mutate(AVG_2018_ = mean(c_across(ends_with("2018")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(-ends_with("2018")) %>% 
  rowwise() %>%
  mutate(AVG_2019_ = mean(c_across(ends_with("2019")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(-ends_with("2019")) %>% 
  rowwise() %>%
  mutate(AVG_2020_ = mean(c_across(ends_with("2020")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(-ends_with("2020")) %>% 
  rowwise() %>%
  mutate(AVG_2021_ = mean(c_across(ends_with("2021")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(-ends_with("2021")) %>% 
  rowwise() %>%
  mutate(AVG_2022_ = mean(c_across(ends_with("2022")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(-ends_with("2022")) %>% 
  rowwise() %>%
  mutate(AVG_2023_ = mean(c_across(ends_with("2023")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(-ends_with("2023")) %>% 
  rowwise() %>%
  mutate(AVG_2024_ = mean(c_across(ends_with("2024")), na.rm = TRUE)) %>%
  ungroup() %>%
  select(-ends_with("2024"))

colnames(HomeOwner_Clean)

# Removing the unwanted _ at the end of the column names

HomeOwner_Clean <- HomeOwner_Clean %>%
  rename(AVG_2015 = AVG_2015_, AVG_2016 = AVG_2016_, AVG_2017 = AVG_2017_, AVG_2018 = AVG_2018_, AVG_2019 = AVG_2019_, AVG_2020 = AVG_2020_, AVG_2021 = AVG_2021_, AVG_2022 = AVG_2022_, AVG_2023 = AVG_2023_, AVG_2024 = AVG_2024_)

colnames(HomeOwner_Clean)

# Removing unnecessary columns

HomeOwner_Clean <- HomeOwner_Clean %>% 
  select(-RegionID, -SizeRank, -RegionType)

colnames(HomeOwner_Clean)
summary(HomeOwner_Clean)

# arranging the data by StateName to get a better look
# adding US to the StateName Column row one

HomeOwner_Clean[1, 'StateName'] <- "US"
HomeOwner_Clean <- HomeOwner_Clean %>%
  arrange(StateName, .by_group = TRUE)
View(HomeOwner_Clean)

# Grouping by StateName and calculating the mean 

HomeOwner_Clean <- HomeOwner_Clean %>%
  group_by(StateName) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

View(HomeOwner_Clean)
glimpse(HomeOwner_Clean)



# define which states belong to which regions

state_regions <- data.frame(
  StateName = c(
    "WA", "OR", "CA", "ID", "MT", "WY", "NV", "UT", "CO", "AZ", "NM",
    "ND", "SD", "NE", "KS", "MN", "IA", "MO", "WI", "IL", "MI", "IN", "OH",
    "TX", "OK", "AR", "LA","MS", "AL",
    "TN", "KY", "GA", "FL", "SC", "NC", "VA","WV",
    "MD", "DE", "NJ", "PA", "NY", "CT", "RI", "MA", "VT", "NH", "ME",
    "AK", "HI",
    "US"
  ),
  RegionName = c(
    rep("West", 11),
    rep("Midwest", 12),
    rep("South", 6),
    rep("Southeast", 8),
    rep("Northeast", 11),
    rep("Pacific", 2),
    rep("National", 1)
  )
)

HomeOwner_8 <- HomeOwner_Clean 


# join the regions to the HomeOwner_8 data frame
colnames(HomeOwner_8)
HomeOwner_8 <- HomeOwner_8 %>% 
  select(-RegionName)

HomeOwner_Clean_with_regions <- HomeOwner_8 %>%
  left_join(state_regions, by = "StateName")
colnames(HomeOwner_8)
if ("RegionName" %in% names(HomeOwner_Clean_with_regions)) {
  HomeOwner_Clean_with_regions <- HomeOwner_Clean_with_regions %>%
    mutate(RegionName = ifelse(StateName == "US", "National", RegionName))
} else {
  print("Error: RegionName column not added during join.")
}

colnames(HomeOwner_Clean_with_regions)
View(HomeOwner_Clean_with_regions) 

HomeOwner_Clean <- HomeOwner_Clean_with_regions
colnames(HomeOwner_Clean)

# reorder the columns

HomeOwner_Clean <- HomeOwner_Clean %>%
  select(StateName, RegionName, AVG_2015, AVG_2016, AVG_2017, AVG_2018, AVG_2019,AVG_2020, AVG_2021, AVG_2022, AVG_2023, AVG_2024)
colnames(HomeOwner_Clean)
View(HomeOwner_Clean)


# Pivot the data frame to long format

HomeOwnerLong <- pivot_longer(
  HomeOwner_Clean,
  cols = starts_with("AVG_"),
  names_to = "Year",
  values_to = "Value"
)


view(HomeOwnerLong)

# Write the cleaned data to a CSV file

write_csv(HomeOwner_Clean, "HomeOwner_Clean.csv")
write_csv(HomeOwnerLong, "HomeOwnerLong.csv")








