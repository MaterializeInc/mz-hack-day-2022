/* 

The purpose of this staging model is to create a flight_information staging model 
with light transformations on top of the source.

*/

{{ config(
    materialized='view'
) }}


with source as (
    
    select * from {{ ref('rp_flight_information') }}
    
),

converted as (
    
    select convert_from(data, 'utf8') as data from source

),

casted as (
    
    select cast(data as jsonb) as data from converted
            
),

renamed as (

    select 
    
       (data->>'icao24')::string as icao24,
       (data->>'callsign')::string as callsign,
       (data->>'origin_country')::string as origin_country,
       (data->>'time_position')::numeric as time_position,
       (data->>'last_contact')::numeric as last_contact,
       (data->>'longitude')::double as longitude,
       (data->>'latitude')::double as latitude,
       (data->>'baro_altitude')::double as baro_altitude,
       (data->>'on_ground')::boolean as on_ground,
       (data->>'velocity')::double as velocity,
       (data->>'true_track')::double as true_track,
       (data->>'vertical_rate')::string as vertical_rate,
       (data->>'sensors')::string as sensors,
       (data->>'geo_altitude')::string as geo_altitude,
       (data->>'squawk')::string as squawk,
       (data->>'spi')::string as spi,
       (data->>'position_source')::string as position_source
     
    from casted
    
)

select * from renamed
