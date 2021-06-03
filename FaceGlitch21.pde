/*
Corrupt.video + OpenCV Face Tracking = FaceGLitching
 Made with Processing by Recyclism aka Benjamin Gaulon
 Paris. May 2014.
 Fill free to use / hack / modify this code
 Updated by Jerome Saint-Clair May 2021
 */

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

int ratio = 3;

void setup() {
  background(0);
  size(1920, 1080);

  video = new Capture(this, width/ratio, height/ratio);
  opencv = new OpenCV(this, width/ratio, height/ratio);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
}

void draw() {

  opencv.loadImage(video);
  image(video, 0, 0, width, height);
  Rectangle[] faces = opencv.detect();

  // glitch faces
  for (int i = 0; i < faces.length; i++) {

    PImage partialSave = video.get(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    partialSave.save("partialSave.jpg");

    // load binary of file
    byte b[] = loadBytes("partialSave.jpg");
    
    int scrambleStart = 10;
    // scramble start excludes 10 bytes///

    int scrambleEnd = b.length;
    // scramble end ///

    int nbOfReplacements = int (random(2, 5));
    // Number of Replacements - Go easy with this as too much will just kill the file ///

    // Swap bits ///
    for (int g = 0; g < nbOfReplacements; g++) {
      int PosA = int(random (scrambleStart, scrambleEnd));
      int PosB = int(random (scrambleStart, scrambleEnd));
      byte tmp = b[PosA];
      b[PosA] = b[PosB];
      b[PosB] = tmp;
    }
    saveBytes("partialSave.jpg", b);
    PImage photo = loadImage("partialSave.jpg");
    image(photo, ratio*faces[i].x, ratio*faces[i].y, ratio*faces[i].width, ratio*faces[i].height );
  }
}

void captureEvent(Capture c) {
  c.read();
}
