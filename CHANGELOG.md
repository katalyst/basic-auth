## [2.0.0] - 2026-11-26

- Breaking: when more than one rule matches a request, the rule added last applies; previously the most specific path
  applied regardless of order
- Breaking: drops support for Ruby < 4
- Add support for `Regexp` paths, e.g. `exclude(%r{/clients/[^/]+/webhooks/[^/]+})`; patterns must match the whole
  request path
- String paths are matched literally, as in 1.0.1; apps that relied on regular expressions in string paths should
  upgrade to 2.0 and pass a `Regexp` instead

## [1.0.1] - 2026-11-26

- Fix: normalise repeated slashes before matching paths, e.g. `//admin` is matched as `/admin`
- Fix: match configured paths on segment boundaries, e.g. excluding `/up` no longer excludes `/uploads`
- Breaking (unintentional): string paths are matched literally, so regular expressions in string paths such as
  `/clients/.*/webhooks/.*` no longer match; upgrade to 2.0 and use a `Regexp` for patterns

## [1.0.0] - 2025-08-04

- Drop support for old ruby versions

## [0.5.0] - 2024-04-26

- Add `/up` as a default allowed path (Rails 7.1+ health check)

## [0.4.0] - 2022-06-10

- Add support for IP address allowlists

## [0.3.2] - 2022-03-25

- Publish to RubyGems

## [0.3.1] - 2021-10-23

- Revert ruby version change that broke compatibility with legacy Rails 3 apps

## [0.3.0] - 2021-10-05

- Add multiple path support

## [0.2.0] - 2021-06-08

- Fix: Use Rails 6 resolution for application name
- Security updates

## [0.1.0] - 2021-03-16

- Initial release
