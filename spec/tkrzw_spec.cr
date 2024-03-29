require "./spec_helper"

describe Tkrzw do
  it "get set" do
    Tkrzw::DB.open(spec_db_name("1.tkh")) do |db|
      db.set("bla", "jopa")
      db.get("bla").should eq "jopa"
      db.get("other").should eq nil
    end
  end

  it "get_raw" do
    Tkrzw::DB.open(spec_db_name("1.tkh")) do |db|
      db.set("bla", "jopa")
      v = nil
      db.get_raw("bla") { |slice| v = String.new(slice); nil }
      v.should eq "jopa"
    end
  end

  it "del" do
    Tkrzw::DB.open(spec_db_name("1.tkh")) do |db|
      db.set("bla", "mu")
      db.get("bla").should eq "mu"
      db.del("bla").should eq true
      db.get("bla").should eq nil
    end
  end

  it "has_key?" do
    Tkrzw::DB.open(spec_db_name("1.tkh")) do |db|
      db.set("bla", "mu")
      db.has_key?("bla").should eq true
      db.has_key?("bla2").should eq false
    end
  end

  it "extract" do
    Tkrzw::DB.open(spec_db_name("1.tkh")) do |db|
      db.has_key?("bla").should eq false
      db.set("bla", "mu")
      db.has_key?("bla").should eq true
      db.extract("bla").should eq "mu"
      db.has_key?("bla").should eq false
      db.extract("bla").should eq nil
    end
  end

  it "each" do
    Tkrzw::DB.open(spec_db_name("1.tkh")) do |db|
      db.set("bla", "mu")
      db.set("fuck", "jopa")
      res = [] of Tuple(String, String)
      db.each do |key, value|
        res << {key, value}
      end

      res.should eq [{"bla", "mu"}, {"fuck", "jopa"}]
    end
  end
end
