#!/bin/bash
# loading env from .env file
export $(xargs <.env)

# while IFS== read -r key value; do
#   printf -v "$key" %s "$value" && export "$key"
# done <.env
