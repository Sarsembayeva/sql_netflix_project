# Netflix Content Analysis — PostgreSQL 

## Project Overview

This project analyzes Netflix's content catalog using PostgreSQL

The goal is to explore the composition, growth, geographic distribution, and characteristics of Netflix's content while demonstrating practical **SQL data analysis and business intelligence skills**.

The project covers data exploration, cleaning, transformation, aggregation, and advanced analytical techniques in PostgreSQL.
### Key Objectives

* Analyze the distribution and percentage breakdown of **Movies vs. TV Shows**.
* Track content growth over time and year-over-year (YoY) changes.
* Identify the most common genres, ratings, and contributing countries.
* Analyze content recency and historical catalog patterns.
* Examine seasonal patterns in Netflix content additions.
* Calculate the time lag between a title's release and its addition to Netflix.
* Identify prolific directors and actors.
* Analyze directors who also appear in their own productions.
* Use advanced SQL techniques to answer business-oriented analytical questions.

---

## Tools & Technologies

* **PostgreSQL** — data storage, data cleaning, transformation, aggregation, and analysis.
* **SQL** — CTEs, aggregate functions, joins, subqueries, CASE statements, window functions, string functions, and array unnesting.
* **GitHub** — project version control and portfolio documentation.

---

## Key Analytical Questions

The project answers 20 business and data-analysis questions using PostgreSQL:

1. What is the distribution and percentage breakdown of Movies vs. TV Shows?
2. What are the most common content ratings for Movies and TV Shows?
3. What are the top 5 longest movies?
4. How much content was released in the last 5 years compared with older titles?
5. Which release years produced the most content?
6. What are the top 10 most popular genres?
7. How is Netflix content geographically distributed by type?
8. Who are the top 10 most prolific directors?
9. Which 15 actors and actresses have the highest number of appearances?
10. Which titles feature a director who is also part of the cast?
11. Which year and month had the highest number of Netflix content additions?
12. What is the average time lag between a title's release and its addition to Netflix?
13. What is the annual year-over-year (YoY) growth in Netflix content additions?
14. Are there seasonal patterns in Netflix content additions by month?
15. What proportion of the catalog was more than 10 years old when added to Netflix?
16. What are the top 3 longest movies within each individual genre?
17. How is content distributed across custom historical eras and genres?
18. How do director rankings differ by country?
19. How are TV shows distributed by number of seasons?
20. How can Netflix titles be classified by recency, and how many titles fall into each category?

---

## SQL Techniques Demonstrated

This project demonstrates a range of PostgreSQL techniques commonly used in Data Analyst roles:

* `SELECT`, `WHERE`, `ORDER BY`, and `DISTINCT`
* `GROUP BY` and `HAVING`
* Aggregate functions such as `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX`
* `CASE WHEN` statements
* `JOIN` operations
* Common Table Expressions (CTEs)
* Subqueries
* Window functions such as `ROW_NUMBER()` and ranking functions
* String manipulation and text processing
* Array functions and `UNNEST()`
* Date and time functions
* Percentage calculations
* Year-over-year growth calculations
* Data cleaning and transformation
* Conditional aggregation
* Ranking and segmentation

---

## Project Structure

```text
Netflix-SQL-Project/
│
├── netflix_project.sql
└── README.md
```

The `netflix_project.sql` file contains the table creation, data preparation, cleaning, and analytical SQL queries used throughout the project.

---

## Getting Started

### 1. Clone the Repository

Clone this repository to your local machine using Git.

### 2. Open PostgreSQL

Open the project in a PostgreSQL environment such as **pgAdmin, DBeaver, or psql**.

### 3. Run the SQL Script

Open:

```text
netflix_project.sql
```

Run the script to:

* Create the Netflix table
* Define the required columns and data types
* Load and prepare the dataset
* Perform data cleaning and transformation
* Execute the analytical queries

### 4. Explore the Results

Review the SQL queries and their results to identify trends and patterns within the Netflix catalog.



---

## Key Insights


Examples of insights to be highlighted include:

* The proportion of Movies vs. TV Shows in the catalog
* The countries contributing the most content
* The most common genres and ratings
* Periods of significant catalog growth
* Seasonal patterns in content additions
* The average time between content release and Netflix addition
* The distribution of recent vs. older content

Actual figures and conclusions will be added after the final analysis and Tableau dashboard are completed.

---

## Dataset

The project uses a publicly available Netflix titles dataset containing information such as:

* Title
* Content type
* Director
* Cast
* Country
* Date added
* Release year
* Rating
* Duration
* Genre
* Description

The dataset is used strictly for analytical and educational purposes.

---

## Skills Demonstrated

This project demonstrates practical skills relevant to a **Data Analyst / BI Analyst** role:

* PostgreSQL
* SQL data analysis
* Data cleaning
* Data transformation
* Exploratory data analysis
* Business-oriented analytical thinking
* Advanced SQL
* CTEs
* Window functions
* Data aggregation
* Data segmentation
* Dashboard development
* Analytical storytelling
* GitHub project documentation

---

## Project Goal

The main goal of this project is to demonstrate how raw data can be transformed into meaningful business insights using SQL

The workflow follows a typical analytical process:

```text
Raw Data
   ↓
Data Preparation & Cleaning
   ↓
PostgreSQL
   ↓
SQL Analysis
   ↓
Business Insights

```

---

## Author Dilara Sarsembayeva

**Data Analyst Portfolio Project**

Built using **PostgreSQL, SQL, Tableau, and GitHub**
