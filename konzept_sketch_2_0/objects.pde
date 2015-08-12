
//Grundklasse für alle Interaktionen
class iObject {
  //generell an aus schalter für funktionen
  boolean aktiv;
  //schalter für edit mode, ignoriert collisionabfragen ect
  boolean editMode;
  //breite, länge
  //sichtbar/unsichtbar
  boolean visible;
  // wichtig: dont change dia while moving objects with cursors oder mouse, grid gets buggy
  float dia, diaX, diaY;
  //position
  float pX, pY, pZ, rX, rY, rZ;
  //eigene iD im array
  int aID;
  //positionbuffer und bufferstatus
  boolean buffered;
  float bufferpX, bufferpY, bufferpZ, bufferrX, bufferrY, bufferrZ;
  //material
  float farbe, sat, hell, trans;
  float colorOff;

  //color destination, animation
  int desti;
  //track nr
  int trackId;

  //status ob ein cursorobjekt auf der position liegt
  boolean linked;
  //welcher cursor ist aktiv
  boolean hoverMaus, hoverTobj, hoverTcur;
  //verlinkter tuioCursor
  Long linkedCursorId;

  boolean pressed, used;

  iObject() {
    pX = 0;
    pY = 0;
    pZ = 0;
    rX = 0;
    rY = 0;
    rZ = 0;

    farbe = sketchFarbe ;
    sat = sketchSat ;
    hell = sketchHell ;
    trans = sketchTrans;
    colorOff =(int) random(-15,15);
  }

  //maus 
  void checkMausInter() {
    if ( (aktiv) && (!editMode) &&(mausInter) ) {
      if ( (globalMaus.x > (pX-diaX/1.9)) && (globalMaus.x < (pX+diaX/1.9)) && (globalMaus.y > (pY-diaY/1.9)) && (globalMaus.y < (pY+diaY/1.9))  ) {
        hoverMaus = true;
      } 
      else {
        hoverMaus = false;
      }
    }
  }

  //link objects to cursors
  void linkTcursor() {
    if ((!editMode) && (aktiv)) {
      Iterator i = tcursorMap.values().iterator();
      while ( (!linked) && (i.hasNext()) ) {
        CHelper c = (CHelper) i.next();  
        if (  (c.posi.x > (pX-diaX/1.9)) && (c.posi.x < (pX+diaX/1.9)) && (c.posi.y > (pY-diaY/1.9)) && (c.posi.y < (pY+diaY/1.9))  ) {        
          if ((!c.doubelTap) && (!c.linked) ) {
            hoverTcur = true;
            linkedCursorId = c.id;
            linked = true;
            c.linked = true;
            editMode = true;      
            break;
          } 
          else if ( (!tracks[trackId].playMode) && (c.doubelTap) && (!c.gebraucht) &&  (dia == iSize)) {
            tapRemove(aID);
            c.gebraucht = true;
            break;
          }
        }
      }
    }
  }

  //delink objects from cursors
  void delinkTcursor() {
    if (linked) {
      CHelper temp = (CHelper) tcursorMap.get(linkedCursorId);
      if (temp==null) {
        linked = false;
        hoverTcur = false;
        //vorsicht, vllt buggy
        editMode = false;
      }
    }
  }
}


////
////////
////////////Block//////////
//////////////////////////////
/////////////////////////
class Block extends iObject {

  //helper for ebenen[][]
  boolean unmarked;
  //animationen
  boolean deactivateANI, activateANI;

  boolean isPartOfBody;
  int bodyNr;
  int openSpace;

  //for playmode
  float playedPitch;
  boolean pressed;
  boolean played;

  boolean removeC;

  float tempX, tempY, tempZ, tempRX, tempRY, tempRZ, tempSca;

  Block(int iD, int trackId_) {
    pZ = (iSize/2)+0.1;
    dia = iSize;
    diaX = iSize;
    diaY =iSize;
    openSpace = 0;
    aID = iD;
    trackId = trackId_;
    pressed = false;
    played = false;
  }

  Block(float posx_, float posy_, int id, int trackId_) {
    pX=posx_;
    pY=posy_;
    pZ = (iSize/2)+0.1;
    dia = iSize;
    diaX =iSize;
    diaY = iSize;
    openSpace = 0;
    aID = id;
    trackId = trackId_;
    pressed = false;
    played = false;
  }

