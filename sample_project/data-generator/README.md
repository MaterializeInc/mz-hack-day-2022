# OpenSky Data Generator

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

[](../data/)

```javascript
{
	"icao24":"06a0d6",
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

## Tweaking the code

If you make any changes to the data generator, rebuild the container using:

```bash
docker-compose build --no-cache

docker-compose up --force-recreate -d
```