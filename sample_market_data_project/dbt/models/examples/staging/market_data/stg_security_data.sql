/*

The purpose of this staging model is to create a security_data staging model
with light transformations on top of the source.

*/

{{ config(
    materialized='view'
) }}


WITH source AS (

    SELECT * FROM {{ ref('security_data') }}

),

converted AS (

    SELECT convert_from(data, 'utf8') AS data FROM source

),

casted AS (

    SELECT cast(data AS jsonb) AS data FROM converted

),

renamed AS (

    SELECT

        (data->>'symbol')::string AS symbol,
        (data->>'shortName')::string AS company_name,
        (data->>'sector')::string AS sector,
        (data->>'industry')::string AS industry,
        (data->>'longBusinessSummary')::string AS business_summary,
        (data->>'website')::string AS website,
        (data->>'logo_url')::string AS logo_url

    FROM casted

)

SELECT * FROM renamed
