FROM elixir:1.15.4-otp-25-alpine AS build

# Add current Mix project
ADD . /app
WORKDIR /app

# Install package managers
RUN mix local.hex --force
RUN mix local.rebar --force

# Fetch dependencies
RUN mix deps.get

# Build release

ENV MIX_ENV=prod
RUN mix release

FROM elixir:1.15.4-otp-25-alpine

ENV MIX_ENV=prod
EXPOSE 4000

COPY --from=build /app/_build/prod/rel/pong /opt/pong

ENTRYPOINT ["/opt/pong/bin/pong", "start"]
