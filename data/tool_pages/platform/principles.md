---
id: "platform-principles"
title: "Guiding Principles of the Rocq Platform"
short_title: "Guiding Principles"
description: The principles that guide the development of the Rocq Platform.
category: "Rocq Platform"
---

## Primary / user facing goals

The primary goal of the Rocq Platform is to provide a stable and dependable extended platform for advanced usages of the Rocq Prover in industry, education and research. While the main goal of the Rocq Platform is to serve the needs of the Rocq users, it can also be of help for Rocq developers. The corresponding secondary goals are given in the next section.

In more detail, the primary goals are:

**Ease of use**: Provide an easy and fast way to install a usable Rocq system. Ease of installation is especially important in education, where each course attendee has to be able to install Rocq with a known feature set with reasonable effort. Also for industrial users, which sometimes start using Rocq by looking at some non-trivial research projects, an easy to install system leaves a good first impression.

**Completeness**: The easy installation shall include, in addition to the core Rocq system, commonly used plugins, libraries and tools. The definition of "commonly used" is, of course, difficult. For the legacy Windows installer, packages have been added either on request of users or teachers or because several research projects use a package as prerequisite. It would be ideal if a large number of important research projects would compile with the packages provided with the extended platform.

**Stability**: The composition of the Rocq Platform, that is the selection of packages, should be stable. I.e., it should be a rare event that a package is removed from the Platform and updates of included packages should have a reasonable compatibility impact. This means that packages should only be added if the authors and maintainers of a package agree to provide a certain level of maintenance. Finding a compromise between this goal and the *Completeness* goal will likely be difficult and require some curation.

**Tested interoperability**: Some Rocq libraries are tested with specific fixed versions of prerequisites. Other developments are tested with other versions of the same prerequisites. This has the effect that such developments cannot be used together. In the Rocq Platform only one version of each library or plugin shall be used and interoperability shall be tested with dedicated interoperability test cases. A specific version of OCaml will be selected and used.

**Release plan**: The Rocq Platform shall have a release schedule which is coupled to the release schedule of the Rocq Prover. The Platform should be released reasonably soon after each Rocq Prover release. This gives both users and maintainers of Platform components a time frame for planning their work. Details on how the release schedule will work can be found in [release cycle](release-cycle) section.

**Releases only**: In the past the legacy Windows installer did sometimes pick intermediate versions of packages in case the most recent release did not build with current Rocq. For the Platform this shall be avoided. The Platform's more flexible release time frame in addition to the beta phase of Rocq Prover releases should be sufficient to make a release of each package or, in case this is not possible, to patch the most recent package release to be compatible with the latest Rocq Prover.

**Cross platform**: The Rocq Platform shall be easy to install on all systems supported by Rocq Prover, that is Linux, Windows and Mac. Since compilation of the Platform takes considerable time, binary releases of the Platform shall be made available on all supported platforms.

**Standard**: By defining a well-documented set of tested interoperable Rocq packages, the Platform will propose a standard Rocq distribution that maintainers of Linux distributions or other package repositories should be able to make available if they wish to.

## Secondary / developer-facing goals

**Developer support**: For developers of plugins, building the Rocq Platform via opam shall also be supported on Linux, Windows and Mac. The opam repository shall be setup such that it is possible to create exactly the same package configuration as included in the most recent or any previous binary release. Furthermore the Rocq Platform shall provide a method to automatically setup a working Rocq developer environment on all supported platforms (compiled from sources).

**Decoupling** In the past the release schedule of Rocq and the extended platform delivered with the Windows installer had a bad influence on each other. On the one hand, providing a stable extended platform with each Rocq release frequently lead to delays in the release schedule of Rocq. On the other hand, attempts to have as little impact on the Rocq schedule as possible lead to suboptimal version pickings for the extensions provided with the platform. In the end delivering a set of packages with each Rocq release created an artificial circular dependency between Rocq Prover and the packages, which led to substantial organizational difficulties. An important goal of the Rocq Platform is to re-establish a manageable dependency structure.

