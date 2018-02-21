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
    beginResetModel();

    m_pElement->reset();
    m_pElement->read();

    endResetModel();
}

void ElementListModel::remove(int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    delete m_pElement->pShapes().takeAt(index);
    endRemoveRows();
}
