FROM docker.io/library/node:16.4 as builder

WORKDIR /headlamp-plugins

COPY ./ /headlamp-plugins/

RUN mkdir -p /headlamp-plugins/build

# Build the plugin
RUN npx @kinvolk/headlamp-plugin build /headlamp-plugins

# Extract the built plugin files to the build directory
RUN npx @kinvolk/headlamp-plugin extract /headlamp-plugins/ /headlamp-plugins/build


FROM alpine:latest

# Copy the built plugin files from the base image to /plugins directory
COPY --from=builder /headlamp-plugins/build/ /plugins/

CMD ["/bin/sh -c 'mkdir -p /build/plugins && cp -r /plugins/* /build/plugins/'"]
