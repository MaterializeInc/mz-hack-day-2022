# dbt

### Syncing schemas from dbt to Metabase

We included the [`dbt-metabase`](https://github.com/gouline/dbt-metabase) plugin in the setup so you can experiment with model synchronization between dbt and Metabase.

#### Populate the Metabase data model

To populate the Metabase [data model](https://www.metabase.com/glossary/data_model) from existing model properties and configurations:

```bash
dbt-metabase models \
    --dbt_path . \
    --dbt_schema public \
    --dbt_database materialize \
    --metabase_host metabase:3000 \
    --metabase_user <email-address> \
    --metabase_password <password> \
    --metabase_database opensky \
    --metabase_http
```

#### Create dbt exposures

To automatically generate a YAML file with [exposures](https://docs.getdbt.com/docs/building-a-dbt-project/exposures/) from Metabase:

```bash
dbt-metabase exposures \
    --dbt_manifest_path ./target/manifest.json \
    --dbt_schema public \
    --dbt_database materialize \
    --metabase_host metabase:3000 \
    --metabase_user <email-address> \
    --metabase_password <password> \
    --metabase_database opensky \
    --output_path ./models/ \
    --output_name metabase_exposures \
    --metabase_http
```