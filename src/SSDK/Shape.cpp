#include "Shape.hpp"

using namespace SSDK;

Shape::Shape()
{
    try
    {

    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("Constructor error!");
}

Shape::Shape( ShapeType shapeType,
              int centralX,
              int centralY,
              int width,
              int height)
{
    this->m_shapeType = shapeType;
    this->m_centralX = centralX;
    this->m_centralY = centralY;
    this->m_width = width;
    this->m_height = height;
}

Shape::~Shape()
{
    try
    {

    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("Destructor error!");
}

QString Shape::at(int index)
{
    try
    {
        switch (index)
        {
        case 0:
            return QString::number(this->m_centralX,10);
            break;

        case 1:
            return QString::number(this->m_centralY,10);
            break;

        case 2:
            return QString::number(this->m_width,10);
            break;

        case 3:
            return QString::number(this->m_height,10);
            break;

        case 4:
        {
            if(ShapeType::CIRCLE == this->m_shapeType)
            {
                return QString("circle");
            }
            else
            {
                return QString("rectangle");
            }
            break;
        }

        default:
            break;
        }
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("读取数据出错")
}

//<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

