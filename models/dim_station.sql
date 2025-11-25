WITH stations AS(
    SELECT 
    start_statio_id,
    start_station_name,
    start_lat,
    start_lng

    FROM {{source("labs_raw_data", "bikes")}}
)


SELECT * FROM stations 
