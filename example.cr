require "./src/tkrzw"

db = Tkrzw::DB.new("1.tkh")
db.set("bla", "jo")

p db.get("bla")
p db.get("bla2")

db.each do |k, v|
  p k, v
end

db.close
