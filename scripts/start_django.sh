#!/bin/bash

python manage.py migrate
gunicorn gradebook.wsgi --bind 0.0.0.0:8000 --reload --preload
