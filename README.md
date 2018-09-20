Capstone Project on Storm Events Data
----------------

This is my capstone project, and it involves using Tableau, R, and SAS Enterprise Miner to analyze three datasets containing storm information from NOAA and the NWS during the year 2017.  The project focuses on predicting the likelihood that a storm will produce fatalities.  It involves using SAS EM to build five types of predictive models: logistic regression, neural network, support vector machine (SVM), random forest, and heterogeneous ensemble model.  By experimenting with different types of models, I will select the method that can identify the highest number of storm casualties.  Additionally, I use Tableau to create visualizations exploring the relationship between storm casualties, geographic location, and time of year.  This helps to determine which states have the highest risk of casualties, and which months of the year are more likely to experience dangerous storms.  Lastly, I use R to conduct a text mining analysis on the storm event narratives.  I will create a word cloud that showcases the most frequent terms used to describe dangerous storms, which is helpful for gaining insights about these storms' characteristics.

The full report can be found in the file "Storm Casualties Report.pdf".  This report is 96 pages long, and it offers a complete picture of the problem from a business perspective.  It includes a definition of the proposed project, relevant research, success factors and KPIs, dataset and variable descriptions, data preparation, data analysis and visualizations, text mining analysis, predictive model development, model comparison, findings, and proposed solutions.  Tables and visualizations are included in the main body of the text.

I have also included a narrated PowerPoint presentation that serves as a brief summary of my analysis and findings.  It is included in the file "Storm Casualties Presentation.pptx".

The three datasets were all obtained from NOAA (National Oceanic and Atmospheric Administration) and the NWS (National Weather Service).  The data files are located in the storm events database (n.d.), and they include all storms recorded in the U.S. during 2017.  The first data file, "StormEvents_details-ftp_v1.0_d2017_c20180525.csv", is the primary dataset which includes most of the important variables for describing each storm (such as storm type, location, number of deaths and injuries, etc.).  The second data file, "StormEvents_fatalities-ftp_v1.0_d2017_c20180525.csv", provides more information about the deaths caused by the storms.  The third data file, "StormEvents_locations-ftp_v1.0_d2017_c20180525.csv", contains more specific information about each storm's location.  The three data files were cleaned using R and combined into a single spreadsheet, "Storms_Complete_2017.csv".  This is the dataset that I used to generate my predictive models in SAS EM (the Tableau visualizations use the original datasets).  The combined dataset is included, but it can also be generated as an output from the R code.

I have included the Tableau file "Storm Events.twb".  This file contains all of the visualizations used in my report.  It uses two data sources, "StormEvents_details-ftp_v1.0_d2017_c20180525.csv" and "StormEvents_locations-ftp_v1.0_d2017_c20180525.csv".  These tables were joined together in Tableau by using a left join, with the storm event details dataset on the left.

I also designed an Entity-Relationship Diagram (ERD) using ER Assistant to map the three datasets used in this project.  This diagram is included in the file "Storm Data ERD.erd".  An image of the diagram can be found on page 19 (Figure 1) in the main report.

The R script is included in the file "Storm Events.R".  It covers data preparation, merging the datasets, exporting the combined dataset, and the text mining (word cloud) section.  The requirements are described in the file "requirements.txt".  Instructions on how to use the program are included as comments in the R file.  After opening the file, please read the instructions carefully before executing the code to ensure that the program functions correctly.

Lastly, the SAS EM process flow diagram I created for this project is included in the file "Storm Events Diagram.xml".  This contains all of the predictive models that I created for the project.  To use this diagram, you need to import the .xml diagram into your SAS EM project.


References:

Storm Events Database. (n.d.). Retrieved May 31, 2018, from https://www.ncdc.noaa.gov/stormevents/details.jsp
