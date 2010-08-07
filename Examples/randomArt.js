/*
 *
 * Draw random art.
 * To invoke, try something like:
 *
 *  yes | viz -PaintRecordScriptFile randomArt.js
 *
 * or:
 *
 *  while ((1)); do echo 4; done | viz -PaintRecordScriptFile randomArt.js -SavesCheckpoints NO
 *
 */

var nextX, nextY,
  lastX = 0,
  lastY = 0;

function bound(z, B) {
  return Math.min(Math.max(0, z), B);
}

function nextZ(lastZ, B, scale) {
  return bound(lastZ + (Math.random() - .5) * randInt(B >> scale), B);
}

function randInt(n) {
  return Math.round(Math.random() * n);
}

function paintRecord(record, index, canvas) {
  var
    height = canvas.width(),
    width = canvas.height(),
    style = parseInt(record.fields[0]);

  if (isNaN(style))
    style = randInt(10);

  canvas.setFillColorR_G_B_A_(Math.random(), Math.random(), Math.random(), Math.random());
  canvas.setStrokeColorR_G_B_A_(Math.random(), Math.random(), Math.random(), Math.random());

  switch (style % 10) {
    case 0:
      nextX = nextZ(lastX, width, 3);
      nextY = nextZ(lastY, height, 3);
      canvas.clearRectWithWidth_andHeight_atX_andY_(nextX - lastX, nextY - lastY, lastX, lastY);
      lastX = nextX;
      lastY = nextY;
       break;
    case 1:
      nextX = nextZ(lastX, width, 3);
      nextY = nextZ(lastY, height, 3);
      canvas.paintRectWithWidth_andHeight_atX_andY_(nextX - lastX, nextY - lastY, lastX, lastY);
      lastX = nextX;
      lastY = nextY;
      break;
    case 2:
      canvas.paintArcWithRadius_andStartAngle_andEndAngle_atX_andY_(randInt(height >> 5),
                                                                    2 * Math.PI * Math.random(),
                                                                    2 * Math.PI * Math.random(),
                                                                    lastX,
                                                                    lastY);
      break;
    case 3:
      canvas.paintCircleWithRadius_atX_andY_(randInt(height >> 5), lastX, lastY);
      break;
    case 4:
      nextX = nextZ(lastX, width, 3);
      nextY = nextZ(lastY, height, 3);
      canvas.strokeRectWithWidth_andHeight_atX_andY_(nextX - lastX, nextY - lastY, lastX, lastY);
      lastX = nextX;
      lastY = nextY;
      break;
    default:
      nextX = nextZ(lastX, width, 5);
      nextY = nextZ(lastY, height, 5);
      canvas.paintLineFromX_andY_toX_andY_(lastX, lastY, nextX, nextY);
      lastX = nextX;
      lastY = nextY;
  }
}