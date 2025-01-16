---
id: managing-versions
title: Managing different versions of OCaml and Coq
description: |
  This page explains how to manage different versions of OCaml and Coq using opam.
category: Opam
---

<p>By default, opam will use the global OCaml installation. Opam can
handle different versions of OCaml and other packages (including Coq)
via
<em>switches</em> or <em>roots</em>.</p>

## Switches

<p>Switches provide separate environments, with their own versions of
OCaml and installed packages. More information about opam
switches <a href="https://opam.ocaml.org/doc/Usage.html#opam-switch">can
be found here</a>.</p>

<p>The following command creates a switch named <code>with-coq</code>
with OCaml <#OCAMLV>:</p>

<pre><code># Run one of the following depending on your version of opam
opam switch create with-coq <#OCAMLV>
</code></pre>

<p>Change to an existing switch named <code>other-switch</code> with
this command:</p>

<pre><code>opam switch other-switch
eval $(opam env)
</code></pre>

## Roots

<p>Opam stores all its configuration (including switches) in a
directory called <em>root</em> (by default, <code>~/.opam</code>). The
path to the root can be set using the <code>$OPAMROOT</code>
environment variable, providing an alternative way of creating fresh
opam environments.
</p>

<p>The main benefit of roots is that they can be used simultaneously,
but they require some external bookkeeping. In comparison. switches
are entirely managed by opam, and they can share the global
configuration of a single root.
</p>

<pre><code># Set a new root location export
OPAMROOT=~/.opam-coq.<#CURRENTVERSION>

# Initialize the root with an explicit OCaml version.
opam init -n --compiler=ocaml-base-compiler.<#OCAMLV>

# Install Coq in this new root (same commands as above)
opam pin add coq <#CURRENTVERSION>
</code></pre>

<p>Every time a new shell is opened, or you want to use a different
root, type in the following lines:
</p>

<pre><code>export OPAMROOT=~/.opam-coq.<#CURRENTVERSION>
eval $(opam env)
</code></pre>
