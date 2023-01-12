class Tkrzw::DB
  @dbm : Lib::DBM

  def initialize(@path : String, @writable = true, @params = "")
    # "truncate=true,num_buckets=100"

    @dbm = Lib.tkrzw_dbm_open(@path, @writable, @params)
    if @dbm.null?
      raise Error.new("Failed to initialize dbm")
    end

    @closed = false
  end

  def self.open(path, writable = true, params = "")
    db = DB.new(path, writable, params)
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

  # ==================================== DB UTIL =====================================================

  def healthy?
    Lib.tkrzw_dbm_is_healthy(@dbm)
  end

  def ordered?
    Lib.tkrzw_dbm_is_ordered(@dbm)
  end

  def writable?
    Lib.tkrzw_dbm_is_writable(@dbm)
  end

  def should_be_rebuilt?
    Lib.tkrzw_dbm_should_be_rebuilt(@dbm)
  end

  def clear!
    Lib.tkrzw_dbm_clear(@dbm)
  end

  @[AlwaysInline]
  def file_size
    Lib.tkrzw_dbm_get_file_size(@dbm)
  end

  @[AlwaysInline]
  def count
    Lib.tkrzw_dbm_count(@dbm)
  end

  # to reduce file_size
  def rebuild!(params = "")
    Lib.tkrzw_dbm_rebuild(@dbm, params)
  end

  # =================================== DATA =======================================================

  @[AlwaysInline]
  def set(key : String | Bytes, value : String | Bytes)
    Lib.tkrzw_dbm_set(@dbm, key, key.bytesize, value, value.bytesize, true)
  end

  @[AlwaysInline]
  def get(key : String | Bytes) : String?
    get_raw(key) do |slice|
      String.new(slice)
    end
  end

  @[AlwaysInline]
  def del(key : String | Bytes) : Bool
    Lib.tkrzw_dbm_remove(@dbm, key, key.bytesize)
  end

  @[AlwaysInline]
  def get_raw(key : String | Bytes)
    ptr = Lib.tkrzw_dbm_get(@dbm, key, key.bytesize, out value_size)

    result = nil

    unless ptr.null?
      result = yield Slice(UInt8).new(ptr, value_size)
      LibC.free(ptr)
    end

    result
  end

  def extract_raw(key : String | Bytes)
    ptr = Lib.tkrzw_dbm_remove_and_get(@dbm, key, key.bytesize, out value_size)
    result = nil
    unless ptr.null?
      result = yield Slice(UInt8).new(ptr, value_size)
      LibC.free(ptr)
    end
    result
  end

  def extract(key : String | Bytes) : String?
    extract_raw(key) do |slice|
      String.new(slice)
    end
  end

  @[AlwaysInline]
  def has_key?(key : String | Bytes) : Bool
    Lib.tkrzw_dbm_check(@dbm, key, key.bytesize)
  end

  @[AlwaysInline]
  def []=(key, value)
    set(key, value)
  end

  @[AlwaysInline]
  def [](key)
    get(key)
  end

  # ==================================== ITERATE ============================================

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
