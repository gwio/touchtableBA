//Interactions

//MAUSposition in 3d bestimmen
void mouseMoved() {
  ///Maus
  for (int i=0; i < tracks.length; i++) {
    if (tracks[i].fokus) {
      tracks[i].checkMaus();
    }
  }

  if (mausInter) {
    globalMaus = getWorldPos(mouseX, mouseY);
  }
}

void mousePressed() {
  if ( (!mausDrag) && (mouseEvent.getClickCount()==2) ) {
    dClickHelp();
  }
}


void dClickHelp() {
  if (!inter.aktiv) {
    boolean noHoverMaus = true;

    for (int i=0; i <tracks[fokusTrack].rock.length; i++) {
      if (tracks[fokusTrack].rock[i].hoverMaus) {
        int ii = (int) ((tracks[fokusTrack].rock[i].pX+(iSize/2))/iSize)+tracks[fokusTrack].ebene.length/2;
        int jj = (int) ((tracks[fokusTrack].rock[i].pY+(iSize/2))/iSize)+tracks[fokusTrack].ebene.length/2;

        noHoverMaus = false;
        tracks[fokusTrack].rock[i].hoverMaus = false;
        tracks[fokusTrack].rock[i].aktiv = false;
        tracks[fokusTrack].rock[i].isPartOfBody = false;
        tracks[fokusTrack].rock[i].editMode = true;
        tracks[fokusTrack].rock[i].deactivateANI = true;
        tracks[fokusTrack].ebene[ii][jj].frei = true;
        tracks[fokusTrack].ebene[ii][jj].rockArId = -1;

        resetQueue.offer(i);

        break;
      }
    }

    if (noHoverMaus) {
      for (int j= 0; j< tracks[fokusTrack].rock.length; j++) {
        if (!tracks[fokusTrack].rock[j].aktiv) {
          tracks[fokusTrack].rock[j].dia=0;        
          tracks[fokusTrack].rock[j].calcPos(globalMaus);

          tracks[fokusTrack].rock[j].activateANI = true;
          break;
        }
      }
    }
  }
}                 


void tapRemove(int id) {
  int ii = (int) ((tracks[fokusTrack].rock[id].pX+(iSize/2))/iSize)+tracks[fokusTrack].ebene.length/2;
  int jj = (int) ((tracks[fokusTrack].rock[id].pY+(iSize/2))/iSize)+tracks[fokusTrack].ebene.length/2;
  tracks[fokusTrack].rock[id].hoverTcur = false;
  // rock[id].hoverMaus = false;
  tracks[fokusTrack].rock[id].aktiv = false;
  tracks[fokusTrack].rock[id].isPartOfBody = false;
  tracks[fokusTrack].rock[id].editMode = true;
  tracks[fokusTrack].rock[id].deactivateANI = true;
  tracks[fokusTrack].ebene[ii][jj].frei = true;
  tracks[fokusTrack].ebene[ii][jj].rockArId = -1;

  resetQueue.offer(id);
}

//add cubes at doubleTap cursors position
void tapAdd() {
  if (  (tCursor) ) {
    itr = tcursorMap.values().iterator();
    while (itr.hasNext ()) {
      CHelper ccc = (CHelper) itr.next();
      //ccc.updateWorldPos();


      if ((ccc.doubelTap) && (!ccc.gebraucht)) {
        ccc.gebraucht = true;  
        for (int j= 0; j< tracks[fokusTrack].rock.length; j++) {
          if ((!tracks[fokusTrack].rock[j].aktiv) && (tracks[fokusTrack].rock[j].dia == iSize)) {
            tracks[fokusTrack].rock[j].dia=0;        
            tracks[fokusTrack].rock[j].calcPos(ccc.posi);

            tracks[fokusTrack].rock[j].activateANI = true;
            break;
          }
        }
      }
    }
  }
}


