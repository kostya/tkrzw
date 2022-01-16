module Tkrzw
  @[Link(ldflags: "#{__DIR__}/../ext/tkrzw-c/libtkrzw.a -lstdc++ -lz")]
  lib Lib
    type DBM = Void*
    fun tkrzw_dbm_open(path : UInt8*, writable : Bool, params : UInt8*) : DBM
    fun tkrzw_dbm_set(dbm : DBM, key : UInt8*, key_size : Int32, value : UInt8*, value_size : Int32, overwrite : Bool)
    fun tkrzw_dbm_get(dbm : DBM, key : UInt8*, key_size : Int32, value_size : Int32*) : UInt8*
    fun tkrzw_dbm_close(dbm : DBM)

    # iter
    type DBMIter = Void*
    fun tkrzw_dbm_make_iterator(dbm : DBM) : DBMIter
    fun tkrzw_dbm_iter_first(iter : DBMIter)
    fun tkrzw_dbm_iter_get(iter : DBMIter, key_ptr : UInt8**, key_size : Int32*, value_ptr : UInt8**, value_size : Int32*) : Bool
    fun tkrzw_dbm_iter_next(iter : DBMIter)
    fun tkrzw_dbm_iter_free(iter : DBMIter)
  end
end
