# AutoReserve

[![Test](https://github.com/po-miyasaka/AutoReserve/workflows/Test/badge.svg)](https://github.com/po-miyasaka/AutoReserve/actions?query=workflow%3ATest)
[![License](https://img.shields.io/github/license/po-miyasaka/AutoReserve)](https://github.com/po-miyasaka/AutoReserve/blob/master/LICENSE)
[![Twitter](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Fpo_miyasaka)](https://twitter.com/po_miyasaka)

ブラウザを動かして予約するやつ

## Usage

### SetUp

```sh
bundle
```

### Run

```sh
bundle exec ruby dmm.rb HogeLoginID HogePassword
```

## Development

Run `rake` to run Lint (autocorrect) and Test.

You can confirm all tasks via `rake -T` that like following.

```sh
$ rake -T
rake lint  # Lint and auto-correct by Rubocop
rake test  # Run all tests by rspec
...
```
