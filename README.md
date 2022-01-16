# tkrzw

Fast Persistent KeyValue Storage. Wrapper for [Tkrzw](https://dbmx.net/tkrzw/)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  tkrzw:
    github: kostya/tkrzw
```

## Usage

```crystal
require "tkrzw"

db = Tkrzw::DB.new("1.tkh")
db.set("bla", "jo")

p db.get("bla")
p db.get("bla2")

db.each do |k, v|
  p k, v
end

db.close
```
## Compare with [LevelDB](https://github.com/crystal-community/leveldb) and [KyotoCabinet](https://github.com/kostya/kyotocabinet)

| test                     | Tkrzw | LevelDB | KyotoCabinet |
| ------------------------ | -------- | ------- | ------------ |
| 1 mln set                | 3.66s   | 3.66s   | 1.00s        |
| 1 mln get                | 3.66s   | 1.95s   | 0.63s        |
| iterate over all records | 3.66s   | 0.27s   | 0.31s        |
| db size                  | 3.66s   | 16Mb    | 45Mb         |
| memory used              | 3.66s   | 16Mb    | 45Mb         |
