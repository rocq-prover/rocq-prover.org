---
id: opam-layout
title: Opam Layout
description: "Opam Repository Layout."
category: Opam
---

## Layout of the Rocq Package Index

The archive is organized in the following Opam repositories.

## released

The repository contains packages for Rocq and for Rocq extensions that
were officially released by the Rocq team or their corresponding authors.
All packages have a version number (i.e. no .dev packages). The
repository is self contained. The repository is intended to be used by
people familiar with the `opam` tool, but also indirectly by any user of the Rocq Platform.

## core-dev

The repository contains package for development versions of Rocq.
Typically .dev packages for Rocq branches. The repository is self-contained.
The repository is intended to be used by developers and beta-testers.

## extra-dev

The repository contains packages for development versions of external
contributions to Rocq. Typically .dev packages following the branches of
the extension. The repository is not self contained, i.e. a package may
depend on a development version of Rocq part of the `core-dev`
repository. The repository is also where new package releases that are
only compatible with a release-candidate of the Rocq Prover are initially
located.
