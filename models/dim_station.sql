WITH stations AS(
    SELECT 
    start_statio_id,
    start_station_name,
    start_lat,
    start_lng

    FROM {{ ref('stg_bikes') }}
)


SELECT * FROM stations 
