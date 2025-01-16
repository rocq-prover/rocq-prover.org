---
id: using-opam
title: Installing the Rocq Prover and its packages
description: |
  This page will help you get started using opam to install the Rocq Prover and its packages.
category: Opam
---

## What is opam?

<p>Opam is the package manager for the OCaml programming language, the language
in which Coq is implemented.
Opam 2.1 is the recommended version, and is assumed below.
Instructions on
<a href="https://opam.ocaml.org/doc/Install.html">how to install opam</a>
itself are available on the opam website.
The following command displays the version of opam you have installed:</p>

<pre><code># Make sure opam version is 2.1.0 or above.
opam --version
</code></pre>

<p>Follow the instructions below to install the last stable version of
Coq and additional packages. The instructions target an opam
newcomer.</p>

<p>Note that these instructions will also work for Opam 2.0 but this
may require you to manually install any external dependencies. In this
case you will have to use <code>opam-depext</code> to see which
external dependencies are missing.</p>

<p>For some operating systems, <code>opam</code>
and <code>opam-depext</code> might still be unable to detect external
dependencies, which will mean you have to check and install them
yourself. To see more detailed information on external dependencies
please consult
the <a href="https://github.com/coq/coq/blob/master/INSTALL.md">INSTALL.md
documentation in the GitHub repository</a>.</p>

## The Coq Platform scripts

<p>The <a href="https://github.com/coq/platform">Coq Platform</a>
provides interactive scripts that allow installing Coq and a standard
set of packages through opam without having to learn anything about
opam.</p>

<p>If a standard setup works for you, then we recommend that you use
these <a href="https://github.com/coq/platform/releases/latest">scripts</a>.
If you do, you can skip directly to <a href="#coq-packages">Using opam to
install Coq packages</a> to learn how to add additional packages to
the initial package set provided by the Platform.</p>

<p>Note that the Platform scripts are compatible with existing opam
installations. They will create a
fresh <a href="#switch">switch.</a></p>

<p>If you prefer to do a fully manual installation, you can proceed to
the next section.</p>

## Initializing opam

<p>Once opam is installed, it must be initialized before first
usage:</p>

<pre><code>opam init
eval $(opam env)
</code></pre>

<p><code>opam init</code> will prompt you to allow opam to set up
initialization scripts, which is generally fine to accept. Otherwise,
every time a new shell is opened you have to type in the
<code>eval $(opam env)</code> command above to update environment variables.</p>

<p>By default, opam will use the global installation of OCaml. You can
initialize opam with an explicit compiler version, for example
<#OCAMLV>, with the option
<code>--compiler=ocaml-base-compiler.<#OCAMLV></code>.
See also the section "Managing different versions of OCaml and Coq" below,
about switches and roots.
</p>

## Installing Coq

<p>To install Coq, simply run the following command. Note that
installing Coq using opam will build it from sources, which will take
several minutes to complete:</p>

<pre><code># Pin the coq package to version <#CURRENTVERSION> and install it.
opam pin add coq <#CURRENTVERSION>
</code></pre>

<p>Pinning prevents opam from upgrading Coq automatically, to avoid
causing inadvertent breakage in your Coq projects. You can upgrade Coq
explicitly to
<code>$NEW_VERSION</code> with essentially the same command:</p>

<pre><code>opam pin add coq $NEW_VERSION
</code></pre>

<p>To ensure that installation was successful, check that <code>coqc
-v</code> prints the expected version of Coq.</p>

### Installing CoqIDE

<p>You may also want to install CoqIDE. Note that this requires GTK+
development files (<code>gtksourceview3</code>) to be available on the
system. Opam (>=2.1) will ensure that these packages are installed (on
most operating systems). To install CoqIDE, simply run:</p>

<pre><code>opam install coqide
</code></pre>

<p>There exist many <a href="/user-interfaces.html">alternative user
interfaces / editor extensions</a> for Coq.  See their respective
websites for instructions on how to install them.</p>

## Installing Coq packages

<p>Coq packages live in a repository separate from the standard OCaml
opam repository. The following command adds that repository to the
current opam <a href="#switch">switch</a> (you can skip this step if
you used the <a href="#platform">Platform scripts</a>):</p>

<pre><code>opam repo add coq-released https://coq.inria.fr/opam/released
</code></pre>

<p>The following command lists the names of all Coq packages along
with short descriptions:</p>

<pre><code>opam search coq
</code></pre>

<p>You can access a more detailed description of a package,
say <code>coq-sudoku</code>, using the command:</p>

<pre><code>opam show coq-sudoku
</code></pre>

<p>You can then install the package using the command:</p>

<pre><code>opam install coq-sudoku
</code></pre>
