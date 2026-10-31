FROM ocaml/opam:alpine-3.24-ocaml-5.2 AS build

# Install system dependencies
RUN sudo apk -U upgrade --no-cache && sudo apk add --no-cache \
    autoconf \
    curl-dev \
    gmp-dev \
    inotify-tools \
    libev-dev \
    oniguruma-dev \
    openssl-dev

# Use Opam 2.2 and enable the backup mirror if primary sources of packages are unavailable
RUN sudo mv /usr/bin/opam-2.2 /usr/bin/opam && opam update
RUN opam option --global 'archive-mirrors+="https://opam.ocaml.org/cache"'

# Pin the opam-repository. This commit is the tip already bundled in the
# ocaml/opam base image, so `git reset --hard` finds it locally and needs no
# network fetch. Keep the pin at or below the base image's opam-repo tip; a
# newer commit would require adding `git fetch origin <sha>` before the reset.
RUN cd ~/opam-repository && git reset --hard 8cdfa3296d9bc7d93273f46eb2438757e4fd5cf0 && opam update

WORKDIR /home/opam

# Install opam dependencies.
# OPAMSOLVERTIMEOUT is raised from the 60s default: the base image's bundled
# solver can come close to it on this dependency graph.
COPY --chown=opam rocqproverorg.opam .
RUN OPAMSOLVERTIMEOUT=300 opam install . --deps-only

# Git commit and branch information
ARG GIT_COMMIT
RUN echo "Based on commit: $GIT_COMMIT"
ENV GIT_COMMIT=${GIT_COMMIT}
LABEL rocqproverorg=${GIT_COMMIT}

ARG GIT_BRANCH
RUN echo "Based on branch: $GIT_BRANCH"
ENV GIT_BRANCH=${GIT_BRANCH}
LABEL rocqproverorg_branch=${GIT_BRANCH}

# Build project
COPY --chown=opam:opam . .
RUN opam exec -- dune build @install --profile=release

# Fetch the opam repository
RUN git clone https://github.com/rocq-prover/opam.git rocq-opam-repository
RUN cd rocq-opam-repository && git checkout master && git pull origin master

# Launch project in order to generate the package state cache
ENV ROCQPROVERORG_REPO_PATH=rocq-opam-repository \
    ROCQPROVERORG_PKG_STATE_PATH=package.state
RUN touch package.state && ./init-cache package.state

FROM alpine:3.24 AS run

ARG GIT_COMMIT
RUN echo "Based on commit: $GIT_COMMIT"
ENV GIT_COMMIT=${GIT_COMMIT}
LABEL rocqproverorg=${GIT_COMMIT}

ARG GIT_BRANCH
RUN echo "Based on branch: $GIT_BRANCH"
ENV GIT_BRANCH=${GIT_BRANCH}
LABEL rocqproverorg_branch=${GIT_BRANCH}

RUN apk -U upgrade --no-cache && apk add --no-cache \
    git \
    gmp \
    libev

RUN chmod -R 755 /var

COPY --from=build /home/opam/package.state /var/package.state
COPY --from=build /home/opam/rocq-opam-repository /var/opam-repository
COPY --from=build /home/opam/_build/default/src/rocqproverorg_web/bin/main.exe /bin/server

COPY playground/asset playground/asset

RUN git config --global --add safe.directory /var/opam-repository

ENV ROCQPROVERORG_REPO_PATH=/var/opam-repository/ \
    DOC_PATH=/doc \
    ROCQPROVERORG_PKG_STATE_PATH=/var/package.state \
    DREAM_VERBOSITY=info \
    ROCQPROVERORG_HTTP_PORT=8080

EXPOSE 8080

ENTRYPOINT [ "/bin/server" ]
