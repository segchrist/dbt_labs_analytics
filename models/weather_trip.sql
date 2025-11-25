WITH CTE AS (

select
t.*,
w.*
from {{ ref('fact_trips') }} t
left join {{ ref('daily_weather') }} w
on t.TRIP_DATE = w.DAILY_WEATHER

order by TRIP_DATE desc

)


select
*
from CTE