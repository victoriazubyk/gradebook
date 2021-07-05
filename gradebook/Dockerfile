FROM python:3.8

EXPOSE 8000

WORKDIR /app

RUN pip install poetry && poetry config virtualenvs.create false
COPY ["pyproject.toml", "poetry.lock", "/app/"]
RUN poetry install

COPY /scripts /scripts
RUN chmod -R +x /scripts

CMD [ "/scripts/start_django.sh" ]
