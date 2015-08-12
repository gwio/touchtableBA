import mathematik.Quaternion;

import oscP5.*;
import netP5.*;

import remixlab.bias.event.*;
import remixlab.bias.event.shortcut.*;
import remixlab.bias.agent.profile.*;
import remixlab.bias.agent.*;
import remixlab.dandelion.agent.*;
import remixlab.proscene.*;
import remixlab.dandelion.core.*;
import remixlab.dandelion.constraint.*;
import remixlab.fpstiming.*;
import remixlab.util.*;
import remixlab.dandelion.geom.*;
import remixlab.bias.core.*;
import remixlab.dandelion.core.Camera;

import TUIO.*;

import java.util.*;
import java.util.concurrent.*;


/*import java.nio.*;
import java.awt.event.*;

//import java.util.AbstractQueue;

*/

//init proscene//
Scene scene;
//StdCamera cam;

private boolean frameHasBeenMoved;

public void init() {
 // frame.removeNotify();
 // frame.setUndecorated(true);
  //frame.addNotify();

  super.init();
}

TuioProcessing tuioClient;

OscP5 oscP5;
NetAddress pd;

////GLOBALS////

///TUIO ON OFF ///////

//schalter für weltinteraktion
boolean mausInter = true;
boolean tObject = false;
boolean tCursor = true;



/*
ionian
 dorian
 phrygian
 lydian
 mixolydian
 aeolian
 
 */
String[] scalesName = {
  "IONIAN", "DORIAN", "PHRYGIAN", "LYDIAN", "MIXOLYDIAN", "AEOLIAN", "hmm ?"
};
//select scale
int scalesArray = 0;

int[][] scales = { 
  {
 0, 2, 4, 5, 7, 9, 11, 12, 4, 0, 9 ,   -0, -2, -4, -5, -7, -9, -11, -12, -4, -0, -9
  }
  , 
  {
    0, 2, 3, 5, 7, 9, 10, 12, 3, 0, 9  ,-0, -2, -3, -5, -7, -9, -10, -12, -3, -0, -9
  }
  , 
  {
    0, 1, 3, 5, 7, 8, 10, 12, 3, 0, 8,  -0, -1, -3, -5, -7, -8, -10, -12, -3, -0, -8
  }
  , 
  {
    0, 2, 4, 6, 7, 9, 11, 12, 4, 0, 9 ,  -0, -2, -4, -6, -7, -9, -11, -12, -4, -0, -9
  }
  , 
  {
    0, 2, 4, 5, 7, 9, 10, 12, 4, 0, 9,   -0, -2, -4, -5, -7, -9, -10, -12, -4, -0, -9
  }
  , 
  {
    0, 2, 3, 5, 7, 8, 10, 12, 3, 0, 8,  -0, -2, -3, -5, -7, -8, -10, -12, -3, -0, -8
  }
  , 
  {
    0, 1, 3, 5, 6, 8, 10, 12, 3, 0, 8,    -0, -1, -3, -5, -6, -8, -10, -12, -3, -0, -8
  }
  ,
};

int globalTimer =0 ;

//size von Instrumenten, global//
//zahlen die durch 2 teilbar sind?
float iSize = 32;

//blocks pro track
int blockAmount = 50;

//master volume;
float master = 0.85;
Track[] tracks = new Track[3];


//ArrayList soundBodys;
PFont font;

//queues... for tuio events///
AbstractQueue<CHelper> addQueue = new ConcurrentLinkedQueue<CHelper>();

AbstractQueue<Long> killQueue= new ConcurrentLinkedQueue<Long>();
//queue for maus event
AbstractQueue<Integer> resetQueue= new ConcurrentLinkedQueue<Integer>();

//queue to remove empty instruments
AbstractQueue<Integer> emptyInstQ = new ConcurrentLinkedQueue<Integer>();


//queue for track switching
AbstractQueue<Integer> switchTrack = new ConcurrentLinkedQueue<Integer>();

//TuioCursor Container//
HashMap<Long, CHelper> tcursorMap = new HashMap<Long, CHelper>();

//Hashmap for Instruments
HashMap<Integer, Instrument> soundBodys = new HashMap<Integer, Instrument>();

Options inter;
//sonstige globals//
//globale mausposition 2d->3d
PVector globalMaus;
//buffer für gedraggte maus
int mausDragId;
//buffer für TUIO doubletap
TuioPoint tuioLastTap;
boolean mausDrag;
boolean mausDragUncheck;
boolean bewegung;
Iterator itr;

//counter für soundBodys
int bodyCount;
//zufällige farbe zur abwechslung ;)
int sketchFarbe=(int) random (360);
int sketchTrans = 65;
int sketchSat = 54 ;
int sketchHell = 80;



