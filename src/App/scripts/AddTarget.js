.pragma library

var rectColor = "#81d4fa";
var cicleColor = "#ffcc80";
var strokeColor = "black";
var selectedBlodWidth = 2;
var unselectedBlodWidth = 0;

function drawShape(target,data,selectedIndex){
    var cnt = data.rowCount();

    target.lineWidth = unselectedBlodWidth;
    target.strokeStyle = strokeColor;
    // 画矩形
    target.beginPath();
    for( var i = 0; i < cnt; ++i ){
        if( data.elementData(i,4) === "rectangle" ){
            target.fillStyle = rectColor;
            target.rect( data.elementData(i,0),
                         data.elementData(i,1),
                         data.elementData(i,2),
                         data.elementData(i,3));
        }
    }
    target.fill();
    // 画圆形
    target.beginPath();
    for( var i = 0; i < cnt; ++i ){
        if( data.elementData(i,4) === "circle" ){
            target.fillStyle = cicleColor;
            target.ellipse( data.elementData(i,0),
                            data.elementData(i,1),
                            data.elementData(i,2),
                            data.elementData(i,3));
        }
    }
    target.fill();
    // 画选中
    if( selectedIndex !== -1 ){
        target.beginPath();
        target.lineWidth = selectedBlodWidth;
        if( data.elementData(selectedIndex,4) === "rectangle" ){
            target.fillStyle = rectColor;
            target.rect( data.elementData(selectedIndex,0),
                        data.elementData(selectedIndex,1),
                        data.elementData(selectedIndex,2),
                        data.elementData(selectedIndex,3));
        }
        else{
            target.fillStyle = cicleColor;
            target.ellipse( data.elementData(selectedIndex,0),
                           data.elementData(selectedIndex,1),
                           data.elementData(selectedIndex,2),
                           data.elementData(selectedIndex,3));
        }
        target.fill();
        target.stroke();
    }
}
