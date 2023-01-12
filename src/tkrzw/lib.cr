module Tkrzw
  @[Link(ldflags: "#{__DIR__}/../ext/tkrzw-c/libtkrzw.a -lstdc++ -lz -llzma")]
  lib Lib
    type DBM = Void*

    # db
    fun tkrzw_dbm_open(path : UInt8*, writable : Bool, params : UInt8*) : DBM
    fun tkrzw_dbm_close(dbm : DBM)

    fun tkrzw_dbm_is_healthy(dbm : DBM) : Bool
    fun tkrzw_dbm_is_ordered(dbm : DBM) : Bool
    fun tkrzw_dbm_is_writable(dbm : DBM) : Bool
    fun tkrzw_dbm_should_be_rebuilt(dbm : DBM) : Bool
    fun tkrzw_dbm_clear(dbm : DBM) : Bool
    fun tkrzw_dbm_get_file_size(dbm : DBM) : Int64
    fun tkrzw_dbm_count(dbm : DBM) : Int64
    fun tkrzw_dbm_rebuild(dbm : DBM, params : UInt8*) : Bool

    # records
    fun tkrzw_dbm_set(dbm : DBM, key : UInt8*, key_size : Int32, value : UInt8*, value_size : Int32, overwrite : Bool)
    fun tkrzw_dbm_get(dbm : DBM, key : UInt8*, key_size : Int32, value_size : Int32*) : UInt8*
    fun tkrzw_dbm_remove(dbm : DBM, key : UInt8*, key_size : Int32) : Bool
    fun tkrzw_dbm_remove_and_get(dbm : DBM, key : UInt8*, key_size : Int32, value_size : Int32*) : UInt8*
    fun tkrzw_dbm_check(dbm : DBM, key : UInt8*, key_size : Int32) : Bool

    # iter
    type DBMIter = Void*
    fun tkrzw_dbm_make_iterator(dbm : DBM) : DBMIter
    fun tkrzw_dbm_iter_first(iter : DBMIter)
    fun tkrzw_dbm_iter_get(iter : DBMIter, key_ptr : UInt8**, key_size : Int32*, value_ptr : UInt8**, value_size : Int32*) : Bool
    fun tkrzw_dbm_iter_next(iter : DBMIter)
    fun tkrzw_dbm_iter_free(iter : DBMIter)
  end
end
