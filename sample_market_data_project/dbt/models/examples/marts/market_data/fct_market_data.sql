{{ config(
    materialized ='materializedview'
) }}


SELECT mktdata.ticker,
       company_name
       sector,
       industry,
       business_summary,
       website,
       logo_url,
       bid_price,
       ask_price,
       current_price

FROM {{ ref('stg_market_data') }} mktdata
JOIN {{ ref('stg_security_data') }} refdata ON mktdata.ticker = refdata.symbol
