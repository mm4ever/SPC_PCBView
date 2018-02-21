#ifndef SHAPE_HPP
#define SHAPE_HPP

#include <QVariant>
#include <QString>

#include "CustomException.hpp"


namespace SSDK
{
    /**
     *  @brief 表示形状的类，存有形状的类型、坐标位置、大小
     *
     *  @author plato
     *  @version 1.00 2018-02-10 plato
     *                note:create it
     */
    class Shape
    {
    public:

        enum class ShapeType
        {
            RECTANGLE,  // 矩形
            CIRCLE      // 圆形
        };

        //>>>----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //constructor & destructor

        Shape();

        Shape( ShapeType shapeType,
               int centralX,
               int centralY,
               int width,
               int height );

        virtual ~Shape();

        //<<<----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        ShapeType shapeType() { return this->m_shapeType; }

        int centralX() { return this->m_centralX; }
        void setCentralX(int centralX) { this->m_centralX = centralX; }

        int centralY() { return this->m_centralY; }
        void setCentralY(int centralY) { this->m_centralY = centralY; }

        int width() { return this->m_width; }
        void setWidth(int width) { this->m_width = width; }

        int height() { return this->m_height; }
        void setHeight(int height) { this->m_height = height; }

        QString at(int index);

    private:
        ShapeType m_shapeType;  // 形状的类型
        int m_centralX{0};      // 形状中心点坐标X
        int m_centralY{0};      // 形状中心点坐标Y
        int m_width{0};         // 形状的宽
        int m_height{0};        // 形状的高
    };

}//End of namespace SSDK

#endif // SHAPE_HPP
