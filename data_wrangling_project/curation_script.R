# Data Technical Test Data Wrangling Cleaning and Transformation Script for study RO4532A
# Author: Laura Budurlean
# Date: 03-11-2025

# Install and load the necessary packages
install.packages("readxl")
install.packages("reshape2")
library(readxl)
library(reshape2)

################ SET FILE PATH ####################
# Set a path to the project file Technical Test - Data Wrangling - v20240923.xlsx in a variable: path <- "/path/to/your/project/file/Technical_Test_Data_Wrangling_v20240923.xlsx"
path <- "Technical_Test_Data_Wrangling_v20240923.xlsx"


################ RUN THE SCRIPT ####################
# Read in the project .xlsx file using readxl package
sheet_names <- excel_sheets(path)
print(sheet_names)

# Now we read in each relevant sheet by sheet name
data_sheet1 <- read_excel(path, sheet = "Patient_clinical_data")
data_sheet2 <- read_excel(path, sheet = "Tissue Sample Metadata")
data_sheet3 <- read_excel(path, sheet = "Serum Protein data")
data_sheet4 <- read_excel(path, sheet = "RNA-seq (RPKM)")

# Create the summary report by selecting relevant columns. We will use column numbers because R hates spaces in the raw data column names. 
summary_report <- data_sheet1[, c(1,2,3,4)]

# Rename column 2 and create a unique patient ID
colnames(summary_report)[2] <- "Patient_ID"
summary_report$Unique_Patient_ID <- paste(summary_report$Study_ID, summary_report$Patient_ID, sep = "_")

# Round the Age column to the nearest whole number
summary_report$Age <- round(summary_report$Age)

# Extract Sample_IDs from data_sheet2 and data_sheet3
samples_sheet2 <- data_sheet2[, c(1, 2)]
colnames(samples_sheet2) <- c("Patient_ID", "Sample_ID")

samples_sheet3 <- data_sheet3[, c(1, 2)]
colnames(samples_sheet3) <- c("Patient_ID", "Sample_ID")

# Combine the samples
all_samples <- rbind(samples_sheet2, samples_sheet3)

# Merge the summary report with the samples
data_report <- merge(summary_report, all_samples, by = "Patient_ID", all.x = TRUE)

# Add the Sample_General_Pathology column based on the logic of the ending letter in Sample_ID column. If it ends with N, it's' NORMAL, if it ends with T, it's PRIMARY, if it ends with M, it's' METASTATIC, otherwise it's NA.
data_report$Sample_General_Pathology <- ifelse(
  grepl("N$", data_report$Sample_ID), "NORMAL",
    ifelse(grepl("T$", data_report$Sample_ID), "PRIMARY",
        ifelse(grepl("M$", data_report$Sample_ID), "METASTATIC", "NA"))
)

# Side note: there is an ERROR in the assignment data with CRC5T being labeled as Normal, and CRC5N labeled as Tumor in the Tissue Sample Metadata sheet. Not sure if this was intentional but this is corrected in the final data_report based on the logic statements I wrote above. I will keep the sample in the report for this example.

# Add the Material_Type column based on the logic of the ending letter in Sample_ID column. If it ends with N, it's' RNA, otherwise it's SERUM.
data_report$Material_Type <- ifelse(grepl("[TNM]$", data_report$Sample_ID), "RNA", "SERUM")

# Transpose data_sheet4
data_sheet4_transposed <- as.data.frame(t(data_sheet4[-1]))

# Set the values in the GeneID column as the new column names
colnames(data_sheet4_transposed) <- data_sheet4$GeneID

# Add the Sample column based on the row names
data_sheet4_transposed <- cbind(Sample = rownames(data_sheet4_transposed), data_sheet4_transposed)
rownames(data_sheet4_transposed) <- NULL

# Create a new data frame with the columns to be appended
data_to_append <- data_sheet3[, c(2, 3, 4)]

# Change the column names to Sample, IL6, and IL6R respectively to make sure the columns to be appended have the same names as in data_sheet4_transposed
colnames(data_to_append) <- c("Sample", "IL6", "IL6R")

# Add missing columns to data_to_append and fill them with NA
missing_cols <- setdiff(colnames(data_sheet4_transposed), colnames(data_to_append))
data_to_append[missing_cols] <- NA

# Reorder columns in data_to_append to match data_sheet4_transposed
data_to_append <- data_to_append[, colnames(data_sheet4_transposed)]

# Append the rows from data_to_append to data_sheet4_transposed
data_sheet4_transposed <- rbind(data_sheet4_transposed, data_to_append)

# Reshape data_sheet4_transposed from wide to long format
data_sheet4_long <- melt(data_sheet4_transposed, id.vars = "Sample", variable.name = "Gene_Symbol", value.name = "Result")

# Merge the reshaped data_sheet4_transposed with data_report by matching Sample to Sample_ID
data_report <- merge(data_report, data_sheet4_long, by.x = "Sample_ID", by.y = "Sample", all.x = TRUE)

# Add column Result_Units to data_report based on the logic of the Sample_ID column. If it ends with N,M, or T, it's' RPKM. If it ends in anything else and the Gene_Symbool is IL6 it's g/L. If it ends in anything else and the Gene_Symbol is IL6R it's mg/L. Otherwise, it's NA.
data_report$Result_Units <- ifelse(
  grepl("[NMT]$", data_report$Sample_ID), "RPKM",
    ifelse(data_report$Gene_Symbol == "IL6", "g/L",
        ifelse(data_report$Gene_Symbol == "IL6R", "mg/L", "NA"))
)

# Add column Status to data_report. If a valid result exists, this value is null. For any non-valid result report an "ERROR", for missing results, report "NOT DONE"
data_report$Status <- ifelse(
  is.na(data_report$Result), "NOT DONE",
  ifelse(data_report$Result == "ERROR", "ERROR", NA)
)

# Rearrange the columns in data_report in the following order: Study_ID Patient_ID Unique_Patient_ID Sex Age Sample_ID Sample_General_Pathology Material_Type Gene_Symbol Result Result_Units Status 
data_report <- data_report[, c("Study_ID", "Patient_ID", "Unique_Patient_ID", "Sex", "Age", "Sample_ID", "Sample_General_Pathology", "Material_Type", "Gene_Symbol", "Result", "Result_Units", "Status")]

# Write the final data_report to a .csv file
write.csv(data_report, "curated_data_RO4532A.csv", row.names = FALSE, quote = FALSE)
