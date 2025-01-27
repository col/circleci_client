# Contribution Guidelines

Hello there.
Thank you for your interest in contributing to this project.
GitHub has a large API that would be impossible to maintain a client for without help.

Reading and following the guidelines in this document is an act of kindness and respect for other contributors.
With your help, we can address issues, make changes, and work together efficiently.

## Ways to Contribute

There are many ways to contribute to this project:

* Anyone can use the `mix api.gen` task (see below) to update the library using the latest OpenAPI description.
* Users of the client can report issues related to the client itself and propose solutions.
* Users and library authors can contribute plugins (see below) for new integrations.
* Everyone can help improve documentation and support others in Discussions.
* Anyone can assist in the triage of bugs, identifying root causes, and proposing solutions.

Please keep in mind the intended scope of this package: to provide a GitHub REST API client that balances an ergonomic user experience with the maintainability of code generation.
Assume that the GitHub OpenAPI description that serves as input to this library will change often, and manually changing the output is impractical.

## Ground Rules

All contributions to this project must align with the [code of conduct](CODE_OF_CONDUCT.md).
Beyond that, we ask:

* Please be kind. Maintaining this project is not paid work.
* Please create an issue before embarking on major refactors or new features.
* Let's make a reasonable effort to support commonly-used 3rd-party integrations.

## Workflows

If you're interested in doing something specific, here are some guidelines:

### Bugs and Blockers

Please use [GitHub Issues](https://github.com/challengr-apps/circleci_client/issues) to report reproducible bugs.

### Feature Requests and Ideas

Please use [GitHub Discussions](https://github.com/challengr-apps/circleci_client/discussions) to share requests and ideas for improvements to the library.

### Updating the Generated Code

If you intend to open a PR with updates to the generated code based on the latest GitHub OpenAPI description, please read carefully:

1. Please use the latest commit from the [official repository](https://circleci.com/docs/api/v2/index.html) at the time of your contribution.
2. Use `mix api.gen default openapi.yaml` to regenerate the code.
3. Please do not make any other changes in the same PR (for example, changing this library's version).

If you run into any unexpected issues while generating the code, please open an issue.

Thank you for your help!

### Implementing Changes

If you've decided to take on the implementation of a new feature or fix, please remember to avoid changing files in `operations/` and `schemas/`.
These directories contain generated code, and therefore will be overwritten.
If something in there needs to be changed, please start a discussion on [the generator repo](https://github.com/aj-foster/open-api-generator).

## Releases

For maintainers, the process of releasing this package to [Hex.pm](https://hex.pm/packages/circleci_client) centers around git tags.
To make a new release:

1. Update the Changelog with a new header that has today's date and the new version.
  Include any missing notes from changes since the last release, and any additional upgrade instructions users may need.
2. Update the `@version` number in `mix.exs`.
  The form should be `X.Y.Z`, with optional suffixes, but no leading `v`.
3. Update the **Installation** instructions in `README.md` to have the newest non-suffixed version number.
4. Commit the above changes with a generic commit message, such as `Release X.Y.Z`.
5. Tag the commit as `X.Y.Z`, with optional suffixes, but no leading `v`.
6. Push the commits and tag (for example, `git push origin main --tags`).
7. Observe the GitHub Action titled **Release**.
  This action automatically publishes the package to Hex.pm.