  ///// //Zeichnen////////
  void display() { 
    if (visible) { 

      if (desti != (tracks[trackId].trackMenu.auswahl[tracks[trackId].trackMenu.selectOben].farbe)  ) {
        desti += 1;
        if (desti > 360) {
          desti = 0;
        }
      }


      if (trans <= sketchTrans) {
        trans ++;
      }




      noStroke();

      if (  (hoverMaus) || (hoverTobj) ||   (linked) || (hoverTcur) ) {
        fill( desti+colorOff, sat+colorOff+45, hell+colorOff, trans+colorOff);
      } 
      else {
        //fill(tracks[trackId].trackMenu.auswahl[selectOben].farbe, sat hell trans);
        fill(desti+colorOff, tracks[trackId].trackMenu.auswahl[tracks[trackId].trackMenu.selectUnten].sat+colorOff, hell+colorOff, trans+colorOff);
      }
      pushMatrix();


     // int ii = (int) ((pX+(iSize/2))/iSize)+tracks[trackId].ebene.length/2;
     // int jj = (int) ((pY+(iSize/2))/iSize)+tracks[trackId].ebene.length/2;

      //////x
      float dx = pX - tempX;
      if (abs(dx) > 0.01) {
        tempX += dx * 0.1;
      } 
      else {
        tempX =  pX;
      } 

      ///////////y
      float dy = pY - tempY;
      if (abs(dy) > 0.01) {
        tempY += dy * 0.1;
      } 
      else {
        tempY =  pY;
      }

      //////////r X 
      if (tempSca > 0.2) {
        //////////////z      
        float dz = pZ - tempZ;
        if (abs(dz) > 0.04) {
          tempZ += dz * geasing;
        } 
        else {
          tempZ =   pZ;
        }

        float drx = rX - tempRX;
        if (abs(drx) > 0.01) {
          tempRX += drx * 0.04;
        } 
        else {
          tempRX =   rX;
        }
        //////r Z
        float drz = rZ - tempRZ;
        if (abs(drz) > 0.01) {
          tempRZ += drz * 0.04;
        } 
        else {
          tempRZ =   rZ;
        }
      }


      ////////scale
      float dsca = 1.0 - tempSca;
      if (abs(dsca) > 0.01) {
        tempSca += dsca * 0.02;
      } 
      else {
        tempSca =  1.0;
      }







      translate(tempX, tempY, tempZ);
      rotateX(tempRX);
      rotateY(tempRX);

      rotateZ(tempRZ);
      if (tempSca < 1.0) {
        scale(tempSca);
      }

      //  translate( ((ii-(tracks[trackId].ebene.length/2))*iSize)-iSize/2, ((jj-(tracks[trackId].ebene.length/2))*iSize)-iSize/2, 0) ;

      if ((inter.aktiv) || (tracks[fokusTrack].beatMode) || (tracks[fokusTrack].setupMode) ) {

        trans = 13;
        // fill(desti, sat, hell, trans-90);
      } 
      
      if (tracks[fokusTrack].pause) {
       fill(desti+colorOff, tracks[trackId].trackMenu.auswahl[tracks[trackId].trackMenu.selectUnten].sat+colorOff, hell+colorOff-40, trans+colorOff);
      }
      
        
      
      box(dia);

      popMatrix();
    }  

    //text für debug
    /*
    if (isPartOfBody) {
     pushMatrix();
     translate(pX, pY, pZ+iSize);
     rotateX(PI+HALF_PI);
     
     
     fill((farbe+(bodyNr*18))%360, 55, 22);
     text(bodyNr, 0.0, 0.0);
     //fill(bodyNr*10,80,80);
     // sphere(6);
     popMatrix();
     }
     */
  }

