
void sendCommand(int id) {
  switch(id) {
  case 0: 

    if (inter.mainBut[0].fokus) {
      inter.aktiv = !inter.aktiv;
    }

    if (tracks[fokusTrack].setupMode) {
      tracks[fokusTrack].setupMode = false;
    }

    if (tracks[fokusTrack].beatMode) {
      tracks[fokusTrack].beatMode = false;
    }


    tracks[fokusTrack].buildMode = true;
    tracks[fokusTrack].playMode = false;

    println("build");
    break;
  case 1: 

    if (inter.mainBut[1].fokus) {
      inter.aktiv = !inter.aktiv;
    }

    if (tracks[fokusTrack].setupMode) {
      tracks[fokusTrack].setupMode = false;
    }


    if (tracks[fokusTrack].beatMode) {
      tracks[fokusTrack].beatMode = false;
    }

    tracks[fokusTrack].buildMode = false;
    tracks[fokusTrack].playMode = true;


    closeSound();

    println("play");
    break;
  case 2: 
    for (int i = 0; i < tracks.length; i++) {
      tracks[fokusTrack].reset();
    }
    closeSound();
    println("reset");
    break;
  case 3:
    println("options");
    tracks[fokusTrack].buildMode = false;
    tracks[fokusTrack].playMode = false;
    tracks[fokusTrack].beatMode = false;
    tracks[fokusTrack].setupMode = !tracks[fokusTrack].setupMode;
    inter.aktiv = false;
    break;

  case 4:
    println("beats");
    tracks[fokusTrack].buildMode = false;
    tracks[fokusTrack].playMode = false;
    tracks[fokusTrack].setupMode = false;
    tracks[fokusTrack].beatMode = !tracks[fokusTrack].beatMode;
    inter.aktiv = false;
    break;

  case 5:
    println("pause");
    closeSound();
    tracks[fokusTrack].pause = !tracks[fokusTrack].pause;

    break;

  case 6:
    println("options");
    tracks[fokusTrack].buildMode = false;
    tracks[fokusTrack].playMode = false;
    tracks[fokusTrack].beatMode = false;
    tracks[fokusTrack].setupMode = !tracks[fokusTrack].setupMode;
    inter.aktiv = false;
    break;

  case 7:
    println("scales");
    scalesArray++;
    if (scalesArray == scales.length) {
      scalesArray = 0;
    }
    inter.mainBut[7].name = scalesName[scalesArray];
    break;
  }
}


void scanEbene() {


  //scan the whole grid
  for (int x = 1; x < tracks[fokusTrack].ebene.length -1; x++) {
    for (int y = 1; y < tracks[fokusTrack].ebene[x].length -1; y++) {
      //if block present...
      if ((!tracks[fokusTrack].ebene[x][y].frei) && (tracks[fokusTrack].ebene[x][y].rockArId >= 0)) {

        int[] n = new int[9];
        int nC = 0;
        int openSpace =0;
        ///...check all adjacent positions for other blocks
        for (int kx = -1; kx <=1 ;kx++) {
          for (int ky = -1;ky <=1; ky++) {
            // when there ist an soundBody, add the block to the soundBody
            if ((!tracks[fokusTrack].ebene[x+kx][y+ky].frei) && (tracks[fokusTrack].ebene[x+kx][y+ky].rockArId >= 0) && (tracks[fokusTrack].rock[tracks[fokusTrack].ebene[x+kx][y+ky].rockArId].isPartOfBody)) {                                
              //store and compare all the neighbour instruments
              n[nC] = tracks[fokusTrack].rock[tracks[fokusTrack].ebene[x+kx][y+ky].rockArId].bodyNr;          
              nC ++;
            }

            if ( ( ((kx == 0)&&(ky == -1)) || ((kx == -1)&&(ky == 0)) || ((kx == 1)&&(ky == 0)) || ((kx == 0)&&(ky == 1)) ) && (tracks[fokusTrack].ebene[x+kx][y+ky].frei) ) {
              openSpace ++;
            }
          }
        }

        tracks[fokusTrack].rock[tracks[fokusTrack].ebene[x][y].rockArId].openSpace = openSpace;

        if ( nC > 0) {

          int nSize = 0;
          int bodyN = 0;
          //get the biggest Instrument
          for (int t= 0; t < n.length; t++) {
            if (n[t] != 0) {
              Instrument iTemp = (Instrument) soundBodys.get(n[t]);
              if ( (iTemp != null) && (iTemp.anzahlCubes > nSize) ) {
                nSize = iTemp.anzahlCubes;
                bodyN = n[t];
              }
            }
          }

          //.. add cube to the biggest instrument      
          tracks[fokusTrack].rock[tracks[fokusTrack].ebene[x][y].rockArId].isPartOfBody = true;
          if (tracks[fokusTrack].rock[tracks[fokusTrack].ebene[x][y].rockArId].bodyNr != bodyN) {        
            tracks[fokusTrack].rock[tracks[fokusTrack].ebene[x][y].rockArId].bodyNr = bodyN;
          }
        }

        if (nC == 0) {
          //if not, make an new soundbody
          bodyCount++;
          soundBodys.put(bodyCount, new Instrument(bodyCount, fokusTrack) );
          //soundBodys.add(new Instrument(bodyCount, temp)); 
          tracks[fokusTrack].rock[tracks[fokusTrack].ebene[x][y].rockArId].bodyNr = bodyCount;
          tracks[fokusTrack].rock[tracks[fokusTrack].ebene[x][y].rockArId].isPartOfBody = true;
        }
      }
    }
  }
}



