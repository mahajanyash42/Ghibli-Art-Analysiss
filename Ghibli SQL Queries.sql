USE yashdb;
GO
SELECT * FROM df_ghibli

-- BASIC SQL QUESTIONS

-- 1.) How many unique characters are in the dataset?
Select count(distinct(character_name)) as total_characters
from df_ghibli

-- 2.) List all special powers available in the dataset.
select distinct(special_powers) as unique_powers
from df_ghibli

-- 3.) Find number of characters from each country
select count(character_name) as num_char, country
from df_ghibli
group by country

-- 4.) what is the avg age of all characters?
select avg(age) as avg_age
from df_ghibli

-- 5.) Which character has maximum height?
select top 1 character_name , height
from df_ghibli
order by height desc

select top 1 character_name , height
from df_ghibli
where height = (select max(height) from df_ghibli)

-- 6.) Find the count of characters based on species.
select species, count(character_name) as num_char
from df_ghibli 
group by species

-- 7.) Which movies have more than 5 characters?
select movie , count(character_name) as num_char
from df_ghibli
group by movie
having count(character_name) > 5

-- 8.) Find characters who have more than one special power.
select character_name , count(special_powers) as countt
from df_ghibli
group by character_name
having count(special_powers) > 1 

-- 9.) Retrieve the oldest character in the dataset
select top 1 character_name, age
from df_ghibli
where age = (select max(age) from df_ghibli)

-- 10.) Get the number of male and female characters in the dataset.
select gender, count(gender) as dist
from df_ghibli
group by gender

SELECT * FROM df_ghibli

-- MODERATE SQL QUESTIONS

-- 11.) Find the top 3 countries with the most characters in the dataset
select top 3 country , count(character_name) as num_char
from df_ghibli
group by country
order by num_char desc

-- 12.)  Identify characters that appear in multiple movies.
select character_name , count(movie) as num_mov
from df_ghibli
group by character_name
having count( movie) > 1

-- 13.) Find the most common special power among all characters. (needs to be reviewed)
select top 1  special_powers, count(special_powers) as freq
from df_ghibli
group by special_powers
order by freq desc


-- 14.) List movies released before the year 2000 that have more than 3 characters.
select movie , release_date , count(character_name) as char_freq
from df_ghibli
where release_date < 2000
group by movie, release_date
having count(character_name) > 3
order by char_freq desc

 select * from df_ghibli

-- 15.) Find the youngest and oldest characters for each species.
SELECT species, 
       MIN(age) AS youngest_age, 
       MAX(age) AS oldest_age
FROM df_ghibli
GROUP BY species;

-- 16.) Find the average height of characters based on their species.
select species, avg(height) as avg_height
from df_ghibli
group by species

-- 17.) Retrieve characters who have both 'Flight' and 'Teleportation' as special powers.(CHECK ONCE AGAIN) 
SELECT character_name, 
FROM df_ghibli
WHERE special_powers IN ('Flight', 'Teleportation')
GROUP BY character_name
HAVING COUNT(DISTINCT special_powers) = 2;

-- 18.) Rank characters by age within their species (oldest first).
select distinct character_name, age , species, rank() over (partition by species order by age desc) as rankk
from df_ghibli
order by rankk

-- 19.) Find the number of characters per movie, sorted in descending order.
select movie , count(character_name) as freq
from df_ghibli
group by movie
order by freq desc

-- 20.) Identify the gender distribution for each species.
select species ,gender , count(gender) as freq
from df_ghibli
group by species, gender
order by species

select * from df_ghibli

-- INTERMEDIATE SQL QUESTIONS

-- 21.)  Find the character with the most unique special powers.
SELECT top 1 character_name, COUNT(special_powers) AS unique_powers
FROM df_ghibli
GROUP BY character_name
ORDER BY unique_powers DESC

-- 22.) Find the second most common species in the dataset.
select species, species_count
from (select species, count(*) AS species_count
from df_ghibli
group by species) 
as subquery
order by species_count desc
offset 1 rows fetch next 1 rows only;


-- 23.) Find characters who are taller than the average height of their species.
select character_name, height
from df_ghibli
where height > (select avg(height) from df_ghibli)

