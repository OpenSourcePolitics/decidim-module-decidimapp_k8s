# frozen_string_literal: true

if ENV["SIMPLECOV"]
  SimpleCov.start do
    track_files "**/*.rb"

    # We ignore some of the files because they are never tested
    add_filter "/bin/"
    add_filter "/spec/"
    add_filter %r{^/lib/decidim/[^/]*/engine.rb}
    add_filter %r{^/lib/decidim/[^/]*/test/factories.rb}
  end

  SimpleCov.merge_timeout 1800

  if ENV["CI"]
    require "simplecov-cobertura"
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  end
end
