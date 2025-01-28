import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from states_info import states_info
home_owner = pd.read_csv(r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\Metro_new_homeowner_affordability_downpayment.csv')

# inspect the data 
print(home_owner.head())
print(home_owner.info())
print(home_owner.describe())
print(home_owner.dtypes)

#Drop rown with missing values
home_owner = home_owner.dropna()

# standardize the column names
home_owner.columns = [col.strip().lower().replace(' ', '_') for col in home_owner.columns]

# Inspect the cleaned data
print(home_owner.info())
print(home_owner.head())

yearly_avg = home_owner[['statename']].copy()
years = range(2015, 2025)

for year in years:
    # Select columns for the current year
    year_columns = [f'{month:02d}/31/{year}' for month in range(1, 13)]
    year_columns = [col for col in year_columns if col in home_owner.columns]
    
    # Calculate the average for the current year
    yearly_avg[f'avg_{year}'] = home_owner[year_columns].mean(axis=1).round(2)


# Inspect the yearly averages
print(yearly_avg.head())



# Add a region column to yearly_avg DataFrame
yearly_avg['region'] = yearly_avg['statename'].map(lambda x: states_info.get(x, {}).get('region', 'Unknown'))

# Group by region and calculate the mean for each region, excluding non-numeric columns
region_avg = yearly_avg.drop(columns=['statename']).groupby('region').mean().reset_index()

# Append the region averages to the yearly_avg DataFrame
yearly_avg = pd.concat([yearly_avg, region_avg], ignore_index=True)

# Inspect the updated yearly_avg DataFrame
print(yearly_avg.tail())
print(yearly_avg.head())

# Shift the region column to be in front of the statename column
cols = yearly_avg.columns.tolist()
cols.insert(0, cols.pop(cols.index('region')))
yearly_avg = yearly_avg[cols]

# Group by region and calculate the mean for each region, excluding non-numeric columns
region_avg = yearly_avg.drop(columns=['statename']).groupby('region').mean().reset_index()
# add a column for the average of the 10 years
region_avg['avg_10_year'] = region_avg.loc[:, 'avg_2015':'avg_2023'].mean(axis=1).round(2)

# Inspect the region averages
region_avg = region_avg.round(2)
print(region_avg)
print(region_avg.columns)

region_avg.to_csv(r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\region_avg_homeowner_data.csv', index=False)



