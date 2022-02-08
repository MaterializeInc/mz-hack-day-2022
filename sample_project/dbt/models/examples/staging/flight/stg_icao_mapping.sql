/*

The purpose of this staging model is to create a icao_mapping staging model
with light transformations on top of the source.

*/

{{ config(
    materialized='view'
) }}


WITH source AS (

    SELECT * FROM {{ ref('icao_mapping') }}

),

converted AS (

    SELECT convert_from(data, 'utf8') AS data FROM source

),

casted AS (

    SELECT cast(data AS jsonb) AS data FROM converted

),

renamed AS (

    SELECT

    (data->>'icao24')::string AS icao24,
           (data->>'manufacturericao')::string AS manufacturericao,
           (data->>'manufacturername')::string AS manufacturername,
           (data->>'model')::string AS model,
           (data->>'typecode')::string AS typecode,
           (data->>'icaoaircrafttype')::string AS icaoaircrafttype,
           (data->>'operator')::string AS operator,
           (data->>'operatorcallsign')::string AS operatorcallsign,
           (data->>'operatoricao')::string AS operatoricao,
           (data->>'built')::string AS built,
           (data->>'categorydescription')::string AS categorydescription

    FROM casted

)

SELECT * FROM renamed
