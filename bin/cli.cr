require "../src/csv-to-json"

require "admiral"

class CLI < Admiral::Command
  define_flag delimiter : String,
    short: d

  define_flag quote_char : String,
    short: q

  define_flag tail : Int64,
    short: t

  define_argument file : String,
    required: true

  define_help description: "A command that says hello"

  define_version Csv::To::Json::VERSION

  def run
    file = arguments.file

    options = {} of Symbol => (Int64 | Char | String)

    if ! flags.delimiter.nil?
      delimiter = flags.delimiter.as(String)

      if delimiter.starts_with? "\\"
        # escape sequence
        escaped = delimiter.at(1)
        if escaped == 't'
          delimiter = '\t'
        end
      else
        delimiter = delimiter.at(0)
      end

      options[:delimiter] = delimiter
    end

    if ! flags.quote_char.nil?
      quote_char = flags.quote_char.as(String)

      if quote_char.starts_with? "\\"
        # escape sequence
        escaped = quote_char.at(1)
        if escaped == 't'
          quote_char = '\t'
        end
      else
        quote_char = quote_char.at(0)
      end

      options[:quote_char] = quote_char
    end

    if flags.tail
      options[:tail] = flags.tail.as(Int64)
    end

    Csv::To::Json.run(file, options)
  end
end

CLI.run
