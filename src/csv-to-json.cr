require "./csv-to-json/*"
require "csv"
require "json"

module Csv::To::Json
  # Processes a CSV file on *in_io* with *options* and produces a JSON object on *out_io*
  def self.run(in_io, out_io, options = {} of Symbol => String)
    STDIN.blocking = true

    # in_io.set_encoding(encoding: "UTF-8", invalid: :skip)

    empty_value_replace_char = options.fetch(:empty_value_replace_char, "")
    tail = options.delete :tail
    delimiter = options.fetch(:delimiter, ',').as(Char)
    quote_char = options.fetch(:quote_char, '"').as(Char)

    #file = File.open(csv)
    csv_io = CSV::Parser.new(in_io, delimiter, quote_char)

    header = csv_io.next_row

    out_io.puts "["

    count = 0
    row = csv_io.next_row

    while !row.nil?

      values = row.as(Array(String))

      # replace each row value with a empty
      #
      # row.as(Array(String)) will already convert empty CSV cells as empty strings so lets skip this mapping
      # if we don't need to do anything
      if empty_value_replace_char != ""
        values = values.map { |s|
          if s == ""
            if empty_value_replace_char.nil?
              s = nil
            else
              s = empty_value_replace_char.as(String)
            end
          else
            s
          end
        }
      end

      out_io.print Hash.zip(
        header.as(Array(String)),
        values
      ).to_json

      begin
        row = csv_io.next_row
      rescue ex : CSV::MalformedCSVError
        STDERR.puts "\n"
        STDERR.puts "#{ex} at line: #{count + 3}"

        in_io.seek(-1 * ex.column_number, IO::Seek::Current)
        STDERR.puts in_io.read_line

        exit 2
      end

      # super ugly
      if tail.nil? ? !row.nil? : tail.to_i != count + 1 && !row.nil?
        out_io.puts ","
      else
        break
      end
      count += 1
    end

    out_io.puts "\n]"
  end
end
