{{ config(materialized='source') }}

{% set source_name %}
    {{ mz_generate_name('icao_mapping') }}
{% endset %}

CREATE SOURCE {{ source_name }}
FROM FILE '/tmp/icao24_mapping_airbus.json.gz' COMPRESSION GZIP
FORMAT BYTES;