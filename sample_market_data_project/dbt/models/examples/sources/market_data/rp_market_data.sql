{{ config(materialized='source') }}

{% set source_name %}
    {{ mz_generate_name('rp_market_data') }}
{% endset %}

CREATE SOURCE {{ source_name }}
FROM KAFKA BROKER 'redpanda:9092' TOPIC 'kf-mktdata-ticks'
  KEY FORMAT BYTES
  VALUE FORMAT BYTES
ENVELOPE UPSERT;