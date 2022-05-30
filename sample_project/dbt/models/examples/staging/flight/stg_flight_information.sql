/*

The purpose of this model is to create a flight_information staging model
with light transformations on top of the source.

*/

{{ config(
    materialized='view'
) }}


WITH source AS (

    SELECT * FROM {{ source('redpanda','rp_flight_information') }}

),

converted AS (

    SELECT convert_from(data, 'utf8') AS data FROM source

),

casted AS (

    SELECT cast(data AS jsonb) AS data FROM converted

),

renamed AS (

    SELECT

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

    FROM casted

)

SELECT * FROM renamed
