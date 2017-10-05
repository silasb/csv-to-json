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
  csv = ARGV.shift

  if csv == "--version"
    puts Csv::To::Json::VERSION
    exit 0
  else
    options = {} of Symbol => String

    if csv == "--tail"
      tail = ARGV.shift
      if tail.nil?
        STDERR.puts "Missing tail argument"
        exit 1
      else
        options[:tail] = tail
      end
    end

    if ARGV.size == 0
      file = csv
    else
      file =  ARGV[ARGV.size - 1]
    end

    Csv::To::Json.run(file, options)
  end

end
