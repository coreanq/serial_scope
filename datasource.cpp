/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Charts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "datasource.h"
#include <QtCharts/QXYSeries>
#include <QtCharts/QAreaSeries>
#include <QtQuick/QQuickView>
#include <QtQuick/QQuickItem>
#include <QtCore/QDebug>
#include <QtCore/QRandomGenerator>
#include <QtCore/QtMath>
#include <QSerialPortInfo>

QT_CHARTS_USE_NAMESPACE

Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QAbstractAxis *)



const int32_t maxSamplingCount = 1000000;
enum {
    STEP1,
    STEP2,
    STEP3,
    STEP8
};



DataSource::DataSource(QQuickView *appViewer, QObject *parent) :
    QObject(parent),
    m_appViewer(appViewer)
{
    qRegisterMetaType<QAbstractSeries*>();
    qRegisterMetaType<QAbstractAxis*>();


    m_serial = new QSerialPort(this);

    m_serial->setBaudRate(QSerialPort::Baud115200);
    m_serial->setDataBits(QSerialPort::Data8);
    m_serial->setParity(QSerialPort::NoParity);


    for( int i = 0; i < CHANNEL_COUNT; i ++ )
    {
        m_data[i].reserve(maxSamplingCount);
        m_points[i].reserve(maxSamplingCount);
        m_yOffsets[i] = 0;
    }
}

void DataSource::open(QString portName)
{
    m_serial->setPortName(portName);
    m_serial->setBaudRate(3000000);

    if (m_serial->open(QIODevice::ReadWrite)) {
        connect(m_serial, &QSerialPort::readyRead, this, &DataSource::readData);
        connect(m_serial, &QSerialPort::errorOccurred, this, &DataSource::onSerialPortError);
        emit sigSerialPortOpenSuccess();
    }
    else {
        printf("");
    }

}
void DataSource::close(QString portName)
{
    m_serial->setPortName(portName);
    m_serial->close();
    emit sigSerialPortError();

}

void DataSource::onSourceChanged(int sampleCount)
{
    m_screenXCount = sampleCount;
}

QStringList DataSource::availablePorts()
{
    QList<QSerialPortInfo> serialInfo = QSerialPortInfo::availablePorts();
    QStringList portList;

    for( QSerialPortInfo info : serialInfo )
    {
        portList << info.portName();
    }

    return portList;
}
void DataSource::onSerialPortError(QSerialPort::SerialPortError error)
{
    switch( error )
    {
    case QSerialPort::NoError:
        break;
     default:
        break;
    }
    emit sigSerialPortError();

}
void DataSource::readData()
{
    char oneByte = 0x00;
    static uint8_t state = 0;
    while(m_serial->bytesAvailable() )
    {
        m_serial->read((char*)&oneByte, 1);

        switch( state )
        {
        case STEP1:
            if( (uint8_t)oneByte == 0xaa )
            {
                state = STEP2;
            }
            else
            {
                state = STEP1;
            }
            break;
        case STEP2:
            if( (uint8_t)oneByte == 0xaa )
            {
                state = STEP3;
            }
            else
            {
                state = STEP1;
            }
            break;
        case STEP3:
            if( (uint8_t)oneByte == 0xaa )
            {
                state = STEP8;
            }
            else
            {
                state = STEP1;
            }
            break;
        case STEP8:
            if( (uint8_t)oneByte == 0xab )
            {
                if( m_serial->bytesAvailable() >= CHANNEL_COUNT * 4 )
                {
                    char buffer[CHANNEL_COUNT * 4] = {0,};
                    int32_t data[CHANNEL_COUNT] = {0,};
                    m_serial->read(buffer, 12 );
                    memcpy(&data[0], &buffer[0], sizeof(data));
                    memcpy(&data[1], &buffer[4], sizeof(data));
                    memcpy(&data[2], &buffer[8], sizeof(data));
                    memcpy(&data[3], &buffer[12], sizeof(data));

                    for (int i = 0; i < CHANNEL_COUNT; i ++ )
                    {
                        if( m_data[i].size() >= maxSamplingCount ) {
                            m_data[i].removeFirst();
                        }
                        m_data[i].append(data[i]);
                    }

                    state = STEP1;
                }
            }
            else
            {
                state = STEP1;
            }
            break;
        default:
            break;
        }
    }
}
void DataSource::update(QAbstractSeries *series, int lineIndex)
{
    if (series) {
        QXYSeries *xySeries = static_cast<QXYSeries *>(series);
        // Use replace instead of clear + append, it's optimized for performance
        m_points[lineIndex].clear();
        int32_t dataTotalCount = m_data[lineIndex].size();

        if( m_data[lineIndex].size() >= m_screenXCount ) {
            for( int i = 0 ; i < m_screenXCount; i ++ ) {
                QPoint pt;
                pt.setX(i);
                pt.setY(m_data[lineIndex][  dataTotalCount - m_screenXCount +  i] + m_yOffsets[lineIndex] );
                m_points[lineIndex].append(pt);
            }
        }
        else {
            for( int i = 0 ; i < m_screenXCount ; i ++ ) {
                QPoint pt;
                pt.setX(i);
                if( i >= m_screenXCount - dataTotalCount)
                {
                    pt.setY(m_data[lineIndex][i - (m_screenXCount - dataTotalCount )  + m_yOffsets[lineIndex]] );
                }
                else
                {
                    pt.setY(0);
                }
                m_points[lineIndex].append(pt);
            }
        }
        xySeries->replace(m_points[lineIndex]);
    }
}
void DataSource::yOffsetChanged(QString offset, int lineIndex)
{
    m_yOffsets[lineIndex] = offset.toInt();
}
