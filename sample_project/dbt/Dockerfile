FROM materialize/dbt-materialize:v0.26.0

WORKDIR /usr/app/dbt

COPY requirements.txt .

RUN set -ex; \
    pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/bin/bash"]