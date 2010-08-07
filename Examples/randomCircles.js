/*
 *
 * Draw random circles for every record, basically disregarding the input.
 * To invoke, try something like:
 *
 *  yes | viz -PaintRecordScriptFile randomCircles.js
 *
 * If you don't need to go backwards through the stream,
 * turn off checkpointing to reduce the memory footprint:
 *
 *  yes | viz -PaintRecordScriptFile randomCircles.js -SavesCheckpoints NO
 *
 */

function paintRecord(record, index, canvas) {
  canvas.setFillColorR_G_B_A_(Math.random(), Math.random(), Math.random(), Math.random());
  canvas.paintCircleWithRadius_atX_andY_(Math.round(Math.random() * 25),
                                         Math.round(Math.random() * canvas.width()),
                                         Math.round(Math.random() * canvas.height()));
}