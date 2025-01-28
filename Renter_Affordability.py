import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from states_info import states_info  # Import the states_info dictionary

# Load the renter data
renter_data = pd.read_csv(r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\Metro_new_renter_affordability_uc_sfrcondomfr_sm_sa_month.csv')

# Inspect the data 
print(renter_data.head())
print(renter_data.info())
print(renter_data.describe())
print(renter_data.dtypes)

# Drop rows with missing values
renter_data = renter_data.dropna()

# Standardize the column names
renter_data.columns = [col.strip().lower().replace(' ', '_') for col in renter_data.columns]

# Inspect the cleaned data
print(renter_data.info())
print(renter_data.head())

# Calculate yearly averages starting from the regionname column
yearly_avg = renter_data[['statename']].copy()
years = range(2015, 2025)  

for year in years:
    # Select columns for the current year
    year_columns = [f'{month:02d}/31/{year}' for month in range(1, 13)]
    year_columns = [col for col in year_columns if col in renter_data.columns]
    
    # Debug print to check year columns
    print(f'Year: {year}, Columns: {year_columns}')
    
    # Calculate the average for the current year and round to 2 decimal places
    yearly_avg[f'avg_{year}'] = renter_data[year_columns].mean(axis=1).round(2)

# Add a region column to yearly_avg DataFrame
yearly_avg['region'] = yearly_avg['statename'].map(lambda x: states_info.get(x, {}).get('region', 'Unknown'))

# Shift the region column to be in front of the statename column
cols = yearly_avg.columns.tolist()
cols.insert(0, cols.pop(cols.index('region')))
yearly_avg = yearly_avg[cols]

# Group by region and calculate the mean for each region, excluding non-numeric columns
region_avg = yearly_avg.drop(columns=['statename']).groupby('region').mean().reset_index()

# Calculate the 10-year average for each region
region_avg['avg_10_year'] = region_avg.loc[:, 'avg_2015':'avg_2024'].mean(axis=1).round(2)

# Inspect the region averages
region_avg = region_avg.round(2)
print(region_avg)

# Save the region averages to a new CSV file
region_avg.to_csv(r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\region_avg_renter_data.csv', index=False)

