# Taking off with Materialize, Redpanda and dbt

This is a sample project with enough plumbing to spin up an end-to-end analytics pipeline using Materialize, Redpanda and dbt. Finding streaming data to play with isn't always a breeze, so we wired up a data generator that polls the [OpenSky Network API](https://openskynetwork.github.io/opensky-api/index.html) continuously to save you some time!

## Setup

<p align="center">
<img width="650" alt="demo_overview" src="https://user-images.githubusercontent.com/23521087/151333471-98ad518d-5ac5-444e-b065-83e3aaa42748.png">
</p>

The project uses Docker Compose to make it easier to bundle up all the services in the pipeline:

* Data generator

* Redpanda

* Materialize

* dbt

* Metabase

### Installation

### Getting the setup up and running

If you're running on an ARM64 architecture, you need an extra initial step to set some environment variables that tell Docker what images to fetch:

```bash
export ARCH=linux/arm64 MIMG=iwalucas
```

Then, run:

```bash
# Start the setup
docker-compose up -d

# Check if everything is up and running!
docker-compose ps
```

At any point, you can stop the data generator using:

```bash
docker stop data-generator
```

Once you're done playing with it, tear the setup down:

```bash
docker-compose down -v
```

## dbt

the ["dbt and Materialize"](https://materialize.com/docs/guides/dbt/#document-and-test-a-dbt-project) guide.

### Get in that shell!

```bash
docker exec -it dbt /bin/bash
```

Check that the `dbt-materialize` plugin has been installed, and that everything is working:

```bash
dbt --version

dbt debug
```

### Build and run your models

```bash
dbt run
```

### Generate documentation

```bash
dbt docs generate

dbt docs serve
```

## Redpanda

### Check the source data

```bash
docker-compose exec redpanda rpk topic list
```

```bash
docker-compose exec redpanda rpk topic consume flight_information
```

To exit the consumer, press **Ctrl+C**.

## Materialize

### Inspect the database

```bash
docker-compose run mzcli
```

```sql
SHOW SOURCES;

         name
-----------------------
 icao_mapping
 rp_flight_information
```

```sql
SHOW VIEWS;

          name
------------------------
 stg_flight_information
 stg_icao_mapping
```

Create source from Redpanda topic
```sql
CREATE MATERIALIZED SOURCE raw_fi FROM KAFKA BROKER 'redpanda:9092'
TOPIC 'flight_information' FORMAT TEXT ;
```

Convert raw text to JSON object
```sql
CREATE VIEW json_fi AS (
  SELECT CAST (text AS JSONB) AS data
  FROM (SELECT * FROM raw_fi)
) ;
```

Convert JSON object to columns
```sql
CREATE VIEW flight_information AS (
  SELECT (data->>'baro_altitude')::decimal(6,4) AS baro_altitude,
         (data->>'callsign')::string            AS callsign,
         (data->>'geo_altitude')::decimal(6,4)  AS geo_altitude,
         (data->>'icao24')::string              AS icao24,
         (data->>'last_contact')::bigint        AS last_contact,
         (data->>'latitude')::decimal(8,6)      AS latitude,
         (data->>'longitude')::decimal(9,6)     AS longitude,
         (data->>'on_ground')::boolean          AS on_ground,
         (data->>'origin_country')::string      AS origin_country,
         (data->>'position_source')::string     AS position_source,
         (data->>'sensors')::string             AS sensors,
         (data->>'spi')::boolean                AS spi,
         (data->>'squawk')::string              AS squawk,
         (data->>'time_position')::bigint       AS time_position,
         (data->>'true_track')::string          AS true_track,
         (data->>'velocity')::string            AS velocity,
         (data->>'vertical_rate')::string       AS vertical_rate
  FROM json_fi
) ;
```

Try a simple query
```sql
SELECT * FROM flight_information WHERE origin_country = 'Malta' LIMIT 10 ;
```

### Query the transformed data

## Metabase

From here, you can pipe data out of Materialize. To visualize the results in [Metabase](https://www.metabase.com/):

**1.** In a browser, navigate to <localhost:3030>.

**2.** Click **Let's get started**.

**3.** Complete the first set of fields asking for your email address. This
    information isn't crucial for anything but has to be filled in.

**4.** On the **Add your data** page, specify the connection properties for the Materialize database:

Field             | Value
----------------- | ----------------
Database          | PostgreSQL
Name              | opensky
Host              | **materialized**
Port              | **6875**
Database name     | **materialize**
Database username | **materialize**
Database password | Leave empty

**5.** Click **Ask a question** -> **Native query**.

**6.** Under **Select a database**, choose **opensky**.
