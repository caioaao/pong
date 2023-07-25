# Use the latest Elixir image from Docker Hub
FROM elixir:1.15.4-otp-25

# Add current Mix project
ADD . /app
WORKDIR /app

# Install package managers
RUN mix local.hex --force
RUN mix local.rebar --force

# Fetch dependencies
RUN mix deps.get

# Compile and run the app
ENTRYPOINT ["mix", "run", "--no-halt"]
