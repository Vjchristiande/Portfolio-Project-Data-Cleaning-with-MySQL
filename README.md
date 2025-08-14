# Tech Layoffs Data Cleaning Project

## Introduction
This project demonstrates a method for cleaning and standardizing a dataset using SQL. It focuses on the economic challenges facing global tech firms, including significant layoffs like Meta's recent cut of over 11,000 employees. This dataset aims to help the Kaggle community analyze the ongoing tech turmoil and gain insights.

## Dataset Description
  - Source: https://1drv.ms/x/c/eb18015fea10e417/Eb6RI7A18h9Ajka2AjEzfngBBn4Eq5Ax0Z-ii5wQHzIswg?e=mMIM9h 
  - No. of Rows: 2689
  - Fields:
      - company
      - location
      - total_laid_off
      - date
      - percentage_laid_off
      - industry
      - source
      - stage
      - funds_raised
      - country
      - date_added
   - Issues:
      - Duplicates
      - Unstardized text
      - Missing values
      - Wrong format (e.g., date, date_added)
      - Unnecessary columns 

  ## Approach
   - **Duplicates**: Remove duplicated rows.
   - **Unstardized text**: Trim unnecessary white spaces, Add white spaces in after commas, and replacing variations of the same value (like "UAE" and "United Arab Emirates") with a single, consistent format.
   - **Missing values**: Fill missing industry values of appsmith company with software development.
   - **Wrong Format**: Convert date and date_added from text to date.
   - **Unnecessary columns**: Remove row_num column

  ## Previews
  ### Raw Data Preview
   - <img width="1061" height="361" alt="image" src="https://github.com/user-attachments/assets/fc88413d-cf75-4ab6-9ea5-48d20984043b" />

  ### Cleaned Data Preview
   - <img width="1102" height="349" alt="image" src="https://github.com/user-attachments/assets/911b7f64-c7eb-4e6a-bcc9-fc6106f5fc4c" />

     