void mouseDragged() {
  boolean mouseCollision = false;

  //damit blöcke auhc in bewegung aufgesammelt werden können
  for (int i=0; i < tracks[fokusTrack].rock.length; i++) {
    tracks[fokusTrack].rock[i].checkMausInter();
  }

  if (mausInter) {
    globalMaus = getWorldPos(mouseX, mouseY);
  }

  if (!mausDrag) {
    for (int i=0; i< tracks[fokusTrack].rock.length; i++) {
      if (tracks[fokusTrack].rock[i].hoverMaus) {
        mausDragId = i;
        //status ob ein wüfel gezogen wird
        mausDrag = true;
        tracks[fokusTrack].rock[i].editMode = true;
        break;
      }
    }
  }

  if ( (mausDrag) && (mausDragUncheck) ) {
    tracks[fokusTrack].ebene[(int)((tracks[fokusTrack].rock[mausDragId].pX+(iSize/2))/iSize)+tracks[fokusTrack].ebene.length/2][(int)((tracks[fokusTrack].rock[mausDragId].pY+(iSize/2))/iSize)+tracks[fokusTrack].ebene.length/2].frei = true;
    tracks[fokusTrack].ebene[(int)((tracks[fokusTrack].rock[mausDragId].pX+(iSize/2))/iSize)+tracks[fokusTrack].ebene.length/2][(int)((tracks[fokusTrack].rock[mausDragId].pY+(iSize/2))/iSize)+tracks[fokusTrack].ebene.length/2].rockArId = -1;


    tracks[fokusTrack].rock[mausDragId].isPartOfBody = false;
    //println(rock[mausDragId].bodyNr+ "partOFBody: " +rock[mausDragId].isPartOfBody+" active: "+rock[mausDragId].aktiv+" editMode: "+rock[mausDragId].editMode+" visible: "+rock[mausDragId].visible+" arrayID ");

    resetQueue.offer(mausDragId);    

    mausDragUncheck = false;
  }


  if (mausDrag) {
    for (int i=0; i<tracks[fokusTrack].rock.length; i++) {
      if ( (!tracks[fokusTrack].rock[i].editMode) && 
        (tracks[fokusTrack].rock[i].visible) && (globalMaus.x > (tracks[fokusTrack].rock[i].pX-tracks[fokusTrack].rock[i].diaX/1.1)) 
        && (globalMaus.x < (tracks[fokusTrack].rock[i].pX+tracks[fokusTrack].rock[i].diaX/1.1)) && 
        (globalMaus.y > (tracks[fokusTrack].rock[i].pY-tracks[fokusTrack].rock[i].diaY/1.1)) && 
        (globalMaus.y < (tracks[fokusTrack].rock[i].pY+tracks[fokusTrack].rock[i].diaY/1.1))  ) {
        mouseCollision = true;
        if (!tracks[fokusTrack].rock[mausDragId].buffered) {
          tracks[fokusTrack].rock[mausDragId].bufferpX = globalMaus.x; 
          tracks[fokusTrack].rock[mausDragId].bufferpY = globalMaus.y;
          tracks[fokusTrack].rock[mausDragId].buffered = true;
        }  
        break;
      }
    }
  }


  /*
bewegung mit collision
   if (  (!mouseCollision) && (mausDrag)) {
   rock[mausDragId].pX = globalMaus.x;
   rock[mausDragId].pY = globalMaus.y;
   }
   */
  if ( (mausDrag)) {

    float dx = globalMaus.x - tracks[fokusTrack].rock[mausDragId].pX;
    if (abs(dx) > 0.01) {
      tracks[fokusTrack].rock[mausDragId].pX += dx * geasing;
    }
    float dy = globalMaus.y - tracks[fokusTrack].rock[mausDragId].pY;
    if (abs(dy) > 0.01) {
      tracks[fokusTrack].rock[mausDragId].pY += dy * geasing;
    }
    //easing oben, uncomment unten zum deaktivieren

    //tracks[fokusTrack].rock[mausDragId].pX = globalMaus.x;
    //tracks[fokusTrack].rock[mausDragId].pY = globalMaus.y;
  }

  if ( (!mouseCollision) && (tracks[fokusTrack].rock[mausDragId].buffered) ) {
    tracks[fokusTrack].rock[mausDragId].buffered = false;
  }
}

