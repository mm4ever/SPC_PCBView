.pragma library

var rectColor = "#81d4fa";
var cicleColor = "#ffcc80";
var strokeColor = "black";
var selectedBlodWidth = 2;
var unselectedBlodWidth = 0;

function drawShape( target,
                    data,
                    selectedIndex,
                    xOffset,
                    yOffset,
                    elementScale ){
    var cnt = data.rowCount();

    target.lineWidth = unselectedBlodWidth;
    target.strokeStyle = strokeColor;

    // 画矩形
    target.beginPath();
    for( var i = 0; i < cnt; ++i ){
        if( data.elementData(i,4) === "rectangle" ){
            target.fillStyle = rectColor;
            // parseInt 将后面括号中的(data.elementData(i,0)变为数字类型
            target.rect( parseInt(data.elementData(i,0)) * elementScale + xOffset,
                         parseInt(data.elementData(i,1)) * elementScale + yOffset,
                         parseInt(data.elementData(i,2)) * elementScale,
                         parseInt(data.elementData(i,3)) * elementScale );
        }
    }
    target.fill();

    // 画圆形
    target.beginPath();
    for( var i = 0; i < cnt; ++i ){
        if( data.elementData(i,4) === "circle" ){
            target.fillStyle = cicleColor;
            target.ellipse( parseInt(data.elementData(i,0)) * elementScale + xOffset,
                            parseInt(data.elementData(i,1)) * elementScale + yOffset,
                            parseInt(data.elementData(i,2)) * elementScale,
                            parseInt(data.elementData(i,3)) * elementScale );
        }
    }
    target.fill();

    // 画选中
    target.beginPath();
    target.lineWidth = selectedBlodWidth;
    if( data.elementData(selectedIndex,4) === "rectangle" ){
        target.fillStyle = rectColor;
        target.rect( parseInt(data.elementData(selectedIndex,0)) * elementScale + xOffset,
                     parseInt(data.elementData(selectedIndex,1)) * elementScale + yOffset,
                     parseInt(data.elementData(selectedIndex,2)) * elementScale,
                     parseInt(data.elementData(selectedIndex,3)) * elementScale );
    }
    else{
        target.fillStyle = cicleColor;
        target.ellipse( parseInt(data.elementData(selectedIndex,0)) * elementScale + xOffset,
                        parseInt(data.elementData(selectedIndex,1)) * elementScale + yOffset,
                        parseInt(data.elementData(selectedIndex,2)) * elementScale,
                        parseInt(data.elementData(selectedIndex,3)) * elementScale );
    }
    target.fill();
    target.stroke();
}
