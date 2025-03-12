# Summary 
This R script performs data wrangling, cleaning, and transformation tasks for the study RO4532A. It processes multiple sheets from an Excel file, merges and reshapes the data, and generates a curated dataset.

### Input Files:
Takes an excel workbook with multiple sheets *Technical Test - Data Wrangling - v20240923.xlsx* file  `Technical_Test_Data_Wrangling_v20240923.xlsx` containing patient clinical data, tissue sample metadata, serum protein data, and RNA-seq data.

### Expected Output:
`curated_data_RO4532A.csv` A CSV file containing the cleaned and transformed data from the example study data

#### Example Output: `curated_data_RO4532A.csv`
| Study_ID | Patient_ID | Unique_Patient_ID | Sex | Age | Sample_ID | Sample_General_Pathology | Material_Type | Gene_Symbol | Result | Result_Units | Status |
|----------|------------|-------------------|-----|-----|-----------|--------------------------|---------------|-------------|--------|--------------|--------|
| RO4532A  | 2310       | RO4532A_2310      | M   | 63  | CRC10M    | METASTATIC               | RNA           | ICAM1       | 2.482574665 | RPKM         | NA     |
| RO4532A  | 2310       | RO4532A_2310      | M   | 63  | CRC10M    | METASTATIC               | RNA           | VCAM1       | 2.688047116 | RPKM         | NA     |
| RO4532A  | 2310       | RO4532A_2310      | M   | 63  | CRC10M    | METASTATIC               | RNA           | IL6         | 1.797076141 | RPKM         | NA     |
| RO4532A  | 2310       | RO4532A_2310      | M   | 63  | S-CRC10-a | NA                       | SERUM         | IL6         | 81.6        | g/L          | NA     |
| RO4532A  | 2310       | RO4532A_2310      | M   | 63  | S-CRC10-a | NA                       | SERUM         | IL6R        | 2.2         | mg/L         | NA     |
| RO4532A  | 2310       | RO4532A_2310      | M   | 63  | S-CRC10-a | NA                       | SERUM         | VCAM1       | NA          | NA           | NOT DONE |
| RO4532A  | 2310       | RO4532A_2310      | M   | 63  | S-CRC10-a | NA                       | SERUM         | SELE        | NA          | NA           | NOT DONE |
| RO4532A  | 2310       | RO4532A_2310      | M   | 63  | S-CRC10-a | NA                       | SERUM         | ICAM1       | NA          | NA           | NOT DONE |
| RO4532A  | 2310       | RO4532A_2310      | M   | 63  | S-CRC10-b | NA                       | SERUM         | ICAM1       | NA          | NA           | NOT DONE |
| RO4532A  | 2310       | RO4532A_2310      | M   | 63  | S-CRC10-b | NA                       | SERUM         | SELE        | NA          | NA           | NOT DONE |
