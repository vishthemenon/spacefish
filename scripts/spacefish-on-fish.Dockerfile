# Speficy fish version to use during build
# docker build -t <image> --build-arg FISH_VERSION=<version>
ARG FISH_VERSION=3.0.0
FROM ohmyfish/fish:${FISH_VERSION}

# Redeclare ARG so its value is available after FROM (cf. https://github.com/moby/moby/issues/34129#issuecomment-417609075)
ARG FISH_VERSION
RUN printf "\nBuilding \e[38;5;27mFish-%s\e[m\n\n" ${FISH_VERSION}

USER root
RUN apk add \
    --no-cache \
    coreutils \
    curl \
    grep

# Install `fishtape to run tests
USER nemo
RUN curl \
    --location \
    --output $HOME/.config/fish/functions/fisher.fish \
    --create-dirs \
    git.io/fisher
RUN fish -c 'fisher add jorgebucaran/fishtape@7426171'

# Copy source code
WORKDIR /tmp/.spacefish-repo/
COPY --chown=nemo:nemo . /tmp/.spacefish-repo/

ENTRYPOINT ["fish", "-c"]
CMD ["tests/run.fish"]
