from sqlalchemy import create_engine, text as sqlaltext
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import seaborn as sn

### Setup and populate database with sample data

## Connect to PostgreSQL database
conn_url = "postgresql+psycopg2://postgres:pass123@localhost:5433/postgres"
engine = create_engine(conn_url)

## Create schema and table
# Open the infrastructure build script and store it as a string object
with open('.build/member_scans.pgsql','r') as file:
	query = sqlaltext(file.read())
# Execute the query
with engine.connect() as connection:
	connection.execute(query)

## Ingest sample data from *.csv
# File path of file to be ingested
csv_file_path = './member_scans.csv'
# Read CSV to DataFrame
df = pd.read_csv(csv_file_path)
# Name of destinaton table
table_name = 'member_scans'
# Write DataFrame to PostgreSQL table
df.to_sql(table_name,engine,if_exists='replace')

### Tests
## 1. Data Integrity and 4. Data Completeness
# The Data Integrity Test and Completeness Test were completed with the solution below.

## 1. Data Integrity Test

# Objective:        Ensure the dataset is clean and contains no missing or
#                   incorrect values.

# Implementation:	Check for missing values in key columns such as weight,
#					weight, and body fat percentage.

## 4. Completeness Test

# Objective:		Ensure that each record contains all required information.

# Implementation:	Check for completeness by verifying that each record has
#					entries for weight, weight, body fat percentage, and other
#					essential metrics.

# Solution:			Query table for any row that has missing values in the
# 					columns that correspond to the fields in the 'result sheet'
# 					of the output of the Evlot360 scanner. The results of this
# 					query will display the full record of any id that has a
# 					missing (NULL) or blank ('') value for any field.

# Open the script for Tests and store it as a string object
step = 'integrity-completeness'
with open(f"./sql/test-{step}.pgsql",'r') as file:
    sql_query = sqlaltext(file.read())
# Execute the query
with engine.connect() as connection:
    test_output = pd.read_sql_query(sql_query,connection)
# Write DataFrame to file
test_output.to_csv(f"./results/{step}")

## 2. Range Validation

# Objective:		Confirm that values fall within expected ranges.

# Implementation:	Create a validation test to check if body fat percentage is
#					within the range of 0% to 100%, and weight and height are
#					within realistic bounds.

# Solution:			Create a flag to indicate whether body fat percentage was
# 					between 0% to 100% in the %BF Validation field. This will
# 					produce a separate row per error if an id record possess
# 					more than one error.

#					Given the age range of the sample (16-59 years), it was
#					assumed that weight between 30kg and 200kg and height
#					between 1m and 2m are within "realistic bounds". A flag
#					(Y/N) was created to indicate whether weight (Weight
#					Validation) or height (Height Validation) were invalid.

# Open the script for Tests and store it as a string object
step = 'range-validation'
with open(f"./sql/test-{step}.pgsql",'r') as file:
    sql_query = sqlaltext(file.read())
# Execute the query
with engine.connect() as connection:
    test_output = pd.read_sql_query(sql_query,connection)
# Write DataFrame to file
test_output.to_csv(f"./results/{step}")

## 3. Outlier Detection

# Objective:		Identify unusual values that might indicate errors.

# Implementation:	Implement a test to flag records with extreme values in body
#					composition metrics for further investigation.

# Solution:			Each query below returns the id for every record where the
#					'quantity' value for each body composition metric is outside
#					the 'low_limit' and 'top_limit'. This produces a list of
#					records to investigate the source of the incorrect
#					measurement.

#					There are 2083 instances where client measurements were
#					outside the upper and lower limits. These instances are
#					quantified per measurement type below, which is followed by
#					a table of the client data that contained these errors.

# Open the script for Tests and store it as a string object
step = 'outlier-detection'
with open(f"./sql/test-{step}.pgsql",'r') as file:
    sql_query = sqlaltext(file.read())
# Follow up test to quantify the number of errors per measurement type
step2 = 'outlier-summary'
with open(f"./sql/test-{step2}.pgsql",'r') as file:
    sql_query2 = sqlaltext(file.read())
