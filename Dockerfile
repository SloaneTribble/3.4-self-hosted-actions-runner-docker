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
# -u 1000 sets UID to 1000 (omitting for now -- necessary?)
RUN adduser -D GHA

# Download and unzip the latest GitHub actions 
# runner linux release into the GHA home folder
RUN cd /home/GHA && mkdir actions-runner && cd actions-runner \
    && curl -o actions-runner-linux-x64-2.312.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.312.0/actions-runner-linux-x64-2.312.0.tar.gz \
    && tar xzf ./actions-runner-linux-x64-2.312.0.tar.gz

# Copy the shell script into Docker image
COPY config-and-run.sh config-and-run.sh

# Make sure that the GHA user owns the runner script and that it is executable
# -R performs the operation recursively
RUN chown -R GHA:GHA config-and-run.sh
RUN chmod +x config-and-run.sh

# Set the docker image to run as the GHA user
USER GHA

ENTRYPOINT [ "./config-and-run.sh" ]



