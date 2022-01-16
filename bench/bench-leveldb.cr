require "leveldb"

File.delete("1.ldb") if File.exists?("1.ldb")
db = LevelDB::DB.new("./1.ldb")
N = 1_000_000

t = Time.local
N.times do |i|
  db.put("bla#{i}", "jopa#{i}")
end
p "set #{Time.local - t}"

t = Time.local
s = 0
N.times do |i|
  s += db.get("bla#{i}").not_nil!.bytesize
end
p s
p "get #{Time.local - t}"

t = Time.local
s = 0
db.each do |k, v|
  s += k.bytesize + v.bytesize
end
p s
p "each #{Time.local - t}"

db.close
# db.destroy
