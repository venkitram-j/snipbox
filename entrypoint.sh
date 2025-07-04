#!/bin/bash

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $DATABASE_HOST $DATABASE_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

# python manage.py flush --noinput
python manage.py migrate --noinput
python manage.py collectstatic --noinput

gunicorn snipbox.wsgi:application --bind 0.0.0.0:8000

exec "$@"