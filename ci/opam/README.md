# SSL compatibility overlay

This repository overrides only ssl.0.7.0 from the opam snapshot used by CI.
The package metadata and checksummed upstream source are unchanged, except
for applying `openssl4.patch`.

The patch backports the SSLv23 minimum-protocol change from
<https://github.com/savonet/ocaml-ssl/pull/189> to SSL 0.7.0. A minimum of 0
lets OpenSSL select its supported minimum instead of rejecting SSL3_VERSION.
The TLS 1.3 maximum and the explicit SSLv3 case are unchanged.

CI adds this repository at highest priority before installing dependencies.
`make create_switch` includes it when creating a local switch. For an existing
switch, run from the repository root:

```sh
opam repository add ssl-fixes "file://$PWD/ci/opam" --this-switch --rank=1
# If the previous SSL 0.8 source pin was applied, remove it first:
opam pin remove ssl --no-action
opam install ssl.0.7.0
```

Keep the existing opam snapshot: this backport does not require newer Dune or
SSL releases. Remove the overlay after adopting a released SSL version that
contains the upstream fix.
