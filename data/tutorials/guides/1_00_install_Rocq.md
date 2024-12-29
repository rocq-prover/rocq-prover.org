---
id: installing-rocq
title: Installing the Rocq Prover
description: |
  This page will help you install Rocq and the Rocq Platform Tools. |
  These instructions work on Windows, and Unix systems like Linux, and macOS.
category: "First Steps"
---

This guide will walk you through a minimal installation of Rocq. That includes installing a package manager and the Rocq Prover itself. We'll also install some support for your editor.

On this page, you'll find installation instructions for Linux, macOS, and Windows.

**Note**: You'll be installing Rocq and its tools through a [command line interface (CLI), or shell](https://www.youtube.com/watch?v=0PxTAn4g20U). 

Beginners are encouraged to install the [Rocq Platform](/install#rocq_platform) using one of the binary installers: we provide binary installers for Windows and macOS.
Installation scripts are also available for all operating systems and abstract over the installation process that is presented here.


## Install opam

[opam](https://opam.ocaml.org/), the official package manager of OCaml and the Rocq Prover, allows users to download and install Rocq tools and libraries. Opam also makes it practical to deal with different projects which require different versions of the Rocq Prover.

Opam can be used to install the OCaml compiler and the Rocq Prover.

To install opam, you can [use your system package manager](https://opam.ocaml.org/doc/Install.html#Using-your-distribution-39-s-package-system) or download the [binary distribution](https://opam.ocaml.org/doc/Install.html#Binary-distribution). The details are available in these links, but for convenience, we use package distributions:

**For macOS**

If you're installing with [Homebrew](https://brew.sh/):

```shell
$ brew install opam
```

Or if you're using [MacPorts](https://www.macports.org/):

```shell
$ port install opam
```

**For Linux**

It's preferable to install opam with your system's package manager on Linux, as superuser. On the opam site, find [details of all installation methods](https://opam.ocaml.org/doc/Install.html). A version of opam above 2.0 is packaged in all supported Linux distributions. If you are using an unsupported Linux distribution, please either download a precompiled binary or build opam from sources.

If you are installing in Debian or Ubuntu:
```shell
$ sudo apt-get install opam
```

If you are installing in Arch Linux:
```shell
$ sudo pacman -S opam
```

**Note**: The Debian package for opam, which is also used in Ubuntu, has the OCaml compiler as a recommended dependency. By default, such dependencies are installed. If you want to only install opam without OCaml, you need to run something like this:
```shell
sudo apt-get install --no-install-recommends opam
```

**For Windows**

It's easiest to install opam with [WinGet](https://github.com/microsoft/winget-cli):

```shell
PS C:\> winget install Git.Git OCaml.opam
```

**Binary Distribution**

If you want the latest release of opam, install it through the binary distribution. On Unix and macOS, you'll need to install the following system packages first: `gcc`, `build-essential`, `curl`, `bubblewrap`, and `unzip`. Note that they might have different names depending on your operating system or distribution. Also, note this script internally calls `sudo`.

The following command will install the latest version of opam that applies to your system:
```shell
$ bash -c "sh <(curl -fsSL https://opam.ocaml.org/install.sh)"
```

On Windows, the winget package is maintained by opam's developers and uses the binaries released [on GitHub](https://github.com/ocaml/opam/releases), however you can also install using an equivalent PowerShell script:

```powershell
Invoke-Expression "& { $(Invoke-RestMethod https://opam.ocaml.org/install.ps1) }"
```

## Initialise opam

After you install opam, you'll need to initialise it. To do so, run the following command, as a normal user. This might take a few minutes to complete.

```shell
$ opam init -y
```

**Note**: In case you are running `opam init` inside a Docker container, you will need to disable sandboxing, which is done by running `opam init --disable-sandboxing -y`. This is necessary, unless you run a privileged Docker container.

Make sure you follow the instructions provided at the end of the output of `opam init` to complete the initialisation. Typically, this is:
```
$ eval $(opam env)
```

on Unix, and from the Windows Command Prompt:

```
for /f \"tokens=*\" %i in ('opam env') do @%i
```

or from PowerShell:

```powershell
(& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }
```

Opam initialisation may take several minutes. While waiting for its installation and configuration to complete, start reading [A Tour of OCaml](tour-of-ocaml).

**Note**: opam can manage something called _switches_. This is key when switching between several OCaml projects. However, in this “getting started” series of tutorials, switches are not needed. If interested, you can read an introduction to [opam switches here](/docs/opam-switch-introduction).

**Any problems installing?** Be sure to read the [latest release notes](https://opam.ocaml.org/blog/opam-2-2-0/). You can file an issue at https://github.com/ocaml/opam/issues or https://github.com/ocaml-windows/papercuts/issues.

## Install the Rocq Prover


To install Rocq, simply run the following command. It will pin the Rocq package to version 9.0.0 and install it.
Note that installing Rocq using opam will build it from sources, 
which will take several minutes to complete:
 
 ```shell
$ opam pin add rocq 9.0.0
```

Pinning prevents opam from upgrading Rocq automatically, to avoid causing inadvertent breakage in your Rocq projects. 
You can upgrade Rocq explicitly to `$NEW_VERSION` with essentially the same command:

 ```shell
$ opam pin add rocq $NEW_VERSION
```

To ensure that installation was successful, check that `rocq -v` prints the expected version of Rocq.

## Install Platform Tools

VsRocq is an extension for [Visual Studio Code]("https://code.visualstudio.com/) (VS Code) and 
[VSCodium](https://vscodium.com/) which provides support for the Rocq Prover. 

It is built around a language server which natively speaks the 
[LSP protocol](https://learn.microsoft.com/en-us/visualstudio/extensibility/language-server-protocol?view=vs-2022).

To install it in your current opam switch, run this command:

 ```shell
$ opam install vsrocq-language-server
```
You can alternatively install [rocq-lsp](https://github.com/ejgallego/coq-lsp).

Now you are ready to write some Rocq code and proofs!

## Check Installation

To check that everything is working properly, you can start the Rocq toplevel:
```shell
$ rocq repl
Welcome to Rocq 9.0.O

Rocq <
```

You're now in an Rocq toplevel, and you can start typing Rocq expressions. For instance, try typing `Eval compute in 2*10.` at the `>` prompt, then hit `Enter`. You'll see the following:
```coq
Rocq > Eval compute in 2*10.
     = 20
     : nat
```

**Congratulations**! You've installed Rocq! 🎉

## Join the Community

Make sure you [join the Rocq community](/community). You'll find many community members on [Discuss](https://discuss.rocq.org/) or [Discord](https://discord.com/invite/cCYQbqN). These are great places to ask for help if you have any issues.
