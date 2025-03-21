---
id: managing-versions
title: Managing different versions of OCaml and Rocq
description: |
  This page explains how to manage different versions of OCaml and Rocq using opam.
category: Opam
---

By default, opam will use the global OCaml installation. Opam can
handle different versions of OCaml and other packages (including Rocq)
via *switches* or *roots*.

## Switches

Switches provide separate environments, with their own versions of
OCaml and installed packages. More information about opam
switches [can be found here](https://opam.ocaml.org/doc/Usage.html#opam-switch).

The following command creates a switch named `with-rocq`
with OCaml `4.14.2`:

```console
# Run one of the following depending on your version of opam
opam switch create with-rocq 4.14.2
```

Change to an existing switch named `other-switch` with this command:
```console
opam switch other-switch
eval $(opam env)
```

To link a directory and all its subdirectories to a particular switch, use:

```console
opam switch link with-rocq
```

This creates a symbolic link `_opam` in the current working directory, pointing 
to the switch to be used when calling `opam` under this working directory. It does 
not require using `eval $(opam env)` anymore. You can remove the link by simply 
removing the symbolic link:

```console
rm _opam
```

## Roots

Opam stores all its configuration (including switches) in a
directory called *root* (by default, `~/.opam`). The
path to the root can be set using the `$OPAMROOT`
environment variable, providing an alternative way of creating fresh
opam environments.


The main benefit of roots is that they can be used simultaneously,
but they require some external bookkeeping. In comparison. switches
are entirely managed by opam, and they can share the global
configuration of a single root.


```console
# Set a new root location export
OPAMROOT=~/.opam-rocq.9.0.0

# Initialize the root with an explicit OCaml version.
opam init -n --compiler=ocaml-base-compiler.4.14.2

# Install Rocq in this new root (same commands as above)
opam pin add rocq-prover 9.0.0
```

Every time a new shell is opened, or you want to use a different
root, type in the following lines:


```console
export OPAMROOT=~/.opam-rocq.9.0.0
eval $(opam env)
```
