<picture>
  <source media="(prefers-color-scheme: dark)" srcset="rocq-id/logos/SVG/logo-rocq-white.svg">
  <source media="(prefers-color-scheme: light)" srcset="rocq-id/logos/SVG/logo-rocq-orange_blue.svg">
  <img alt="Rocq logo" src="rocq-id/logos/SVG/logo-rocq-orange_blue.svg" width="70%">
</picture>

# rocq-prover.org

[![Actions Status](https://github.com/rocq-prover/rocq-prover.org/workflows/CI/badge.svg)](https://github.com/rocq-prover/rocq-prover.org/actions)

This repository contains the sources of the Rocq website. It is served at https://rocq-prover.org/.

## Acknowledgments

This website is a fork and customization of the [https://github.com/ocaml/ocaml.org](OCaml.org) website, 
reusing its infrastructure and package managment facilities. We are very thankful and grateful for the 
great work done by the OCaml developers! Please consult that repository for acknowledgments of the 
website developers of the original website.

## Features

- **Integrated documentation and package management:** The site combines the
  package management (https://rocq-prover.org/packages) with a new central
  documentation source (codenamed 'docs.ocaml.org') for all 400+ opam packages
  directly within the rocq-prover.org site.

- **Responsive and accessible:** The site design also takes into account modern
  web-design principles, restructuring the old content in accordance with methods
  that will present it more compellingly. It is a total redesign that modernises
  the look and feel of the webpage, as well as make it easier to navigate and more
  accessible (particularly on mobile devices).

- **Separation of data editing from HTML/CSS generation:** The data used in the
  website is stored in Yaml or Markdown, so users can easily edit it and
  contribute to the website. Ocurrent is used to generate OCaml code from this
  data. The data turned in OCaml is the site served content. All the data used
  in the site can be found in [`./data`](./data).

## Getting Started

Before you begin, make sure you have opam (OCaml Package Manager) installed on your system. If you haven't installed it yet, you can follow the official installation instructions for your platform:

- [Official opam Installation Guide](https://opam.ocaml.org/doc/Install.html)

Once opam is installed, you can set up the project with the following command:

```
make switch
```

Or alternatively (using your current switch):

```
opam install . --deps-only --with-test --with-doc
```

Users of NixOS can get all external dependencies needed to run the above commands by running:

```
nix-shell -p binutils pkg-config curl gmp libev oniguruma
```

Then, you can build and run the website with:

```
make start
```

## Maintainers

The rocq-prover.org maintainer's team is composed of the following community members:

- Matthieu Sozeau [mattam82](https:/github.com/mattam82), Owner (Inria)
- Nicolas Tabareau [tabareau](https:/github.com/tabareau), Owner (Inria)
- Théo Zimmermann [Zimmi48](https:/github.com/Zimmi48), Owner (Télécom Paris)

The original graphic design and Rocq Prover identity are due to Bastien Sozeau [BastienSozeau](https://github.com/bastiensozeau), 
from the [Noir Blanc Rouge](https://noirblancrouge.com/) type foundry.

The rocq-prover.org website benefits from the work of the upstream OCaml.org maintainers, their team 
being composed of the following community members:

- Anil Madhavapeddy ([@avsm](https://github.com/avsm)), Owner (University of Cambridge)
- Thibaut Mattio ([@tmattio](https://github.com/tmattio)), Lead Maintainer (Tarides)
- Christine Rose ([@christinerose](https://github.com/christinerose)), Maintainer (Tarides)
- Cuihtlauac Alvarado ([@cuihtlauac](https://github.com/cuihtlauac)), Maintainer (Tarides)
- Sabine Schmaltz ([@sabine](https://github.com/sabine)), Maintainer (Tarides)

The roles and responsibilities are explained in the governance, don't hesitate to [have a look](https://rocq-prover.org/rocq-team) for more details.

We're always looking for new maintainers! If you're interested in helping us make rocq-prover.org the best resource to learn Rocq and discover the ecosystem, [reach out to us](mailto:rocq-website@rocq-prover.org)!

## Contributing

We'd love your help improving rocq-prover.org!

See our contributing guide in [`CONTRIBUTING.md`](./CONTRIBUTING.md)

## License

- The source code is released under ISC.
- The data is released under CC BY-SA 4.0.
- Code examples within the content are released under UNLICENSE.
- The OCaml logo is released under UNLICENSE.
- The Rocq logo is released under TODO.
- The vendored files are listed with their licenses in [`LICENSE-3RD-PARTY`](./LICENSE-3RD-PARTY).

See our [`LICENSE`](./LICENSE) for the complete licenses.

## Code of Conduct

This project follows the [Rocq Code of Conduct](https://rocq-prover.org/policies/code-of-conduct).
