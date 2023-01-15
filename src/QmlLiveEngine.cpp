#include "QmlLiveEngine.h"
#include <QFileInfo>
#include <QTimer>
#include <QFileSystemWatcher>
#include <QQmlContext>
#include <QDir>
#include <QWindow>
QObject *QmlLiveEngine::Logger = nullptr;
QmlLiveEngine::QmlLiveEngine(QObject *parent)
    : QQmlApplicationEngine(parent), m_watcher(new QFileSystemWatcher(this)),
      m_timer(new QTimer(this)), m_window(nullptr)
{
    connect(m_watcher, &QFileSystemWatcher::directoryChanged, this, &QmlLiveEngine::onFileSystemChanged); //监听文件夹变化
    connect(m_watcher, &QFileSystemWatcher::fileChanged, this, &QmlLiveEngine::onFileSystemChanged);     //监听文件变化
    connect(m_timer, &QTimer::timeout, this, &QmlLiveEngine::onReloadRequested);                      //延时加载
    m_timer->setSingleShot(true);
}
QmlLiveEngine::~QmlLiveEngine()
{
}
void QmlLiveEngine::hotload(QUrl url)
{
    rootContext()->setContextProperty("$Engine", this);
    load(url);
    m_window = rootObjects().first();
    Logger = m_window->findChild<QObject *>("logger");
    qInstallMessageHandler(QmlLiveEngine::messageHandler); //输出重定向
}
QString QmlLiveEngine::setQmlPath(QString Qmlpath)
{
    if (Qmlpath != m_QmlPath)
    {
        m_QmlPath = Qmlpath;
        //删除旧的配置
        unwatchAll();
        auto importList=importPathList();
        if(!m_absQmlDir.isEmpty())
        {
            int index = importList.indexOf(m_absQmlDir);
            if (index != -1)
                importList.removeAt(index);
        }
        //更新
        Qmlpath.replace("file:/",""); //去掉file://
        m_absQmlPath = QDir(Qmlpath).absolutePath();
        m_absQmlDir = m_absQmlPath.left(m_absQmlPath.lastIndexOf('/'));
        scanfPaths(m_absQmlDir);
        importList.push_back(m_absQmlDir);
        setPluginPathList(importList);
    }
    return m_absQmlPath;
}
void QmlLiveEngine::onFileSystemChanged()
{
    if (!m_timer)
        return;
    if (!m_timer->isActive())
        m_timer->start();
}

void QmlLiveEngine::onReloadRequested()
{
    unwatchAll();
    scanfPaths(m_absQmlDir);
    QMetaObject::invokeMethod(m_window, "reload");
}

void QmlLiveEngine::scanfPaths(const QString &dir)
{
    QDir d(dir);
    QStringList files = d.entryList(QStringList() << "*.*", QDir::Files);
    QStringList dirs = d.entryList(QDir::Dirs | QDir::NoDotAndDotDot);

    m_watcher->addPath(dir);
    for (QString &file : files)
    {
        m_watcher->addPath(dir + '/' + file);
    }

    for (QString &subdir : dirs)
    {
        scanfPaths(dir + '/' + subdir);
    }
}

void QmlLiveEngine::unwatchAll()
{
    QStringList dirs = m_watcher->directories();
    QStringList files = m_watcher->files();
    QStringList fails;

    for (QString &dir : dirs)
    {
        if (!m_watcher->removePath(dir))
        {
            fails << dir;
        }
    }
    for (QString &file : files)
    {
        if (!m_watcher->removePath(file))
        {
            fails << file;
        }
    }
    if (!fails.empty())
    {
        qWarning() << tr("The following directories or files "
                         "cannot be removed from file system watcher:");
        for (QString &fail : fails)
        {
            qWarning() << "\t" << fail;
        }
    }
}

void QmlLiveEngine::messageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    Q_UNUSED(context);

    if (Logger != nullptr)
    {
        QVariant v(msg);
        if (type == QtWarningMsg || type == QtCriticalMsg || type == QtFatalMsg)
            QMetaObject::invokeMethod(Logger,"error",Q_ARG(QVariant,v));
        else
            QMetaObject::invokeMethod(Logger, "debug", Q_ARG(QVariant, v));
    }
}