# Execute the query
with engine.connect() as connection:
    test_output = pd.read_sql_query(sql_query,connection)
    test_output2 = pd.read_sql_query(sql_query2,connection)
# Write DataFrame to file
test_output2.to_csv(f"./results/{step2}")
test_output.to_csv(f"./results/{step}")

## 5. Correlation Matrix

# Objective:		Understand relationships between body composition metrics.

# Implementation:	Generate a correlation matrix and test if the correlations
#					align with expectations (e.g., positive correlation between
#					weight and BMI).

# Solution:			A heatmap was used to visualise the correlations between the
#					various client measurements. The upper and lower limits were
#					excluded for easier digestion of the findings. BMI was
#					calculated and included in the correlation matrix.

# Open the script for Tests and store it as a string object
step = 'correlation-matrix'
with open(f"./sql/test-{step}.pgsql",'r') as file:
    sql_query = sqlaltext(file.read())
# Execute the query
with engine.connect() as connection:
    data = pd.read_sql_query(sql_query,connection)
# Create DataFrame of correlation input data
df_corr_mat = pd.DataFrame(data)
# Calculate correlation matrix
correlation_matrix = df_corr_mat.corr()
# Generate heatmap of correlation matrix
correlation_image = plt.figure()
mask = np.triu(np.ones_like(correlation_matrix, dtype=bool))
sn.heatmap(correlation_matrix,vmax=1,vmin=-1,center=0,cmap='vlag',mask=mask)
# Save figure
correlation_image.savefig(f"./results/{step}.png")

### Visualisations
## Histogram of Body Fat Percentage

# Objective:		Visualize the distribution of body fat percentage.

# Implementation:	Create a histogram to understand the spread of body fat
#					percentage values and identify any potential outliers

# Create object of SQL query as a string
step = 'histogram-body-fat-percentage'
sql_query = f"SELECT CAST(mbf_quantity AS FLOAT) / CAST(weight AS FLOAT) AS Body_Fat_Percentage FROM {table_name}"
# Execute the query
with engine.connect() as connection:
    body_fat_percentage = pd.read_sql_query(sql_query,connection)
# Plot histogram
histogram_image = plt.figure()
plt.hist(body_fat_percentage)
# Save figure
histogram_image.savefig(f"./results/{step}.png")

## Box Plot of Weight and Height
# Objective:		Summarize the distribution of weight and height.

# Implementation:	Use box plots to display key statistics and identify any
#					unusual patterns or outliers in weight and height.

# Create object of SQL query as a string. Height is converted to centimetres.
step = 'box-plot-height'
sql_query = f"SELECT height/10 FROM {table_name}"
# Execute the query
with engine.connect() as connection:
    height = pd.read_sql_query(sql_query,connection)
# Plot box plot
boxplotheight_image = plt.figure()
plt.boxplot(height)
# Save figure
boxplotheight_image.savefig(f"./results/{step}.png")

# Create object of SQL query as a string. Weight is converted to kilograms.
step = 'box-plot-weight'
sql_query = f"SELECT weight/10 FROM {table_name}"
# Execute the query
with engine.connect() as connection:
    weight = pd.read_sql_query(sql_query,connection)
# Plot box plot
boxplotweight_image = plt.figure()
plt.boxplot(weight)
# Save figure
boxplotweight_image.savefig(f"./results/{step}.png")

## Scatter Plot of Weight vs. Height

# Objective:		Explore the relationship between weight and height.

# Implementation:	Create a scatter plot to observe if there's a clear trend or
#					pattern between weight and height.

# Create object of SQL query as a string. Weight is converted to kilograms.
# Height is converted to centimetres.
step = 'scatterplot-weight-height'
sql_query = f"SELECT weight/10 AS weight,height/10 AS height FROM {table_name}"
# Execute the query
with engine.connect() as connection:
    weight_v_height = pd.read_sql_query(sql_query,connection)
# Create scatter plot comparing weight (kg) with height (cm)
weight_v_height.plot.scatter(x='weight',y='height')
# Save figure
plt.savefig(f"./results/{step}.png")