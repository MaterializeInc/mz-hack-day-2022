{{ config(
    materialized ='materializedview'
) }}


SELECT fi.icao24,
       manufacturername,
       model,
       operator,
       origin_country,
       time_position,
       longitude,
       latitude
FROM {{ ref('stg_flight_information') }} fi
JOIN {{ ref('stg_icao_mapping') }} icao ON fi.icao24 = icao.icao24
