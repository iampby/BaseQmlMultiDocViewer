#include "texthandler.h"
#include<QMessageBox>
#include<QFileInfo>
TextHandler::TextHandler():m_target(Q_NULLPTR),
    m_doc(Q_NULLPTR),m_cursorPosition(0),m_selectionStart(0),m_selectionEnd(0)
{

}

void TextHandler::setTarget(QQuickItem *target)
{
    m_doc=Q_NULLPTR;

    m_target=target;
    if(!m_target)
    return;
    QVariant doc=m_target->property("textDocument");
    if(doc.isValid())
            QMessageBox::warning(Q_NULLPTR,"¾¯¸æ",
                                 "locate in texthandler.cpp line:18,"
                                                "textDocument property is no exist.",QMessageBox::Ok);
    if(doc.canConvert<QQuickTextDocument*>()){
        QQuickTextDocument*qqdoc=doc.value<QQuickTextDocument*>();
        if(qqdoc)m_doc=qqdoc->textDocument();
    }
    emit targetChanged();

}

QUrl TextHandler::fileUrl() const
{
    return  m_fileUrl;
}

QString TextHandler::text() const
{
    return m_text;
}

QString TextHandler::textTitle() const
{
return m_textTitle;
}

void TextHandler::setFileUrl(const QUrl &arg)
{
    if(m_fileUrl!=arg){
        m_fileUrl=arg;
        QString fileName=QQmlFile::urlToLocalFileOrQrc(arg);
        if(QFile::exists(fileName)){
QFile file(fileName);
if(file.open(QFile::ReadOnly)){
    QByteArray data=file.readAll();
    QTextCodec*codec=QTextCodec::codecForName("GB2312");
    setText(codec->toUnicode(data));
    if(m_doc)m_doc->setModified(false);
    if(fileName.isEmpty())
        m_textTitle=QStringLiteral("untitled.txt");
    else
        m_textTitle=QFileInfo(fileName).fileName();
    emit textChanged();
    emit textTitleChanged();
        }
    }
        emit fileUrlChanged();
}
}

void TextHandler::setText(const QString &arg)
{
if(m_text!=arg)
    m_text=arg;
emit textChanged();
}

void TextHandler::setTextTitle(QString &arg)
{
m_textTitle=arg;
}
