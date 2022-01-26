{{ config(materialized='source') }}

{% set source_name %}
    {{ mz_generate_name('rp_flight_information') }}
{% endset %}

CREATE SOURCE {{ source_name }}
FROM KAFKA BROKER 'redpanda:9092' TOPIC 'flight_information'
  KEY FORMAT BYTES
  VALUE FORMAT BYTES
ENVELOPE UPSERT;