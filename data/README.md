# Retrieving data

## GitHub teams

To generate the `github_teams.json` file, run the following GraphQL query (for instance in the [GitHub GraphQL Explorer](https://developer.github.com/v4/explorer/)):

```graphql
query {
  organization(login: "rocq-prover") {
    teams(first: 100) {
      totalCount
      nodes {
        slug
        name
        description
        members {
          nodes { login name }
        }
      }
    }
  }
}
```

To generate the `github_teams_simplified.json` file, run the following `jq` command (at the root of the repository):

```bash
jq '{
  teams: .data.organization.teams.nodes | map({
    id: .slug,
    name: .name,
    description: .description,
    contacts: [],
    members: .members.nodes | map({github: .login, name: (.name // "")})
  })
}' data/github-teams.json > data/github-teams-simplified.json
```

## Platform Packages

To generate the list of platform packages, get the list of packages on the last readme of the platform
(e.g., https://github.com/rocq-prover/platform/blob/2025.01.0/doc/README~8.20~2025.01.md) and place it
in the following files (by level): 
gen_tools_base.html gen_tools_ide.html gen_tools_full.html gen_tools_extended.html gen_tools_optional.html gen_tools_dependency.html

Then run the script from the `data` folder
```bash
../scripts/cat_tools.sh 
```
