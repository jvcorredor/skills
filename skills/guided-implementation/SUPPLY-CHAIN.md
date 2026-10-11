# Supply chain field

Fill the card's **Supply chain** field for any unit that touches dependencies, CI, container images, or infrastructure-as-code. One line per point; write "unknown" where you have not verified a fact.

- **Pinning**: exact version or range; GitHub Actions pinned to a full commit SHA with the tag in a comment; images by digest; Helm chart versions; lockfile changes (`go.sum`, `package-lock.json`, `.terraform.lock.hcl`, and kin).
- **Provenance**: who publishes it; signatures or attestations (Sigstore, SLSA) where they exist.
- **Blast radius**: transitive dependencies added; permissions granted (workflow `permissions:`, token scopes); network or egress access at build time.
- **Update policy**: how it gets bumped (the repo's Renovate or Dependabot config, if any) and what that implies for the pinning choice.