int aktiveCubes;

int fokusTrack = 0;

float globalZoom = 1100.0;
float geasing = 1;

float sWinkel = QUARTER_PI-0.18;

float camRotDesti = QUARTER_PI-0.18;
float camRot = QUARTER_PI-0.18;

Vec  camOr = new Vec();
float camZoomDesti = 1;
float camZoom = 1;

float globalMenuZ = 60;
/*
///
 Setup
 ///
 */

void setup() {
  //size 16:10
  size(1280, 800, P3D);
frame.setLocation(0,-1);

  colorMode(HSB, 360, 100, 100, 100);
  rectMode(CENTER);
  //sphereDetail(10);
  noSmooth();
  noStroke();

prepareExitHandler();

  //proSceneCam//
  scene = new Scene(this);
  

  frameRate(60);

  //camera setup//
  //scene.setCameraType(Camera.Type.ORTHOGRAPHIC);
  scene.setRadius(400);
 // scene.setGridIsDrawn(false);
 // scene.setAxisIsDrawn(false);
  scene.camera().setFieldOfView(PI/7);
  scene.camera().setPosition(new Vec(0, 50, globalZoom));
  

  scene.camera().frame().rotateAroundPoint(new Quat(new Vec(0, 0, 1), QUARTER_PI), new Vec(0, 0, 0) );
  scene.camera().frame().rotateAroundPoint(new Quat(new Vec(-1, 0, 0), sWinkel), new Vec(0, 0, 0) );


  camOr = scene.camera().position();
  //proScene keyboard und mouse//

scene.disableKeyboardAgent();
scene.disableMotionAgent();

  

  //tuio client//
  tuioClient = new TuioProcessing(this);

  //OSC lib
  oscP5 = new OscP5(this, 12000);
  pd = new NetAddress("localhost", 12000);

  //inits
  globalMaus = new PVector(0, 0, 0);
  mausDragUncheck = true;
  bodyCount = 0;


  font = createFont("font.TTF", 220);

  textFont(font); 
  textSize(8);

  for (int i= 0; i < tracks.length; i++) {
    tracks[i] = new Track(i, false);
  }

  //erste ebene aktivieren
  tracks[0].fokus = true;

  inter = new Options();

  //tracks[0].fokus = true;
  oneTimeSetup();
}


/*
///
 //DRAW
 ///
 */

void draw() {

  
  if (!frameHasBeenMoved) {
   frame.setLocation(0,0);
  frameHasBeenMoved = true; 
    
  }
  //wichtig! , zuerst
  getQueues();

  if (frameCount%100==0) {

    scanEbene();
  }
  //cursor 3d positionen updaten

  if (tCursor) {
    Iterator itrA = tcursorMap.values().iterator();
    while (itrA.hasNext ()) {
      CHelper cccc = (CHelper) itrA.next();
      cccc.updateWorldPos();
    }
  }

  //getCursorWorldPos();
  //doubleTapRemove();
  println(frameRate);
  //println(soundBodys.size());

  //aktive cubes zählen
  aktiveCubes = 0;

  for (int i=0; i<tracks.length; i++) {
    if (tracks[i].fokus) {
      tracks[i].countActiveCubes();
    }
  }

  //println(aktiveCubes);


  //tuio cursors
  if (tCursor) { 
    for (int i=0; i< tracks.length; i++) {
      if ( (tracks[i].fokus) && (!tracks[i].setupMode) ) {
        tracks[i].cursorInteraction();
        tracks[i].piano();
      }
    }
  }

  //doubleTaps in die Landschaft ausführen nachdem alles oben gelinkt wurde

  // if (buildMode) {
  //tapAdd();
  //}

  beleuchtung();
  //makeGrid();
  //showGlobalMaus();
  // showArrayGrid();


  //update instrumen infos
  instrumentUpdates();
  //remove empty instruments from hashmap
  removeInstruments();

  //hintergrundebene erstellen
  pushMatrix();
  rotateZ(QUARTER_PI);
  fill(0, 0, 0, 100);
  rect(0, 0, 2000, 2000);
  popMatrix();



  //globales menue aktivieren


  //zeichnen
  for (int i=0; i < tracks.length; i++) {
    if (tracks[i].fokus) {
      tracks[i].animate();
    } 
    else {
      tracks[i].mini();
      tracks[i].notDisplay();
    }
  }


  //play musik

  for (int i =0; i < tracks.length; i++) {
    tracks[i].music();
  }
  //globales menue
  inter.update();
  inter.display();

  //timer 
  globalTimer++;

  camUpdate();
}


