FROM python:3.8-slim

COPY requirements.txt .

RUN set -ex; \
  	pip install --no-cache-dir -r requirements.txt

ADD opensky.py .

CMD ["python", "-u", "./opensky.py"]
