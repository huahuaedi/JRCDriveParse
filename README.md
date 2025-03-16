Driving Cycle Analysis and Synthesis
This repository contains tools for analyzing, processing, and synthesizing driving cycles from real-world vehicle data. The project aims to create composite driving cycles that accurately represent various driving conditions for use in vehicle energy management research and development.
Overview
Driving cycles are essential for evaluating vehicle performance, energy consumption, and emissions. This project offers tools to:

Extract and process time-speed data from multiple driving cycle segments
Combine segments into a continuous, representative driving cycle
Calculate key statistical metrics for driving cycle characterization
Visualize individual and combined driving cycles
Export processed data for use in simulation environments

Data Source
The driving data used in this project comes from the JRC Data Catalogue:

Dataset: JRC Data Browser and Transportation - JRCDBT0001
Specific Collection: One Vehicle Multiple Drivers On-Road Campaign

This dataset contains real-world driving data collected from vehicles in various driving conditions.
Features

Multi-file Processing: Automatically process and combine multiple CSV files containing driving cycle segments
Seamless Time Integration: Adjust time values to create continuous driving cycles from separate segments
Statistical Analysis: Calculate key metrics including:

Mean and maximum speed
Maximum acceleration and deceleration
Speed standard deviation
Coefficient of variation (CV)


Visualization: Generate plots for individual segments and combined driving cycles
Data Export: Export processed data in various formats for further analysis or simulation

Key Files

driving_cycle_processor.m: Main MATLAB script for processing and analyzing driving cycles
README.md: Project documentation (this file)
Output files:

combined_driving_data.mat: Complete combined dataset
combined_time_speed.mat: Simplified dataset with only time and speed
individual_driving_data.mat: Data from individual files
driving_metrics.mat and driving_metrics.csv: Statistical metrics for all cycles



Usage

Download the data:
Download the required CSV files from the JRC database and place them in the appropriate folder structure.
Configure the script:
Edit the fileNames variable in driving_cycle_processor.m to point to your CSV files.
Run the script:
matlabCopyrun driving_cycle_processor.m

Examine outputs:

Check the generated MAT files for processed data
Review the CSV file for statistical metrics
Examine the generated plots for visual representation



Applications
This tool is particularly useful for:

Energy management system development for electric and hybrid vehicles
Vehicle powertrain simulation and validation
Comparative analysis of driving patterns
Creation of custom driving cycles for specific research needs

Methodology
The driving cycle synthesis process follows these steps:

Data Extraction: Read time, speed, and other relevant data from CSV files
Time Adjustment: Align consecutive segments to create a continuous timeline
Data Combination: Concatenate speed, engine speed, and gear data from all segments
Metrics Calculation: Compute statistical characteristics for each segment and the combined cycle
Visualization: Generate plots to visualize the data and provide visual verification
Export: Save the processed data in various formats for downstream applications

Contributing
Contributions to improve the code or extend its functionality are welcome. Please feel free to submit pull requests or open issues for discussion.
License
This project is available under the MIT License - see the LICENSE file for details.
