# Description:

During the Spring 2016 semester, I worked with Professor Levitan to study entrainment and outlier speech (when a speaker's acoustic-prosodic feature deviates significantly from the norm). We hypothesized that outlier speech is more likely to be perceived and thereby imitated.

In this repo, I included many of the R scripts, tables, and CSV files that I created over the course of the semester. 

For one feature:
1. For that feature, find average value for one participant for entire conversation
2. Repeat Step 1 for all participants
3. Calculate partner_diff and non_partner_diff
4. Run ttests
5. Combine Steps 1-4 into one 'superscript' and repeat for all other features.

# Installation
I used RStudio
https://www.rstudio.com/products/rstudio/download3/

You can open CSVs with RStudio, but it might be easier to Excel, LibreOffice, Google docs, or any kind of spreadsheet program.



# Description of files

## CSV files

__original_data_all_features.csv__ - Original data received from Min 

__participant_gender.csv__ - Genders of all partners

__TopLevelTemplate.csv__ - The format of a top-level table for a feature. Each participant is paired with his/her partner. The columns "self_feature", "partner_feature", "partner_diff", and "nonpartner_diff" are specific for the feature in question. As I had received data for seven features (loudness, f0finenv, voicing, f0final, jitterlocal, jitterddp, shimmerlocal), I used this template to create a top-level table for each feature.

## R Scripts

__fdrtest.R__ - FDR (false discovery rate) test, provided by Prof. Levitan



# Contributors
Robert Ip, Professor Rivka Levitan, Min Ma

