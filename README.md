# gds-entra-infrastructure-modules

Repo where we store reusable terraform modules for the gds-entra solution.

## Developer Onboarding

1. This repository uses pre-commit. Please install prerequisite tools first:

```zsh
brew install tflint checkov trivy terraform-docs codespell
```

> [!IMPORTANT]
> Make sure the Homebrew path is included in the PATH environment variable in your default shell (probably Zsh on MacOS).

2. Then complete steps 1. and 3. from the [pre-commit quick start](https://pre-commit.com/#quick-start).

If pre-commit detects issues when you attempt to commit changes, a dialogue box similar to the one below will appear. Click 'Show Command Output' to see details:

![pre-commit](./docs/pre-commit.png)

> [!IMPORTANT]
> This README was created, and is maintained by terraform-docs. A pre-commit hook is configured to run this utility automatically; you can also run it manually as shown below:

```zsh
terraform-docs markdown table --indent 2 --output-mode inject --output-file README.md ./terraform-azurerm-<module name suffix>
```
