/*
 *
 * Draw circles for every record, based only on the index.
 * This example demonstrates a deterministic paintRecord function,
 * which means that stepping back and forth through the stream makes sense.
 * To invoke, try something like:
 *
 *  yes | head -n 1000 | viz -PaintRecordScriptFile deterministicCircles.js
 *
 */

function paintRecord(record, index, canvas) {
  var
    height = canvas.height(),
    width = canvas.width();
  var
    green = (index % width) / width,
    blue = (index % 1001) / 1001;
  canvas.setFillColorR_G_B_A_(1 - green, green, blue, .3);
  canvas.setStrokeColorR_G_B_A_(0, 0, 0, .1);
  canvas.paintCircleWithRadius_atX_andY_(Math.abs(Math.sin(Math.PI * index / 213) * 20),
                                         Math.pow(Math.cos(Math.PI * index / 131), 2) * width,
                                         Math.pow(Math.sin(Math.PI * index / 151), 2) * height);
}