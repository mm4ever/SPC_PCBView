#include "Element.hpp"

using namespace std;
using namespace SSDK;
using namespace SSDK::DB;

Element::Element()
{
    int role = Qt::UserRole;

    m_roleNames.insert(role++, "shape");
    m_roleNames.insert(role++, "centralX");
    m_roleNames.insert(role++, "centralY");
    m_roleNames.insert(role++, "cwidth");
    m_roleNames.insert(role++, "cheight");
}
Element::~Element()
{
    for(int i = 0; i < this->m_pShapes.size(); ++i)
    {
        delete this->m_pShapes[i];
    }
}

void Element::reset()
{
    for(int i = 0; i < this->m_pShapes.size(); ++i)
    {
        delete this->m_pShapes[i];
    }
}

void Element::read()
{
    SqliteDB sqlite( this->jobPath().toStdString() );
    try
    {
        auto isOpened = sqlite.isOpened();
        if( isOpened )
        {
            // 读取MeasuredObjs表
            string selectedString = "select * from MeasuredObjs";
            sqlite.prepare( selectedString );
            sqlite.begin();

            Shape *pShape = nullptr;
            Shape::ShapeType shapeType;
            string shape = "";
            while(true)
            {
                sqlite.step();
                if(sqlite.latestErrorCode() == SQLITE_DONE)
                {
                    break;
                }
                shape = boost::get<string>(sqlite.columnValue(0));
                transform(shape.begin(),shape.end(),shape.begin(),::toupper);
                if ( VAR_TO_STR(Shape::ShapeType::RECTANGLE) == shape )
                {
                    shapeType = Shape::ShapeType::RECTANGLE;
                }
                else if ( VAR_TO_STR(Shape::ShapeType::CIRCLE) == shape )
                {
                    shapeType = Shape::ShapeType::CIRCLE;
                }
                else
                {
                    THROW_EXCEPTION("读取被测对象形状失败！");
                }

                pShape = new Shape( shapeType,
                                    boost::get<int>(sqlite.columnValue(1)),
                                    boost::get<int>(sqlite.columnValue(2)),
                                    boost::get<int>(sqlite.columnValue(3)),
                                    boost::get<int>(sqlite.columnValue(4)) );

                this->pShapes().push_back(pShape);
            }

            sqlite.reset();
            sqlite.close();
        }
        else
        {
            THROW_EXCEPTION("程式加载失败！");
        }
    }
    catch( const CustomException& ex )
    {
        if( sqlite.isOpened() )
        {
            sqlite.reset();
            sqlite.close();
        }
        THROW_EXCEPTION( ex.what() );
    }
}

void Element::add(Shape::ShapeType shapeType, int centralX, int centralY, int width, int height)
{
    Shape *pShape = nullptr;
    pShape = new Shape(shapeType, centralX, centralY, width, height);
    this->pShapes().push_back(pShape);
}

void Element::remove(int centralX, int centralY)
{
    for (QVector<Shape *>::iterator iter = this->pShapes().begin();
         iter != this->pShapes().end(); ++iter)
    {

        if ( centralX ==  (*iter)->centralX() &&
             centralY == (*iter)->centralY() )
        {
            delete *iter;
            this->pShapes().erase(iter);
            break;
        }
    }
}

void Element::save()
{
    SqliteDB sqlite;
    try
    {
        // 创建数据库对象，打开传入路径的数据库
        sqlite.open( "../data/save" );

        if( !sqlite.isOpened() )
        {
            THROW_EXCEPTION("数据库打开失败！");
        }
        string sqlDrop = "DROP TABLE MeasuredObjs;";
        sqlite.execute( sqlDrop );

        string sqlCreate = "CREATE TABLE MeasuredObjs( "
                           "Shape TEXT, "
                           "CentralX INTEGER, "
                           "CentralY INTEGER, "
                           "Width INTEGER, "
                           "Height INTEGER); ";
        sqlite.execute( sqlCreate );

        string sqlInsert = "INSERT INTO MeasuredObjs( "
                           "Shape, CentralX, CentralY, Width, Height) "
                           "VALUES(?,?,?,?,?);";

        sqlite.prepare( sqlInsert );
        sqlite.begin();
        string shapeType = "";

        for (QVector<Shape *>::iterator iter = this->pShapes().begin();
             iter != this->pShapes().end(); ++iter)
        {
            // 判断生成的被测对象类型，然后设置相应的类型
            if (Shape::ShapeType::RECTANGLE == (*iter)->shapeType() )
            {
                shapeType = VAR_TO_STR(Shape::ShapeType::RECTANGLE);
            }
            else if (Shape::ShapeType::CIRCLE == (*iter)->shapeType() )
            {
                shapeType = VAR_TO_STR(Shape::ShapeType::CIRCLE);
            }
            else
            {
                THROW_EXCEPTION("被测对象形状错误！");
            }
            transform(shapeType.begin(),shapeType.end(),shapeType.begin(),::tolower);

            sqlite.execute( sqlInsert, shapeType,
                                       (*iter)->centralX(),
                                       (*iter)->centralY(),
                                       (*iter)->width(),
                                       (*iter)->height() );
        }
        sqlite.commit();

        sqlite.close();
    }
    catch( const CustomException& ex )
    {
        if( sqlite.isOpened() )
        {
            sqlite.reset();
            sqlite.close();
        }
        THROW_EXCEPTION( ex.what() );
    }
}


