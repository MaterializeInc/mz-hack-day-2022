# Taking off with Materialize, Redpanda and dbt

This is a sample project with enough plumbing to spin up an end-to-end analytics pipeline using Materialize, Redpanda and dbt to explore real-time data.

## Setup

<p align="center">
<img width="650" alt="demo_overview" src="https://user-images.githubusercontent.com/23521087/151333471-98ad518d-5ac5-444e-b065-83e3aaa42748.png">
</p>

The project uses [Docker Compose](https://docs.docker.com/get-started/08_using_compose/) to make it easier to bundle up all the services in the pipeline:

* **Data generator**

  Finding streaming data to play with isn't always a breeze, so we wired up a data generator that polls the [OpenSky Network API](https://openskynetwork.github.io/opensky-api/index.html) continuously to save you some time! For details like poll frequency and message schema, or just a template to create a message producer for a different source of data, check the [`data-generator` directory](/data-generator).

* **Redpanda**

  The data generator produces JSON-formatted events with flight information into the `flight_information` Redpanda topic. You can think of Redpanda as your source of truth, the system that stores and distributes your business-critical data downstream.

* **Materialize**

  Materialize is set up to consume streaming flight information from Redpanda, as well as static aircraft reference data. The sources and transformations will be defined using dbt! We've also included `mzcli` (a `psql`-like SQL client) in the setup, so you can easily connect to the running Materialize instance.

* **dbt**

  dbt acts as the SQL transformation layer in the setup, and is bootstrapped with some examples and templates to get you going.

* **Metabase**

### Installation

To get started, make sure you have installed:

* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)

We recommend running Docker with at least 2 CPUs and 8GB of memory, so double check your [resource preferences](https://docs.docker.com/desktop/mac/#preferences) before moving on!

### Getting the setup up and running

> :raised_hand_with_fingers_splayed: **Warning for M1 Mac users:** some of the tools used in this project don't provide multi-architecture Docker images just yet, so you need to run an extra initial step to set the variables that determine the right images to fetch for `arm64`. **Don't skip this step!**

If you're on a M1 Mac, first run:

```bash
export ARCH=linux/arm64 MIMG=iwalucas`
```

To get the setup up and running:

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

Once you're done playing with the setup, tear it down:

```bash
docker-compose down -v
```

## Redpanda

### Check the source data

To tap into and manage Redpanda, you can use their neat [rpk](https://docs.redpanda.com/docs/reference/rpk-commands/) CLI. For example, to check that the topic has been created, run:

```bash
docker-compose exec redpanda rpk topic list
```

and that there's data landing from the `data-generator`:

```bash
docker-compose exec redpanda rpk topic consume flight_information
```

To exit the consumer, press **Ctrl+C**.

## dbt

If this is your first time trying out dbt with Materialize, our [dbt + Materialize guide](https://materialize.com/docs/guides/dbt/#document-and-test-a-dbt-project) should give you a good overview of the basic concepts and supported materializations.

### Get in that shell!

To access the [dbt CLI](https://docs.getdbt.com/dbt-cli/cli-overview), run:

```bash
docker exec -it dbt /bin/bash
```

From here, you can run dbt commands as usual. For example, to check that the `dbt-materialize` plugin has been installed, and that everything is working:

```bash
dbt --version

dbt debug
```

### Build and run your models

> **Note:** any changes you make to the `/dbt` directory locally, like adding new models, will be shipped to the container automatically.

We've created a few core models that take care of defining [_sources_](https://materialize.com/docs/overview/api-components/#source-components) in Materialize:

* `rp_flight_information.sql`

* `icao_mapping.sql`

, as well as some staging [_views_](https://materialize.com/docs/overview/api-components/#non-materialized-views) to transform the source data:

* `stg_flight_information.sql`

* `stg_icao_mapping.sql`

, [run](https://docs.getdbt.com/reference/commands/run) the dbt models:

```bash
dbt run
```

The first time you run a dbt model on top of Materialize…well, you never have to run it again! No matter how much or how frequently your data arrives, your models will stay up-to-date without manual or configured refreshes.

### Generate documentation

To generate documentation for your project and bring up the website, run:

```bash
dbt docs generate

dbt docs serve
```

The documentation website should be available at: [http://localhost:8000/](http://localhost:8000/)

## Materialize

If you're completely new to Materialize, you can refer to our [getting started guide](https://materialize.com/docs/get-started/) for .

### Inspect the database

To connect to the running Materialize service, you can use any [compatible CLI](https://materialize.com/docs/connect/cli/). Let's roll with `mzcli`, which is included in the setup:

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

## Metabase

To visualize the results in [Metabase](https://www.metabase.com/):

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