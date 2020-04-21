# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.2] - 2020-04-21

### Changed
- Fix Gemfile.lock missing version bump
- Support Ruby >= 2.5 (https://www.ruby-lang.org/en/news/2020/04/05/support-of-ruby-2-4-has-ended/)

## [1.0.1] - 2020-04-13

### Added
- Introduce `TestingSupport::HttpResponses` for sharing the http and JSON fixtures
so we can share these in environments that use this gem.

## [1.0.0] - 2020-04-13

Initial release.
