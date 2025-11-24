WITH CTE AS(
    SELECT
    TO_TIMESTAMP(started_at) as started_at,
    DATE(TO_TIMESTAMP(started_at)) as started_date,
    HOUR(TO_TIMESTAMP(started_at)) as started_hour,
    {{get_day_type('started_at')}} AS day_type,
    {{get_season('started_at')}} AS year_season
    FROM {{source("labs_raw_data", "bikes")}}   
)


SELECT * FROM CTE