# csv-to-json

Blindly convert from CSV to JSON while using the CSV headers as keys for the JSON objects.

## Installation

	crystal build --release bin/cli.cr -o c2j

move somewhere in your $PATH

## Usage

Used with jq to quickly filter and display data

	 c2j beam-network.csv | jq '.[] | select(.["Last Name"] == "Rutledge")'

Find records, but redefine all matching objects

	 c2j beam-network.csv | jq '.[] | select(.["Last Name"] == "Rutledge") | { last_name: ."Last Name", first_name: ."First Name" }'

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/silasb/csv-to-json/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[silasb]](https://github.com/silasb) silasb - creator, maintainer
