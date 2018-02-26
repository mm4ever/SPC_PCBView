#ifndef SQLITEDB_H
#define SQLITEDB_H

#include <string>
#include <type_traits>
#include <map>
#include <unordered_map>
#include <functional>
#include <memory>
#include <tuple>
#include <iostream>

#include <boost/variant/variant.hpp>
//#include <boost/comcompute/algorithm/mismatch.hpp>
#include <boost/variant/get.hpp>

#include <rapidjson/writer.h>
#include <rapidjson/document.h>
#include <rapidjson/stringbuffer.h>

#include <sqlite3.h>

//#include "inoncopyable.hpp"
//#include "Exception/customexception.hpp"
//#include "Archive/Json/json.hpp"
#include "Blob.hpp"
//#include "./stringop.hpp"

    namespace SSDK
    {
        namespace DB
        {
            /**
            *  @brief This class is used to operate sqlite DB
            * 主要参考:
            *         1. <<深入应用c++11>> P302 “使用C++封装sqlite库”
            *         2.使用的sqlite版本为3.18
            *
            *
            *  @author rime
            *  @version 1.00 2017-04-05 rime
            *                note:create it
            */
            class SqliteDB
            {
            public:

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //enum & struct & define/typedef/using

                /**
                 * 配合sqlite使用的json接口,主要用于配合查询使用
                 */
                using JsonBuilder = rapidjson::Writer<rapidjson::StringBuffer>;

                /**
                 *sqlite支持的数据结构, 方便sqlite和c++进行数据结构转换
                 *sqlite 返回的类型总共有5种:
                 *       [SQLITE_INTEGER]
                 *       [SQLITE_FLOAT]
                 *       [SQLITE_TEXT]
                 *       [SQLITE_BLOB]
                 *       [SQLITE_NULL]
                 */
                using  sqliteValue = boost::variant<
                                                    double,
                                                    int,uint32_t,
                                                    sqlite3_int64,
                                                    char*,
                                                    const char*,
                                                    const unsigned char *,
                                                    SSDK::DB::Blob,
                                                    std::string,
                                                    const void *,
                                                    std::nullptr_t>;

                template<int...>
                struct indexTuple{};

                template<int N,int... indexes>
                struct makeIndexes:makeIndexes<N-1,N-1,indexes...>{};

                template<int... indexes>
                struct makeIndexes<0,indexes...>
                {
                  typedef indexTuple<indexes...> type;
                };

                //<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //member variant

                /**
                 * excecuteScalar 执行Sql语句把结果放到sqlite3_statememnt对象中，这时需要根据当前的类型来调用对应
                 * 的sqlite3_column_xxx 来取出真实的结果。这里通过表驱动法，将sqlite类型和对应的取值函数放到一个表中
                 * 在外面可以根据类型调用对应的取值函数了
                 */
                static std::unordered_map< int,std::function<sqliteValue(sqlite3_stmt*,int)> > m_valMap;


                /**
                 * 将sqlite中获取具体值写入到json串中
                 */
                static std::unordered_map< int, std::function<void(sqlite3_stmt*,int, JsonBuilder&)> > m_jsonBuilderMap;

                static std::string m_beginStr;//开始
                static std::string m_commitStr;//提交
                static std::string m_rollbackStr;//回滚

                //<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //constructor & deconstructor

                SqliteDB();
                explicit SqliteDB(const std::string& dbPath);

                virtual ~SqliteDB();

                //<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //get & set functions

                /**
                 * @brief dbPath
                 * @return
                 *             sqlite文件的完整路径
                 */
                const std::string& dbPath(){return this->m_dbFilePath;}

                /**
                 * @brief isOpened
                 * @return
                 *          判断sqlite文件是否打开
                 *
                 */
                 bool isOpened(){return this->m_isdbOpened;}

                /**
                 * @brief latestErrorCode
                 * @return
                 *           最近一次执行的错误码
                 *
                 * 注意:
                 *         sqlite定义了20多种错误代码
                 *         在一般情况下,函数正确返回的结果码为SQLITE_OK, SQLITE_ROW和SQLITE_DONE,否则返回错误码
                 */
                int latestErrorCode(){return this->m_latestResultCode;}

                //<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //open & close functions

                /**
                 * @brief open
                 *             打开一个sqlite数据库
                 * @param dbPath
                 *              sqlite路径
                 * @return
                 *              打开是否成功, 成功返回为true,否则返回为false
                 *
                 * 注意:
                 *         如果数据库不存在，数据库将被创建并打开, 如果创建失败则设置失败标志
                 */
                bool open(const std::string& dbPath);

                /**
                 * @brief close
                 *              关闭一个sqlite数据库, 释放资源
                 * @return
                 *              关闭是否成功, 成功返回为true,否则返回为false
                 */
                bool close();

                //<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //simple sqlite wrapper

                /**
                 * @brief prepare
                 *             准备函数,sqlite在每次excecute都需要调用该函数
                 *             批量操作之前准备sql接口，可能带占位符
                 *
                 *             该函数将SQL文本转换为prepared_statement对象，并在函数执行后返回该对象的指针. 事实上,该函数并不会评估参数指定SQL语句
                 * , 它仅仅是将SQL文本初始化为待执行的状态.
                 *
                 * @param sqlStr
                 *              需要excecute的sql语句
                 * @return
                 *              是否成功
                 */
                bool prepare(const std::string& sqlStr);

                /**
                 * @brief step
                 *           执行一次sqlite3_step操作, 并sqliteDB中获取到相应的参数或更新相应状态
                 * @return
                 *            如果已经执行完毕, 即sqlite3_step返回SQLITE_DONE,返回true, 否则返回false
                 */
                bool step();

                /**
                 * @brief reset
                 *            执行一次sqlite3_reset, 使得后续重复使用m_pstatement
                 * @return
                 *            如果执行成功,返回true, 否则返回false
                 */
                bool reset();

                /**
                 * @brief getColumnCnt
                 *              获取列数量
                 * @return
                 */
                int columnCnt();
                /**
                 * @brief columnName
                 *             获取列的名称
                 * @param index
                 *              列索引号
                 * @return
                 */
                const char* columnName(int index);
                /**
                 * @brief getColumnValue
                 *              获取列的Value
                 * @param index
                 *              列索引号
                 * @return
                 *              返回对应的sqliteValue的值
                 */
                sqliteValue columnValue( int index);

                //<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //execute functions

                //>>>-------------------------------------------------------------------------------------------------------------------------------------
                //1. normal exceute

                /**
                 *         excecute 接口统一了SQL的执行，内部调用sqlite3_prepare_v2、sqlite3_bind_xxx、sqlite3_step
                 * 和sqlite3_reset接口、其中sqlite3_bind_xxx绑定参数的泛化比较关键，因为sqlite绑定的参数需要根据
                 * 参数的类型来调用对应绑定的接口。
                 *         SQL语句中参数个数和类型都是不确定的，这里需要通过可变参数模板来解决变参的问题。另外，不同参数类型
                 * 选择不同的绑定函数，通过std::enable_if来解决
                 */

                /**
                 * @brief execute
                 *             执行不带参数的Sql语句，不带占位符. 执行sql，不带返回结果, 如insert,update,delete等
                 * @param sqlStr
                 *              需要excecute的sql语句
                 * @return
                 *              是否成功
                 */
                bool execute(const std::string& sqlStr);
                /**
                 * @brief execute
                 *             执行带参数的Sql语句， 带占位符. 执行sql，不带返回结果如插入一条记录
                 * @param sqlStr
                 *             需要excecute的sql语句
                 * @param args
                 *             参数列表
                 *
                 *             SQL语句中参数个数和类型都是不确定的，这里需要通过可变参数模板来解决变参的问题
                 * @return
                 *              是否成功
                 */
                template<typename... Args>
                bool execute(const std::string& sqlStr,Args &&...args);

                /**
                 * @brief executeWithParms
                 *             批量操作接口，必须先调用prepare接口
                 * @param args
                 *              参数列表
                 * @return
                 *               是否成功
                 *
                 * 注意:
                 *         1.该函数用于评估prepare函数返回的m_pstatement对象，在执行完该函数之后，m_pstatement对象的内部指针将指向其返回的结果集的第一行。
                 * 如果打算进一步迭代其后的数据行，就需要不断的调用该函数，直到所有的数据行都遍历完毕。然而对于INSERT、UPDATE和DELETE等DML语句，
                 * 该函数执行一次即可完成。
                 *         2.该函数使用了可变参数模板, 统一了SQL的执行，其中sqlite3_bind_xxx 绑定参数泛化比较关键
                 */
                template<typename... Args>
                bool executeWithParms(Args &&...args);

                /**
                 * ExceuteScalar 接口用于返回一个值，比如简单的汇聚函数,如select count(*).select max(*)等，
                 * 还可以返回某个值，比如获取某个人的年龄或者姓名，因此，这个executeScalar返回的是多种不同的类型，
                 * 为了统一接口，这里将Variant作为具体值的返回类型，在获取返回值后再根据模板参数类型将真实值从Varient
                 * 中取出
                 */

                /**
                 * @brief executeScalar
                 *             执行带参数的Sql语句,并返回sqlite_int64类型,执行简单的汇聚函数，如select count(*), select max(*)等
                 *  @param sqlStr
                 *             需要excecute的sql语句
                 *  @param args
                 *             参数列表
                 *
                 *             SQL语句中参数个数和类型都是不确定的，这里需要通过可变参数模板来解决变参的问题
                 * @return
                 *              R类型返回值
                 */
                template< typename R = sqlite_int64,typename... Args>
                R executeScalar(const std::string& sqlStr,Args&&... args);

                //>>>-------------------------------------------------------------------------------------------------------------------------------------
                //2.json (insert & query)

                /**
                 * @brief queryToJson
                 *             执行一个查询语句, 把数据导入到Json对象中
                 * @param querySqlStr
                 *             查询语句
                 * @return
                 *             json字符串
                 *
                 *  查询直接将结果放在json对象中,这样做有3个好处
                 * 1.避免了业务实体和物理表之间的耦合, 因为底层的物理表可能要会有变动,如果底层变了,上面的业务实体也要跟着变,如果
                 *    是json对象就不会有这个问题,因为json本身就是一个自描述的结构体,
                 * 2.避免了定义大量的业务实体,因为json对象就代表了业务实体,应用层只要关系如何解析json就可以了
                 * 3.方便与其它系统交互,甚至直接通过网络传输,因为json是一个标准,各个语言对json支持的很好
                 *
                 *        查询接口的实现思路是，循环调用sqlite3_step将每一行的数据取出来，然后解析每一行中的每一列，将其
                 * 组成json的键值对，最终创建一个JsonObject对象的集合
                 */
                std::string queryToJson(const std::string& querySqlStr);

                /**
                 * @brief insertJsonToSqlite
                 *             插入Json数据对象到Sqlite
                 * @param insertSqlStr
                 *              插入语句
                 * @param json
                 *              json字符串
                 * @return
                 *              是否成功
                 *
                 * 注意:
                 *   json接口主要流程如下：
                 *      1.首先要解析json字符串
                 *      2.然后再遍历json对象列表，将列表中的对象解析出来
                 *      3.然后解析出json对象的值来
                 *      4.根据值的类型调用sqlite3_bind_xxx函数将该类型对应的值绑定起来
                 *      5.最后调用step执行SQL语句
                 *
                 * 这里的Josn不能有嵌套类型了, 即每一列都对应了基础类型(Number/String/Null)
                 */
                bool insertJsonToSqlite(const std::string& insertSqlStr, const char* jsonStr);
                /**
                 * 这个重载函数和上面类似, 差别只不过是直接输入Json对象
                 */
                bool insertJsonToSqlite(const rapidjson::Value& val);

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //3.tuple (insert)

                /**
                 * @brief insertTupleToSqlite
                 *             插入Tuple数据对象到Sqlite
                 * @param sqlStr
                 *             插入语句
                 * @param tuple
                 *             待插入的tuple对象
                 * @return
                 *            是否成功
                 *
                 * 注意:
                 *         tuple接口主要流程如下：
                 *         1.将Tuple转换为可变参数
                 *         2.将转换后的参数通过enable_if重载bindValueToSqlite将tuple的每个元素绑定起来
                 */
                template<typename Tuple>
                bool insertTupleToSqlite(const std::string& sqlStr, Tuple&& tuple);

                template<int... indexes,typename Tuple>//用到了in的类型便于参数展开, 但是没有直接用到in, 所以这里会发生一个警告
                bool insertTupleToSqlite( indexTuple< indexes... >&& in,Tuple&& tuple);

                //<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //transaction functions

                /*数据库事务(Database Transaction) ，是指作为单个逻辑工作单元执行的一系列操作，要么完全地执行，要么完全地不执行。
                事务处理可以确保除非事务性单元内的所有操作都成功完成，否则不会永久更新面向数据的资源。通过将一组相关操作组
                合为一个要么全部成功要么全部失败的单元，可以简化错误恢复并使应用程序更加可靠。一个逻辑工作单元要成为事务，
                必须满足所谓的ACID（原子性、一致性、隔离性和持久性）属性。事务是数据库运行中的逻辑工作单位，由DBMS中的事
                务管理子系统负责事务的处理。*/

                /**
                 * @brief begin
                 *             开始执行一个事务
                 * @return
                 *             是否成功
                 */
                bool begin();
                /**
                 * @brief rollBack
                 *             回滚事务, 在SQL执行失败的时候执行
                 * @return
                 *             是否成功
                 */
                bool rollBack();
                /**
                 * @brief commit
                 *          提交事务
                 * @return
                 *          是否成功
                 */
                bool commit();

            private:

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //member variant

                const std::string m_dbFilePath;//sqlite文件路径

                /**
                 *sqlite的核心对象有sqlite3和sqlite3_stmt对象:
                 *       sqlite3对象在创建或者打开数据库时创建
                 *       sqlite3_stmt用来保存sqlite语句,以便在后面执行
                 */
                sqlite3* m_pdbHandle{nullptr};//数据库操作句柄
                sqlite3_stmt* m_pstatement{nullptr};//数据路状态句柄, 已经把sql语句解析了的、用sqlite自己标记记录的内部数据结构。

                int m_latestResultCode {-1};//最近一次sqlite执行的返回码
                bool m_isdbOpened{false};//db是否打开

                rapidjson::StringBuffer m_jsonBuf;//json字符串的bug
                JsonBuilder m_jsonBuilder;

                //<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //execute functions

                //通过json串写到数据库中
                bool insertJsonTransaction(const rapidjson::Document& doc);

                //<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                //data interaction

                //>>>-------------------------------------------------------------------------------------------------------------------------------------
                //1.interaction of  build-in type of c++ and sqlite type

                /**
                 * @brief bindValueToSqlite
                 *             绑定参数到Sqlite
                 * @param statement
                 *              sqlite状态指针
                 * @param current
                 *              可变参数展开后当前参数所在的索引
                 * @param first
                 *              当前参数列表中第一个参数
                 * @param args
                 *              参数列表
                 * @return
                 *              是否成功
                 *
                 * 注意:
                 *          实现思路是：先展开参数包，在展开参数的时候，通过std::enable_if根据参数的类型
                 * 来选择合适的sqlite3_bind函数
                 */
                template <typename T,typename... Args>
                int bindArgsToSqlite(int current,T&&first, Args&&... args);
                int bindArgsToSqlite(int current){return SQLITE_OK;}//用于参数展开递归的终止函数, 这里因为current没有用到,会有个警告

                /**
                 *以下的enable_if重载模板函数都是为了适应不同的参数类型, 函数内部是根据T类型的不同调用了不同的
                 * sqlite3_bind_XXX函数
                 */

                template <typename T>
                typename std::enable_if<std::is_floating_point<T>::value>::type//double or float
                bindValueToSqlite(int current,T t);

                template <typename T>
                typename std::enable_if<std::is_same<T,int64_t>::value || std::is_same<T,uint64_t>::value>::type//int64 or uint64
                bindValueToSqlite( int current,T t);

                template <typename T>
                typename std::enable_if<std::is_same<T,int>::value || std::is_same<T,uint>::value>::type//int or uint
                bindValueToSqlite(int current,T t);

                template <typename T>
                typename std::enable_if<std::is_same<std::string, T>::value, int>::type
                bindValueToSqlite(int current, const T& t);

                template <typename T>
                typename std::enable_if<std::is_same<char*, T>::value || std::is_same<const char*,T>::value>::type
                bindValueToSqlite(int current,T t);//char* or const char*

                template <typename T>
                typename std::enable_if<std::is_same<Blob,T>::value>::type
                bindValueToSqlite( int current,const T& t);//Blob

                template <typename T>
                typename std::enable_if<std::is_same<std::nullptr_t,T>::value>::type
                bindValueToSqlite(int current,const T& t);//nullptr

                /**
                 *如果在命令执行失败的情况下根据不同的类型返回不同类型的错误值
                 */
                template< typename T>
                typename std::enable_if<std::is_arithmetic<T>::value,T>::type
                getErrorVal();

                template< typename T>
                typename std::enable_if<!std::is_arithmetic<T>::value && !std::is_same<T,Blob>::value,T>::type
                getErrorVal();

                template< typename T>
                typename std::enable_if<std::is_same<T,Blob>::value,T>::type
                getErrorVal();

                //>>>-------------------------------------------------------------------------------------------------------------------------------------
                //2.interaction of  json and sqlite type

                /**
                 * @brief buildSqliteToJsonArray
                 *          绑定数据记录到Json的Array类型, 通常是绑定一张表
                 */
                void bindToJsonArray();

                /**
                 * @brief bindToJsonObject
                 *              绑定数据记录到一个Json对象, 通常是一条记录
                 * @param colCount
                 *              每条记录的列数
                 */
                void bindToJsonObject(int colCount);

                /**
                  * @brief buildToJsonValue
                  *             绑定数据到一个Json的Value,通常是一条记录的某一列
                  * @param index
                  *             列索引
                  */
                void bindToJsonValue(int index);

                /**
                  * @brief bindJsonValueToSqlite
                  *             绑定Value到Sqlite
                  * @param val
                  *             Json的value
                  * @param index
                  *             value所在的列索引
                  */
                 void bindJsonValueToSqlite(const rapidjson::Value& val,int index);
                 /**
                 * 是bindJsonValueToSqlite函数的子集, 绑定的Value是Number类型
                 */
                void bindJsonNumberToSqlite(const rapidjson::Value& val,int index);

            };//End of namespace Sqlite
        }//End of namespace DB
    }//End of namespace SSDK

    //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //template functions out of class

    template< typename T>
    typename std::enable_if<std::is_arithmetic<T>::value,T>::type
    SSDK::DB::SqliteDB::getErrorVal()
    {
        return T(-9999);
    }

    template< typename T>
    typename std::enable_if<!std::is_arithmetic<T>::value && !std::is_same<T,SSDK::DB::Blob>::value,T>::type
    SSDK::DB::SqliteDB::getErrorVal()
    {
        return "";
    }

    template< typename T>
    typename std::enable_if<std::is_same<T,SSDK::DB::Blob>::value,T>::type
    SSDK::DB::SqliteDB::getErrorVal()
    {
        return {nullptr};
    }

    template<typename... Args>
    bool SSDK::DB::SqliteDB::executeWithParms(Args &&...args)
    {
        if(SQLITE_OK != bindArgsToSqlite(1,std::forward<Args>(args)...))
        {
            return false;
        }

        this->m_latestResultCode = sqlite3_step(this->m_pstatement);

        sqlite3_reset(this->m_pstatement);
        return (this->m_latestResultCode == SQLITE_DONE);
    }

    template<typename... Args>
    bool SSDK::DB::SqliteDB::execute(const std::string& sqlStr,Args &&...args)
    {
        if(!this->prepare(sqlStr))
        {
            return false;
        }

        return executeWithParms(std::forward<Args>(args)...);
    }

    template< typename R,typename... Args>
    R SSDK::DB::SqliteDB::executeScalar(const std::string& sqlStr,Args&&... args)
    {
        if(!this->prepare(sqlStr))
        {
            return getErrorVal<R>();
        }

        //绑定sql脚本中参数
        if(SQLITE_OK != bindArgsToSqlite(1,std::forward<Args>(args)...))
        {
            return getErrorVal<R>();
        }

        this->m_latestResultCode = sqlite3_step(this->m_pstatement);

        if(this->m_latestResultCode != SQLITE_ROW)
        {
            return getErrorVal<R>();
        }

        auto val = columnValue(0);
        auto res = boost::get<R>(val);
        sqlite3_reset(this->m_pstatement);
        return res;
    }

    template<typename Tuple>
    bool SSDK::DB::SqliteDB::insertTupleToSqlite(const std::string& sqlStr, Tuple&& t)
    {
        if(!prepare(sqlStr))
        {
            return false;
        }

        return insertTupleToSqlite(
                    typename makeIndexes<std::tuple_size<Tuple>::value>::type(),
                    std::forward<Tuple>(t));
    }

    template<int... indexes,typename Tuple>//用到了in的类型便于参数展开, 但是没有直接用到in, 所以这里会发生一个警告
    bool SSDK::DB::SqliteDB::insertTupleToSqlite(SSDK::DB::SqliteDB::indexTuple< indexes... >&& in, Tuple&& t)
    {
       if(SQLITE_OK != bindArgsToSqlite(1,std::get<indexes>(std::forward<Tuple>(t))...))
       {
           return false;
       }

       this->m_latestResultCode = sqlite3_step(this->m_pstatement);
       sqlite3_reset(this->m_pstatement);
       return this->m_latestResultCode == SQLITE_DONE;
    }

    template <typename T,typename... Args>
    int SSDK::DB::SqliteDB::bindArgsToSqlite(int current,T&&first, Args&&... args)
    {
        bindValueToSqlite(current,first);
        if(SQLITE_OK == this->m_latestResultCode)
        {
            bindArgsToSqlite(current+1,std::forward<Args>(args)...);
        }

        return this->m_latestResultCode;
    }

    template <typename T>
    typename std::enable_if<std::is_floating_point<T>::value>::type//double or float
    SSDK::DB::SqliteDB::bindValueToSqlite( int current,T t)
    {
        this->m_latestResultCode = sqlite3_bind_double(this->m_pstatement, current, std::forward<T>(t));
    }

    template <typename T>
    typename std::enable_if<std::is_same<T,int64_t>::value || std::is_same<T,uint64_t>::value>::type//int64 or uint64
    SSDK::DB::SqliteDB::bindValueToSqlite(int current,T t)
    {
        this->m_latestResultCode = sqlite3_bind_int64(this->m_pstatement, current, std::forward<T>(t));
    }

    template <typename T>
    typename std::enable_if<std::is_same<T,int>::value || std::is_same<T,uint>::value>::type//int or uint
    SSDK::DB::SqliteDB::bindValueToSqlite(int current,T t)
    {
        this->m_latestResultCode = sqlite3_bind_int(this->m_pstatement, current, std::forward<T>(t));
    }

    template <typename T>
    typename std::enable_if<std::is_same<SSDK::DB::Blob,T>::value>::type
    SSDK::DB::SqliteDB::bindValueToSqlite(int current,const T& t)//Blob
    {
        this->m_latestResultCode = sqlite3_bind_blob(
                    this->m_pstatement,
                    current,
                    t.buf(),
                    t.size(),
                    SQLITE_TRANSIENT);
    }

    template <typename T>
    typename std::enable_if<std::is_same<std::string, T>::value, int>::type
    SSDK::DB::SqliteDB::bindValueToSqlite(int current, const T& t)
    {
            return sqlite3_bind_text(this->m_pstatement, current, t.data(), t.length(), SQLITE_TRANSIENT);
        }

    template <typename T>
    typename std::enable_if<std::is_same<char*, T>::value || std::is_same<const char*,T>::value>::type
    SSDK::DB::SqliteDB::bindValueToSqlite( int current,  T t)//char* or const char*
    {
        this->m_latestResultCode = sqlite3_bind_text(
                    this->m_pstatement,
                    current,
                    t,
                    strlen(t),
                    SQLITE_TRANSIENT);
    }

    template <typename T>
    typename std::enable_if<std::is_same<std::nullptr_t,T>::value>::type
    SSDK::DB::SqliteDB::bindValueToSqlite( int current,const T& t)//nullptr
    {
        this->m_latestResultCode = sqlite3_bind_null(
                    this->m_pstatement,
                    current);
    }


    //<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


#endif // SQLITEDB_H
