--Advanced SQL Project -- Spotify Datasets
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


--EDA
select count(*) from spotify; 

select count(distinct artist) from spotify;


select distinct album_type from spotify; 

select max(duration_min) from spotify;
select min(duration_min) from spotify;

select * from spotify 
where duration_min = 0;

delete from spotify where duration_min = 0
select * from spotify where duration_min = 0

select distinct channel from spotify;
select distinct most_played_on from spotify; 

/*
-----------------------------------
--DATA Analysis -Easy Category
----------------------------------- 


Retrieve the names of all tracks that have more than 1 billion streams.
List all albums along with their respective artists.
Get the total number of comments for tracks where licensed = TRUE.
Find all tracks that belong to the album type single.
Count the total number of tracks by each artist.*/ 

--Q.1 Retrieve the names of all tracks that have more than 1 billion streams.--------- 
select * from spotify
where stream > 1000000000

--Q.2 List all albums along with their respective artists. --------------- 
select album,artist from spotify
from spotify

--Q.3 Get the total number of comments for tracks where licensed = TRUE. -------- 
select sum(comments) from spotify as total_comments
where licensed = True

--Q.4 Find all tracks that belong to the album type single. ------------------ 
select track from spotify 
where album_type = 'single';

--Q.5 Count the total number of tracks by each artist ------------------ 
select  
artist , count(*) as total_no_songs from spotify 
group by artist 


/*-----Medium Questions-------------------------------------------------------
Calculate the average danceability of tracks in each album.
Find the top 5 tracks with the highest energy values.
List all tracks along with their views and likes where official_video = TRUE.
For each album, calculate the total views of all associated tracks.
Retrieve the track names that have been streamed on Spotify more than YouTube.*/
------------------------------------------------------------------------------- 


--Q.6 Calculate the average danceability of tracks in each album. -- 
select album  ,avg(danceability) as avg_danceability from spotify 
group by album 
order by 2 desc

--Q.7 Find the top 5 tracks with the highest energy values. -------- 
select track, avg(energy) from spotify
group by 1
order by 2 desc
limit 5 


--Q.8 List all tracks along with their views and likes where official_video = TRUE. ----- 
select 
track,
sum(views) as total_views,
sum(likes) as total_likes from spotify
where official_video = 'true'
group by 1
order by 2 desc 

--Q.9 For each album, calculate the total views of all associated tracks. ------- 
select album,track,sum(views) from spotify 
group by 1 ,2
order by 3 desc

--Q.10 Retrieve the track names that have been streamed on Spotify more than YouTube.--- 
select * from 
(select 
track,
coalesce(sum(case when most_played_on = 'Youtube' then stream END),0) as streamed_on_youtube,
coalesce(sum(case when most_played_on = 'Spotify' then stream END),0) as streamed_on_spotify 
from spotify 
group by 1 
) as t1 
where streamed_on_spotify > streamed_on_youtube and streamed_on_youtube <> 0


/*-----Advanced Questions-------------------------------------------------------
Find the top 3 most-viewed tracks for each artist using window functions.
Write a query to find tracks where the liveness score is above the average.
Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
------------------------------------------------------------------------------- 

--Q.11 Find the top 3 most-viewed tracks for each artist using window functions.*/ 
with ranking_artist
as 
(select
artist,track,sum(views) as total_views,
dense_rank() over(partition by artist order by sum(views) desc) as rank 
from spotify 
group by 1 , 2
order by 1,3 desc
)
select * from ranking_artist
where rank <= 3 

--Q.12 Write a query to find tracks where the liveness score is above the average. 
select 
track,
artist,
liveness
from spotify 
where liveness > (SELECT AVG(liveness) from spotify)

--Q.13 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album. --- 
with cte 
as 
(SELECT album,max(energy) as highest_energy,
min(energy) as lowest_energy
from spotify
group by 1)
select album,highest_energy - lowest_energy as enegry_diff 
from cte
order by 2 desc







