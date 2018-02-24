#ifndef ELEMENT_HPP
#define ELEMENT_HPP

#include <QDateTime>
#include <QVector>
#include <QHash>

#include "DB/SqliteDb.hpp"

#include "Shape.hpp"
#include "FormatConvertor.hpp"

namespace Job
{
    class Element
    {
    public:
        Element();
        virtual ~Element();

        void reset();

        void read();

        void add(SSDK::Shape::ShapeType shapeType, int centralX, int centralY, int width, int height);

        void save();

        QVector<SSDK::Shape *>& pShapes() { return this->m_pShapes; }

        // 哈希表，实现通过字符串取值
        QHash<int, QByteArray> m_roleNames;

        QString jobPath() const { return this->m_jobPath; }
        void setJobPath(const QString &jobPath) { this->m_jobPath = jobPath; }

    private:
        QString m_jobPath;
        QVector<SSDK::Shape *> m_pShapes;

    };
}//End of namespace Job

#endif // ELEMENT_HPP
