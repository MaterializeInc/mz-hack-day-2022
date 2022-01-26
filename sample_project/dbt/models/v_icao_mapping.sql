{{ config(materialized='view') }}

SELECT (data->>'icao24')::string AS icao24,
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
FROM (SELECT CAST(data AS JSONB) AS data
      FROM (
        SELECT CONVERT_FROM(data, 'utf8') AS data
        {# /* FROM {{ source('public','icao_mapping') }} */ #}
        FROM {{ ref('icao_mapping') }} )
)