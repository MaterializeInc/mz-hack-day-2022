#!/usr/bin/env python

import time
import os
import json
import schedule
import logging
from kafka import KafkaProducer
from yfinance import Ticker, Tickers

SUBSCRIBED_FIELDS = {"bid", "ask", "currentPrice"}


def create_kafka_producer() -> KafkaProducer:
    kafkaBrokers = os.getenv("KAFKA_BROKERS", "")
    return KafkaProducer(bootstrap_servers=kafkaBrokers)


def create_payload(security: Ticker) -> bytes:
    payload = json.dumps(
        {
            "ticker": security.ticker,
            **{k: v for k, v in security.info.items() if k in SUBSCRIBED_FIELDS},
        }
    )
    return payload.encode("utf-8")


def get_tickers() -> Tickers:
    tickers = os.getenv("TICKERS", "")
    return Tickers(tickers)


def produce_ticks(kafka_producer: KafkaProducer, topic: str, security_data: Tickers):
    for ticker, security in security_data.tickers.items():
        kafka_producer.send(
            topic=topic,
            key=ticker.encode("utf-8"),
            value=create_payload(security),
        )
    kafka_producer.flush()


if __name__ == "__main__":
    producer = create_kafka_producer()
    topic = os.getenv("KAFKA_MARKET_DATA_TOPIC", "")
    produce_ticks(producer, topic, get_tickers())
    schedule.every(60).seconds.do(
        produce_ticks, kafka_producer=producer, topic=topic, security_data=get_tickers()
    )

    while True:
        schedule.run_pending()
        time.sleep(1)
