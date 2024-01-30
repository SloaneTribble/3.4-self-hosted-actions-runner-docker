# Use Alpine Linux as base image
FROM alpine:3.19.1

# Update package repositories and install/update packages
# jq is a command-line JSON processor
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    jq \
    curl \
    bash

# Set up a non-root user named "GHA"
# -D removes need for user to have a password
# -u 1000 sets UID to 1000
RUN adduser -D -u 1000 GHA

# Set the working directory
WORKDIR /GHA

# Download and unzip the latest GitHub actions 
# runner linux release into the GHA home folder
RUN curl -o actions-runner-osx-x64-2.312.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.312.0/actions-runner-osx-x64-2.312.0.tar.gz
RUN tar xzf ./actions-runner-osx-x64-2.312.0.tar.gz

# Make sure that the GHA user owns the script from #5 and that it is executable
RUN chown GHA:GHA config-and-run.sh
RUN chmod +x config-and-run.sh

# Set the docker image to run as the GHA user
USER GHA

ENTRYPOINT [ "./config-and-run.sh" ]



