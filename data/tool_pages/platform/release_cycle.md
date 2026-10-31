---
id: "release-cycle"
title: "Rocq Prover and Rocq Platform release cycle"
description: An overview of how the Rocq Platform gets released.
category: "Rocq Platform"
---


## Summary

We aim at a release process for the Rocq Prover and the Rocq Platform which makes it
easier for users to provide feedback and for developers to deliver fixes.

In a nutshell the *Rocq Prover "beta period"* is replaced by a **Rocq Platform "beta period"**.
Rocq Prover devs tag an almost final version on top of which the Rocq Platform core is
built. Rocq Prover point releases are then used to quickly deliver fixes
to the Platform.

## Motivation

The beta testing period does not provide enough feedback to sensibly improve
Rocq between the `VX+beta1` and `VX.0` tags. The reasons are, most important
last:
- users have better things to do, frankly
- one month is short, especially with Christmas, summer holidays or conferences
  around (our beta period is December or May)
- in order to test Rocq you are likely to need a bunch of Rocq packages, and they
  are typically only available after the beta period is over

Moreover the "beta period" has also been seen by devs as a time frame where
they can still change many things. As a result, users are even less happy
to spend time working on a moving target.

Finally, due to the cost of backporting breaking changes from the master
branch to the release branch, this only happens very early in the release
cycle (for example only 2 such changes were backported in the beta period
for 8.12, 0 for 8.13).

### New actor: Rocq Platform

The Rocq Platform is a selection of Rocq packages which work well
for a given Rocq version. One of its objective is to disentangle the release
of Rocq with the release of other packages. It provides scripts that build
that selection of Rocq packages on Windows, Mac and Linux from sources
on the user's machine, and as well binary installers (prebuilt) for users
to quickly get a working environment.

**The Platform is the final product users will get** in this new model;
the Rocq Prover is a core component of it.

## Detailed design

The new process' timeline:
```text
                     DO+           O                         O      O     O
rocq prover -+---(1)---+------(2)----+----------(3)------------+------+-----+-----
 vX branch/          |             |                         |
          VX+rc1 tag/              |                         |
                          VX.0 tag/                          |
                                                    VX.1 tag/
   
                                  DI                   DI              DI
platform  -----------+----(4)------+--------(5)---------+---------------+-------
      YYYY.MM branch/              |                    |               |
                   YYYY.MM+beta tag/                    |               |
                                          YYYY.MM.0 tag/   YYYY.MM.1 tag/
Artifacts:
- D = Docker image for the Rocq Prover (or the Rocq Platform)
- O = OPAM package (O+ means for core-dev, otherwise it is for the main OPAM repo)
- I = binary installers for Rocq Platform
```

### Rocq Prover

On time based schedule the RM branches vX.

1. The RM shepherds the few PRs which are ready, ensures blocker issues are fixed
   and pins projects tracked by CI (using commit hashes, not necessarily tags).
   The RM generates the Changelog file via the `generate-release-changelog.sh`
   script, but leaves the release notes empty (it's the project leader who
   fills them in before the .0 release).
   This step should take no more than 2 weeks.
   - The RM **tags** VX+rc1, but produces no binary installers, see the Platform release.
   - The RM ensures an **OPAM package** is available, currently the policy is to upload it to
     `core-dev`.
   - Subsequently, the RM ensures a **Docker image** is available, so that project maintainers can use it
     in CI during (4).

   **No breaking change is allowed from now on, unless a severe problem is found.**
2. The documentation is updated (eg. the Changes file) and eventual fixes
   required by the Platform are done. Ideally no other change is done.
   This step should take no more than 2 weeks.
   - The RM **tags** the .0 release.
   - The RM ensures an **OPAM package** is uploaded to the main OPAM repository.
3. In response to a severe bug report Rocq devs make an hotfix in master which is
   backported to vX.
   - The RM **tags** the point release, possibly as soon
    as the fix is available and merged.
   - The RM ensures an **OPAM package** is uploaded to the main OPAM repository.

### Rocq Platform

When Rocq Prover VX+rc1 is tagged, the PRM branches YYYY.MM off

