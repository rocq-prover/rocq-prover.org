## Creating and Submitting a Package

This page contains instructions to submit a simple example Rocq package
called `foo` at version `1.0.0`. The full documentation on Opam packages
can be found on the [Opam web site](http://opam.ocaml.org/doc/Packaging.html).

## Package layout

For simplicity, we will assume that the Rocq project you want to package
contains a `Makefile` providing the following commands:

    make          # Build the package
    make install  # Install the package

Click here to see a minimal example `Makefile`.

    build: Makefile.rocq
        $(MAKE) -f Makefile.rocq

    install: Makefile.rocq
        $(MAKE) -f Makefile.rocq install

    Makefile.rocq: _RocqProject
        rocq makefile -f _RocqProject -o $@

See also the Reference Manual on [building a Rocq project with
`rocq_makefile`](/refman/practical-tools/utilities.html#building-a-rocq-project-with-rocq-makefile-details).

The project must be available to download as an archive. For example, if
your repository is hosted on GitHub, tag the commit corresponding to the
`1.0.0` version of your project:

    git tag 1.0.0
    git push origin 1.0.0

If your repository is on GitHub at `$YOU/foo` (where `$YOU` is your
GitHub user name), the archive corresponding to the tag `1.0.0` can be
downloaded from this URL:
`https://github.com/$YOU/foo/archive/1.0.0.tar.gz`, using `curl -L` or
your browser for example.

You can then record its checksum which will be used in the package definition using:

    YOURHASH=`shasum -a 512 1.0.0.tar.gz`

Finally, you must upload the archive on GitHub as an asset of your release (using Edit Release).
This is necessary as github does not guarantee the checksum stability of auto-generated `/archive/` 
tarballs. One can also use the [`gh` CLI tool](https://cli.github.com/) to upload an archive to 
a release (`gh release upload tag archive.tar.gz`). Your release will then have an url of shape:

    https://github.com/$YOU/foo/releases/download/1.0.0/1.0.0.tar.gz

## The Opam archive for Rocq

Opam packages live in this repository:
[rocq-prover/opam](https://github.com/rocq-prover/opam). New
packages are submitted through GitHub.

### Clone the repository

Follow this section if this is your first submission to the Rocq Opam archive.

First, go to the GitHub page of
[rocq-prover/opam](https://github.com/rocq-prover/opam) and [make a
fork](https://help.github.com/articles/fork-a-repo/).

The repository is now available in your personal GitHub space. Clone it
locally by typing the following, where `$YOU` is your GitHub user name.
The correct URL in the third line can also be found by clicking on the
*clone or download* button on the GitHub page of your fork.

This creates a clone with two remotes, one for the official archive,
called `upstream`, and one for your fork, called `origin`.

    git clone https://github.com/rocq-prover/opam -o upstream
    cd opam
    git remote add origin https://github.com/$YOU/opam

### Update the repository

If you already have a clone of `rocq-prover/opam`, for example because
this is not your first submission, the following command updates the
`upstream` remote with all changes since your last update or initial
clone.

    git fetch upstream

### Create a package definition file

Create a new branch named `rocq-foo.1.0.0` based on `upstream/master`:

    git checkout -b rocq-foo.1.0.0 upstream/master

In the `rocq-prover/opam` directory, create a sub-directory named as
follows:

    mkdir -p released/packages/rocq-foo/rocq-foo.1.0.0

The Opam package is thus named `rocq-foo` and the sub-directory name is
the package name followed by a dot followed by the version of the
package.

In that directory, create a text file called `opam`, which will contain
the package's metadata (build instructions, dependencies, etc.). Here
is a template for `released/packages/rocq-foo/rocq-foo.1.0.0/opam`:

    opam-version: "2.0"
    synopsis: "A Rocq library doing wonders" # One-line description
    description: """
      Foo does bar with baz.
    """ # Longer description, can span several lines

    homepage: "https://github.com/$YOU/foo"
    dev-repo: "git+https://github.com/$YOU/foo.git"
    bug-reports: "https://github.com/$YOU/foo/issues"
    doc: "https://$YOU.github.io/foo/"
    maintainer: "your@email.address"
    authors: [
      "You"
    ]
    license: "MIT" # Make sure this is reflected by a LICENSE file in your sources

    depends: [
      "rocq" {>= "9.0" & < "9.1~"}
    ]

    build: [
      [make "-j%{jobs}%"]
    ]
    install: [
      [make "install"]
    ]

    url {
      src: "https://github.com/$YOU/foo/archive/1.0.0.tar.gz"
      checksum: "sha512=YOURHASH"
    }

    tags: [
      "keyword:fooish"
      "category:Miscellaneous/Rocq Extensions"
      "date:2025-07-01"
      "logpath:Foo"
    ]

The last two fields are of particular interest:

-   The `url` section describes where to find your package. It must have
    at least the following fields: the `src` field with the URL of the
    package archive, and the `checksum` field with the checksum of that
    archive prefixed by `sha512=`.
-   The `tags` field contains Rocq-specific metadata. See also the [RFC
    on Opam
    metadata](https://github.com/rocq-prover/rfcs/blob/master/text/003-opam-metadata.md).

For a description of the other fields, see the [relevant section of the
Opam
Manual](https://opam.ocaml.org/doc/Manual.html#Package-definitions).

The checksum can be obtained with:

    curl -L https://github.com/$YOU/foo/releases/download/1.0.0/1.0.0.tar.gz | shasum -a 512

In the `opam` file, the checksum must be prefixed with the hashing
algorithm, here `sha512=`. (`sha256=`, and `md5=` are also supported.)

Commit the new `opam` file:

    git add released/packages/rocq-foo/rocq-foo.1.0.0/opam
    git commit -m 'Package rocq-foo.1.0.0'

### Test your new package

The preliminary step is to lint your `opam` file as follows

    opam lint --check-upstream released/packages/rocq-foo/rocq-foo.1.0.0/opam

Once no more errors are given, the best way to test your package is to
add your local clone of `rocq-prover/opam` to opam as follows, and then
run `opam install` on your new package in verbose mode:

    opam repo add test ./released
    opam install -v rocq-foo

If things go wrong, after having fixed the problem and before trying
again to install the package, run `opam update`.

### Submit your new package

Submission happens by [creating a pull
request](https://help.github.com/articles/creating-a-pull-request/) on
the [rocq-prover/opam
repository](https://github.com/rocq-prover/opam).

First push your changes to your personal fork:

    git push origin rocq-foo.1.0.0

Then visit the GitHub page of your personal fork and click on the *new
pull request* button.

## Making good packages

### Conventions

1.  The archive follows a [layout](opam-layout.html). Regular packages
    shall be placed in the `released` directory. One can also write
    packages that install development branches of a software. In that
    case `extra-dev` directory has to be used and the version has to end
    in `dev` like `mybranch.dev`.
2.  The package name should start with `rocq-`, for example `rocq-color`
    or `rocq-interval`.
3.  The `tags` field in the `opam` file can contain additional metadata
    (like a categorization or the Rocq logical path the package
    populates) as described in
    [RFC3](https://github.com/rocq-prover/rfcs/blob/master/text/003-opam-metadata.md)

### Rules of thumb

The released repository shall contain software that works with a stable
version of Rocq. Packages are maintained by their corresponding authors
or by the Rocq team. Dependencies must be expressed in a conservative way
providing both lower and upper bounds to version numbers. This way all
installable packages (i.e. with satisfiable constraints) shall compile
successfully.

We advise package authors to make sure that the following conditions are
met:

1.  Includes a *Changelog* that lists the main changes between any two
    versions part of this archive
2.  The *License* must allow free redistribution (even if it is not a
    free software license)
3.  *No* *Admitted* proofs
4.  All *Axioms* used are documented
5.  ML code is *reviewed* by a Rocq developer
6.  *Documentation* should be available (see the `doc:` field in the
    Opam metadata)

In any case the Rocq development team keeps the right to refuse the
integration of a package or remove any package at any time.

### Updating a package to a new version

1.  Like the initial version, the new version of the package should be
    submitted in a pull request and is encouraged to follow the
    guidelines above
2.  We recommend to ease the transition from the old to the new version
    by providing a transition strategy (a document helping a user to
    perform the switch: e.g. documenting all renamings).
3.  The old version stays in the repository.
