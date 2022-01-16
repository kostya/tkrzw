require "../src/tkrzw"

File.delete("1.tkh") if File.exists?("1.tkh")
db = Tkrzw::DB.new("1.tkh")
N = 2_000_000

t = Time.local
N.times do |i|
  db.set("bla#{i}", "jopa#{i}")
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
