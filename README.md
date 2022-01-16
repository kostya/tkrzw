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

| test                     | Tkrzw  | LevelDB | KyotoCabinet |
| ------------------------ | ------ | ------- | ------------ |
| 2 mln set                | 1.22s  | 3.95s   | 1.66s        |
| 2 mln get                | 0.96s  | 2.43s   | 1.22s        |
| iterate over all records | 1.19s  | 0.34s   | 0.73s        |
| db size                  | 65Mb   | 21Mb    | 83Mb         |
| memory used              | 72.2Mb | 97.1Mb  | 70.4Mb       |

