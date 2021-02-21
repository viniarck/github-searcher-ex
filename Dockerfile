FROM elixir:1.11.3
# Dockerfile for testing the app

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY . /app
RUN mix local.hex --force
RUN mix deps.get

CMD ["bash", "-c", "/app/prestart.sh"]
