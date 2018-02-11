#include "SqliteDb.hpp"

using namespace std;
using namespace rapidjson;
using namespace SSDK;
using namespace SSDK::DB;
//using namespace SSDK::Exception;

//>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//member variant

/**
 *excecuteScalar 执行Sql语句把结果放到sqlite3_statememnt对象中，这时需要根据当前的类型来调用对应
 * 的sqlite3_column_xxx 来取出真实的结果。这里通过表驱动法，将sqlite类型和对应的取值函数放到一个表中
 * 在外面可以根据类型调用对应的取值函数了
 */
std::unordered_map <int, std::function<SqliteDB::sqliteValue(sqlite3_stmt*,int)>> SqliteDB::m_valMap =
{
    { std::make_pair(SQLITE_INTEGER, [](sqlite3_stmt*stmt,int index){ return sqlite3_column_int(stmt,index); }) },
    { std::make_pair(SQLITE_FLOAT,   [](sqlite3_stmt*stmt,int index){ return sqlite3_column_double(stmt,index); }) },
    { std::make_pair(SQLITE_BLOB,    [](sqlite3_stmt*stmt,int index)
            {
                const char* pSrc = (const char*)sqlite3_column_blob(stmt,index);
                Blob blob(pSrc);
                 return blob;
             })
    },
    { std::make_pair(SQLITE_TEXT,    [](sqlite3_stmt*stmt,int index){ return string((const char*)sqlite3_column_text(stmt,index)); }) } ,
    { std::make_pair(SQLITE_NULL,    [](sqlite3_stmt*stmt,int index){ return nullptr; })},//当为NULL时, stmt和index都没有用到, 所以这里会产生一个警告
};

/**
 * 将sqlite中获取具体值写入到json串中
 */
std::unordered_map <int, std::function<void(sqlite3_stmt*,int,SqliteDB::JsonBuilder&)>> SqliteDB::m_jsonBuilderMap =
{
    { std::make_pair(SQLITE_INTEGER, [](sqlite3_stmt* stmt, int index, SqliteDB::JsonBuilder& builder){ builder.Int64(sqlite3_column_int64(stmt,index)); }) },
    { std::make_pair(SQLITE_FLOAT,   [](sqlite3_stmt* stmt, int index, SqliteDB::JsonBuilder& builder){ builder.Double(sqlite3_column_double(stmt,index)); }) },
    { std::make_pair(SQLITE_BLOB,    [](sqlite3_stmt* stmt, int index, SqliteDB::JsonBuilder& builder){ builder.String((const char*)sqlite3_column_blob(stmt,index)); }) },
    { std::make_pair(SQLITE_TEXT,    [](sqlite3_stmt* stmt, int index, SqliteDB::JsonBuilder& builder){ builder.String((const char*)sqlite3_column_text(stmt,index)); }) } ,
    { std::make_pair(SQLITE_NULL,    [](sqlite3_stmt* stmt, int index, SqliteDB::JsonBuilder& builder){ builder.Null(); })},//当为NULL时, stmt和index都没有用到, 所以这里会产生一个警告
};

std::string SqliteDB::m_beginStr = "begin";
std::string SqliteDB::m_commitStr = "commit";
std::string SqliteDB::m_rollbackStr = "rollback";

//<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//constructor & deconstructor

SqliteDB::SqliteDB():
    m_dbFilePath(""),
    m_jsonBuilder(this->m_jsonBuf)
{

}

SqliteDB::SqliteDB(const string &dbPath):
    m_dbFilePath(dbPath),
    m_pdbHandle(nullptr),
    m_pstatement(nullptr),
    m_jsonBuilder(this->m_jsonBuf)
{
    this->open(dbPath);
}

SqliteDB::~SqliteDB()
{
    this->close();
}

//<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//open & close functions

bool SqliteDB::open(const string &dbPath)
{
    //TBC 后续需要增加对路径是否存在的判断

    this->m_isdbOpened = false;

    this->m_latestResultCode = sqlite3_open(dbPath.data(),&this->m_pdbHandle);
    this->m_isdbOpened = (this->m_latestResultCode  == SQLITE_OK && nullptr != this->m_pdbHandle);

    return this->m_isdbOpened;
}

