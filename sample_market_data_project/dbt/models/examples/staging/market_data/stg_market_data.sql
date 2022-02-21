/*

The purpose of this model is to create a market_data staging model
with light transformations on top of the source.

*/

{{ config(
    materialized='view'
) }}


WITH source AS (

    SELECT * FROM {{ ref('rp_market_data') }}

),

converted AS (

    SELECT convert_from(data, 'utf8') AS data FROM source

),

casted AS (

    SELECT cast(data AS jsonb) AS data FROM converted

),

renamed AS (

    SELECT

       (data->>'ticker')::string as ticker,
       (data->>'bid')::double as bid_price,
       (data->>'ask')::double as ask_price,
       (data->>'currentPrice')::double as current_price

    FROM casted

)

SELECT * FROM renamed
