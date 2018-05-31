import processing.sound.*;
Amplitude amp;
AudioIn in;

//////////volume bars//////////////
float vol;
float[] volHistory= new float[100];
int counter;
//int passoncounter;
int framecount=1;
int bandwidth=10;
int banddistance=20;
float deg;
int sensitivity=55000;

///////////////////////////


////color////
float frequency =0.07;
int amplitude =127;
float A=0.3;
float r;
float g;
float b;
float n=0.0;
int center=128;
//////////////////////////////////////


/////Jumping box////////////////
float v0 =-0.1;
float v1=-1;
float a10 =-0.01;
float a20 = -0.7;
PVector[] s= new PVector[100];

PVector a1= new PVector(0, a10);
PVector a2= new PVector(0, a20);
PVector[] v= new PVector[100];
int ellipsewidth=10;
//////////

///
int rot=1;



void setup() {
  //size(720, 720);
  fullScreen();

  background(0);
  frameRate(60);
  for (int i=0; i<=99; i++) {
    volHistory[i]=0;
    s[i]=new PVector(0, bandwidth/2);
    v[i]=new PVector(0, v0);
  }
  counter =0;
  vol =0;
 // passoncounter=0;
  deg=0;



  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);




  
}


void draw() {

  // rotate
  translate(width/2, height/2);
  rotate(radians(deg));
  if (amp.analyze()*sensitivity>300) {
    float dirc=random(-1, 1);
   
    if (dirc>0.6) {
      rot=1;
    } else {
      rot=-1;
    }
  }
  deg=deg+rot*sin(radians(map(amp.analyze()*sensitivity, 0, 1200, 20, 180)));



  println(amp.analyze()*sensitivity);

  rectMode(CENTER);

  vol = amp.analyze()*sensitivity;
  //println(volHistory);
  if (counter<framecount) {
    counter+=1;
  } else if (counter==framecount) {
    fill(0);
    rect(0, 0, width*2, height*2);
    rect(0, 0, bandwidth, vol);

    ////////////////rainbow////////
    for (int i=0; i<=48; i++) {
      r= sin(frequency*i+A)*amplitude+center;
      g= sin(frequency*i+A+1)*amplitude+center;
      b= sin(frequency*i+A+2)*amplitude+center;
      fill(r, g, b);
      noStroke();
      ////////////////////////////////////////////    
      rect((i+1)*banddistance, 0, bandwidth, volHistory[i]);

      rect(-1*i*banddistance, 0, bandwidth, volHistory[i]);

      //////falling ball//////////

      ellipse((i+1)*banddistance, s[i].y+3, ellipsewidth, ellipsewidth);
      ellipse(-1*i*banddistance, s[i].y+3, ellipsewidth, ellipsewidth);
      ellipse((i+1)*banddistance, -1*(s[i].y+3), ellipsewidth, ellipsewidth);
      ellipse(-1*i*banddistance, -1*(s[i].y+3), ellipsewidth, ellipsewidth);
      if (volHistory[i]/2>s[i].y) {
        s[i].y=volHistory[i]/2;
        s[i].limit(500);
      }


      for (int j=0; j<=48; j++) 
      {   
        v[j].y=v1*sin(map(s[j].y, 0, 700, 0, PI/2));
        s[j].add(v[j]);
      }
    }
    counter =0;
    volHistory[0]=vol;
    for (int i=48; i>=0; i--) {
      volHistory[i+1]=volHistory[i]; //volHistory[passoncounter+1]=volHistory[passoncounter];
    }
  }

  A=A+amp.analyze()*10;
  
  println(amp.analyze()*100);
}
