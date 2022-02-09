# OpenSky Data Generator

The `opensky.py` data generator pulls live flight information data from the [OpenSky REST API](https://openskynetwork.github.io/opensky-api/rest.html) [^1] **every 15 seconds**, and uses the [Kafka Python client](https://kafka-python.readthedocs.io/en/master/) (`kafka-python`) to push events into Redpanda.

**Example:**

```javascript
{
	"icao24": "c00734",
	"callsign": "WJA1468",
	"origin_country": "Canada",
	"time_position": 1644173486,
	"last_contact": 1644173487,
	"longitude": -112.5983,
	"latitude": 41.6014,
	"baro_altitude": 10668,
	"on_ground": false,
	"velocity": 256.33,
	"true_track": 178.16,
	"vertical_rate": 0,
	"sensors": null,
	"geo_altitude": 10835.64,
	"squawk": "1374",
	"spi": false,
	"position_source": 0
}
```

The flight information events can be enriched with the sample aircraft reference data provided in [`/data`](../data) based on the `icao24` field.

**Example:**

```javascript
{
	"icao24":"c00734",
	"manufacturericao":"AIRBUS",
	"manufacturername":"Airbus",
	"model":"ACJ319 115X",
	"typecode":"A319",
	"icaoaircrafttype":"L2J",
	"operator":"Qatar Executive",
	"operatorcallsign":"",
	"operatoricao":"QQE",
	"built":"2009-01-01",
	"categorydescription":"Large (75000 to 300000 lbs)"
}
```

[^1]: The OpenSky Network, http://www.opensky-network.org

## Tweaking the code

If you make any changes to the data generator, rebuild the container using:

```bash
docker-compose build --no-cache

docker-compose up --force-recreate -d
```