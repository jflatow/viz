/*
 *
 * Draw random circles for every record,
 * assuming the first field in the record specifies the radius.
 * To invoke, try something like:
 *
 *  perl -ne 'print "$1\n" if /(\d+)/' /dev/random | viz -PaintRecordScriptFile randomCircles.js
 *
 */

function paintRecord(record, index, canvas) {
  canvas.setFillColorR_G_B_A_(Math.random(), Math.random(), Math.random(), Math.random());
  canvas.paintCircleWithRadius_atX_andY_(parseInt(record.fields[0]),
                                         Math.round(Math.random() * canvas.width()),
                                         Math.round(Math.random() * canvas.height()));
}