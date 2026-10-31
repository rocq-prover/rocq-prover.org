---
id: opam-dev
title: Installing the development version of Rocq
description: "Using Opam for Development."
category: Opam
---

If you want to work with the latest development version of the Rocq prover, follow this quick setup guide.

## Create a switch

First, create a dedicated switch to follow the development branch of Rocq:
```shell
opam switch create rocq-master 4.14.4+options
opam repo add core-dev https://rocq-prover.org/opam/core-dev
opam install rocq-core.dev 
opam pin add rocq-core --current
```
Here we call the new switch `rocq-master`, you can of course pick any name you want.

**Note: macOS 26 with Command Line Tools shipping the macOS 27 SDK:** 
If you happen to use macOS 26 and experience a `dune` segmentation fault during install, just
create the switch with
`ac_cv_func_pipe2=no ac_cv_func_dup3=no opam switch create rocq-master 4.14.4+options`
(see ocaml/ocaml#15067).

## Install packages

In addition to the core, you might want to include the standard library:
```shell
opam install rocq-stdlib
```

And add other packages from the development branch, for instance `rocq-equations`:
```shell
opam repo add extra-dev https://rocq-prover.org/opam/extra-dev
opam install rocq-equations
```

## Configure VS Code

If you're using VS Code, install the language server:
```shell
opam pin add vsrocq-language-server.dev https://github.com/rocq-prover/vsrocq.git --subpath=language-server
```

Inside VS Code, go to `Extensions > VsRocq`, then click on `Settings`, and set `Vsrocq: Path` to the path obtained via `which vsrocqtop` in a shell session.

## Upgrade

When you want to upgrade to the latest development version of Rocq (and installed packages), simply:
```shell
opam update
opam upgrade
```
