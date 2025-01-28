import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from states_info import states_info


# Load the homeowner data
homeowner_data_by_state = pd.read_csv(r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\yearly_avg_homeowner_data.csv')

# Inspect the data
print(homeowner_data_by_state.head())
print(homeowner_data_by_state.info())

# Calculate the average for each state across all occurrences, excluding non-numeric columns
numeric_columns = homeowner_data_by_state.select_dtypes(include=[np.number]).columns
state_avg_home = homeowner_data_by_state.groupby('statename')[numeric_columns].mean().reset_index().round(2)

# Calculate the 10-year average for each state
state_avg_home['avg_10_year'] = state_avg_home.loc[:, 'avg_2015':'avg_2024'].mean(axis=1).round(2)

# Merge the region information back into the state_avg_home DataFrame
state_avg_home = state_avg_home.merge(homeowner_data_by_state[['statename', 'region']].drop_duplicates(), on='statename')

# Shift the region column to be in front of the statename column
cols = state_avg_home.columns.tolist()
cols.insert(0, cols.pop(cols.index('region')))
state_avg_home = state_avg_home[cols]

# Inspect the updated DataFrame
print(state_avg_home.head(20))
state_avg_home.to_csv(r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\state_avg_homeowner_data.csv', index=False)