-- 24.) Rank movies by character diversity (i.e., number of unique species in each movie).
select movie , count(distinct species) as countt , rank() over (order by count(species) desc) as rankk
from df_ghibli 
group by movie
-- order by countt desc


-- 25.) Find the most common special power for each gender.
with cte as (select gender, special_powers, count(special_powers) as countt , rank() over (partition by gender order by count(special_powers) desc) as rankk
from df_ghibli
--where rankk = 1
group by gender, special_powers
)
--order by gender, countt desc)
select *  from cte
where rankk = 1;


-- 26.) Find characters that share the same age, height, and species.
select count(character_name) , age , height , species
from df_ghibli
group by age , height , species
HAVING COUNT(*) > 1



-- 27.) Find the total number of characters per country and their percentage of the dataset.
select country ,count(character_name) as countt , round (100,0 * count(*)/ (select count(*) from df_ghibli),2) as percentt
from df_ghibli
group by country
ORDER BY countt DESC;


-- 28.)  Find characters who have appeared in exactly two different movies.
select character_name, movie, count(movie) as countt
from df_ghibli
group by character_name, movie
having count(distinct movie) = 2

-- 29.) Identify the top 5 most powerful characters based on the number of special powers they possess.
select top 5 character_name, count(distinct special_powers) as countt
from df_ghibli
group by character_name
order by countt desc

-- 30.) Find the oldest character in each country and rank them by age.
select character_name , country , age , rank() over (partition by country order by age desc) as rankk
from df_ghibli

-- ADVANCED SQL QUESTIONS

-- 31.) Find the average height of each species and list characters taller than their species average.
with cte as (select  species, avg(height) as avg_height
from df_ghibli
group by species )
-- order by species, avg_height desc
select t.character_name , t.species , t.height , s.avg_height
from df_ghibli t
join cte s 
on t.species = s.species
where t.height > s.avg_height;


-- 32.) Rank movies by character diversity (i.e., number of unique species in each movie).
select movie , count(distinct species) countt , rank() over (order by count(distinct species) desc )as rank
from df_ghibli
group by movie

-- 33.) Find the oldest character in each country.
with cte as (select character_name , age , country , rank() over (partition by country order by age desc) as rankk
from df_ghibli
group by country, character_name, age)
select * from cte
where rankk =1
--order by country , age desc

-- 34.) Identify characters appearing in multiple movies and count their appearances.
with cte as (select character_name , count(distinct movie) as countt
from df_ghibli
group by character_name, movie)
--order by character_name)
select * from cte where countt > 1


-- 35.) Find the most common special power per gender.
with cte as (select gender, special_powers , count(special_powers) as countt
, rank() over (partition by gender order by count(special_powers) desc) as rankk
from df_ghibli
group by gender, special_powers)
select * from cte 
where rankk = 1
--order by gender , countt desc
l
-- 36.) Find characters that appear in exactly two different movies.
select character_name , count(movie) as countt
from df_ghibli
group by character_name
having count(movie)  = 2

WITH movie_appearances AS (
    SELECT character_name, COUNT( movie) AS movie_count
    FROM df_ghibli
    GROUP BY character_name
)
SELECT *
FROM movie_appearances
WHERE movie_count = 2;

-- 37.) Calculate the percentage of characters from each country.
select country , count(*) as countt , 
(count(*)* 100)/ sum(count(*)) over() as percentage
from df_ghibli
group by country
order by percentage desc

-- 38.) Find the most powerful characters (by number of unique special powers).
with cte as (select character_name , count(distinct special_powers) as countt
from df_ghibli
group by character_name)
select top 1 * from cte 
where countt = (select max(countt) from cte)


-- 39.) Identify duplicate characters (same age, height, species).
with cte as (select age , height , species , count(*) as dup
from df_ghibli
group by age , height , species)
select * from cte
where dup > 1

-- 40.) Find the second most common species in the dataset.
with cte as (select species , count(species) as countt
from df_ghibli
group by species)
SELECT top 1 species , countt as common FROM cte
WHERE countt < (SELECT MAX(countt) FROM cte)
order by common desc


