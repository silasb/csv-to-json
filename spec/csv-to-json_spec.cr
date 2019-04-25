require "./spec_helper"
require "yaml"

describe Csv::To::Json do
  describe "VERSION" do
    it "matches shards.yml" do
      version = YAML.parse(File.read(File.join(__DIR__, "..", "shard.yml")))["version"].as_s
      version.should eq(Csv::To::Json::VERSION)
    end

    it "matches the README" do
      version = YAML.parse(File.read(File.join(__DIR__, "..", "shard.yml")))["version"].as_s
      readme_line = File.read(File.join(__DIR__, "..", "README.md")).scan(/version: (\d.\d.\d)/)[0][1]

      readme_line.should contain(version)
    end
  end

  describe "#run" do
    it "will respond to #run" do
      Csv::To::Json.responds_to?(:run).should be_true
    end

    context "with io object" do
      it "will try to parse the CSV object and output to out_io" do
        in_io = IO::Memory.new("field 1,field 2\nvalue 1,\n")
        out_io = IO::Memory.new()

        Csv::To::Json.run(in_io, out_io)

        out_io.seek(0)
        out_io.to_s.should contain("[\n{\"field 1\":\"value 1\",\"field 2\":\"\"}\n]\n")
      end
    end

    context "with options" do
      context "with empty_value_replace_char option" do
        it "will replace each empty value with the empty_value_replace_char char" do
          in_io = IO::Memory.new("field 1,field 2\nvalue 1,\n")
          out_io = IO::Memory.new()

          options = {
            :empty_value_replace_char => "blah"
          }

          Csv::To::Json.run(in_io, out_io, options)

          out_io.seek(0)
          out_io.to_s.should contain("blah")
        end
      end

      context "with delimiter option" do
        it "will parse on different delimiter" do
          in_io = IO::Memory.new("field 1\tfield 2\nvalue 1\t\n")
          out_io = IO::Memory.new()

          options = {
            :delimiter => '\t'
          }

          Csv::To::Json.run(in_io, out_io, options)

          out_io.seek(0)
          out_io.to_s.should contain("[\n{\"field 1\":\"value 1\",\"field 2\":\"\"}\n]\n")
        end
      end

      context "with quote_char option" do
        it "will parse on different quote char" do
          in_io = IO::Memory.new("field 1,!\"field 2\"!\nvalue 1,\n")
          out_io = IO::Memory.new()

          options = {
            :quote_char => '!'
          }

          Csv::To::Json.run(in_io, out_io, options)

          out_io.seek(0)
          out_io.to_s.should contain("[\n{\"field 1\":\"value 1\",\"\\\"field 2\\\"\":\"\"}\n]\n")
        end
      end
    end

    context "unicode data issues" do
      it "will parse あ char" do
        in_io = IO::Memory.new("field 1\nあ")
        out_io = IO::Memory.new()

        Csv::To::Json.run(in_io, out_io)

        out_io.seek(0)
        out_io.to_s.should contain(%([\n{"field 1":"あ"}\n]\n))
      end

      it "will parse \u0041 char" do
        in_io = IO::Memory.new("field 1\n\u0041")
        out_io = IO::Memory.new()

        Csv::To::Json.run(in_io, out_io)

        out_io.seek(0)
        out_io.to_s.should contain(%([\n{"field 1":"A"}\n]\n))
      end
    end
  end
end
