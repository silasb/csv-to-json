require "../src/csv-to-json"

require "signal"

# doesn't appear to work
Signal::PIPE.trap do
  exit -1
end

if ARGV.size < 1
  STDERR.puts "FILE argument not present"
  exit 1
else
  csv = ARGV[0]

  if csv == "--version"
    puts Csv::To::Json::VERSION
  else
    Csv::To::Json.run(csv)
  end
end
