---
id: using-opam
title: Installing the Rocq Prover and its packages
description: |
  This page will help you get started using opam to install the Rocq Prover and its packages.
category: Opam
---

## What is opam?

Opam is the package manager for the OCaml programming language, the language
in which Rocq is implemented.
Opam 2.1 is the recommended version, and is assumed below.
Instructions on
[how to install opam](https://opam.ocaml.org/doc/Install.html)
itself are available on the opam website.
The following command displays the version of opam you have installed:

```console
# Make sure opam version is 2.1.0 or above.
opam --version
```

Follow the instructions below to install the last stable version of
Rocq and additional packages. The instructions target an opam
newcomer.

Note that these instructions will also work for Opam 2.0 but this
may require you to manually install any external dependencies. In this
case you will have to use `opam-depext` to see which
external dependencies are missing.

For some operating systems, `opam`
and `opam-depext` might still be unable to detect external
dependencies, which will mean you have to check and install them
yourself. To see more detailed information on external dependencies
please consult
the [INSTALL.md documentation in the GitHub repository](https://github.com/coq/coq/blob/master/INSTALL.md).

## The Rocq Platform scripts

The [Rocq Platform](https://github.com/coq/platform)
provides interactive scripts that allow installing Rocq and a standard
set of packages through `opam` without having to learn anything about
`opam`.

If a standard setup works for you, then we recommend that you use
these [scripts](https://github.com/coq/platform/releases/latest).
If you do, you can skip directly to [Using opam to install Rocq packages](#installing-rocq-packages) to learn how to add additional packages to
the initial package set provided by the Platform.

Note that the Platform scripts are compatible with existing `opam`
installations. They will create a fresh [switch.](#switch)

If you prefer to do a fully manual installation, you can proceed to
the next section.

## Initializing opam

Once opam is installed, it must be initialized before first
usage:

```console
opam init
eval $(opam env)
```

`opam init` will prompt you to allow opam to set up
initialization scripts, which is generally fine to accept. Otherwise,
every time a new shell is opened you have to type in the
`eval $(opam env)` command above to update environment variables.

By default, opam will use the global installation of OCaml. You can
initialize opam with an explicit compiler version, for example
4.14.1, with the option
`--compiler=ocaml-base-compiler.4.41.1`.
See also the section on [managing different versions of OCaml and Rocq](/docs/managing-versions),
about switches and roots.


## Installing Rocq

To install Rocq, simply run the following command. Note that
installing Rocq using opam will build it from sources, which will take
several minutes to complete. The following command will pin the rocq-prover
package to version 9.0.0 and install it.


```console
opam pin add rocq-prover 9.0.0
```

Pinning prevents opam from upgrading Rocq automatically, to avoid
causing inadvertent breakage in your Rocq projects. You can upgrade Rocq
explicitly to
`$NEW_VERSION` with essentially the same command:

```console
opam pin add rocq-prover $NEW_VERSION
```

To ensure that installation was successful, check that `rocqc -v` prints the expected version of Rocq.

### Installing RocqIDE

You may also want to install RocqIDE. Note that this requires GTK+
development files (`gtksourceview3`) to be available on the
system. Opam (>=2.1) will ensure that these packages are installed (on
most operating systems). To install RocqIDE, simply run:

```console
opam install rocqide
```

There exist many [alternative user interfaces / editor extensions](/install) for Rocq, follow
the link for instructions on how to install them.

## Installing Rocq packages

Rocq packages live in a repository separate from the standard OCaml
opam repository. The following command adds that repository to the
current opam [switch](#switch) (you can skip this step if
you used the [Platform scripts](#platform)):

```console
opam repo add rocq-released https://rocq-prover.org/opam/released
```

The following command lists the names of all Rocq (and Coq) packages along
with short descriptions:

```console
opam search --or rocq coq
```

You can access a more detailed description of a package,
say `rocq-equations`, using the command:

```console
opam show rocq-equations
```

You can then install the package using the command:

```console
opam install rocq-equations
```
