import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from states_info import states_info  # Import the states_info dictionary

# Function to process affordability data
def process_affordability_data(file_path, output_file):
    # Load the data
    data = pd.read_csv(file_path)

    # Inspect the data
    print(data.head())
    print(data.info())

    # Drop rows with missing values
    data = data.dropna()

    # Standardize the column names
    data.columns = [col.strip().lower().replace(' ', '_') for col in data.columns]

    # Calculate yearly averages starting from the regionname column
    yearly_avg = data[['statename']].copy()
    years = range(2015, 2024)  # Adjust the range based on your dataset

    for year in years:
        # Select columns for the current year
        year_columns = [f'{month:02d}/31/{year}' for month in range(1, 13)]
        year_columns = [col for col in year_columns if col in data.columns]
        
        # Calculate the average for the current year and round to 2 decimal places
        yearly_avg[f'avg_{year}'] = data[year_columns].mean(axis=1).round(2)

    # Add a region column to yearly_avg DataFrame
    yearly_avg['region'] = yearly_avg['statename'].map(lambda x: states_info.get(x, {}).get('region', 'Unknown'))

    # Calculate the average for each state, excluding non-numeric columns
    numeric_columns = yearly_avg.select_dtypes(include=[np.number]).columns
    state_avg = yearly_avg.groupby('statename')[numeric_columns].mean().reset_index()

    # Calculate the 10-year average for each state
    state_avg['avg_10_year'] = state_avg.loc[:, 'avg_2015':'avg_2024'].mean(axis=1).round(2)

    # Merge the region information back into the state_avg DataFrame
    state_avg = state_avg.merge(yearly_avg[['statename', 'region']].drop_duplicates(), on='statename')

    # Shift the region column to be in front of the statename column
    cols = state_avg.columns.tolist()
    cols.insert(0, cols.pop(cols.index('region')))
    state_avg = state_avg[cols]

    # Inspect the updated DataFrame
    print(state_avg.head(20))

    # Save the updated DataFrame to a new CSV file
    state_avg.to_csv(output_file, index=False)

    return state_avg

# Process renter affordability data
renter_file_path = r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\Metro_new_renter_affordability_uc_sfrcondomfr_sm_sa_month.csv'
renter_output_file = r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\updated_renter_data_by_state.csv'
renter_data = process_affordability_data(renter_file_path, renter_output_file)

# Process homeowner affordability data
homeowner_file_path = r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\Metro_new_home_affordability_uc_sfrcondomfr_sm_sa_month.csv'
homeowner_output_file = r'C:\Users\Chris\OneDrive - SNHU\CODING RANDOM\PYTHON\V.S. Homowner vs. Renter\updated_homeowner_data_by_state.csv'
homeowner_data = process_affordability_data(homeowner_file_path, homeowner_output_file)

