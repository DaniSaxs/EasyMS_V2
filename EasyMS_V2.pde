import processing.serial.*;

import cc.arduino.*;
import org.firmata.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Arduino arduino;

boolean activate = false;
boolean turnOn = false;

boolean activate2 = false;
boolean turnOn2 = false;

String directory;
Minim minim;

int opacityButton = 200;
int opacity = 0;

int boton;

File folderPiano;
String pianoName;
AudioSample pianoSound;
float pianoControl;
float pianoRotate;
String namesPiano[];
int pianoLength;

File folderDrums;
String drumsName;
AudioSample drumsSound;
float drumsControl;
float drumsRotate;
String namesDrums[];
int drumsLength;

File folderGuitar;
String guitarName;
AudioSample guitarSound;
float guitarControl;
float guitarRotate;
String namesGuitar[];
int guitarLength;

File folderBass;
String bassName;
AudioSample bassSound;
float bassControl;
float bassRotate;
String namesBass[];
int bassLength;

int time;

float angle1;
float angle2;
float angle3;
float angle4;

PImage drumsImg;
PImage pianoImg;
PImage bassImg;
PImage guitarImg;

int period = 1000;
long time_now = 0;

void setup() {
   size(600, 400);
   
   minim = new Minim(this);
  
   drumsImg = loadImage("images/drums.png");
   pianoImg = loadImage("images/piano.png");
   bassImg = loadImage("images/bass.png");
   guitarImg = loadImage("images/guitar.png");
   
   println("Waiting for Arduino...");
   arduino = new Arduino(this,"COM5",57600);
   if(arduino != null) println("Arduino Connected!");
   
   arduino.pinMode(2,Arduino.INPUT);
   
   directory = "C:/Users/danie/Desktop/EasyMS";
   folderPiano = new File(directory + "/piano");
   folderDrums = new File(directory + "/drums");
   folderGuitar = new File(directory + "/guitar");
   folderBass = new File(directory + "/bass");
   
}

void draw() {
  background(51);
  
  namesPiano = folderPiano.list();
  pianoLength = namesPiano.length;
  
  namesDrums = folderDrums.list();
  drumsLength = namesDrums.length;
  
  namesGuitar = folderGuitar.list();
  guitarLength = namesGuitar.length;
  
  namesBass = folderBass.list();
  bassLength = namesBass.length;
  
  boton = arduino.digitalRead(2);

  float potenDrums = arduino.analogRead(0);
  drumsRotate = map(potenDrums,0,1023,0,290);
  drumsControl = map(potenDrums,0,1023,0,drumsLength);
  
  float potenPiano = arduino.analogRead(1);
  pianoRotate = map(potenPiano,0,1023,0,290);
  pianoControl = map(potenPiano,0,1023,0,pianoLength);
  
  float potenGuitar = arduino.analogRead(2);
  guitarRotate = map(potenGuitar,0,1023,0,290);
  guitarControl = map(potenGuitar,0,1023,0,guitarLength);
  
  float potenBass = arduino.analogRead(3);
  bassRotate = map(potenBass,0,1023,0,290);
  bassControl = map(potenBass,0,1023,0,bassLength);
  
  GUI();
  
  wavesDraw();
  
  //minim.stop();
  
  playFinal();
  
}

