require 'ostruct'

require "redshift_extractor/version"

require 'pg'
require 'redshift_copier'

def require_all(pattern)
  root = File.expand_path("../", File.dirname(__FILE__))
  Dir.glob("#{root}/#{pattern}/**/*.rb").sort.each { |path| require path }
end

require_all("lib/redshift_extractor")

module RedshiftExtractor
end

