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