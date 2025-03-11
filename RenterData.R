Renter <- read.csv("Metro_new_renter_affordability_uc_sfrcondomfr_sm_sa_month.csv")
head(Renter)
str(Renter)
colnames(Renter)
glimpse(Renter)
summary(Renter)
dim(Renter)
View(Renter)
skim_without_charts(Renter)
print(colnames(Renter))

# New Data Frame and mutating columns to clean and organize
# Calculate the mean of the specified columns
# More efficient way of getting the mean and removing the unwanted rows, above is the long version, below is the short efficient version

Renter_Clean <- Renter %>%
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

colnames(Renter_Clean)
colnames(Renter)
# Removing the unwanted _ at the end of the column names

Renter_Clean <- Renter_Clean %>%
  rename(AVG_2015 = AVG_2015_, AVG_2016 = AVG_2016_, AVG_2017 = AVG_2017_, AVG_2018 = AVG_2018_, AVG_2019 = AVG_2019_, AVG_2020 = AVG_2020_, AVG_2021 = AVG_2021_, AVG_2022 = AVG_2022_, AVG_2023 = AVG_2023_, AVG_2024 = AVG_2024_)

colnames(Renter_Clean)

# Removing unnecessary columns

Renter_Clean <- Renter_Clean %>% 
  select(-RegionID, -SizeRank, -RegionType)

colnames(Renter_Clean)
Renter_Clean <- Renter_Clean %>%
  select(StateName, RegionName, AVG_2015, AVG_2016, AVG_2017, AVG_2018, AVG_2019,AVG_2020, AVG_2021, AVG_2022, AVG_2023, AVG_2024)
colnames(Renter_Clean)

# adding US to the StateName Column row one
# arranging the data by StateName to get a better look

Renter_Clean[1, 'StateName'] <- "US"

Renter_Clean <- Renter_Clean %>%
  arrange(StateName, .by_group = TRUE)
View(Renter_Clean)

# Grouping by StateName and calculating the mean 

Renter_Clean <- Renter_Clean %>%
  group_by(StateName) %>%
  summarise(across(everything(), mean, na.rm = TRUE))

View(Renter_Clean)
glimpse(Renter_Clean)


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

Renter_8 <- Renter_Clean 


# join the regions to the HomeOwner_8 data frame
Renter_8 <- Renter_8 %>% 
  select(-RegionName)

colnames(Renter_Clean_with_regions)
colnames(Renter_8)
Renter_Clean_with_regions <- Renter_8 %>%
  left_join(state_regions, by = "StateName")

if ("RegionName" %in% names(Renter_Clean_with_regions)) {
  Renter_Clean_with_regions <- Renter_Clean_with_regions %>%
    mutate(RegionName = ifelse(StateName == "US", "National", RegionName))
} else {
  print("Error: RegionName column not added during join.")
}

colnames(Renter_Clean_with_regions)
View(Renter_Clean_with_regions) 

Renter_Clean <- Renter_Clean_with_regions
colnames(Renter_Clean)

# reorder the columns

Renter_Clean <- Renter_Clean %>%
  select(StateName, RegionName, AVG_2015, AVG_2016, AVG_2017, AVG_2018, AVG_2019,AVG_2020, AVG_2021, AVG_2022, AVG_2023, AVG_2024)
colnames(Renter_Clean)
View(Renter_Clean)


# Pivot the data frame to long format

RenterLong <- pivot_longer(
  Renter_Clean,
  cols = starts_with("AVG_"),
  names_to = "Year",
  values_to = "Value"
)


view(RenterLong)

# Write the cleaned data to a CSV file

write_csv(Renter_Clean, "Renter_Clean.csv")
write_csv(RenterLong, "RenterLong.csv")
