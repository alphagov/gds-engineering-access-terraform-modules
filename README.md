# gds-entra-infrastructure-modules

Repo where we store reusable terraform modules for the gds-entra solution.

## Developer Onboarding

1. This repository uses pre-commit. Please install prerequisite tools first:

```zsh
brew install tflint checkov trivy terraform-docs codespell
```

2. Then complete steps 1. and 3. from the [pre-commit quick start](https://pre-commit.com/#quick-start).

> [!IMPORTANT]
> If pre-commit detects issues when you attempt to commit changes, a dialogue box similar to the one below will appear. Click 'Show Command Output' to see details:

![pre-commit](./docs/pre-commit.png)

> [!IMPORTANT]
> README.md files for each module were created, and are maintained by terraform-docs. A pre-commit hook is configured to run this utility automatically; you can also run it manually as shown below:

```zsh
terraform-docs markdown table --indent 2 --output-mode inject --output-file README.md <module name>
```

## Creating New Modules

Please update the following filters when introducing a new module directory, if required:

```hcl
# .pre-commit-config.yaml

      - id: terraform_docs
        files: ^(azurerm-conditional-access|msgraph-entra-domain)/.*\.tf$
        args:
          - --hook-config=--add-to-existing-output-files=true
          - --hook-config=--output-mode=inject
          - --hook-config=--config=.terraform-docs.yml
```

```hcl
# .github/workflows/terraform.yml

      - uses: dorny/paths-filter@de90cc6fb38fc0963ad72b210f1f284cd68cea36 # v3.0.2
        id: filter
        with:
          filters: |
            azurerm-conditional-access:
              - 'azurerm-conditional-access/**'
            msgraph-entra-domain:
              - 'msgraph-entra-domain/**'
```

## Releasing Individual Modules

First determine the next version to [release](https://github.com/alphagov/gds-engineering-access-terraform-modules/releases)

To release a new version of a specific module, create and push a git tag matching the module's directory name and desired version. For example, to release version 0.0.1 of the `azurerm-conditional-access` module, you would run the commands below from the root of the checked out repository:

```sh
git tag azurerm-conditional-access/v0.0.1 -m 'Initial release'
git push origin azurerm-conditional-access/v0.0.1
```

This will trigger the release workflow for that module only. Each module should be tagged and released independently using this pattern.

## Consuming Modules

1. On the [Releases page](https://github.com/alphagov/gds-engineering-access-terraform-modules/releases), find your desired module/version combination and click on the short commit SHA hash:

![assets](./docs/assets.png)

2. On the commit page, click the copy button to retrieve the full commit SHA hash:

![assets](./docs/sha.png)

3. Reference the module in the source argument of your module block. Add a comment to indicate the release version this commit SHA represents.

```hcl
module "azurerm-conditional-access" {
  source = "github.com/alphagov/gds-engineering-access-terraform-modules//<module name>?ref=<commit sha hash>" # <release version>
  #...
}
```

```hcl
# Example

module "azurerm-conditional-access" {
  source = "github.com/alphagov/gds-engineering-access-terraform-modules//azurerm-conditional-access?ref=303d8966acf114429f8613fa070a1848c2ff3661" # v0.0.1
  #...
}
```

> [!NOTE]
> The double forward slash is required syntax when referencing a module in a repository subdirectory.
