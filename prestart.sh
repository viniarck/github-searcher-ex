#! /usr/bin/env bash

echo "Waiting for the DB to start"
sleep 10;

echo "cd /app"
cd /app

echo "Trying to upgrade migrations to head"
mix local.rebar --force
mix deps.update ranch
mix deps.get
mix ecto.migrate
mix phx.server