bool SqliteDB::close()
{
    if(nullptr == this->m_pdbHandle)
    {
        if( !this->m_isdbOpened)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    sqlite3_finalize(this->m_pstatement);

    //>>>--------------------------------------------------------------------------------
    //close db handle

    /**
     *在关闭连接数据库的时候，需要判断关闭所有的结果码，需要循环调用sqlite3_next_stmt释放所有的sqlite3_stmt
     *对象，最后关闭sqlite3对象
     */

    this->m_latestResultCode = sqlite3_close(this->m_pdbHandle);
    while( this->m_latestResultCode == SQLITE_BUSY)
    {
        this->m_latestResultCode = SQLITE_OK;
        auto stmt = sqlite3_next_stmt( this->m_pdbHandle ,nullptr);

        if(nullptr == stmt)
            break;

        this->m_latestResultCode =sqlite3_finalize(stmt);
        if(this->m_latestResultCode == SQLITE_OK)
        {
            this->m_latestResultCode = sqlite3_close(this->m_pdbHandle);
        }
    }

    //<<<--------------------------------------------------------------------------------

    this->m_pdbHandle = nullptr;
    this->m_pstatement = nullptr;
    return (this->m_latestResultCode  == SQLITE_OK);
}

//<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//simple sqlite wrapper

bool SqliteDB::prepare(const string &sqlStr)
{
    this->m_latestResultCode = sqlite3_prepare_v2(
                this->m_pdbHandle,
                sqlStr.data(),
                -1,
                &this->m_pstatement,
                nullptr);

    return (this->m_latestResultCode  == SQLITE_OK);
}

bool SqliteDB::step()
{
    this->m_latestResultCode = sqlite3_step(this->m_pstatement);
    return (this->m_latestResultCode  == SQLITE_DONE);
}

bool SqliteDB::reset()
{
     this->m_latestResultCode = sqlite3_reset(this->m_pstatement);
    return (this->m_latestResultCode  == SQLITE_OK);
}

const char *SqliteDB::columnName(int index)
{
    return  static_cast<const char*>(sqlite3_column_name(this->m_pstatement, index));
}

SqliteDB::sqliteValue SqliteDB::columnValue( int index)
{
    int type = sqlite3_column_type(this->m_pstatement,index);
    //根据列类型取值
    auto it = m_valMap.find(type);

    return it->second(this->m_pstatement,index);
}

int SqliteDB::columnCnt()
{
    return sqlite3_column_count(this->m_pstatement);
}

//<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//excecute functions

bool SqliteDB::execute(const string &sqlStr)
{
    this->m_latestResultCode = sqlite3_exec(
                this->m_pdbHandle,
                sqlStr.data(),
                nullptr,
                nullptr,
                nullptr);

    return (this->m_latestResultCode  == SQLITE_OK);
}

//<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//transaction function

bool SqliteDB::begin()
{
    return execute(this->m_beginStr);
}

bool SqliteDB::rollBack()
{
    return execute(this->m_rollbackStr);
}

bool SqliteDB::commit()
{
    return execute(this->m_commitStr);
}

//<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


//>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//json functions

std::string  SSDK::DB::SqliteDB::queryToJson(const std::string& querySql)
{
    if (!prepare(querySql))
        return nullptr;

    this->m_jsonBuf.Clear();

    bindToJsonArray();

    return m_jsonBuf.GetString();
}


/**
 * json接口的实现比tuple复杂一些：
 *      首先要解析json字符串
 *      然后再遍历json对象列表，将列表中的对象解析出来
 *      然后解析出json对象的值来
 *      根据值的类型调用sqlite3_bind_xxx函数将该类型对应的值绑定起来
 *      最后调用step执行SQL语句
 */

bool SqliteDB::insertJsonToSqlite(const std::string& sqlStr,const char* json)
{
    //解析json串
    Document doc;
    doc.Parse<0>(json);

    if(doc.HasParseError())
    {
        cout<<doc.GetParseError()<<endl;
        return false;
    }

    //解析SQL语句
    if(!prepare(sqlStr))
    {
        return false;
    }

    //启用事务写数据
    return insertJsonTransaction(doc);
}

bool SqliteDB::insertJsonToSqlite(const Value &val)
{
    int index = 0;
    for(Value::ConstMemberIterator iter = val.MemberBegin(); iter!=val.MemberEnd();++iter,++index)
    {
        auto& v = iter->value;
        bindJsonValueToSqlite( v, index+ 1);

        if(this->m_latestResultCode!=SQLITE_OK)
        {
            return false;
        }
    }

    this->m_latestResultCode = sqlite3_step(this->m_pstatement);
    sqlite3_reset(this->m_pstatement);
    return SQLITE_DONE == this->m_latestResultCode;
}

bool SqliteDB::insertJsonTransaction(const Document &doc)
{
    this->begin();

    //解析json对象
    for(size_t i = 0, size = doc.Size(); i < size; ++i)
    {
        if(!insertJsonToSqlite(doc[i]))
        {
            this->rollBack();
            break;
        }
    }

    if(this->m_latestResultCode != SQLITE_DONE)
    {
        return false;
    }

    this->commit();
    return true;
}

void SqliteDB::bindJsonValueToSqlite(const Value &val, int index)
{
    auto type = val.GetType();
    if(type == kNullType)
    {
        this->m_latestResultCode = sqlite3_bind_null(this->m_pstatement,index);
    }
    else if(type == kStringType)
    {
        this->m_latestResultCode = sqlite3_bind_text(
                    this->m_pstatement,
                    index,
                    val.GetString(),
                    -1,
                    SQLITE_STATIC);
    }
    else if(type == kNumberType)
    {
        bindJsonNumberToSqlite(val,index);
    }
    else
    {
//        THROW_EXCEPTION_WITH_OBJ("Can not find this type");
    }
}

void SqliteDB::bindJsonNumberToSqlite(const Value &val, int index)
{
    if(val.IsInt() || val.IsUint())
    {
        this->m_latestResultCode = sqlite3_bind_int(this->m_pstatement,index,val.GetInt());
    }
    else if(val.IsInt64() || val.IsUint64())
    {
        this->m_latestResultCode =  sqlite3_bind_int64(this->m_pstatement,index,val.GetInt64());
    }
    else
    {
        this->m_latestResultCode =  sqlite3_bind_double(this->m_pstatement,index,val.GetDouble());
    }
}


//<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



//>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//data interaction

void SqliteDB::bindToJsonArray()
{
    int colCount = sqlite3_column_count(this->m_pstatement);

    m_jsonBuilder.StartArray();//代表了数据库对象的Json都是Array对象
    while (true)
    {
        this->m_latestResultCode = sqlite3_step(this->m_pstatement);
        bindToJsonObject(colCount);

        if (this->m_latestResultCode == SQLITE_DONE)
        {

            break;
        }
    }

    m_jsonBuilder.EndArray();
    sqlite3_reset(this->m_pstatement);
}

void SqliteDB::bindToJsonObject(int colCount)
{
    m_jsonBuilder.StartObject();

    for (int i = 0; i < colCount; ++i)
    {
        char* name = (char*) sqlite3_column_name(this->m_pstatement, i);
//        SSDK::StringOP::toUpper(name);
//        SSDK::toUpper(name);

        m_jsonBuilder.String(name);  //写字段名
        bindToJsonValue(i);
    }

    m_jsonBuilder.EndObject();
}

void SqliteDB::bindToJsonValue(int index)
{
    int type = sqlite3_column_type(this->m_pstatement,index);
    auto it = this->m_jsonBuilderMap.find(type);
    if(it == this->m_jsonBuilderMap.end())
    {
//        THROW_EXCEPTION_WITH_OBJ("Can not find this type");
    }

    it->second(this->m_pstatement,index,this->m_jsonBuilder);
}

//<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