  //animation open close track
  void notDisplay() {
    if (visible) {

      int ii = (int) ((pX+(iSize/2))/iSize)+tracks[trackId].ebene.length/2;
      int jj = (int) ((pY+(iSize/2))/iSize)+tracks[trackId].ebene.length/2;

      //////x
      float dx = (tracks[trackId].mapPos.x) - tempX;
      if (abs(dx) > 0.01) {
        tempX += dx * 0.1;
      } 
      else {
        tempX =   (tracks[trackId].mapPos.x);
      } 

      ///////////y
      float dy = (tracks[trackId].mapPos.y) - tempY;
      if (abs(dy) > 0.01) {
        tempY += dy * 0.1;
      } 
      else {
        tempY =   (tracks[trackId].mapPos.y);
      }

      //////////r X 
      if (tempSca < 0.2) {
        //////////////z      
        float dz = globalMenuZ - tempZ;
        if (abs(dz) > 0.04) {
          tempZ += dz * 0.04;
        } 
        else {
          tempZ =   globalMenuZ;
        }

        float drx = (TWO_PI+0.65) - tempRX;
        if (abs(drx) > 0.01) {
          tempRX += drx * 0.04;
        } 
        else {
          tempRX =   (TWO_PI+0.65);
        }
        //////r Z
        float drz = (tracks[trackId].rZ) - tempRZ;
        if (abs(drz) > 0.01) {
          tempRZ += drz * 0.04;
        } 
        else {
          tempRZ =   (tracks[trackId].rZ);
        }
      }


      ////////scale
      float dsca = (tracks[trackId].miniScale) - tempSca;
      if (abs(dsca) > 0.01) {
        tempSca += dsca * 0.12;
      } 
      else {
        tempSca =  tracks[trackId].miniScale;
      }

      pushMatrix();
      
      translate(tempX, tempY, tempZ);
      

rotateX(tempRX);
      rotateY(tempRX);
      //rotateZ( degrees(tempRZ));
      rotateZ( tempRZ);
      
      scale(tempSca);
      translate( ((ii-(tracks[trackId].ebene.length/2))*iSize)-iSize/2, ((jj-(tracks[trackId].ebene.length/2))*iSize)-iSize/2, 0) ;
      
      
      
      ////////////test performance
      if ( (aktiv) && (visible) && ((tracks[fokusTrack].harmonic) || (tracks[fokusTrack].melodic)) && (!tracks[fokusTrack].playMode)) {
      Instrument blub = (Instrument) soundBodys.get(bodyNr);
      if ((blub != null) && (blub.playing)) {
        played = true;
      } 
      else {
        played = false;
      }
    }
     ///////////// 
      
      if (played) {
        fill(desti, 80, hell, 100);
                  
        
      } else {
      fill(desti, 0, hell, trans);
      }
      box(iSize);


      popMatrix();
    }
  }


  void animation() {

    if (deactivateANI) {
      dia -= 2;
      if (dia <= 0) {
        visible = false;
        deactivateANI = false;
        dia  = iSize;
      }
    }

    if (activateANI) {
      dia += 2;
      if (dia >= iSize) {
        dia = iSize;     
        activateANI = false;
      }
    }


    if ( (aktiv) && (visible) && ((tracks[fokusTrack].harmonic) || (tracks[fokusTrack].melodic)) && (!tracks[fokusTrack].playMode)) {
      Instrument blub = (Instrument) soundBodys.get(bodyNr);
      if ((blub != null) && (blub.playing)) {
        played = true;
      } 
      else {
        played = false;
      }
    }

    if ((played)) {
      //desti+= random(20);
      //sat += random(-3, 3);
      hell += random (-3,3);
      trans += random(-2, 2);
      //hell = 100;
      desti += random(-1,1);
      pZ = iSize*0.8;
    } 
    else {
      pZ =  (iSize/2)+0.1;
    }
  }

