---
title: Contributing to Calyx
layout: docs
permalink: /introduction/contributing/
---

# Contributing to Calyx

Calyx is an open source project and contributions are welcome.

## General Contributions

The best way to contribute is to use the Gem. Install it on a local project and try things out. Does it work? Does it do what you expect? Is there anything missing?

It’s really helpful to contribute to discussion on open issues, reporting bugs or suggest new features. Any feedback and criticism is received with gratitude.

## Code Contributions

Changes that fix bugs and improve test coverage will generally be merged on-the-spot. Larger changes that introduce new features should harmonise with the vision, goals and style of the project. If in doubt, just ask in advance.

### Submitting Changes

Changes to the source code and documentation should be submitted as a pull request on GitHub, corresponding to the following process:

- Fork the repo and make a new branch for your changes
- Submit your branch as a pull request against the master branch

If any aspects of your changes need further explanation, use the pull request description to provide further detail and context (including code samples as necessary).

Please don’t bump the version as part of your pull request (this happens separately).

### Pull Request Checklist

- Extraneous and trivial small commits should be squashed into larger descriptive commits
- Commits should include concise and clear messages using standard formatting conventions
- The test suite must be passing
- Newly introduced code branches should be covered by tests
-- Introduce new tests if existing tests don’t support your changes
- Changes to method signatures and class organisation should be annotated by doc comments

## Code of Conduct

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms.
