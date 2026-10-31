---
title: Tail of a List
slug: "1"
difficulty: beginner
tags: [ "list" ]
description: "Write a function that returns the last element of a list."
tutorials: [ "lists"]
---

<!-- markdownlint-disable MD025 -->

# Solution

```ocaml
Open Scope list_scope.

Fixpoint last {A} (l:list A) (d:A) : A :=
  match l with
    | [] => d
    | [a] => a
    | a :: l => last l d
  end.
```

# Statement

Write a function `last : forall {A:Type}, list A -> A -> A` where `last l d` returns the last element of the list `l`, or the default value `d` if `l` is empty.
the last element of a list

```ocaml
> Eval compute in last [1 ; 2 ; 3 ] 0;;
  = 3 : nat
> Eval compute in last [] 0.
  = 0 : nat
```
