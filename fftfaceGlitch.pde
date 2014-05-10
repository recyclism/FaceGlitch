/*
Corrupt.video + OpenCV Face Tracking = FaceGLitching
Made with Processing by Recyclism aka Benjamin Gaulon
Paris. May 2014.
Fill free to use / hack / modify this code

*/


// Implementing the minim library for audio analysis
import ddf.minim.analysis.*;
import ddf.minim.*;
 
// Create the minim object
Minim minim;
AudioInput in;
FFT fft;
 
// Needed later to make fft manipulations
int bands = 0;
float bandsfloat = 0;
float avg_bands = 0;
 

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

PImage photo;
PImage faceSave;

void setup() {
  
   // Setting up minim objects
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.logAverages(60, 7);
 
  // Getting the number of bands from fft
  bandsfloat = float(fft.avgSize());


  background(0);
  size(640, 480);

  video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
}

void draw() {
  scale(1);
  opencv.loadImage(video);

  image(video, 0, 0 );
  noFill();
  noStroke();
  strokeWeight(1);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {

    photo = loadImage("partialSave.jpg");

    println(faces[i].x + "/" + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);

    PImage partialSave = get(faces[i].x+1, faces[i].y+1, faces[i].width-1, faces[i].height-1);
    partialSave.save("partialSave.jpg");
  
  fft.forward(in.mix);
  avgBands(0, 5);
 
 byte b[] = loadBytes("partialSave.jpg");
   
   // glitch faces
   
     byte bCopy[] = new byte[b.length];
     arrayCopy(b, bCopy);
     // load binary of file

     int scrambleStart = 10;
     // scramble start excludes 10 bytes///
     
     int scrambleEnd = b.length;
     // scramble end ///
     
      // Number of Replacements * avg_bands

     int nbOfReplacements = int (random(0, 5000 * avg_bands));

     // Swap bits ///
     for(int g = 0; g < nbOfReplacements; g++)

     {
       int PosA = int(random (scrambleStart, scrambleEnd));

       int PosB = int(random (scrambleStart, scrambleEnd));

       byte tmp = bCopy[PosA];

       bCopy[PosA] = bCopy[PosB];

       bCopy[PosB] = tmp;

  saveBytes("partialSave.jpg", bCopy);
     }

    
  image(photo, faces[i].x, faces[i].y, faces[i].width, faces[i].height );
 
  }
  
 
}

void captureEvent(Capture c) {
  c.read();
}


// This function returns average volume of a selection of bands
// The two arguments are lo and hi percentages of all bands
void avgBands(float lo_t, float hi_t) {
  float bandadd = 0;
  float adder = bandsfloat/100;
 
  lo_t = lo_t*adder;
  hi_t = hi_t*adder;
 
  int lo_t_int = int(lo_t);
  int hi_t_int = int(hi_t);
 
  for (int i = lo_t_int; i < hi_t_int; i = i+1) {
    bandadd += (fft.getAvg(i)/32);
  }
  avg_bands = bandadd/(hi_t_int-lo_t_int);
  println("Band average: " + avg_bands);
  //println(avg_bands);
}

void stop()
{
  minim.stop();
  super.stop();
}
