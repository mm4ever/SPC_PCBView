.pragma library

var isSelected = false;
var xPos = 0;
var yPos = 0;
var width = 0;
var height = 0;
var lineWidth = 0;
var strokeStyle = "";
var fillStyle = "";
var shape = "";

function setProperties(target){
    this.isSelected = target.isSlelected;
    this.xPos = target.targetPosX;
    this.yPos = target.targetPosY;
    this.width = target.targetWidth;
    this.height = target.targetHeight;
    this.lineWidth = target.borderWidth;
    this.strokeStyle = target.borderColor;
    this.fillStyle = target.fillCorlor;
    this.shape = target.targetShape;
}

function drawShape(target){
    target.lineWidth = lineWidth;
    target.strokeStyle = strokeStyle;
    target.fillStyle  = fillStyle;
    target.beginPath();
    if( shape === "rectangle" ){
        target.rect(xPos,yPos,width,height);
    }
    else if( shape === "circle" ){
        target.ellipse(xPos,yPos,width,height);
    }
    target.fill();
    target.stroke();
    target.closePath();
}
