/*

Using the flight source files as an example, create dbt models that define 
your Materialize source(s) on top of the streams.

*/


{{ config(
    enabled = false,
    materialized ='source'
) }}

{% set source_name %}
    {{ mz_generate_name('source_name') }}
{% endset %}

CREATE SOURCE {{ source_name }}
FROM KAFKA BROKER 'redpanda:9092' TOPIC 'source_name'
  KEY FORMAT BYTES
  VALUE FORMAT BYTES
ENVELOPE UPSERT;

