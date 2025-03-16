# Driving Cycle Analysis and Synthesis

This repository contains tools for analyzing, processing, and synthesizing driving cycles from real-world vehicle data. The project aims to create composite driving cycles that accurately represent various driving conditions for use in vehicle energy management research and development.

## Overview

Driving cycles are essential for evaluating vehicle performance, energy consumption, and emissions. This project offers tools to:

- Extract and process time-speed data from multiple driving cycle segments  
- Combine segments into a continuous, representative driving cycle  
- Calculate key statistical metrics for driving cycle characterization  
- Visualize individual and combined driving cycles  
- Export processed data for use in simulation environments  

## Data Source

The driving data used in this project comes from the JRC Data Catalogue:

- **Dataset:** JRC Data Browser and Transportation - JRCDBT0001
- **Specific Collection:** One Vehicle Multiple Drivers On-Road Campaign

This dataset contains real-world driving data collected from vehicles in various driving conditions.

## Features

- **Multi-file Processing:** Automatically process and combine multiple CSV files containing driving cycle segments  
- **Seamless Time Integration:** Adjust time values to create continuous driving cycles from separate segments  
- **Statistical Analysis:** Calculate key metrics including:
  - Mean and maximum speed  
  - Maximum acceleration and deceleration  
  - Speed standard deviation  
  - Coefficient of variation (CV)  
- **Visualization:** Generate plots for individual segments and combined driving cycles  
- **Data Export:** Export processed data in various formats for further analysis or simulation  

## Key Files

- **`driving_cycle_processor.m`** - Main MATLAB script for processing and analyzing driving cycles  
- **`README.md`** - Project documentation (this file)  
- **Output files:**
  - `combined_driving_data.mat` - Complete combined dataset  
  - `combined_time_speed.mat` - Simplified dataset with only time and speed  
  - `individual_driving_data.mat` - Data from individual files  
  - `driving_metrics.mat` and `driving_metrics.csv` - Statistical metrics for all cycles  

## Usage

1. **Download the data:**  
   Download the required CSV files from the JRC database and place them in the appropriate folder structure.

2. **Configure the script:**  
   Edit the `fileNames` variable in `driving_cycle_processor.m` to point to your CSV files.

3. **Run the script:**  
   ```matlab
   run driving_cycle_processor.m
   ```

4. **Examine outputs:**  
   - Check the generated MAT files for processed data  
   - Review the CSV file for statistical metrics  
   - Examine the generated plots for visual representation  

## Applications

This tool is particularly useful for:

- Energy management system development for electric and hybrid vehicles  
- Vehicle powertrain simulation and validation  
- Comparative analysis of driving patterns  
- Creation of custom driving cycles for specific research needs  

## Methodology

The driving cycle synthesis process follows these steps:

1. **Data Extraction:** Read time, speed, and other relevant data from CSV files  
2. **Time Adjustment:** Align consecutive segments to create a continuous timeline  
3. **Data Combination:** Concatenate speed, engine speed, and gear data from all segments  
4. **Metrics Calculation:** Compute statistical characteristics for each segment and the combined cycle  
5. **Visualization:** Generate plots to visualize the data and provide visual verification  
6. **Export:** Save the processed data in various formats for downstream applications  

## Example Output

### Sample Metrics

| Cycle Name  | Mean Speed (m/s) | Max Speed (m/s) | Max Accel (m/s²) | Min Accel (m/s²) | Std Speed (m/s) | CV  |
|-------------|-----------------|-----------------|------------------|------------------|----------------|----|
| D1_part1    | 12.32           | 35.90          | 3.76             | -3.09            | 10.11          | 0.82 |
| D1_part2    | 8.98            | 36.47          | 2.04             | -2.49            | 8.18           | 0.91 |
| D1_part3    | 8.01            | 33.35          | 2.68             | -2.64            | 7.99           | 1.00 |
| Combined    | 10.71           | 21.00          | 2.90             | -1.04            | 5.65           | 0.53 |

## Contributing

Contributions to improve the code or extend its functionality are welcome. Please feel free to submit pull requests or open issues for discussion.

## Acknowledgements

We would like to express our gratitude to the European Commission's Joint Research Centre (JRC) for providing the open-access driving data used in this project. The JRC Open Data platform has been invaluable for our research and development work.

## License

This project is available under the MIT License - see the `LICENSE` file for details.
