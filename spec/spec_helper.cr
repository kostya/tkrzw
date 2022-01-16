require "spec"
require "../src/tkrzw"
require "file_utils"

def spec_db_name(name)
  FileUtils.mkdir_p("#{__DIR__}/.dbs")
  "#{__DIR__}/.dbs/#{name}"
end

Spec.before_each do
  Dir["#{__DIR__}/.dbs/*"].each do |name|
    File.delete(name)
  end
end
