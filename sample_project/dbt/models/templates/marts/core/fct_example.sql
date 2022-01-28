/*
You can use this this model file to create a fact or dim table by joining existing 
models. Don't forget to document and apply tests to any dbt model models you have created
*/


{{ config(
    enabled = false,
    materialized ='source'
) }}


select * from {{ ref('stg_example') }}
