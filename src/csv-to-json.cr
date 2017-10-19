require "./csv-to-json/*"
require "csv"
require "json"

module Csv::To::Json
  def self.run(csv, options = {} of Symbol => String)
    unless File.exists?(csv)
      STDERR.puts "File not found"
      exit 1
    end

    STDIN.blocking = true

    tail = options.delete :tail
    delimiter = options.fetch(:delimiter, ',').as(Char)
    quote_char = options.fetch(:quote_char, '"').as(Char)

    file = File.open(csv)
    csv_io = CSV::Parser.new(file, delimiter, quote_char)

    header = csv_io.next_row

    puts "["

    count = 0
    row = csv_io.next_row

    while !row.nil?
      print Hash.zip(header.as(Array(String)), row.as(Array(String))).to_json

      begin
        row = csv_io.next_row
      rescue ex : CSV::MalformedCSVError
        STDERR.puts "\n"
        STDERR.puts "#{ex} at line: #{count + 3}"

        file.seek(-1 * ex.column_number, IO::Seek::Current)
        STDERR.puts file.read_line

        exit 2
      end

      # super ugly
      if tail.nil? ? !row.nil? : tail.to_i != count + 1 && !row.nil?
        puts ","
      else
        break
      end
      count += 1
    end

    puts "\n]"
  end
end
