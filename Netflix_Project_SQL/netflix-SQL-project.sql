Netflix Project 

Netflix Content Analysis — PostgreSQL & Tableau

Project Overview

This project analyzes Netflix's content catalog using PostgreSQL and Tableau.

-The goal is to understand:
    - the distribution of Movies vs TV Shows
	- content growth over time
	- the most common genres and ratings
	- geographic distribution of content
	- catalog recency
	- movie duration and TV show season distribution
	- directors and actors with the highest number of titles

## Tools

- PostgreSQL
- SQL
- Tableau
- GitHub

## SQL Analysis

The analysis includes:

1. Movies vs TV Shows
2. Content ratings
3. Longest movies
4. Recent vs older content
5. Content by release year
6. Top genres
7. Content by country
8. Top directors
9. Top actors
10. Directors appearing in their own productions
11. Netflix additions by month
12. Average catalog lag
13. Year-over-year content growth
14. Seasonal upload patterns
15. Older catalog content
16. Longest movies by genre
17. Content by era and genre
18. Director rankings by country
19. TV show season distribution
20. Content recency classification 


-- STAGE 1: DROP EXISTING TABLE
DROP TABLE IF EXISTS netflix;

-- STAGE 1: CREATE TABLE

CREATE TABLE netflix
(
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    casts VARCHAR(10000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(150),
    description VARCHAR(250)
);

-- TOTAL NUMBER OF RECORDS

SELECT COUNT(*) AS total_rows
FROM netflix;


-- CHECK FOR DUPLICATE SHOW IDs

SELECT 
    show_id,
    COUNT(*) AS duplicate_count
FROM netflix
GROUP BY show_id
HAVING COUNT(*) > 1;


-- CHECK FOR MISSING VALUES

SELECT
    COUNT(*) FILTER (WHERE show_id IS NULL) AS missing_show_id,
    COUNT(*) FILTER (WHERE type IS NULL) AS missing_type,
    COUNT(*) FILTER (WHERE title IS NULL) AS missing_title,
    COUNT(*) FILTER (WHERE director IS NULL) AS missing_director,
    COUNT(*) FILTER (WHERE casts IS NULL) AS missing_casts,
    COUNT(*) FILTER (WHERE country IS NULL) AS missing_country,
    COUNT(*) FILTER (WHERE date_added IS NULL) AS missing_date_added,
    COUNT(*) FILTER (WHERE release_year IS NULL) AS missing_release_year,
    COUNT(*) FILTER (WHERE rating IS NULL) AS missing_rating,
    COUNT(*) FILTER (WHERE duration IS NULL) AS missing_duration,
    COUNT(*) FILTER (WHERE listed_in IS NULL) AS missing_genre,
    COUNT(*) FILTER (WHERE description IS NULL) AS missing_description
FROM netflix;


--Q1.How many movies and TV shows are there, and what is their percentage breakdown?

SELECT 
    COUNT(CASE WHEN type = 'Movie' THEN 1 END) AS total_movies,
    COUNT(CASE WHEN type = 'TV Show' THEN 1 END) AS total_tv_shows,
    ROUND(COUNT(CASE WHEN type = 'Movie' THEN 1 END) * 100.0 / COUNT(*), 2) AS movie_percentage,
    ROUND(COUNT(CASE WHEN type = 'TV Show' THEN 1 END) * 100.0 / COUNT(*), 2) AS tv_show_percentage
FROM netflix;


--Q2.What are the most common content ratings for movies and TV shows?

SELECT 
    type,
    rating,
    COUNT(*) AS rating_count
FROM netflix
WHERE rating IS NOT NULL
GROUP BY type, rating 
ORDER BY rating_count DESC;


--Q3.What are the top 5 longest movies?

SELECT
    title,
    CAST(split_part(duration, ' ', 1) AS integer) AS duration_minutes
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY duration_minutes DESC
LIMIT 5;


--Q4.How many titles were released in the last 5 years compared to older classics?

SELECT 
    CASE 
        WHEN release_year >= (SELECT MAX(release_year) FROM netflix) - 5 THEN 'Last 5 Years'
        ELSE 'Older Catalog Classics'
    END AS catalog_category,
    COUNT(*) AS title_count
FROM netflix
GROUP BY 1;


--5.Which release years produced the most content?

SELECT 
    release_year, 
    COUNT(*) AS total_titles
FROM netflix
GROUP BY release_year
ORDER BY total_titles DESC;


--6.What are the top 10 most popular genres?

SELECT 
    TRIM(genre) AS genre_name,
    COUNT(*) AS title_count
FROM netflix,
LATERAL UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
GROUP BY genre_name
ORDER BY title_count DESC
LIMIT 10;


--7.Which countries contribute the highest volume of content, and how does that split between Movies and TV Shows?

SELECT 
    TRIM(single_country) AS country_name,
    type,
    COUNT(*) AS title_count
FROM netflix,
LATERAL UNNEST(STRING_TO_ARRAY(country, ',')) AS single_country
WHERE country IS NOT NULL
GROUP BY country_name, type
ORDER BY title_count DESC;


--8.Who are the top 10 most prolific directors based on total titles produced?

SELECT 
    TRIM(single_director) AS director_name,
    COUNT(*) AS total_titles
FROM netflix,
LATERAL UNNEST(STRING_TO_ARRAY(director, ',')) AS single_director
WHERE director IS NOT NULL
GROUP BY director_name
ORDER BY total_titles DESC
LIMIT 10;


--9.Who are the top 15 actors and actresses who appear most frequently in Netflix casts?

SELECT 
    TRIM(actor) AS actor_name,
    COUNT(*) AS appearance_count
FROM netflix,
LATERAL UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor
WHERE casts IS NOT NULL
GROUP BY actor_name
ORDER BY appearance_count DESC
LIMIT 15;


--10.How many titles feature a director who is also included in the cast list?

SELECT COUNT(DISTINCT n.show_id) AS dual_role_titles
FROM netflix n
WHERE n.director IS NOT NULL AND n.casts IS NOT NULL
  AND EXISTS (
      SELECT 1 
      FROM UNNEST(STRING_TO_ARRAY(n.director, ',')) AS d
      JOIN UNNEST(STRING_TO_ARRAY(n.casts, ',')) AS c 
        ON TRIM(d) = TRIM(c));

  
--11.Which specific year and month had the highest volume of content added to Netflix?

SELECT 
    TO_CHAR(TO_DATE(TRIM(date_added), 'Month DD, YYYY'), 'YYYY-MM') AS year_month,
    COUNT(*) AS added_count
FROM netflix
WHERE date_added IS NOT NULL AND TRIM(date_added) <> ''
GROUP BY year_month
ORDER BY added_count DESC
LIMIT 1;


--12.What is the average time gap in years between a movie's release year and its actual date added to Netflix?

SELECT 
    ROUND(AVG(EXTRACT(YEAR FROM TO_DATE(TRIM(date_added), 'Month DD, YYYY')) - release_year), 2) AS avg_catalog_lag_years
FROM netflix
WHERE type = 'Movie' 
  AND date_added IS NOT NULL 
  AND TRIM(date_added) <> '';


--13.What is the annual growth rate percentage of content additions year-over-year?

WITH yearly_additions AS (
    SELECT 
        EXTRACT(YEAR FROM TO_DATE(TRIM(date_added), 'Month DD, YYYY')) AS addition_year,
        COUNT(*) AS total_added
    FROM netflix
    WHERE date_added IS NOT NULL AND TRIM(date_added) <> ''
    GROUP BY addition_year
)
SELECT 
    addition_year,
    total_added,
    LAG(total_added) OVER (ORDER BY addition_year) AS prev_year_added,
    ROUND(
        (total_added - LAG(total_added) OVER (ORDER BY addition_year)) * 100.0 / 
        NULLIF(LAG(total_added) OVER (ORDER BY addition_year), 0), 2
    ) AS yoy_growth_percentage
FROM yearly_additions
ORDER BY addition_year;


--14.Are there specific months where Netflix historically uploads more content?

SELECT 
    TO_CHAR(TO_DATE(TRIM(date_added), 'Month DD, YYYY'), 'Month') AS addition_month,
    EXTRACT(MONTH FROM TO_DATE(TRIM(date_added), 'Month DD, YYYY')) AS month_number,
    COUNT(*) AS total_added
FROM netflix
WHERE date_added IS NOT NULL AND TRIM(date_added) <> ''
GROUP BY addition_month, month_number
ORDER BY month_number;


--15.What proportion of the current catalog consists of content older than 10 years at the time it was added?

SELECT 
    COUNT(CASE WHEN EXTRACT(YEAR FROM TO_DATE(TRIM(date_added), 'Month DD, YYYY')) - release_year > 10 THEN 1 END) AS older_than_10_years,
    COUNT(*) AS total_catalog,
    ROUND(
        COUNT(CASE WHEN EXTRACT(YEAR FROM TO_DATE(TRIM(date_added), 'Month DD, YYYY')) - release_year > 10 THEN 1 END) * 100.0 / 
        COUNT(*), 2
    ) AS percentage_older_than_10_years
FROM netflix
WHERE date_added IS NOT NULL AND TRIM(date_added) <> '';


--16.What are the top 3 longest movies within each individual genre?

WITH unnested_movies AS (
    SELECT 
        n.title,
        TRIM(g.genre) AS genre,
        CAST(SPLIT_PART(n.duration, ' ', 1) AS INTEGER) AS duration_minutes
    FROM netflix n,
    LATERAL UNNEST(STRING_TO_ARRAY(n.listed_in, ',')) AS g(genre)
    WHERE n.type = 'Movie' AND n.duration IS NOT NULL
),
ranked_movies AS (
    SELECT 
        genre,
        title,
        duration_minutes,
        ROW_NUMBER() OVER (PARTITION BY genre ORDER BY duration_minutes DESC) AS rn
    FROM unnested_movies
)
SELECT genre, title, duration_minutes
FROM ranked_movies
WHERE rn <= 3;


--17.How is content distributed across custom eras based on release year and genre?

WITH categorized_content AS (
    SELECT 
        show_id,
        TRIM(g.genre) AS genre,
        CASE 
            WHEN release_year < 1990 THEN 'Classic Era'
            WHEN release_year BETWEEN 1990 AND 1999 THEN '90s'
            WHEN release_year BETWEEN 2000 AND 2009 THEN '2000s'
            ELSE 'Modern Era'
        END AS era
    FROM netflix,
    LATERAL UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS g(genre)
)
SELECT 
    era,
    genre,
    COUNT(*) AS title_count
FROM categorized_content
GROUP BY era, genre
ORDER BY era, title_count DESC;


--18.How do directors rank within each country based on the number of titles released?

WITH unnested_data AS (
    SELECT 
        TRIM(c.country_name) AS country_name,
        TRIM(d.director_name) AS director_name
    FROM netflix,
    LATERAL UNNEST(STRING_TO_ARRAY(country, ',')) AS c(country_name),
    LATERAL UNNEST(STRING_TO_ARRAY(director, ',')) AS d(director_name)
    WHERE country IS NOT NULL AND director IS NOT NULL
),
director_counts AS (
    SELECT 
        country_name,
        director_name,
        COUNT(*) AS title_count
    FROM unnested_data
    GROUP BY country_name, director_name
),
ranked_directors AS (
    SELECT 
        country_name,
        director_name,
        title_count,
        RANK() OVER (PARTITION BY country_name ORDER BY title_count DESC) AS rnk
    FROM director_counts
)
SELECT country_name, director_name, title_count, rnk
FROM ranked_directors
ORDER BY country_name, rnk;


--19.What is the distribution of TV show durations segmented by season counts?

WITH tv_seasons AS (
    SELECT 
        CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) AS season_count
    FROM netflix
    WHERE type = 'TV Show' AND duration IS NOT NULL
),
segmented_shows AS (
    SELECT 
        CASE 
            WHEN season_count = 1 THEN '1 Season'
            WHEN season_count BETWEEN 2 AND 3 THEN '2-3 Seasons'
            ELSE '4+ Seasons'
        END AS season_segment
    FROM tv_seasons
)
SELECT 
    season_segment,
    COUNT(*) AS total_shows,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM segmented_shows
GROUP BY season_segment
ORDER BY total_shows DESC;


--20.What is the breakdown of content titles based on a recency classification flag?

SELECT 
    CASE 
        WHEN (2026 - release_year) <= 2 THEN 'New Release'
        WHEN (2026 - release_year) BETWEEN 3 AND 5 THEN 'Recent Catalog'
        ELSE 'Legacy'
    END AS recency_category,
    COUNT(*) AS total_titles
FROM netflix
WHERE release_year IS NOT NULL
GROUP BY recency_category
ORDER BY total_titles DESC;