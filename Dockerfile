FROM python:3.8.1-alpine3.11 AS poetry

RUN apk add --update --no-cache curl

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

WORKDIR /app

ONBUILD COPY pyproject.toml poetry.lock ./

ONBUILD RUN $HOME/.poetry/bin/poetry export -f requirements.txt > requirements.txt

ONBUILD RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_UNINSTALL=1 python

FROM poetry

ENV PD_API_KEY NO_KEY_PRESENT
ENV SLACK_API_KEY NO_KEY_PRESENT

RUN pip install -r requirements.txt

COPY authieux ./authieux/

ENTRYPOINT ["python", "authieux/main.py"]