## Summary of stakeholders

Here are the different categories of expected stakeholders for the Rocq Platform:
- **Users**: in particular newcomers, students, teachers, industrial users, academic researchers, artifact reviewers.
- **Package authors and maintainers**.
- **Packagers**: maintainers of Linux distributions and other package repositories.
- **Rocq developers**: in particular, Rocq release managers who pass on some of their attributions to the Platform.

## Package inclusion process

- Packages are typically included on user request via a [GitHub issue](https://github.com/rocq-prover/platform/issues?q=is%3Aissue+label%3A%22kind%3A+package+inclusion%22).

- Requests should contain a justification. Good justifications are usage of the package in a regular course or a course with more than 25 attendees or usage of the package as prerequisite in at least three other packages or research developments by authors other than the author of the original package.

- The author(s) or current maintainer(s) of the package shall agree to the inclusion of their package in the Rocq Platform. This means that they agree to put reasonable effort into releasing a version of the package compatible with each new Rocq Prover release shortly after every release and to maintain some relative stability between each release. The agreement of the authors is given via a comment in the respective GitHub issue.

- All the dependencies of a Platform package are also officially part of the Platform. This means in particular that, apart from dependencies that are outside the Rocq ecosystem and are well-known to be stable and well supported, the maintainers of the dependencies should also agree to the inclusion in the Platform and commit to keep producing new compatible releases which are relatively stable. As part of the stability commitment, maintainers should refrain from adding new dependencies that are not already part of the Platform without raising the question with the Platform maintainers.

## Package exclusion process

- The exclusion of a package shall be a rare event.

- In case the package authors / maintainers cannot maintain compatibility to a new Rocq Prover release in the expected time, for one release the curator will try to organize maintenance otherwise. The Platform curator will also have timely discussions with the Rocq team in case changes in the Rocq Prover might lead to substantial maintenance effort in a Platform package. If the maintenance problem continues for the next release, the curator can remove a package from the Platform. The Platform users shall be informed about such a decision as early as possible, at least 1 month before a Platform release.

## Questions to be resolved

### Quality constraints for included packages

For now, we haven't set any quality constraints beyond the fact that the packages are sufficiently used and stable. But other constraints, such as the existence of complete documentation, might be set in the future. The [Rocq Platform Docs](/docs/platform-docs) project aims to eventually provide tutorials and how-to guides covering the full extent of the Rocq Platform.

### Licensing constraints for included packages

The current Platform includes packages under a variety of licenses, including non-open-source licenses (in the case of CompCert). We might evolve this (non-)requirement in the future. This question is linked to the tiers question below.

### Several tiers

If it turns out that it would help providing timely releases or solving the licensing questions raised above, we might decide to provide several tiers of the Rocq Platform. For instance, we could provide both a core Rocq Platform that would be released only weeks after a Rocq Prover release and provide a basic set of Rocq packages with strict inclusion criteria, and an extended Rocq Platform that would be released months after and provide a larger set of packages with more lax inclusion criteria. If we were to provide several tiers, the naming scheme for those is still to be determined.

### Other questions?

If you do see other questions that should be addressed in the Platform charter, do not hesitate to open a pull request to contribute.

## The Rocq Platform from a technical point of view

Technically the Rocq Platform is a [GitHub repository](https://github.com/rocq-prover/platform) containing:

- Information on packages included in the Platform and their versions, sources, build instructions. This information is either given as an opam repo, or there will be automated scripts to generate the opam repo from it.

- A CI setup which tests if the Rocq Platform builds on Linux, Windows and Mac and which creates the binary setups for these platforms.

- Additional scripts and tools, e.g. for automatic setup of a Rocq development environment.

- Possibly patches for included packages, although the goal is to avoid patching packages and instead to fix issues upstream.

- Discussions (in form of issues) on the package inclusion and exclusion.