#include "Circle.hpp"

using namespace SSDK;

Circle::Circle():
    Shape(ShapeType::CIRCLE),
    m_startPosX(0),
    m_startPosY(0),
    m_radius(0)
{
    try
    {

    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("Constructor error!")
}

Circle::Circle(double xPos, double yPos, double radius):
    Shape(ShapeType::CIRCLE),
    m_startPosX(xPos),
    m_startPosY(yPos),
    m_radius(radius)
{
    try
    {

    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("Constructor error!")
}

Circle::~Circle()
{
    try
    {

    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("Destructor error!")
}