void removeInstruments() {

  Iterator i = soundBodys.values().iterator();
  while  (i.hasNext () ) {
    Instrument ins = (Instrument) i.next();  
    //println(ins.anzahlCubes+"  opens: "+ins.openSpace);
    if (ins.anzahlCubes <= 0) {

      if (ins.playing) {
        noteOff(ins.trackNr, ins.playedNote);
      }

      emptyInstQ.offer(ins.id);
    }
  }
}



//scans the layer grid for adjacent blocks
//all adjacent blocks == one instrument// +1/-1 to ignore the borders


void instrumentUpdates() {

  for (int i = 0; i < tracks.length; i++) {
    tracks[i].aktiveInst = 0;
  }
  Iterator i = soundBodys.values().iterator();
  while  (i.hasNext () ) {
    Instrument ins = (Instrument) i.next();  
    ins.updateCubesCount();

    if (ins.trackNr == 0) {
      tracks[0].aktiveInst++;
    }

    if (ins.trackNr == 1) {
      tracks[1].aktiveInst++;
    }

    if (ins.trackNr == 2) {
      tracks[2].aktiveInst++;
    }

    //provisorisch zum testen
  }
}


void resetBodyNr(int id) {
  //remove the instrument id from all adjacent block to redraw when removing from existing instrument
  for (int b = 0; b< tracks[fokusTrack].rock.length; b++) {
    if (tracks[fokusTrack].rock[b].bodyNr == tracks[fokusTrack].rock[id].bodyNr) {
      tracks[fokusTrack].rock[b].isPartOfBody = false;
    }
  } 
  //scanEbene();
}

void showArrayGrid() {
  for (int i = 0; i < tracks[fokusTrack].ebene.length; i++) {
    for (int j = 0; j < tracks[fokusTrack].ebene[i].length; j++) {
      // if (tracks[fokusTrack].ebene[i][j].frei == false) {
      pushMatrix();
      // scale(0.1);
      translate( ((i-(tracks[fokusTrack].ebene.length/2))*iSize)-iSize/2, ((j-(tracks[fokusTrack].ebene.length/2))*iSize)-iSize/2, 10) ;

      fill(0, 0, 50);
      box(iSize/4);
      // rect(0, 0, iSize, iSize);       
      popMatrix();
      // }
    }
  }
}
//Tuio Curso Queues
void getQueues() {


  while (switchTrack.peek () !=null) {
    int tempST = (int) switchTrack.poll();

    Iterator j = tcursorMap.values().iterator();
    while ( (j.hasNext ()) ) {
      CHelper c = (CHelper) j.next(); 
      killQueue.offer(c.id);
    }

    for (int i= 0; i < tracks.length; i++) {      

      if (i == tempST) {
        tracks[i].fokus = true;
        fokusTrack = i;
      } 
      else {
        tracks[i].fokus = false;
      }
      //buildMode = true;
    }
  }

  if (tCursor) {
    // first process the queues
    // delet old counter
    while (killQueue.peek () != null) {
      tcursorMap.remove(killQueue.poll());
    } 
    //add new counter
    while (addQueue.peek () != null) {
      CHelper tt = addQueue.poll();
      Long tId = tt.id;
      //print (temp);
      tcursorMap.put(tId, tt);
    }
  }

  while (resetQueue.peek () !=null) {
    resetBodyNr(resetQueue.poll());
  }

  while (emptyInstQ.peek () !=null) {
    soundBodys.remove(emptyInstQ.poll());
  }
}

//Projektion von Maus und Touch berechnen
PVector getWorldPos(float x, float y) {
  PVector tempVect = new PVector(x, y, 0);
  PVector testR = pointUnderPixel(tempVect);
  return testR;
}


/*
//3d Position aller Cursor aktualisieren und DoubleTaps versenden
 void getCursorWorldPos() {
 if (tCursor) {
 itr = tcursorMap.values().iterator();
 while (itr.hasNext ()) {
 CHelper ccc = (CHelper) itr.next();
 ccc.updateWorldPos();
 }
 }
 }
 */