  //Position im Raster bestimmen
  void calcPos(PVector posis) {


    if ( (posis.x < 0) && (posis.y < 0) ) {  
      pX = ((int(posis.x/iSize))*iSize)-(iSize/2) ;
      pY = ((int(posis.y/iSize))*iSize)-(iSize/2) ;
    }

    if ( (posis.x > 0) && (posis.y > 0) ) {  
      pX = ((int(posis.x/iSize))*iSize)+(iSize/2) ;
      pY = ((int(posis.y/iSize))*iSize)+(iSize/2) ;
    }

    if ( (posis.x < 0) && (posis.y > 0) ) {  
      pX = ((int(posis.x/iSize))*iSize)-(iSize/2);
      pY = ((int(posis.y/iSize))*iSize)+(iSize/2) ;
    }

    if ( (posis.x > 0) && (posis.y < 0) ) {  
      pX = ((int(posis.x/iSize))*iSize)+(iSize/2) ;
      pY = ((int(posis.y/iSize))*iSize)-(iSize/2) ;
    }



    //mark position in grid
    //ebene[(int)((pX+(dia/2))/iSize)+ebene.length/2][(int)((pY+(dia/2))/iSize)+ebene.length/2].frei = false; 

    int ii = (int) ((pX+(iSize/2))/iSize)+tracks[trackId].ebene.length/2;
    int jj = (int) ((pY+(iSize/2))/iSize)+tracks[trackId].ebene.length/2;

    if (!tracks[trackId].ebene[ii][jj].frei) {
      //platzhalter event für doppelte würfel
      aktiv = false;
      visible = false;
      isPartOfBody = false;
    } 
    else if (tracks[trackId].ebene[ii][jj].frei) {
      tracks[trackId].ebene[ii][jj].frei = false;
      tracks[trackId].ebene[ii][jj].rockArId = aID;
      editMode = false;
      //isPartOfBody = false;
      aktiv = true;
      visible = true;
      tempX = pX;
      tempY = pY;
      tempZ = pZ;
      tempSca = 1.0;
      //zweimal funzt besser
      //scanEbene();
    }
  }
  ///////////////////////////////////
  //mit tuio cursor bewegen
  void moveWithCursor() {
    if (linked) {
      CHelper temp = (CHelper) tcursorMap.get(linkedCursorId);
      //delinken und ins raster setzte wenn gelinkter tuiocursor verschwindet
      if (temp==null) {
        if (buffered) {
          calcPos(new PVector(bufferpX, bufferpY, 0));
          unmarked = false;
        } 
        else {             
          calcPos(new PVector(pX, pY, 0));
          unmarked = false;
        }
      }
      else {  
        //unmark position in grid
        if (!unmarked) {
          tracks[trackId].ebene[(int)((pX+(iSize/2))/iSize)+tracks[trackId].ebene.length/2][(int)((pY+(iSize/2))/iSize)+tracks[trackId].ebene.length/2].frei = true;
          tracks[trackId].ebene[(int)((pX+(iSize/2))/iSize)+tracks[trackId].ebene.length/2][(int)((pY+(iSize/2))/iSize)+tracks[trackId].ebene.length/2].rockArId = -1;
          isPartOfBody = false;
          unmarked = true;
          editMode = true;
          //remove the instrument id from all adjacent block to redraw
          resetQueue.offer(aID);
        }

        //collision check
        temp.collision = false;
        for (int i=0; i<tracks[trackId].rock.length; i++) {
          if ( (!tracks[trackId].rock[i].editMode) && 
            (tracks[trackId].rock[i].visible) && 
            (temp.posi.x > (tracks[trackId].rock[i].pX-tracks[trackId].rock[i].diaX/1.1)) && 
            (temp.posi.x < (tracks[trackId].rock[i].pX+tracks[trackId].rock[i].diaX/1.1)) && 
            (temp.posi.y > (tracks[trackId].rock[i].pY-tracks[trackId].rock[i].diaY/1.1)) && 
            (temp.posi.y < (tracks[trackId].rock[i].pY+tracks[trackId].rock[i].diaY/1.1))  ) {
            temp.collision = true;
            if (!buffered) {
              bufferpX = temp.posi.x; 
              bufferpY = temp.posi.y;
              buffered = true;
            }  
            break;
          }
        }

        //hier if ! temp.collision einfügen für bewegung mit kollisionsabfrage

/*
        float dx = temp.posi.x - pX;
        if (abs(dx) > 0.01) {
          pX += dx * geasing;
        } else {
         pX = temp.posi.x; 
        }
        float dy = temp.posi.y - pY;
        if (abs(dy) > 0.01) {
          pY += dy * geasing;
        } else {
         pY = temp.posi.y; 
        }
*/
        // easing deaktivieren , hier drüber

         pX = temp.posi.x;
         pY = temp.posi.y;
        //buffer wieder deaktivieren um neue kollision speichern zu können
        if ( (!temp.collision) && (buffered) ) {
          buffered = false;
        }
      }
    }
  }

  void playPiano() {
    Iterator i = tcursorMap.values().iterator();
    while ( (aktiv) && (visible) && (i.hasNext ()) ) {
      CHelper c = (CHelper) i.next();  
      if (  (c.posi.x > (pX-diaX/1.9)) && (c.posi.x < (pX+diaX/1.9)) && (c.posi.y > (pY-diaY/1.9)) && (c.posi.y < (pY+diaY/1.9))  ) {
        pressed = true;
        if (!played) {
          playedPitch = tracks[trackId].pitch+scales[scalesArray][(int) random(scales[scalesArray].length)];
          played =true;

          /*
          ////NAAAAHHHHH function machen....
           */

          Instrument nah = (Instrument) soundBodys.get(bodyNr);

         nah.sendSetup();
          /*
        /////////////////////////////////////////////////////////////77
           */

          noteOn(trackId, playedPitch);
          println("ON "+aID);
        }
        break;
      } 
      else {
        pressed = false;
      }
    }

    if ((played) && (!pressed)) {
      played = false;
      noteOff(trackId, playedPitch);
      println("OFF "+aID);
    }

    if ((tcursorMap.size() == 0) && (pressed)) {
      pressed = false;
      if (played) {
        played = false;
        noteOff(trackId, playedPitch);
        println("OFF "+aID);
      }
    }


    //println(pressed+"  "+aID);
  }
}


///positionspeicher für das ebeneraster
class raster {
  boolean frei;
  int rockArId;
  raster() {
    frei = true;
  }
}
