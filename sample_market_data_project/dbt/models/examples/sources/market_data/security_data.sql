{{ config(materialized='source') }}

{% set source_name %}
    {{ mz_generate_name('security_data') }}
{% endset %}

CREATE SOURCE {{ source_name }}
FROM FILE '/tmp/security_data.json.gz' COMPRESSION GZIP
FORMAT BYTES;