//Szene Ausleuchtung
void beleuchtung() {
  background(0, 0, 100);

  lights();
 // pointLight(sketchFarbe, 80, 40, 0, 0, 120);
  //pointLight(200, 80, 60, 200, 200, 300);
    pointLight(00, 0,40, -100,100, 150);
  if ( tracks[fokusTrack].playing ) {
   
   //directionalLight(sketchFarbe+10, 50, 60, 0.7, -0.2, 0.7 );
  }

  directionalLight(0, 70, 100, -20, 20, 22);
//  pointLight(00, 80, 70, 100, 100, 20);
  shininess(0.6);
  specular(0.2);
}


//Raster zum testen
void makeGrid() {
  strokeWeight(1);
  stroke(0, 0, 80);
  for (int i=-(int)iSize*100; i < 1000; i += iSize) {
    line (i, 2000, (iSize/2)+0.1, i, -2000, (iSize/2)+0.1);
  }
  for (int i=-(int)iSize*100; i < 1000; i += iSize) {
    line (2000, i, (iSize/2)+0.1, -2000, i, (iSize/2)+0.1);
  }
}



// Mausprojetion 2d-3d
/*
class GLCamera extends Camera {
  protected PGraphicsOpenGL pgl;
  protected GL gl;
  protected GLU glu;

  public GLCamera(Scene scn) {
    super(scn);
    pgl = (PGraphicsOpenGL) pg3d;
    gl = pgl.gl;
    glu = pgl.glu;
  }

  public WorldPoint pointUnderPixel(Point pixel) {
    float []depth = new float[1];
    pgl.beginGL();
    gl.glReadPixels((int)pixel.x, (screenHeight() - (int)pixel.y), 1, 1, GL.GL_DEPTH_COMPONENT, GL.GL_FLOAT, FloatBuffer.wrap(depth));
    pgl.endGL();
    PVector point = new PVector((int)pixel.x, (int)pixel.y, depth[0]);
    point = unprojectedCoordinatesOf(point);
    return new WorldPoint(point, (depth[0] < 1.0f));
  }
}
*/

PVector pointUnderPixel(PVector pixel) {
  /*
  float []depth = new float[1];
  glCam.pgl.beginGL();
  glCam.gl.glReadPixels((int)pixel.x, (int)height-(int)pixel.y, 1, 1, GL.GL_DEPTH_COMPONENT, GL.GL_FLOAT, FloatBuffer.wrap(depth));
  glCam.pgl.endGL();
  PVector point = new PVector((int)pixel.x, (int)pixel.y, depth[0]);
  point = glCam.unprojectedCoordinatesOf(point);
  */
  Vec pup;
  pup =  scene.pointUnderPixel(new Point(pixel.x,pixel.y) );
  PVector point = new PVector(pup.x(),pup.y(),0);
  return point;
}



void textureCube(float dia_) {

  beginShape();
  vertex( -(dia_/2), -(dia_/2), -(dia_/2) );
  vertex( +(dia_/2), -(dia_/2), -(dia_/2) );
  vertex( +(dia_/2), +(dia_/2), -(dia_/2) );
  vertex( -(dia_/2), +(dia_/2), -(dia_/2) );
  endShape();

  beginShape();
  vertex( -(dia_/2), -(dia_/2), -(dia_/2) );
  vertex( -(dia_/2), +(dia_/2), -(dia_/2) );
  vertex( -(dia_/2), +(dia_/2), +(dia_/2) );
  vertex( -(dia_/2), -(dia_/2), +(dia_/2) );
  endShape();

  beginShape();
  vertex( -(dia_/2), -(dia_/2), +(dia_/2) );
  vertex( +(dia_/2), -(dia_/2), +(dia_/2) );
  vertex( +(dia_/2), +(dia_/2), +(dia_/2) );
  vertex( -(dia_/2), +(dia_/2), +(dia_/2) );
  endShape();

  beginShape();
  vertex( +(dia_/2), -(dia_/2), +(dia_/2) );
  vertex( +(dia_/2), -(dia_/2), -(dia_/2) );
  vertex( +(dia_/2), +(dia_/2), -(dia_/2) );
  vertex( +(dia_/2), +(dia_/2), +(dia_/2) );
  endShape();

  beginShape();
  vertex( +(dia_/2), +(dia_/2), +(dia_/2) );
  vertex( +(dia_/2), +(dia_/2), -(dia_/2) );
  vertex( -(dia_/2), +(dia_/2), -(dia_/2) );
  vertex( -(dia_/2), +(dia_/2), +(dia_/2) );
  endShape();

  beginShape();
  vertex( -(dia_/2), -(dia_/2), +(dia_/2) );
  vertex( +(dia_/2), -(dia_/2), +(dia_/2) );
  vertex( +(dia_/2), -(dia_/2), -(dia_/2) );
  vertex( -(dia_/2), -(dia_/2), -(dia_/2) );
  endShape();
}
