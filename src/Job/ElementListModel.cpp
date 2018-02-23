#include "ElementListModel.hpp"

using namespace SSDK;

ElementListModel::ElementListModel(QObject *parent):
    QAbstractListModel(parent),
    m_pElement(new Element())
{
    try
    {

    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("构造函数出错")
}

ElementListModel::~ElementListModel()
{
    try
    {
        delete this->m_pElement;
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("析构函数出错")
}

void ElementListModel::save()
{
    try
    {
        this->m_pElement->save();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("保存数据到数据库文件出错")
}

int ElementListModel::rowCount(const QModelIndex &parent) const
{
    try
    {
        Q_UNUSED(parent);
        return m_pElement->pShapes().size();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("获取行数出错")
}

QVariant ElementListModel::data(const QModelIndex &index, int role) const
{
    try
    {
        Shape *pElement = m_pElement->pShapes()[index.row()];
        return pElement->at(role - Qt::UserRole);
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("获取数据出错")
}

QHash<int, QByteArray> ElementListModel::roleNames() const
{
    return this->m_pElement->m_roleNames;
}

QString ElementListModel::source() const
{
    try
    {
        return m_pElement->jobPath();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("source get函数出错")
}

void ElementListModel::setSource(const QString &filePath)
{
    try
    {
        m_pElement->setJobPath(filePath);
        reload();
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("source set函数出错")
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
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("重新加载函数出错")
}

void ElementListModel::remove(int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    delete m_pElement->pShapes().takeAt(index);
    endRemoveRows();
}

QVariant ElementListModel::elementData(int index, int attr)
{
    try
    {
        if(index <= this->m_pElement->pShapes().size() -1 )
        {
            return this->m_pElement->pShapes()[index]->at(attr);
        }
    }
    CATCH_AND_RETHROW_EXCEPTION_WITH_OBJ("获取元素数据出错")
}
