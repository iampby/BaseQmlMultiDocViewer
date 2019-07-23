#include"htmlhandler.h"
#include<qmessagebox.h>
#include<QtCore/QFileInfo>
HtmlHandler::HtmlHandler():m_target(Q_NULLPTR),m_doc(Q_NULLPTR),m_cursorPosition(-1)
  ,m_selectionStart(0),m_selectionEnd(0)
{

}

void HtmlHandler::setTarget(QQuickItem *target)
{
m_doc=Q_NULLPTR;
m_target=target;
if(!m_target)
return;
QVariant doc=m_target->property("textDocument");
if(doc.isValid())
        QMessageBox::warning(Q_NULLPTR,"¾¯¸æ",
                             "locate in htmlhandler.cpp line:18,"
                                            "textDocument property is no exist.",QMessageBox::Ok);
if(doc.canConvert<QQuickTextDocument*>())
{
    QQuickTextDocument*qqdoc=doc.value<QQuickTextDocument*>();
    if(qqdoc)
        m_doc=qqdoc->textDocument();
}
emit targetChanged();
}

QUrl HtmlHandler::fileUrl() const
{
return m_fileUrl;
}

QString HtmlHandler::text() const
{
return m_text;
}

QString HtmlHandler::htmlTitle() const
{
    return  m_htmlTitle;
}

void HtmlHandler::setFileUrl(const QUrl &arg)
{

if(m_fileUrl!=arg)
{
    m_fileUrl=arg;
    QString fileName=QQmlFile::urlToLocalFileOrQrc(arg);
    if(QFile::exists(fileName))
    {
        QFile file(fileName);
        if(file.open(QFile::ReadOnly))
        {
            QByteArray data=file.readAll();
            QTextCodec*codec=QTextCodec::codecForHtml(data);
            setText(codec->toUnicode(data));
            if(m_doc)m_doc->setModified(false);
            if(fileName.isEmpty())
                m_htmlTitle=QStringLiteral("untitled.txt");
            else
                m_htmlTitle=QFileInfo(fileName).fileName();
            emit textChanged();
            emit htmlTitleChanged();
        }
    }
    emit fileUrlChanged();
}
}

void HtmlHandler::setText(const QString &arg)
{
    if(m_text!=arg){
        m_text=arg;
        emit textChanged();
    }
}

void HtmlHandler::setHtmlTitle(QString arg)
{
    if(m_htmlTitle!=arg){
        m_htmlTitle=arg;
        emit htmlTitleChanged();
    }
}
