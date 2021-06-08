/*
 Corrupt.video + OpenCV Face Tracking = FaceGLitching
 Made with Processing by Recyclism aka Benjamin Gaulon
 Paris. May 2014.
 Fill free to use / hack / modify this code
 Updated by Jerome Saint-Clair May 2021
-------------------------------------------
  How to run FaceGlitch from Processing 3.5.4:
  
  1. Download Processing 3.5.4 (Mac or Pc)
  https://processing.org/download/
  
  2. Move Processing to the Application Folder
  
  3. Open Processing
  
  4. Top menu select Sketch > Import Library > add Library
    - Type "Video", Select and click Install:
    Video | GStreamer based video library for Processing [Processing Foundation]
  
  5. Top menu select Sketch > Import Library > add Library
    - Type "OpenCV" Select and click Install:
    OpenCV for Processing | Computer vision with OpenCV [Greg Borenstein]
  
  6. Top menu File > Open, open file FaceGlitch.pde
  
  7. Top menu Sketch > Present
  
  8. Press Esc key to quit
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

    String ext = random(3) > .5 ? ".jpg" : ".gif";
    
    PImage partialSave = video.get(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    partialSave.save("partialSave" + ext);

    // load binary of file
    byte b[] = loadBytes("partialSave" + ext);
    
    int scrambleStart = 20;
    // scramble start excludes 10 bytes///

    int scrambleEnd = b.length;
    // scramble end ///

    int nbOfReplacements = int (random(2, 10));
    // Number of Replacements - Go easy with this as too much will just kill the file ///

    // Swap bits ///
    for (int g = 0; g < nbOfReplacements; g++) {
      int PosA = int(random (scrambleStart, scrambleEnd));
      int PosB = int(random (scrambleStart, scrambleEnd));
      byte tmp = b[PosA];
      b[PosA] = b[PosB];
      b[PosB] = tmp;
    }
    saveBytes("partialSave" + ext, b);
    PImage photo = loadImage("partialSave" + ext);
    image(photo, ratio*faces[i].x, ratio*faces[i].y, ratio*faces[i].width, ratio*faces[i].height );
  }
}

void captureEvent(Capture c) {
  c.read();
}