void camUpdate() {


  if (tracks[fokusTrack].buildMode) {
    camRotDesti = sWinkel ;
    camZoomDesti = 1.0;
    //globalMenuZ = 40;
  } 
  else if (tracks[fokusTrack].playMode) {
    camRotDesti = sWinkel ;
    camZoomDesti = 1.0;
    //globalMenuZ = 60;
  } 
  else if (tracks[fokusTrack].setupMode) {
    camRotDesti = sWinkel -0.3;
    camZoomDesti = 1.3;
  }
  else if (tracks[fokusTrack].beatMode) {
    camRotDesti = sWinkel -0.3;
    camZoomDesti = 1.3;
    //globalMenuZ = 500;
  }

  if (inter.aktiv) {
    //camZoomDesti = 1.5; 
    //camRotDesti = sWinkel + 0.4;
  } 
  else {
    //camZoomDesti = 1; 
    // camRotDesti = sWinkel;
  }



  float CR = camRotDesti - camRot;
  if (abs(CR) > 0.01) {
    camRot += CR * 0.09;
    //println(camRot);

    scene.camera().frame().rotateAroundPoint(new Quat(new Vec(-1, 0, 0), (CR*0.09)), new Vec(0, 0, 0) );
    bewegung = true;
  } 
  else {         
    // camRot =  camRotDesti;
    bewegung = false;
  }


  float CZ = camZoomDesti - camZoom;
  if (abs(CZ) > 0.01) {
    camZoom += CZ * 0.09;
    //println(camZoom);
   
    Vec zoomTemp = Vec.multiply(camOr, camZoom);
    scene.camera().setPosition(zoomTemp);
    bewegung = true;
  } 
  else {          
    bewegung = false;
  }
}

void keyPressed() {
  if (key =='x') {

    saveFrame("screen###.png");
  }

  if (key == 'r') {

    //buggy 
    for (int i = 0; i < tracks[fokusTrack].rock.length ; i++) {
      tracks[fokusTrack].rock[i].calcPos(new PVector( random(-200, 200), random (-200, 200), 0));
    }
  }

  if (key == 't') {

    inter.aktiv = !inter.aktiv;
  }

  if (key == 'o') {

    for (int i = 0; i < tracks.length; i++) {
      tracks[fokusTrack].setupMode =  !tracks[fokusTrack].setupMode; 
      tracks[fokusTrack].buildMode =  !tracks[fokusTrack].buildMode;
    }
  }


  if (key == 'p') {

    for (int i = 0; i < tracks.length; i++) {
      tracks[fokusTrack].playMode =  !tracks[fokusTrack].playMode;
      tracks[fokusTrack].buildMode =  !tracks[fokusTrack].buildMode;
    }
  }

  if (key == '1') {
    switchTrack.offer(0);
    //camRotDesti = sWinkel;
  }

  if (key == '2') {
    switchTrack.offer(1);
    //camRotDesti = sWinkel+0.5;
  }

  if (key == '3') {
    switchTrack.offer(2);
    // camRotDesti = sWinkel +1;
  }
  
  if (key == 's') {
    playNote( 0, 100, 0.9, 400);
  background(0,100,100);  
    
  }
}

float mtof(float midi) {
  float tempF =  440*pow(2, (midi-69)/12);
  return tempF;
}


void closeSound() {
  Iterator ib = soundBodys.values().iterator();
  while  (ib.hasNext () ) {
    Instrument ins = (Instrument) ib.next();
    if ((ins.trackNr ==  fokusTrack) && (ins.playing)) {
      noteOff(fokusTrack, ins.playedNote);
      ins.playing = false;
    }
  }
  if (tracks[fokusTrack].playing) {
    noteOff(fokusTrack, tracks[fokusTrack].playedNote);
    tracks[fokusTrack].playing = false;
  }
}

void oneTimeSetup() {
  for (int i = 0; i < tracks.length; i++) {
    setCarrierW(i, i);
    setModW(i, i); 

    OscMessage panSpeed = new OscMessage("/s"+i+"/pan/speed");
    panSpeed.add(5); 
    oscP5.send(panSpeed, pd);

    adsrSetup( i, i+1);

    panSpeed =new OscMessage("/s"+i+"/controlmode");
    panSpeed.add(0);
    oscP5.send(panSpeed, pd);
    
    OscMessage mGain = new OscMessage("/s"+i+"/gain");
    mGain.add(0.85);
    oscP5.send(mGain, pd);
    
  }
}

private static void prepareExitHandler() {
      Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
            public void run() {
                  System.out.println("SHUTDOWN HOOK");
            }
      }));
}   
