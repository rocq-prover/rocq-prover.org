---
id: set-up-editor
title: Configuring Your Editor
description: |
  This page will show you how to set up your editor for the Rocq Prover.
category: "Tooling"
---
While the toplevel is great for interactively trying out the language, we will shortly need to write Rocq files in an editor. 

The Rocq Prover has plugins for many editors, but the most actively maintained are for Visual Studio Code, Emacs and Vim.

## Visual Studio Code

> TL;DR
> Install the package `vsrocq-language-server` in your [opam switch](/docs/opam-switch-introduction).

For VSCode, install the [Rocq Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=maximedenes.vscoq) from the Visual Studio Marketplace. The extension depends on Rocq LSP. To install it in your switch, you can run:

```shell
$ opam install vsrocq-language-server
```

You can alternatively install [rocq-lsp](https://github.com/ejgallego/coq-lsp).

Now you are ready to write some Rocq code and proofs!

### Editor Features at Your Disposal
If your editor is setup correctly, here are some important features you can begin using to your advantage:

#### 1) Hovering for Type Information: 

![VSCode Hovering](/media/tutorials/vscode-hover.gif)

This is a great feature that let's you see type information of any Rocq definition. All you have to do is place your cursor over the code and it will be displayed in the tooltip.

#### More ...

In Construction

## Emacs and Vim

**Emacs users** can use the major Rocq mode [Proof General](https://proofgeneral.github.io/), that can be extended by the minor Coq mode [Company-Coq](https://github.com/cpitclaudel/company-coq).

See their webpage for installation instructions.

**Vim/NeoVim users** can use the [Coqtail](https://github.com/whonore/Coqtail) extension. 
NeoVim users can also test the experimental support for [VsCoq's `vscoqtop` server](https://github.com/tomtomjhj/vscoq.nvim) or for [`coq-lsp`](https://github.com/tomtomjhj/coq-lsp.nvim).

## Standalone interfaces

Alternatively, you can use [RocqIDE](https://coq.inria.fr/refman/practical-tools/coqide.html), a standalone desktop application which is developed and distributed alongside the Rocq Prover.

As a way to try Rocq without installing anything, you can use [JsRocq](https://jscoq.github.io/). JsRocq loads Rocq entirely in your browser.