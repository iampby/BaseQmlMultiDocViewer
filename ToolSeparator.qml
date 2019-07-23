import QtQuick 2.4

Item {
width: 8
anchors.top: parent.top
anchors.bottom: parent.bottom
anchors.margins: 6
Rectangle{
    width: 1
    height: parent.height
    anchors.horizontalCenter: parent.horizontalCenter
    color: "#25000000"
}
Rectangle{
    width: 1
    height: parent.height
    anchors.horizontalCenter: parent.horizontalCenter
    color: "#33ffffff"
}
}
