FROM ocaml/opam:alpine-3.20-ocaml-5.2 AS build

# Install system dependencies
RUN sudo apk update && sudo apk add --update libev-dev openssl-dev gmp-dev oniguruma-dev inotify-tools curl-dev autoconf

# Branch freeze was opam-repo HEAD at the time of commit
RUN cd opam-repository && git pull origin c45f5bab71d3589f41f9603daca5acad14df0ab0 && opam update

WORKDIR /home/opam

# Install Opam dependencies
ADD rocqproverorg.opam rocqproverorg.opam
RUN opam install . --deps-only

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
ENV ROCQPROVERORG_REPO_PATH=rocq-opam-repository
ENV ROCQPROVERORG_PKG_STATE_PATH=package.state
RUN touch package.state && ./init-cache package.state

FROM alpine:3.20 AS run

ARG GIT_COMMIT
RUN echo "Based on commit: $GIT_COMMIT"
ENV GIT_COMMIT=${GIT_COMMIT}
LABEL rocqproverorg=${GIT_COMMIT}

ARG GIT_BRANCH
RUN echo "Based on branch: $GIT_BRANCH"
ENV GIT_BRANCH=${GIT_BRANCH}
LABEL rocqproverorg_branch=${GIT_BRANCH}

RUN apk update && apk add --update libev gmp git

RUN chmod -R 755 /var

COPY --from=build /home/opam/package.state /var/package.state
COPY --from=build /home/opam/rocq-opam-repository /var/opam-repository
COPY --from=build /home/opam/_build/default/src/rocqproverorg_web/bin/main.exe /bin/server

COPY playground/asset playground/asset

RUN git config --global --add safe.directory /var/opam-repository

ENV ROCQPROVERORG_REPO_PATH=/var/opam-repository/
ENV DOC_PATH=/doc
ENV ROCQPROVERORG_PKG_STATE_PATH=/var/package.state
ENV DREAM_VERBOSITY=info
ENV ROCQPROVERORG_HTTP_PORT=8080

EXPOSE 8080

ENTRYPOINT [ "/bin/server" ]
