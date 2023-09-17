# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian instead of
# Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20210902-slim - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.13.1-erlang-23.3.4.7-debian-bullseye-20210902-slim
#
ARG BUILDER_IMAGE="hexpm/elixir:1.13.1-erlang-23.3.4.7-debian-bullseye-20210902-slim"
ARG RUNNER_IMAGE="debian:bullseye-20210902-slim"

FROM ${BUILDER_IMAGE} as builder

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git npm \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# copy umbrella app
COPY apps apps
COPY run_task.sh .

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix do deps.get, deps.compile

# collect node_modules
#RUN mix assets.install
#RUN mix assets.deploy

RUN mix compile

COPY config/runtime.exs config/

RUN mix release geolocation_service_importer
RUN mix release geolocation_service_web
RUN mix release geolocation_service_migrator

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/geolocation_service_importer ./geolocation_service_importer
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/geolocation_service_web ./geolocation_service_web
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/geolocation_service_migrator ./geolocation_service_migrator

COPY --from=builder --chown=nobody:root /app/run_task.sh ./geolocation_service_importer
RUN chmod +x ./geolocation_service_importer/run_task.sh

USER nobody

