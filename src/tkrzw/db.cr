class Tkrzw::DB
  @dbm : Lib::DBM

  def initialize(@path : String, @locking = true, @params = "")
    # "truncate=true,num_buckets=100"

    @dbm = Lib.tkrzw_dbm_open(@path, @locking, @params)
    if @dbm.null?
      raise Error.new("Failed to initialize dbm")
    end

    @closed = false
  end

  def self.open(path, locking = true, params = "")
    db = DB.new(path, locking, params)
    yield db
  ensure
    db.close if db
  end

  def close
    return if @closed
    Lib.tkrzw_dbm_close(@dbm)
    @closed = true
  end

  def finalize
    close
  end

  @[AlwaysInline]
  def set(key : String | Bytes, value : String | Bytes)
    Lib.tkrzw_dbm_set(@dbm, key, key.bytesize, value, value.bytesize, true)
  end

  @[AlwaysInline]
  def get(key : String | Bytes)
    get_slice(key) do |slice|
      String.new(slice)
    end
  end

  @[AlwaysInline]
  def del(key : String | Bytes)
    Lib.tkrzw_dbm_remove(@dbm, key, key.bytesize)
  end

  @[AlwaysInline]
  def get_slice(key : String | Bytes)
    ptr = Lib.tkrzw_dbm_get(@dbm, key, key.bytesize, out value_size)

    result = nil

    unless ptr.null?
      result = yield Slice(UInt8).new(ptr, value_size)
      LibC.free(ptr)
    end

    result
  end

  def []=(key, value)
    set(key, value)
  end

  def [](key)
    get(key)
  end

  def each
    iter = Lib.tkrzw_dbm_make_iterator(@dbm)
    Lib.tkrzw_dbm_iter_first(iter)
    while true
      unless Lib.tkrzw_dbm_iter_get(iter, out key_ptr, out key_size, out value_ptr, out value_size)
        break
      end
      key = String.new(key_ptr, key_size)
      value = String.new(value_ptr, value_size)
      LibC.free(key_ptr)
      LibC.free(value_ptr)

      yield key, value

      Lib.tkrzw_dbm_iter_next(iter)
    end

    self
  ensure
    Lib.tkrzw_dbm_iter_free(iter) if iter
  end
end
