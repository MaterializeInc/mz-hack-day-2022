/* 

The purpose of this staging model is to create a icao_mapping staging model 
with light transformations on top of the source

*/

{{ config(
    materialized='view'
) }}


with source as (
    
    select * from {{ ref('icao_mapping') }}
    
),

converted as (
    
    select convert_from(data, 'utf8') as data from source

),

casted as (
    
    select cast(data as jsonb) as data from converted
            
),

renamed as (

    select 
    
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
     
    from casted
    
)

select * from renamed
