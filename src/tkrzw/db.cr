class Tkrzw::DB
  @dbm : Lib::DBM

  def initialize(@path : String, @params = "")
    # "truncate=true,num_buckets=100"

    @dbm = Lib.tkrzw_dbm_open(@path, true, @params)
    if @dbm.null?
      raise Error.new("Failed to initialize dbm")
    end

    @closed = false
  end

  def self.open(path, params = "")
    db = DB.new(path, params)
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
  def set(key : String, value : String)
    Lib.tkrzw_dbm_set(@dbm, key, key.bytesize, value, value.bytesize, true)
  end

  @[AlwaysInline]
  def get(key : String)
    ptr = Lib.tkrzw_dbm_get(@dbm, key, key.bytesize, out value_size)

    unless ptr.null?
      res = String.new(ptr, value_size)
      LibC.free(ptr)
      res
    end
  end

  def []=(key, value)
    set(key, value)
  end

  def [](key)
    get(key)
  end

  # def has_key?(key : String)
  #   if Lib.dbcheck(@db, key, key.bytesize) == -1
  #     false
  #   else
  #     true
  #   end
  # end

  # # get and del
  # def extract(key : String)
  #   vbuf = Lib.dbseize(@db, key, key.bytesize, out vsiz)
  #   unless vbuf.null?
  #     res = String.new(vbuf, vsiz)
  #     Lib.free(vbuf.as(Void*))
  #     res
  #   else
  #     # raise Error.new("get error '#{last_ecode_name}'")
  #     nil
  #   end
  # end

  # def del(key : String)
  #   if Lib.dbremove(@db, key, key.bytesize) == 0
  #     raise Error.new("del error '#{last_ecode_name}'")
  #   end
  #   true
  # end

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

  # def drop!
  #   Lib.dbdel(@db)
  # end

  # def clear!
  #   if Lib.dbclear(@db) == 0
  #     raise Error.new("clear error '#{last_ecode_name}'")
  #   end
  #   true
  # end

  # def count
  #   Lib.dbcount(@db)
  # end

  # def size
  #   Lib.dbsize(@db)
  # end

  # def status
  #   s = Lib.dbstatus(@db)
  #   res = String.new(s)
  #   Lib.free(s.as(Void*))
  #   res
  # end
end
