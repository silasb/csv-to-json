# csv-to-json

Blindly convert from CSV to JSON while using the CSV headers as keys for the JSON objects.
Also works with TSV files or any file that can be delimited.

## Installation

	crystal build --release bin/cli.cr -o c2j

move somewhere in your $PATH

## Usage

	Usage:
		./c2j [flags...] <file> [arg...]

	Flags:
	    --delimiter, -d
	    --empty-value-replace-char, -e
	    --help (default: false)         # Displays help for the current command.
	    --quote-char, -q
	    --tail, -t
	    --version (default: false)

Convert CSV to JSON

	c2j some.csv

Convert TSV to JSON

	c2j -d '\t' -q '|' some.txt

Parsing empty CSV cells with something other than `null` by using `--empty-value-replace-char`

	c2j --empty_value_replace_char '' some.txt
	{ "hello": "" }

instead of:

	{ "hello": null }

Used with `jq` to quickly filter and display data

	c2j some.csv | jq '.[] | select(.["Last Name"] == "Rutledge")'

Find records, but redefine all matching objects

	c2j some.csv | jq '.[] | select(.["Last Name"] == "Rutledge") | { last_name: ."Last Name", first_name: ."First Name" }'

Used to convert CSV to a format that [`esbulk`](https://github.com/miku/esbulk) can use

	c2j -d '\t' -q '|' LATEST.txt | jq -c '.[] | .' | esbulk -index some-index

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
