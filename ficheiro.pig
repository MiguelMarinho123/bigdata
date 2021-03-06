ratings = LOAD '/root/input/u.data' USING PigStorage('\t') AS (user_id:int, movie_id:int, rating:int, time:int);
group_ratings = GROUP ratings BY movie_id;
avg_ratings = FOREACH group_ratings GENERATE group as movie_id, AVG(ratings.rating) as avg_rating , COUNT(ratings.rating) as cnt;
avg_ratings = FILTER avg_ratings BY cnt >= 10;

movies = LOAD '/root/input/u.item' USING PigStorage('|') AS (movie_id:int, movie_name:chararray);

grouped_tables = JOIN avg_ratings BY movie_id, movies BY movie_id;
dataset = FOREACH grouped_tables GENERATE movies::movie_name as movie_name, SIZE(movie_name) as len_movie;
ordered = ORDER dataset BY len_movie desc;
top10 = LIMIT ordered 10;
DUMP top10;
