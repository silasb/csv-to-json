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
  end
end
