#include "ElementListModel.hpp"

using namespace SSDK;

ElementListModel::ElementListModel(QObject *parent):
    QAbstractListModel(parent),
    m_pElement(new Element())
{

}

ElementListModel::~ElementListModel()
{
    delete this->m_pElement;
}

int ElementListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_pElement->pShapes().size();
}

QVariant ElementListModel::data(const QModelIndex &index, int role) const
{
    Shape *pElement = m_pElement->pShapes()[index.row()];
    return pElement->at(role - Qt::UserRole);
}

QHash<int, QByteArray> ElementListModel::roleNames() const
{
    return this->m_pElement->m_roleNames;
}

QString ElementListModel::source() const
{
    return m_pElement->jobPath();
}

void ElementListModel::setSource(const QString &filePath)
{
    m_pElement->setJobPath(filePath);
    reload();
}

void ElementListModel::reload()
{
    try
    {
        beginResetModel();

        m_pElement->reset();
        m_pElement->read();

        endResetModel();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("加载数据有误！");
}

void ElementListModel::add(Shape::ShapeType shapeType, int centralX, int centralY, int width, int height)
{
    try
    {
        beginInsertRows(QModelIndex(),this->m_pElement->pShapes().size(),this->m_pElement->pShapes().size());
        m_pElement->add(shapeType,centralX,centralY,width,height);
        endInsertRows();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("添加数据有误！");
}

void ElementListModel::remove(int index)
{
    try
    {
        beginRemoveRows(QModelIndex(), index, index);
        delete m_pElement->pShapes().takeAt(index);
        endRemoveRows();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("删除数据有误！");
}

void ElementListModel::save()
{
    try
    {
        m_pElement->save();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("保存数据有误！");
}

QVariant ElementListModel::elementData(int index, int attr)
{
    return this->m_pElement->pShapes()[index]->at(attr);
}
