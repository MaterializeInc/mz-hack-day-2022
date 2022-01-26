#!/usr/bin/env python
import datetime
import time
import sys
import os
import json
import requests
import schedule
import logging
from kafka import KafkaProducer

def json_serializer(obj):
    if isinstance(obj, (datetime.datetime, datetime.date)):
        return obj.isoformat()
    raise "Type %s not serializable" % type(obj)


def get_opensky():

    # Producer instance
    prod = KafkaProducer(bootstrap_servers='redpanda:9092')

    try:
        # Documentation: https://openskynetwork.github.io/opensky-api/rest.html#all-state-vectors
        # Unauthenticated requests are capped to a time resolution of 10 seconds.
        r = requests.get('https://opensky-network.org/api/states/all').json()

        for sv in r['states']:

            json_value=json.dumps({"icao24": sv[0],
                                   "callsign": sv[1],
                                   "origin_country": sv[2],
                                   "time_position": sv[3],
                                   "last_contact": sv[4],
                                   "longitude": sv[5],
                                   "latitude": sv[6],
                                   "baro_altitude": sv[7],
                                   "on_ground": sv[8],
                                   "velocity": sv[9],
                                   "true_track": sv[10],
                                   "vertical_rate": sv[11],
                                   "sensors": sv[12],
                                   "geo_altitude": sv[13],
                                   "squawk": sv[14],
                                   "spi": sv[15],
                                   "position_source": sv[16]
                    },default=json_serializer, ensure_ascii=False)

            prod.send(topic='flight_information', key=sv[0].encode('utf-8'), value=json_value.encode('utf-8'))

        prod.flush()

    except Exception as e:
        print("Exception: %s" % str(e),file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":

    get_opensky()
    schedule.every(15).seconds.do(get_opensky)

    while True:
        schedule.run_pending()
        time.sleep(1)
