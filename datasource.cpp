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
#include <QTimer>
#include <QDateTime>

QT_CHARTS_USE_NAMESPACE

Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QAbstractAxis *)



const int32_t maxSamplingCount = 1000000;
enum {
    STEP1,
    STEP2,
    STEP3,
    STEP4,
    PROCESSING,
};


QSerialPort* m_serial  = new QSerialPort();

QString time_format = "yyyy-MM-dd_HHmmss";

DataSource::DataSource(QObject *parent) :
    QObject(parent)
{
    qRegisterMetaType<QAbstractSeries*>();
    qRegisterMetaType<QAbstractAxis*>();

    m_serial->setBaudRate(3000000);
    m_serial->setDataBits(QSerialPort::Data8);
    m_serial->setParity(QSerialPort::NoParity);

    connect(m_serial, &QSerialPort::readyRead, this, &DataSource::readData);
//    connect(m_serial, &QSerialPort::errorOccurred, this, &DataSource::onSerialPortError);

    for( int i = 0; i < CHANNEL_COUNT; i ++ )
    {
        m_data[i].reserve(maxSamplingCount);
        m_points[i].reserve(maxSamplingCount);
        m_yOffsets[i] = 0;
    }

    // 100us 30 bytes data -> 300kbytes /s
    m_serialBuffer.reserve(1000000);
    m_timerBufferProcessing.setInterval(100);

    connect(&m_timerBufferProcessing, &QTimer::timeout, this, &DataSource::dataProcessing );

}

void DataSource::open(QString portName)
{
    m_serial->setPortName(portName);
    if (m_serial->open(QIODevice::ReadWrite)) {
        emit sigSerialPortOpenSuccess();
        m_timerBufferProcessing.start();

        QDateTime date = QDateTime::currentDateTime();
        QString date_string = date.toString(time_format);
        QString file_name(QString("s300_data_%1.csv").arg(date_string));
        m_file.setFileName(file_name);
        bool isOpen = m_file.open(QFile::WriteOnly|QFile::Append|QFile::Text); // 쓰기 전용, 텍스트, 이어쓰기

    }
    else {
        m_file.close();
        printf("");
    }

}
void DataSource::close(QString portName)
{
    m_serial->setPortName(portName);
    m_serial->close();
    emit sigSerialPortError();
    m_timerBufferProcessing.stop();
    m_file.close();

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

void DataSource::dataProcessing()
{
    uint8_t oneByte = 0x00;
    static uint8_t state = 0;
    static uint8_t data_count = 0;
    static char buffer[CHANNEL_COUNT * 4 + 1] = {0,};


    uint32_t ulLoopCnt = m_serialBuffer.size();


    QTextStream saveFile(&m_file);

    for( uint32_t ulCnt = 0; ulCnt < ulLoopCnt; ulCnt ++ )
    {
        oneByte = m_serialBuffer.at(ulCnt);
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
                state = STEP4;
            }
            else
            {
                state = STEP1;
            }
            break;
        case STEP4:
            if( (uint8_t)oneByte == 0xab )
            {
                state = PROCESSING;
            }
            else
            {
                state = STEP1;
            }
            break;
        case PROCESSING:

            buffer[data_count++] = (char)oneByte;

            if( data_count == CHANNEL_COUNT * 4 + 1)
            {
                state = STEP1;
                data_count = 0;

                float data[CHANNEL_COUNT] = {0,};
                memcpy(&data[0], &buffer[0], CHANNEL_COUNT * 4);

                uint8_t calculate_sum = 0xff;
                uint8_t sum = buffer[CHANNEL_COUNT * 4];

                for(uint8_t cnt= 0; cnt < CHANNEL_COUNT * 4; cnt ++ )
                {
                    calculate_sum += buffer[cnt];
                }

                if( sum != calculate_sum )
                {
                    qDebug() << data[0] << ", " << data[1] << ", " << data[2] << ", " << data[3] << ", " << data[4] << ", " << data[5];
                }
                else
                {
                    QDateTime date = QDateTime::currentDateTime();
                    QString date_string = date.toString("HHmmss.zzz");
                    saveFile << date_string << "," << data[0] << "," << data[1] << "," << data[2] << "," << data[3] << "," << data[4] << "," << data[5] << "\n";
                    for (int i = 0; i < CHANNEL_COUNT; i ++ )
                    {
                        m_data[i].append(data[i]);
                    }
                }

            }
            break;
        default:
            break;
        }
    }

    m_file.flush();

    if( m_file.size() > 100000000 )
    {
        m_file.close();
        QDateTime date = QDateTime::currentDateTime();
        QString date_string = date.toString(time_format);
        QString file_name(QString("s300_data_%1.csv").arg(date_string));
        m_file.setFileName(file_name);
        bool isOpen = m_file.open(QFile::WriteOnly|QFile::Append|QFile::Text); // 쓰기 전용, 텍스트, 이어쓰기
        if( isOpen == false )
        {
            qDebug() << "open fail";
        }
        else
        {
            qDebug() << "new file open";

        }
    }

    m_serialBuffer.clear();
}
void DataSource::readData()
{
    if( m_serial->bytesAvailable() )
    {
        m_serialBuffer.append( m_serial->readAll() );
    }

}
void DataSource::update(QAbstractSeries *series, int lineIndex)
{
    if (series) {
        QXYSeries *xySeries = static_cast<QXYSeries *>(series);
        // Use replace instead of clear + append, it's optimized for performance
        m_points[lineIndex].resize(m_screenXCount);
        m_points[lineIndex].fill( QPointF(0,0) );
        int32_t dataTotalCount = m_data[lineIndex].size();

        if( dataTotalCount > maxSamplingCount - 10000 )
        {
            auto start_iter = m_data[lineIndex].begin();
            auto end_iter = start_iter + 300000;

            m_data[lineIndex].erase( start_iter, end_iter);
            dataTotalCount = m_data[lineIndex].size();
//            qDebug() << lineIndex <<  m_data[lineIndex].size();
        }


        if( m_data[lineIndex].size() >= m_screenXCount ) {
            for( int i = 0 ; i < m_screenXCount; i ++ ) {
                QPointF pt;
                pt.setX(i);
                pt.setY( ( m_data[lineIndex][  dataTotalCount - m_screenXCount +  i] + m_yOffsets[lineIndex] )  * m_yScales[lineIndex] );
                m_points[lineIndex].replace(i, pt);
            }
        }
        else {
            for( int i = 0 ; i < m_screenXCount ; i ++ ) {
                QPointF pt;
                pt.setX(i);
                if( i >= m_screenXCount - dataTotalCount)
                {
                    pt.setY( ( m_data[lineIndex][i - (m_screenXCount - dataTotalCount )  + m_yOffsets[lineIndex]] )  * m_yScales[lineIndex] ) ;
                }
                else
                {
                    pt.setY(0);
                }
                m_points[lineIndex].replace(i, pt);
//                m_points[lineIndex].append(pt);
            }
        }
        xySeries->replace(m_points[lineIndex]);
    }
}
void DataSource::yOffsetChanged(QString offset, int lineIndex)
{
    m_yOffsets[lineIndex] = offset.toInt();
}

void DataSource::yScaleChanged(QString scale, int lineIndex)
{
    m_yScales[lineIndex] = scale.toInt();
}
