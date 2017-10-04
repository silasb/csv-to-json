require "./csv-to-json/*"
require "csv"
require "json"

module Csv::To::Json
  def self.run(csv)
    unless File.exists?(csv)
      STDERR.puts "File not found"
      exit 1 
    end

    STDIN.blocking = true

    csv_io = CSV.new(File.read(csv), headers: true)

    puts "["

    csv_io.next

    loop do
      print csv_io.row.to_h.to_json
      if csv_io.next
        puts ","
      else
        break
      end
    end

    puts "\n]"
  end
end
