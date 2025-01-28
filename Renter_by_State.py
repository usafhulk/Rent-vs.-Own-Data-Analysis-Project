import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from states_info import states_info  # Import the states_info dictionary

# Load the renter data
renter_data_by_state = pd.read_csv(r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\yearly_avg_renter_data.csv')

# Inspect the data
print(renter_data_by_state.head())
print(renter_data_by_state.info())

# Calculate the average for each state across all occurrences, excluding non-numeric columns
numeric_columns = renter_data_by_state.select_dtypes(include=[np.number]).columns
state_avg = renter_data_by_state.groupby('statename')[numeric_columns].mean().reset_index().round(2)

# Calculate the 10-year average for each state
state_avg['avg_10_year'] = state_avg.loc[:, 'avg_2015':'avg_2024'].mean(axis=1).round(2)

# Merge the region information back into the state_avg DataFrame
state_avg = state_avg.merge(renter_data_by_state[['statename', 'region']].drop_duplicates(), on='statename')

# Shift the region column to be in front of the statename column
cols = state_avg.columns.tolist()
cols.insert(0, cols.pop(cols.index('region')))
state_avg = state_avg[cols]

# Inspect the updated DataFrame
print(state_avg.head(20))

# Save the state averages to a new CSV file
state_avg.to_csv(r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\state_avg_renter_data.csv', index=False)




