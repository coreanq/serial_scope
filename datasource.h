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

#ifndef DATASOURCE_H
#define DATASOURCE_H

#include <QtCore/QObject>
#include <QtCharts/QAbstractSeries>
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <QQueue>
#include <QStringListModel>
#include <QTimer>
#include <QThread>
#include <QFile>
#include <QTextStream>


#define CHANNEL_COUNT		6

QT_BEGIN_NAMESPACE
class QQuickView;
QT_END_NAMESPACE

QT_CHARTS_USE_NAMESPACE


class DataSource : public QObject
{
    Q_OBJECT
public:
    explicit DataSource(QObject *parent = 0);

Q_SIGNALS:
signals:
    void sigSerialPortOpenSuccess();
    void sigSerialPortError();


public:
    Q_INVOKABLE void update(QAbstractSeries *series, int lineIndex);
    Q_INVOKABLE void yOffsetChanged(QString offset, int lineIndex);
    Q_INVOKABLE void yScaleChanged(QString scale, int lineIndex);

    Q_INVOKABLE void readData();
    Q_INVOKABLE QStringList availablePorts();
    Q_INVOKABLE void open(QString portName);
    Q_INVOKABLE void close(QString portName);
    Q_INVOKABLE void onSerialPortError(QSerialPort::SerialPortError error);
    Q_INVOKABLE void onSourceChanged(int sampleCount);
    Q_INVOKABLE void dataProcessing();

private:
    QFile				m_file;
    QTextStream			m_saveData;

    QTimer 				m_timerBufferProcessing;
    QQueue<float> 		m_data[CHANNEL_COUNT];
    QByteArray  		m_serialBuffer;

    QVector<QPointF> 	m_points[CHANNEL_COUNT];
    int					m_yOffsets[CHANNEL_COUNT];
    int					m_yScales[CHANNEL_COUNT];
    QStringListModel 	m_modelSerialList;
    int 		     	m_screenXCount;
};

#endif // DATASOURCE_H
