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

    file = File.open(csv)
    csv_io = CSV::Parser.new(file)

    header = csv_io.next_row

    puts "["

    count = 0
    row = csv_io.next_row

    while !row.nil?
      print Hash.zip(header.as(Array(String)), row.as(Array(String))).to_json
      row = csv_io.next_row
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
