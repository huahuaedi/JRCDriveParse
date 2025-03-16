This document provides instructions for acquiring and preparing the data needed for the driving cycle analysis and synthesis project.

## Data Source

The data used in this project comes from the European Commission's Joint Research Centre (JRC) Data Catalogue:

- **Main Repository:** JRC Data Browser and Transportation - JRCDBT0001  
- **Specific Dataset:** One Vehicle Multiple Drivers On-Road Campaign  

## Downloading the Data

1. Navigate to the **One Vehicle Multiple Drivers On-Road Campaign** directory.  
2. Download the CSV files you want to analyze from the appropriate subdirectories.  
3. Organize the downloaded files in your local project folder structure.  

## Recommended File Organization

We recommend organizing your data files in the following structure:

```plaintext
project_root/
├── driving_cycle_processor.m
├── jrc_data/
│   ├── D1_part1.csv
│   ├── D1_part2.csv
│   ├── D1_part3.csv
│   ├── D1_part4.csv
│   └── D1_part5.csv
└── output/
    ├── combined_driving_data.mat
    ├── combined_time_speed.mat
    ├── individual_driving_data.mat
    ├── driving_metrics.csv
    └── plots/
```

## Data Selection Guidelines

When selecting driving data segments to combine, consider the following:

- **Representativeness:** Choose segments that represent different driving conditions (urban, highway, etc.).
- **Data Quality:** Ensure the selected segments have minimal missing data points.
- **Diversity:** Include segments with varying speed profiles, acceleration patterns, and durations.
- **Compatibility:** Select segments that can be logically combined (e.g., urban segments with other urban segments).
- **Research Purpose:** Select segments that align with your specific research objectives.

## File Format Requirements

The CSV files should contain at least the following columns:

- **Time:** Time in seconds
- **Speed:** Vehicle speed in m/s
- **Gear:** Gear position (optional)

Additional columns may be present but are not required for basic processing.

## Data Preprocessing Recommendations

Before running the main script, you may want to:

- **Check data integrity:** Validate that all CSV files have the expected columns.
- **Remove outliers:** Filter out any extreme values that may be due to sensor errors.
- **Normalize time:** Ensure time values start from 0 in each file (the script will handle alignment).
- **Standardize units:** Confirm all speed values are in m/s (convert if necessary).

## Customizing Data Selection

To use different CSV files:

1. Open `driving_cycle_processor.m` in MATLAB.
2. Locate the `fileNames` variable at the beginning of the script.
3. Modify the array to include the paths to your selected CSV files:

```matlab
fileNames = {
    'jrc_data/your_file1.csv', 
    'jrc_data/your_file2.csv', 
    'jrc_data/your_file3.csv'
};
```

4. Save the script and run it to process your selected files.
