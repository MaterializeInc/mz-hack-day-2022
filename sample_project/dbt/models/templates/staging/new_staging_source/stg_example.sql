/*

Using the staging models in the staging flight folder as an example,
create staging models to do light transformations on your declared sources.

*/

{{ config(
    enabled = false,
    materialized ='view'
) }}

SELECT * FROM {{ ref('source_example') }}