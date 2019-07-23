import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import pbySecond 1.0
import pbyFirst 1.0
ApplicationWindow{
    id:main
    visible: true
    width: 640
    height: 480
    minimumWidth: 400
    minimumHeight: 300
    property color textBackgroundColor:'black'
    property color textColor:'white'
    Action{
        id:cutAction
        text: '剪切'
        iconSource:"./images/cut.png"
        shortcut: 'ctrl+x'
        iconName: 'edit-cut'
        enabled:false
        onTriggered: textArea.cut()

    }
    Action{
        id:pasteAction
        text: '粘贴'
        iconSource: "./images/paste.png"
        shortcut: 'ctrl+v'
        iconName: 'edit-paste'
        enabled: false
        onTriggered: textArea.paste()
    }
    Action{
        id:copyAction
        text: '复制'
        iconSource: "./images/copy.png"
        shortcut: 'ctrl+c'
        iconName: 'edit-copy'
        enabled: false
        onTriggered: textArea.copy()
    }


    Action{
        id:htmlOpenAction

        iconSource:"./images/filehtml.jpg"
        iconName: 'html-open'
        text:"打开网页"
        onTriggered: htmlDlg.open()
    }
    Action{
        id:textOpenAction
        iconSource: "./images/filetext.jpg"
        iconName: 'text-open'
        text:'打开文本'
        onTriggered: textDlg.open()
    }
    Action{
        id:imgOpenAction
        iconSource: "./images/fileimage.png"
        iconName: "image-open"
        text: "打开图片"
        onTriggered: imgDlg.open()
    }
    Action{
        id:imgZoomInAction
        iconSource: "./images/zoomIn.jpg"
        iconName: "image-zoomin"
        text:"放大图片"
        enabled: false
        onTriggered: {
            imgeArea.scale+=0.1
            if(imgeArea.scale>3)
                imgeArea.scale=1
        }
    }
    Action{
        id:imgZoomOutAction
        iconSource: "./images/zoomOut.jpg"
        iconName: "image-zoomout"
        text:"缩小图片"
        enabled: false
        onTriggered: {
            imgeArea.scale-=0.1
            if(imgeArea.scale<0.1)
                imgeArea.scale=1
        }
    }
    Action{
        id:imgLeftRotaAction
        iconSource: "./images/rotateleft.jpg"
        iconName: "image-rotateleft"
        text:"逆时针旋转45度"
        enabled: false
        onTriggered: {
            imgeArea.rotation-=45
        }
    }
    Action{
        id:imgrightRotaAction
        iconSource: "./images/rotateright.jpg"
        iconName: "image-rotateright"
        text:"顺时针旋转45度"
        enabled: false
        onTriggered: {
            imgeArea.rotation+=45
        }
    }

    menuBar: MenuBar{
        Menu{
            title: '文档'
            MenuItem{
                text: '文本...'
                action: textOpenAction
            }

            MenuItem{
                text: '网页...'
                action: htmlOpenAction
            }
            MenuItem{
                text: '图片...'
                action: imgOpenAction
            }
            MenuSeparator{}
            MenuItem{
                text: '退出...'
                onTriggered: Qt.quit()
            }
        }
        Menu{
            title: '编辑'
            MenuItem{
                action: copyAction
            }
            MenuItem{
                action: cutAction
            }
            MenuItem{
                action: pasteAction
            }
        }
        Menu{
            title: '图像'
            MenuItem{
                text: '放大'
                action: imgZoomInAction
            }
            MenuItem{
                text: '缩小'
                action:imgZoomOutAction
            }
            MenuItem{
                text: '向左旋转'
                action: imgLeftRotaAction
            }
            MenuItem{
                text: '向右旋转'
                action: imgrightRotaAction
            }
        }
        Menu{
            title: '帮助'
            MenuItem{
                text:'帮助...'
                onTriggered: aboutBox.open()
            }
        }
    }
    toolBar: ToolBar{
        id:mainToolBar
        width: parent.width
        RowLayout{
            anchors.fill: parent
            spacing: 0
            ToolButton{action: htmlOpenAction}
            ToolSeparator{}
            ToolButton{action: textOpenAction}
            ToolButton{action: copyAction}
            ToolButton{action: cutAction}
            ToolButton{action: pasteAction}
            ToolSeparator{}
            ToolButton{action: imgOpenAction}
            ToolButton{action: imgLeftRotaAction}
            ToolButton{action: imgrightRotaAction}
            ToolButton{action: imgZoomInAction}
            ToolButton{action: imgZoomOutAction}
            Item{Layout.fillWidth: true}
        }
    }
    Item {
        id: centralArea
        anchors.fill: parent
        visible: true
        property var current:htmlArea
        BusyIndicator{
            id:busy
            anchors.centerIn: parent
            running: false
            z:3
        }
        TextArea{
            id:htmlArea
            anchors.fill: parent
            readOnly: true
            frameVisible: false
            baseUrl: "qrc:/"
            text:htmldoc.text
            textFormat: Qt.RichText
        }
        TextArea{
            id:textArea
            anchors.fill: parent
            visible: false
            frameVisible: false
            wrapMode: TextEdit.WordWrap
            font.pixelSize: 12
            text:textdoc.text
            Component.onCompleted: forceActiveFocus()
        }

        Image {
            id: imgeArea
            visible: false
            anchors.fill: parent
            asynchronous: true
            fillMode: Image.PreserveAspectFit
            onStatusChanged: {
                if(status===Image.Loading){
                    busy.running=true
                }else if(status===Image.Ready){
                    busy.running=false
                }else if(status===Image.Error){
                    busy.running=false
                    mainStatusBar.text="图片无法显示"
                }
            }
        }
    }
    statusBar:Rectangle{
        id:mainStatusBar
        color:'lightgray'
        implicitHeight: 30
        width: parent.width
        property alias text:status.text
        Text{
            id:status
            anchors.fill: parent
            anchors.margins: 4
            font.pixelSize: 12
        }
    }
    MessageDialog{
        id:aboutBox
        title: '关于'
        text: "MultiDocViewer 1.1 \n 这是一个多功能文档查看器，可打开文本、网页、
图片等多种类型的文档 、你使用 Qt Quick Controls 开发而成。  \nCopyright @2010-2017
easybooks.版权所有"
        icon: StandardIcon.Information
    }
    FileDialog{
        id:htmlDlg
        title: "打开网页"
        nameFilters: ["网页 (*.htm *.html *.mht)"]
        onAccepted:{
            htmldoc.fileUrl=fileUrl
            var filePath=new String(fileUrl)
            mainStatusBar.text=filePath.slice(8)
            centralArea.current=htmlArea
            textArea.visible=false
            imgeArea.visible=false
            htmlArea.visible=true
            main.title=htmldoc.htmlTitle+" - 多功能文档查看器"
            copyAction.enabled=false
            cutAction.enabled=false
            pasteAction.enabled=false
            imgLeftRotaAction.enabled=false
            imgrightRotaAction.enabled=false
            imgZoomOutAction.enabled=false
            imgZoomInAction.enabled=false
        }
    }
    FileDialog{
        id:textDlg

        title: "打开文本"
        nameFilters: ["文本文件 (*.txt)"]
        onAccepted: {
            textdoc.fileUrl=fileUrl


            var filePath=new String(fileUrl)
            mainStatusBar.text=filePath.slice(8)
            centralArea.current=textArea
            htmlArea.visible=false
            imgeArea.visible=false
            textArea.visible=true
            main.title=textdoc.textTitle+" - 多功能文档查看器"
            copyAction.enabled=true
            pasteAction.enabled=true
            copyAction.enabled=true
            imgrightRotaAction.enabled=false
            imgLeftRotaAction.enabled=false
            imgZoomInAction.enabled=false
            imgZoomOutAction.enabled=false
        }
    }
    FileDialog{
        id:imgDlg
        title: "打开图片"
        nameFilters: ["图像文件 (*.jpg *.jpeg *.png *.gif *.bmp *.icon)"]
        onAccepted: {
            var filePath=new String(fileUrl)
            mainStatusBar.text=filePath.slice(8)
            var dot=filePath.lastIndexOf(".")
            var sep=filePath.lastIndexOf("/")
            if(dot>sep){
                var fileName=filePath.substring(sep+1)
                main.processFile(fileUrl,fileName)
            }else{
                mainStatusBar.text="出错！MultiDocViewer 不支持此文件格式"
            }
        }
    }
    HtmlHandler{
        id:htmldoc
        Component.onCompleted: htmldoc.fileUrl="qrc:/HTM.html"
       // target: main
    }
    TextHandler{
        id:textdoc

    }
function processFile(fileUrl,name){
    if(centralArea.current!==imgeArea){
        if(centralArea.current!==null){
            centralArea.current.visible=false
        }
        imgeArea.visible=true
        centralArea.current=imgeArea
    }
    imgeArea.source=fileUrl
    main.title=name+" - 多功能文档查看器"
    copyAction.enabled=false
    pasteAction.enabled=false
    copyAction.enabled=false
    imgrightRotaAction.enabled=true
    imgLeftRotaAction.enabled=true
    imgZoomInAction.enabled=true
    imgZoomOutAction.enabled=true
}
}
