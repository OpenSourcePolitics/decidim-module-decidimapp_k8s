# frozen_string_literal: true

require "spec_helper"

describe String do
  describe "#colorize" do
    it "colorizes a string" do
      expect("hello".colorize(31)).to eq("\e[31mhello\e[0m")
    end
  end

  it "has constants for colors" do
    expect(String::BLACK).to eq(30)
    expect(String::RED).to eq(31)
    expect(String::GREEN).to eq(32)
    expect(String::YELLOW).to eq(33)
    expect(String::BLUE).to eq(34)
    expect(String::MAGENTA).to eq(35)
    expect(String::CYAN).to eq(36)
    expect(String::WHITE).to eq(37)
    expect(String::NONE).to eq(0)
  end

  it "has methods for colors" do
    expect("hello".black).to eq("\e[30mhello\e[0m")
    expect("hello".red).to eq("\e[31mhello\e[0m")
    expect("hello".green).to eq("\e[32mhello\e[0m")
    expect("hello".yellow).to eq("\e[33mhello\e[0m")
    expect("hello".blue).to eq("\e[34mhello\e[0m")
    expect("hello".magenta).to eq("\e[35mhello\e[0m")
    expect("hello".cyan).to eq("\e[36mhello\e[0m")
    expect("hello".white).to eq("\e[37mhello\e[0m")
    expect("hello".reset).to eq("\e[0mhello\e[0m")
  end
end
