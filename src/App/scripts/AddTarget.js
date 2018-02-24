.pragma library

var rectColor = "#C5E1A5";
var cicleColor = "#FFE082";
var strokeColor = "#F44336";
var selectedBlodWidth = 2;
var unselectedBlodWidth = 0;

var x = 0;
var y = 0;
var w = 0;
var h = 0;
var shape = "rectangle";

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
        x = data.elementData(i,0);
        y = data.elementData(i,1);
        w = data.elementData(i,2);
        h = data.elementData(i,3);
        shape = data.elementData(i,4);
        if( "rectangle" === shape &&
            x * elementScale + xOffset >= 0 &&
            y * elementScale + yOffset >= 0 &&
            w * elementScale + xOffset <= 1280 &&
            h * elementScale + yOffset <= 720 ){
            target.fillStyle = rectColor;
            target.rect( x * elementScale + xOffset,
                         y * elementScale + yOffset,
                         w * elementScale,
                         h * elementScale );
        }
    }
    target.fill();

    // 画圆形
    target.beginPath();
    for( var i = 0; i < cnt; ++i ){
        x = data.elementData(i,0);
        y = data.elementData(i,1);
        w = data.elementData(i,2);
        h = data.elementData(i,3);
        shape = data.elementData(i,4);
        if( "circle" === shape &&
            x * elementScale + xOffset >= 0 &&
            y * elementScale + yOffset >= 0 &&
            w * elementScale + xOffset <= 1280 &&
            h * elementScale + yOffset <= 720 ){
            target.fillStyle = cicleColor;
            target.ellipse( x * elementScale + xOffset,
                            y * elementScale + yOffset,
                            w * elementScale,
                            h * elementScale );
        }
    }
    target.fill();

    // 画选中
    if(-1 !== selectedIndex ){
        x = data.elementData(selectedIndex,0);
        y = data.elementData(selectedIndex,1);
        w = data.elementData(selectedIndex,2);
        h = data.elementData(selectedIndex,3);
        shape = data.elementData(selectedIndex,4);
        target.beginPath();
        target.lineWidth = selectedBlodWidth;
        if( "rectangle" === shape ){
            target.fillStyle = rectColor;
            target.rect( x * elementScale + xOffset,
                         y * elementScale + yOffset,
                         w * elementScale,
                         h * elementScale );
        }
        else{
            target.fillStyle = cicleColor;
            target.ellipse( x * elementScale + xOffset,
                            y * elementScale + yOffset,
                            w * elementScale,
                            h * elementScale );
        }
        target.fill();
        target.stroke();
    }

    target.closePath();
}