<!-- markdownlint-disable MD029 -->
4. Starting with the pins made by RM on Rocq's CI all packages part of the
   Platform (or its core) are pinned (in accordance with upstreams, which are
   notified about the ongoing process). Most, if not all, packages are in Rocq's
   CI or the Platform's CI so there should be no surprises.
   This step should not take more than one month.
   - The PRM **tags** YY.MM+beta tag and publishes the **binary installers**
   - The PRM also ensures a **Docker image** is available with the entire Platform prebuilt
5. As users pick up the Platform and find severe bugs in Rocq, the Platform picks
   up point releases of Rocq containing hotfixes and eventually extends packages
   beyond the core set.
<!-- markdownlint-enable MD029 -->

### Synchronization points

- The end of (1) starts the release cycle of the Platform.
- The end of (2) and (4) don't need to be done at the same time, but if they
  are then the release cycle presented in this CEP roughly coincides with the
  previous one. Normally (2) precedes (4), but if the doc is not ready yet
  the Platform can still release a beta.
- Rocq's VX.0 tag can be made as soon as the doc is clear. This will stress the
  fact that upstreams can pin with no worries as soon as the rc is tagged.

### Announces

- Rocq Prover tags are only announced to devs
- Rocq Platform pins are communicated to upstream devs, which may tag/release.
- Rocq Platform tags and packages **are announced to the community** (this is
  when we party)

### Rocq Prover's CI

For each project P included in the Platform:

- if P has ML code, then it must be tested using the **standard configuration**.
  It can also be tested using another configuration.
- if P is pure .v code we have two cases
  - if it is a core Platform component (has many users in the Platform) then it
    must be tested using the standard configuration. It can also be tested using
    another configuration.
  - if it is not a core component, then it can be tested with any configuration,
    or not tested at all (it must be tested by the Platform's CI anyway)

The decision of which is the "standard configuration" and the switch to a new
one is subject to discussion between the Rocq developers and the Platform ones,
and the switch should happen in a coordinated way.

Moreover, Rocq Prover's CI must test:
- a **selection of Platform scripts**, to test the script themselves,
  not the build of Platform packages. Currently the `-extent=i` Platform flag
  makes it build only Rocq+RocqIDE, that should be sufficient.

Rocq's CI can test anything else of course, including non standard
configurations and projects that are not in the Platform.

### Platform CI

- on branch **YYYY.MM** it must test **all packages** and
  build **installers** as artifacts.
  This makes the Platform release doable without specific hardware (e.g. a Mac
  or a PC with windows).
- on branch **master** it should take Rocq master and its
  **upstream tracked branches**
  (for the subset of projects part of the Platform) and eventually report the
  failures upstream. Currently this activity is logged in dedicated issues.

#### Terminology

- "severe bug" is a bug which *blocks* many users with no decent workaround,
  or a soundness bug.
- "hotfix" is a minimal patch that repairs a problem, not necessarily the nice
  solution which may require refactoring or cleanups. The patch should pass CI
  with no overlay and must be reviewable (in a strict sense, as in looking for
  bugs, not just as in "looks reasonable")
- "RM" is the release manager of Rocq
- "PRM" are the release managers of the Rocq Platform
- "standard configuration" is a version of ocaml and other tools which are
  agreed between Rocq devs and the Platform devs (dune, make, gmp, gtk...) as
  well as a set of configure options or env variables for Rocq (eg enabling or
  disabling native_compute, tuning OCaml's GC, tweaking the stack size)

#### Notes about Platform versioning

It's essentially the Ubuntu scheme:
- YYYY.MM plays the role of a major version, as in Rocq's 8.13
- YYYY.MM.0,  YYYY.MM.1 ... play the role of point releases, as Rocq's 8.13.0 ..

Hence, it is not YYYY.MM.DD but rather YYYY.MM.XX.

## Drawbacks

This new process identifies 3 groups of developers which need to talk to each
other: Rocq dev, Platform devs, and Docker devs. This is a risk, but also an
advantage since the Rocq release becomes more lightweight, leaving the RM
more time to focus on supporting the release with hotfixes.
