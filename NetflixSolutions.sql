-- NETFLIX PROJECT

CREATE TABLE NETFLIX 
(
   show_id VARCHAR(5),
   type     VARCHAR(10),
   title    VARCHAR(150),
   director   VARCHAR(208),
   castS  VARCHAR(1000),
   country   VARCHAR(150),
   date_added   VARCHAR(50),
   release_year  INT,
   rating	VARCHAR(10),
   duration  VARCHAR(15),
   listed_in	VARCHAR(100),
   description   VARCHAR(250)
);

SELECT * FROM NETFLIX;

SELECT COUNT(*) FROM NETFLIX;

-- 15 BUSINESS PROBLEMS

-- 1. Count the Number of Movies vs TV Shows
SELECT TYPE, 
COUNT(*) AS TOTAL_CONTENT FROM NETFLIX 
GROUP BY TYPE;


--2. Find the Most Common Rating for Movies and TV Shows

WITH TopRating AS (
    SELECT 
        type,
        rating,
        ROW_NUMBER() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rn
    FROM netflix
    GROUP BY type, rating
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM TopRating
WHERE rn = 1;


--3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT * FROM NETFLIX 
WHERE  RELEASE_YEAR =  2020 AND TYPE = 'Movie';

--4. Find the Top 5 Countries with the Most Content on Netflix

SELECT
   UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
   COUNT (show_id) as total_content
FROM NETFLIX
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;

--5. Identify the Longest Movie?

SELECT *FROM NETFLIX
WHERE TYPE = 'Movie'
And Duration = (select max(duration) from Netflix);


--6. Find Content Added in the Last 5 Years

Select * from netflix
where to_date(date_added, 'MONTH DD YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';


--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
 SELECT TYPE, Director FROM NETFLIX
 WHERE DIRECTOR like '%Rajiv Chilaka%';


8. List All TV Shows with More Than 5 Seasons
 Select * from netflix
 where type = 'TV Show' AND SPLIT_PART(duration, ' ', 1)::INT > 5;

9. Count the Number of Content Items in Each Genre

SELECT
   UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
   COUNT (show_id) as total_content
FROM NETFLIX
GROUP BY genre;


--10.Find each year and the average numbers of content release in India on netflix. Return top 5 year with highest avg content release!

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


--11. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in ILIKE '%Documentaries';


--12. Find All Content Without a Director

SELECT * FROM NETFLIX 
WHERE DIRECTOR IS NULL;


13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * FROM NETFLIX
WHERE CASTS ILIKE '%SALMAN KHAN%' 
AND
RELEASE_YEAR > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT  
   UNNEST(STRING_TO_ARRAY (CASTS, ',')) AS ACTOR,
   COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX
WHERE COUNTRY ILIKE '%INDIA%'
GROUP BY ACTOR
ORDER BY TOTAL_CONTENT DESC
LIMIT 10;


--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad Content'
            ELSE 'Good Content'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;


 