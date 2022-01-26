{{ config(materialized='view') }}

SELECT (data->>'icao24')::string AS icao24,
       (data->>'callsign')::string AS callsign,
       (data->>'origin_country')::string AS origin_country,
       (data->>'time_position')::numeric AS time_position,
       (data->>'last_contact')::numeric AS last_contact,
       (data->>'longitude')::double AS longitude,
       (data->>'latitude')::double AS latitude,
       (data->>'baro_altitude')::double AS baro_altitude,
       (data->>'on_ground')::boolean AS on_ground,
       (data->>'velocity')::double AS velocity,
       (data->>'true_track')::double AS true_track,
       (data->>'vertical_rate')::string AS vertical_rate,
       (data->>'sensors')::string AS sensors,
       (data->>'geo_altitude')::string AS geo_altitude,
       (data->>'squawk')::string AS squawk,
       (data->>'spi')::string AS spi,
       (data->>'position_source')::string AS position_source
FROM (SELECT CAST(data AS JSONB) AS data
      FROM (
        SELECT CONVERT_FROM(data, 'utf8') AS data
        FROM {{ ref('rp_flight_information') }} )
)