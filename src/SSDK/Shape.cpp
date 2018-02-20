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

}

//<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

