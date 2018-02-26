#ifndef ELEMENTLISTMODEL_HPP
#define ELEMENTLISTMODEL_HPP

#include <QObject>
#include <QAbstractListModel>

#include "Element.hpp"

namespace App
{
    class ElementListModel: public QAbstractListModel
    {
        Q_OBJECT

        Q_PROPERTY(QString source READ source WRITE setSource)
    public:
        ElementListModel(QObject *parent = nullptr);
        virtual ~ElementListModel();

        Q_INVOKABLE void reload();
        Q_INVOKABLE void add(SSDK::Shape::ShapeType shapeType, int centralX, int centralY, int width, int height);
        Q_INVOKABLE void remove(int index);
        Q_INVOKABLE void save();
        Q_INVOKABLE QVariant elementData(int index,int attr);

        int rowCount(const QModelIndex &parent) const;
        QVariant data(const QModelIndex &index, int role) const;
        QHash<int, QByteArray> roleNames() const;

        QString source() const;
        void setSource(const QString& filePath);

    Q_SIGNALS:

    private:
        Job::Element* m_pElement { nullptr };
    };
}//End of namespace App

#endif // ELEMENTLISTMODEL_HPP