void playFinal(){
  
   drumsControl = (int)drumsControl;
   pianoControl = (int)pianoControl;
   guitarControl = (int)guitarControl;
   bassControl = (int)bassControl;
   
   //Todos cero
  
  if(pianoControl == 0 && drumsControl == 0 && guitarControl == 0 && bassControl == 0){
    pianoName = "Cero!";
    drumsName = "Cero!";
    guitarName = "Cero!";
    bassName = "Cero!";
  }
  
  //Batería
  
  if(drumsControl != 0 && pianoControl == 0 && guitarControl == 0 && bassControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;
    
    if(turnOn){
      minim.stop();
      drumsName = namesDrums[(int)(drumsControl - 1)];
      drumsSound = minim.loadSample("drums/" + drumsName, 512);
      drumsSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Piano
  
  if(pianoControl != 0 && drumsControl == 0 && guitarControl == 0 && bassControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;
    
    if(turnOn){
      minim.stop();
      pianoName = namesPiano[(int)(pianoControl - 1)];
      pianoSound = minim.loadSample("piano/" + pianoName, 512);
      pianoSound.trigger();
      opacity = 0;
      turnOn = false;
    }
    
  }
  
  //Guitarra
  
  if(guitarControl != 0 && drumsControl == 0 && pianoControl == 0 && bassControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;
    
    if(turnOn){
      minim.stop();
      guitarName = namesGuitar[(int)(guitarControl - 1)];
      guitarSound = minim.loadSample("guitar/" + guitarName, 512);
      guitarSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Bajo
  
  if(bassControl != 0 && drumsControl == 0 && pianoControl == 0 && guitarControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;
    
    if(turnOn){
      minim.stop();
      bassName = namesBass[(int)(bassControl - 1)];
      bassSound = minim.loadSample("bass/" + bassName, 512);
      bassSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Batería y Piano
  
  if(drumsControl != 0 && pianoControl != 0 && guitarControl == 0 && bassControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;
    
    if(turnOn){
      minim.stop();
      drumsName = namesDrums[(int)(drumsControl - 1)];
      pianoName = namesPiano[(int)(pianoControl - 1)];
      drumsSound = minim.loadSample("drums/" + drumsName, 512);
      pianoSound = minim.loadSample("piano/" + pianoName, 512);
      drumsSound.trigger();
      pianoSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Piano y Guitarra
  
   if(pianoControl != 0 && guitarControl != 0 && drumsControl == 0 && bassControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;

    if(turnOn){
      minim.stop();
      pianoName = namesPiano[(int)(pianoControl - 1)];
      guitarName = namesGuitar[(int)(guitarControl - 1)];
      pianoSound = minim.loadSample("piano/" + pianoName, 512);
      guitarSound = minim.loadSample("guitar/" + guitarName, 512);
      pianoSound.trigger();
      guitarSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Piano y Bajo
  
   if(pianoControl != 0 && bassControl != 0 && drumsControl == 0 && guitarControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0){
      activate = true;
    }
    if(turnOn){
      minim.stop();
      pianoName = namesPiano[(int)(pianoControl - 1)];
      bassName = namesBass[(int)(bassControl - 1)];
      pianoSound = minim.loadSample("piano/" + pianoName, 512);
      bassSound = minim.loadSample("bass/" + bassName, 512);
      pianoSound.trigger();
      bassSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Guitarra y Bajo
  
  if(guitarControl != 0 && bassControl != 0 && drumsControl == 0 && pianoControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;

    if(turnOn){
      minim.stop();
      guitarName = namesGuitar[(int)(guitarControl - 1)];
      bassName = namesBass[(int)(bassControl - 1)];
      guitarSound = minim.loadSample("guitar/" + guitarName, 512);
      bassSound = minim.loadSample("bass/" + bassName, 512);
      guitarSound.trigger();
      bassSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Bajo y Batería
  
  if(bassControl != 0 && drumsControl != 0 && pianoControl == 0 && guitarControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;

    if(turnOn){
      minim.stop();
      bassName = namesBass[(int)(bassControl - 1)];
      drumsName = namesDrums[(int)(drumsControl - 1)];
      bassSound = minim.loadSample("bass/" + bassName, 512);
      drumsSound = minim.loadSample("drums/" + drumsName, 512);
      bassSound.trigger();
      drumsSound.trigger();
      turnOn = false;
    }
  }
  
  //Batería y Guitarra
  
  if(drumsControl != 0 && guitarControl != 0 && pianoControl == 0 && bassControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;

    if(turnOn){
      minim.stop();
      drumsName = namesDrums[(int)(drumsControl - 1)];
      guitarName = namesGuitar[(int)(guitarControl - 1)];
      drumsSound = minim.loadSample("drums/" + drumsName, 512);
      guitarSound = minim.loadSample("guitar/" + guitarName, 512);
      drumsSound.trigger();
      guitarSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Batería, Piano y Guitarra
  
  if(pianoControl != 0 && drumsControl != 0 && guitarControl != 0 && bassControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;

    if(turnOn){
      minim.stop();
      pianoName = namesPiano[(int)(pianoControl - 1)];
      pianoSound = minim.loadSample("piano/" + pianoName, 512);
      drumsName = namesDrums[(int)(drumsControl - 1)];
      drumsSound = minim.loadSample("drums/" + drumsName, 512);
      guitarName = namesGuitar[(int)(guitarControl - 1)];
      guitarSound = minim.loadSample("guitar/" + guitarName, 512);
      pianoSound.trigger();
      drumsSound.trigger();
      guitarSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Piano, Bajo y Guitarra
  
  if(pianoControl != 0 && bassControl != 0 && guitarControl != 0 && drumsControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;
      
    if(turnOn){
      minim.stop();
      pianoName = namesPiano[(int)(pianoControl - 1)];
      pianoSound = minim.loadSample("piano/" + pianoName, 512);
      bassName = namesBass[(int)(bassControl - 1)];
      bassSound = minim.loadSample("bass/" + bassName, 512);
      guitarName = namesGuitar[(int)(guitarControl - 1)];
      guitarSound = minim.loadSample("guitar/" + guitarName, 512);
      pianoSound.trigger();
      bassSound.trigger();
      guitarSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Bajo, Guitarra y Batería
  
  if(bassControl != 0 && guitarControl != 0 && drumsControl != 0 && pianoControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;

    if(turnOn){
      minim.stop();
      drumsName = namesDrums[(int)(drumsControl - 1)];
      drumsSound = minim.loadSample("drums/" + drumsName, 512);
      guitarName = namesGuitar[(int)(guitarControl - 1)];
      guitarSound = minim.loadSample("guitar/" + guitarName, 512);
      bassName = namesBass[(int)(bassControl - 1)];
      bassSound = minim.loadSample("bass/" + bassName, 512);
      drumsSound.trigger();
      guitarSound.trigger();
      bassSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Batería, Piano y Bajo
  
  if(drumsControl != 0 && pianoControl != 0 && bassControl != 0 && guitarControl == 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;

    if(turnOn){
      minim.stop();
      pianoName = namesPiano[(int)(pianoControl - 1)];
      pianoSound = minim.loadSample("piano/" + pianoName, 512);
      drumsName = namesDrums[(int)(drumsControl - 1)];
      drumsSound = minim.loadSample("drums/" + drumsName, 512);
      bassName = namesBass[(int)(bassControl - 1)];
      bassSound = minim.loadSample("bass/" + bassName, 512);
      pianoSound.trigger();
      drumsSound.trigger();
      bassSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
  //Todos
  
  if(pianoControl != 0 && drumsControl != 0 && guitarControl != 0 && bassControl != 0){
    if(boton == 1 && activate == true){
      turnOn = !turnOn;
      activate = false;
    }else if(boton == 0) activate = true;
      
    if(turnOn){
      minim.stop();
      pianoName = namesPiano[(int)(pianoControl - 1)];
      pianoSound = minim.loadSample("piano/" + pianoName, 512);
      drumsName = namesDrums[(int)(drumsControl - 1)];
      drumsSound = minim.loadSample("drums/" + drumsName, 512);
      guitarName = namesGuitar[(int)(guitarControl - 1)];
      guitarSound = minim.loadSample("guitar/" + guitarName, 512);
      bassName = namesBass[(int)(bassControl - 1)];
      bassSound = minim.loadSample("bass/" + bassName, 512);
      pianoSound.trigger();
      drumsSound.trigger();
      guitarSound.trigger();
      bassSound.trigger();
      opacity = 0;
      turnOn = false;
    }
  }
  
}

void GUI(){

  angle1 = 360 - radians(-drumsRotate);
  angle2 = 360 - radians(-pianoRotate);
  angle3 = 360 - radians(-guitarRotate);
  angle4 = 360 - radians(-bassRotate);
  
  textFont(createFont("Poppins", 12));
  fill(255,255,255);
  text("2021©DaniSaxs", width * 0.83, height * 0.98);
  
  //Drums Image
  pushMatrix();
    translate(width * 0.215, height * 0.05);
    scale(0.2);
    image(drumsImg,0,0);
  popMatrix();
  
    //WhiteBox Drums
    pushMatrix();
      noStroke();
      fill(255,255,255);
      rect(width * 0.24, height * 0.33, 70, 22, 100);
      
      textFont(createFont("Poppins", 15));
      fill(#121212);
      text(str((int)drumsControl), width * 0.29, height * 0.37);
    popMatrix();
  
  //PianoImage
  pushMatrix();
    translate(width * 0.615, height * 0.05);
    scale(0.2);
    image(pianoImg,0,0);
  popMatrix();
  
    //WhiteBox Piano
    pushMatrix();
      noStroke();
      fill(255,255,255);
      rect(width * 0.64, height * 0.33, 70, 22, 100);
      
      textFont(createFont("Poppins", 15));
      fill(#121212);
      text(str((int)pianoControl), width * 0.69, height * 0.37);
    popMatrix();
  
  //GuitarImage
  pushMatrix();
    translate(width * 0.215, height * 0.5);
    scale(0.2);
    image(guitarImg,0,0);
  popMatrix();
  
  //WhiteBox Guitar
      pushMatrix();
        noStroke();
        fill(255,255,255);
        rect(width * 0.24, height * 0.78, 70, 22, 100);
        
        textFont(createFont("Poppins", 15));
        fill(#121212);
        text(str((int)guitarControl), width * 0.29, height * 0.82);
      popMatrix();
  
  //BassImage
  pushMatrix();
    translate(width * 0.615, height * 0.5);
    scale(0.2);
    image(bassImg,0,0);
  popMatrix();
  
    //WhiteBox Bass
      pushMatrix();
        noStroke();
        fill(255,255,255);
        rect(width * 0.64, height * 0.78, 70, 22, 100);
        
        textFont(createFont("Poppins", 15));
        fill(#121212);
        text(str((int)bassControl), width * 0.69, height * 0.82);
      popMatrix();
  
  //Drums Potentiometer
  pushMatrix();
    strokeWeight(4);
    fill(255);
    stroke(#121212);
    translate(width*0.3, height*0.45);
    circle(0,0,25);
    rotate(angle1);
    stroke(#FF1A1A);
    line(0, 0, 8, 8);
  popMatrix();
  
  //Piano Potentiometer
  pushMatrix();
    strokeWeight(4);
    fill(255);
    stroke(#121212);
    translate(width*0.7, height*0.45);
    circle(0,0,25);
    rotate(angle2);
    stroke(#121212);
    line(0, 0, 8, 8);
  popMatrix();
  
  //Guitar Potentiometer
  pushMatrix();
    strokeWeight(4);
    fill(255);
    stroke(#121212);
    translate(width*0.3, height*0.9);
    circle(0,0,25);
    rotate(angle3);
    stroke(#BF3600);
    line(0, 0, 8, 8);
  popMatrix();
  
  //Bass Potentiometer
  pushMatrix();
    strokeWeight(4);
    fill(255);
    stroke(#121212);
    translate(width*0.7, height*0.9);
    circle(0,0,25);
    rotate(angle4);
    stroke(#767675);
    line(0, 0, 8, 8);
  popMatrix();
  
}

void buttonDraw(){
  pushStyle();
    noStroke();
    fill(144,20,20,150);
    circle(width / 2, height / 2, 70);
    fill(255,39,39,opacityButton);
    circle(width / 2, height / 2, 50);
  popStyle();
}

void wavesDraw(){
  
  opacity += 10;
  
  if(opacity >= 255){
    opacity = 255;
  }
  
  pushStyle();
    noStroke();
    fill(144,20,20, opacity + 20);
    circle(width / 2, height / 2, 100);
    fill(255,39,39, opacity + 15);
    circle(width / 2, height / 2, 80);
    fill(255,39,39, opacity + 10);
    circle(width / 2, height / 2, 60);
    fill(255,39,39, opacity);
    circle(width / 2, height / 2, 40);
  popStyle();
}