void mouseReleased() {

  if (mausDrag) {

    if (tracks[fokusTrack].rock[mausDragId].buffered) {
      tracks[fokusTrack].rock[mausDragId].calcPos(new PVector(tracks[fokusTrack].rock[mausDragId].bufferpX, tracks[fokusTrack].rock[mausDragId].bufferpY));
      tracks[fokusTrack].rock[mausDragId].buffered = false;
    } 
    else {
      tracks[fokusTrack].rock[mausDragId].calcPos(globalMaus);
    }
    mausDrag = !mausDrag;
    mausDragUncheck = true;
  }
}

void showGlobalMaus() {
  println("X: "+globalMaus.x+" Y: "+globalMaus.y+" Z: "+globalMaus.z);
  noFill();
  strokeWeight(4);
  stroke(0, 100, 70);
  line(globalMaus.x, globalMaus.y, 0, globalMaus.x+40, globalMaus.y, 0);
  stroke(80, 100, 70);
  line(globalMaus.x, globalMaus.y, 0, globalMaus.x, globalMaus.y+40, 0);
  stroke(160, 100, 70);
  line(globalMaus.x, globalMaus.y, 0, globalMaus.x, globalMaus.y, globalMaus.z);
  noStroke();
}

////////////TUIO////////////////
///////////////////////////////


//////////////////TUIO Cursor Helper///////////////////
class CHelper {
  PVector posi;
  float xpos, ypos;
  long id;
  int instrument;
  boolean linked, moved, collision, doubelTap, gebraucht, neu;

  CHelper(float xpos_, float ypos_, long id_, boolean dt) {
    xpos = xpos_;
    ypos = ypos_;
    id = id_;
    linked = false;
    doubelTap = dt;
    posi = new PVector(0, 0, 0);
    neu = true;
  }

  void updateWorldPos() {
    if ( (moved) || (neu) ) {
      posi = getWorldPos(xpos, ypos);
      moved = false;
      neu = false;
    }
  }
}

//for cursor hashmap an queue
/////ADD
void addC(float x, float y, long id, boolean dt) {
  x = map(x, 0, 1, 0, width);
  y = map(y, 0, 1, 0, height);
  CHelper temp = new CHelper(x, y, id, dt);
  addQueue.offer(temp);
}

//MOVE
void moveC(float x, float y, long id) {
  CHelper temp = (CHelper) tcursorMap.get(id);
  if (temp!=null) {
    temp.xpos = map(x, 0, 1, 0, width);
    temp.ypos = map(y, 0, 1, 0, height);
    temp.moved = true;
  }
}

//REMOVE
void removeC(long id) {
  killQueue.offer(id);
}



///tuio eigene events

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  println("add object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  println("remove object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  println("update object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
    +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  // println("add cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  boolean doubleT = false;

  if (tuioLastTap != null) {  // only do this if we have a previous tap
    float timeMult = 0.000001;   // getTotalMilliseconds seems to be returning microseconds instead of milliseconds in current TUIO client library :/
    float nowTime = tcur.getTuioTime().getTotalMilliseconds() * timeMult;
    float lastTime = tuioLastTap.getTuioTime().getTotalMilliseconds() * timeMult;
    //        println(nowTime + " - " + lastTime);
    ///HIER DIE 0.0003 höher VERRINGERT DAS doubleTAP TEMPO
    if (nowTime - lastTime < 0.0006  ) {    // check time different between current and previous tap
      float dx = tcur.getX() - tuioLastTap.getX(); // horizontal distance
      float dy = tcur.getY() - tuioLastTap.getY(); // vertical distance
      float d2 = dx * dx + dy * dy; // square of distance between taps
      //            println(d2);
      if (d2 < 0.01) {
        //doubleTap TRUE tuioDoubleTap = true; 
        doubleT = true;
      }
    }
  }
  tuioLastTap = new TuioPoint(tcur); // store info for next tap
  addC(tcur.getX(), tcur.getY(), tcur.getSessionID(), doubleT);
}


// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  // println("update cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
  //  +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  moveC(tcur.getX(), tcur.getY(), tcur.getSessionID());
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  //println("remove cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+")")
  removeC(tcur.getSessionID());
}

// called after each message bundle
// representing the end of an image frame
void refresh(TuioTime bundleTime) {
}

