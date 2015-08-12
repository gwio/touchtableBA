//ein globales einstellungsmenue
class Options {
  boolean aktiv, updatePos;
  PVector centerPos;
  int selected;



  MenuBlock[] mainBut = new MenuBlock[8];

  Options() {
    centerPos = new PVector();
    aktiv = false; 
    updatePos = false;
    selected = -1;



    mainBut[0] = new MenuBlock(0, "BUILD", true, 1);
    mainBut[1] = new MenuBlock(1, "MANUAL", true, 0);
    mainBut[2] = new MenuBlock(2, "RESET", false, 0 );
    mainBut[3] = new MenuBlock(3, "WAVE", false, 0);
    mainBut[4] = new MenuBlock(4, "RHYTHM", false, 0);
    mainBut[5] = new MenuBlock(5, "STOP", false, 0);
    mainBut[6] = new MenuBlock(6, "WAVE", false, 1);
    mainBut[7] = new MenuBlock(7, scalesName[scalesArray], false, 0);
  }

  void update() {


    if (aktiv ) {
      centerPos = getWorldPos(width/2, height/2);
      if (tracks[fokusTrack].buildMode) {
        mainBut[0].fokus = true; 
        mainBut[1].fokus = false;
      } 
      else if (tracks[fokusTrack].playMode) {
        mainBut[0].fokus = false; 
        mainBut[1].fokus = true;
      }

      if (tracks[fokusTrack].pause) {
        inter.mainBut[5].name = "PLAY";
      } 
      else {
        inter.mainBut[5].name = "STOP";
      }
      if (mainBut[0].fokus) {
        inter.mainBut[0].name = "BUILD";
        inter.mainBut[1].name = "MANUAL";
      } 
      
      if (mainBut[1].fokus) {
        inter.mainBut[0].name = "AUTO";
        inter.mainBut[1].name = "MANUAL";
      }
      
      
      
    } 
    else {
      centerPos =getWorldPos( tracks[fokusTrack].miniXoff, tracks[fokusTrack].miniYoff );
      if (tracks[fokusTrack].buildMode) {
        mainBut[0].fokus = true; 
        mainBut[1].fokus = false;
      } 
      else if (tracks[fokusTrack].playMode) {
        mainBut[0].fokus = false; 
        mainBut[1].fokus = true;
      }
    }
  }

  void display() {
    if (aktiv) {

      for (int i=0; i < mainBut.length; i++) {

        mainBut[i].display();
        mainBut[i].checkInter();
      }
      pushStyle();
      noFill();
      stroke(mainBut[0].farbe, mainBut[0].sat, mainBut[0].hell, mainBut[0].trans);
      strokeWeight(0.25);
      line(mainBut[0].pX, mainBut[0].pY, globalMenuZ, mainBut[1].pX, mainBut[1].pY, globalMenuZ);
      popStyle();
    } 
    else {


      for (int i = 0; i < 2; i++) {
        mainBut[i].display();
        mainBut[i].checkInter();
      }



      for (int i = 2; i < mainBut.length; i++) {
        mainBut[i].display();
      }
    }
  }
}


//menu elements
class MenuBlock extends iObject {
  String name;
  int id;
  boolean major;
  float closeDia, openDia;
  boolean fokus;
  boolean hoverT, hoverM;
  boolean pressed;
  boolean used;
  float easing = 0.1;
  int partOf;
  float tempTrans;


  MenuBlock(int id_, String name_, boolean major_, int partOf_) {
    id = id_;
    major = major_;
    name = name_;
    closeDia = 20;
    openDia = 40;
    fokus = false;
    pZ = globalMenuZ;
    dia = closeDia;
    diaX = closeDia;
    diaY = closeDia;
    used = false;
    partOf = partOf_;

    if (major) {
      sat = 20 ;
      hell = 100;
      trans = 100;
      ;
    }

    tempTrans = trans;
  }


  void display() {

    float dz = globalMenuZ - pZ;
    if (abs(dz) > 1) {
      pZ += dz * easing;
    } 
    else {
      pZ =   globalMenuZ;
    }

    if ((fokus) && (major)) {


      if (inter.aktiv) {
        //easing dia
        float dd = openDia - dia;
        if (abs(dd) > 1) {
          dia += dd * easing;
          diaX += dd * easing;
          diaY += dd * easing;
        } 
        else {
          dia = openDia;
          diaX = openDia;
          diaY = openDia;
        }
      } 
      else {
        //und im fokus, also passender modus
        float dd = closeDia - dia;
        if (abs(dd) > 1) {
          dia += dd * easing;
          diaX += dd * easing;
          diaY += dd * easing;
        } 
        else {
          dia = closeDia;
          diaX = closeDia;
          diaY = closeDia;
        }

        float dt = tempTrans - trans;
        if (abs(dt) > 1) {
          trans += dt * easing;
        } 
        else {
          trans = tempTrans;
        }
      }  


      //easing xpos
      float dx = inter.centerPos.x - pX;
      if (abs(dx) > 1) {
        pX += dx * easing;
      } 
      else {
        pX =  inter.centerPos.x;
      }

      //easing ypos   
      float dy = inter.centerPos.y - pY;
      if (abs(dy) > 1) {
        pY += dy * easing;
      } 
      else {
        pY =  inter.centerPos.y;
      }
    } 
    else if (major) {


      if (!inter.aktiv) {
        //easing dia
        float dd = 0 - dia;
        if (abs(dd) > 1) {
          dia += dd * easing;
          diaX += dd * easing;
          diaY += dd * easing;
        } 
        else {
          dia = 0;
          diaX = 0;
          diaY = 0;
        }

        //easing trans
        float dt = 0 - trans;
        if (abs(dt) > 1) {
          trans += dt * easing;
        } 
        else {
          trans = 0;
        }


        //easing x
        float dx = (inter.centerPos.x) - pX;
        if (abs(dx) > 1) {
          pX += dx * easing;
        } 
        else {
          pX =   (inter.centerPos.x);
        }

        //easing ypos   
        float dy = (inter.centerPos.y) - pY;
        if (abs(dy) > 1) {
          pY += dy * easing;
        } 
        else {
          pY =  (inter.centerPos.y);
        }
      } 
      else {


        float dt = tempTrans - trans;
        if (abs(dt) > 1) {
          trans += dt * easing;
        } 
        else {
          trans = tempTrans;
        }

        //easing dia
        float dd = closeDia - dia;
        if (abs(dd) > 1) {
          dia += dd * easing;
          diaX += dd * easing;
          diaY += dd * easing;
        } 
        else {
          dia = closeDia;
          diaX = closeDia;
          diaY = closeDia;
        }
      }
      //easing x
      float dx = (inter.centerPos.x+150) - pX;
      if (abs(dx) > 1) {
        pX += dx * easing;
      } 
      else {
        pX =   (inter.centerPos.x+150);
      }

      //easing ypos   
      float dy = (inter.centerPos.y+150) - pY;
      if (abs(dy) > 1) {
        pY += dy * easing;
      } 
      else {
        pY =  (inter.centerPos.y+150);
      }
    }  

    ///elemente von build
    if  ((!major) && (inter.mainBut[partOf].fokus) && (inter.aktiv)) {


      //easing xpos
      float dx = (inter.mainBut[partOf].pX + ( cos ( (TWO_PI/8)*id)  *180)) - pX;
      if (abs(dx) > 1) {
        pX += dx * easing;
      } 
      else {
        pX =  (inter.mainBut[partOf].pX + ( cos ((TWO_PI/8)*id)  *180));
      }

      //easing ypos   
      float dy = (inter.mainBut[partOf].pY +( sin ((TWO_PI/8)*id)  * 180)) - pY;
      if (abs(dy) > 1) {
        pY += dy * easing;
      } 
      else {
        pY =  (inter.mainBut[partOf].pY +( sin ((TWO_PI/8)*id)  * 180));
      }

      //easing trans
      float dt = tempTrans - trans;
      if (abs(dt) > 1) {
        trans += dt * easing;
      } 
      else {
        trans = tempTrans;
      }

      //easing dia
      float dd = closeDia - dia;
      if (abs(dd) > 1) {
        dia += dd * easing;
        diaX += dd * easing;
        diaY += dd * easing;
      } 
      else {
        dia = closeDia;
        diaX = closeDia;
        diaY = closeDia;
      }


      dia = closeDia;
      diaX = closeDia;
      diaY = closeDia;
      pushStyle();
      noFill();
      stroke(farbe, sat, hell, trans);
      strokeWeight(0.25);
      line(inter.mainBut[partOf].pX, inter.mainBut[partOf].pY, inter.mainBut[partOf].pZ, pX, pY, pZ);
      popStyle();
    } 

    //wenn nciht im fokus
    else if ( ((!major) && (!inter.mainBut[partOf].fokus)) || ((!major) &&(!inter.aktiv)) ) {
      float dx = (inter.mainBut[partOf].pX + ( cos (id)  )) - pX;
      if (abs(dx) > 1) {
        pX += dx * easing;
      } 
      else {
        pX =  (inter.mainBut[partOf].pX + ( cos ((TWO_PI/8)*id)  ));
      }

      //easing ypos   
      float dy = (inter.mainBut[partOf].pY +( sin ((TWO_PI/8)*id)  )) - pY;
      if (abs(dy) > 1) {
        pY += dy * easing;
      } 
      else {
        pY = (inter.mainBut[partOf].pY +( sin ((TWO_PI/8)*id)  ));
      }


      //easing trans
      float dt = 0 - trans;
      if (abs(dt) > 1) {
        trans += dt * easing;
      } 
      else {
        trans = 0;
      }

      //easing dia
      float dd = 0 - dia;
      if (abs(dd) > 1) {
        dia += dd * easing;
        diaX += dd * easing;
        diaY += dd * easing;
      } 
      else {
        dia = 0;
      }


      pushStyle();
      noFill();
      stroke(farbe, sat, hell, trans);
      strokeWeight(0.5);
      line(inter.mainBut[partOf].pX, inter.mainBut[partOf].pY, inter.mainBut[partOf].pZ, pX, pY, pZ);
      popStyle();
    }




    pushMatrix();
    translate(pX, pY, pZ);
    rotateX(rX);
    rotateY(rY);

    if ( inter.selected == id) {
      fill(farbe+22, sat+22, hell+22, 100);
    } 
    else {
      fill(farbe, sat, hell, trans);
    }




    box(dia);     
    popMatrix();


    //verbindungslinie zwischen major

if (inter.aktiv) {
    pushMatrix();
    if (major) {
    translate(pX+25, pY+16, pZ+dia);
    } else {
       translate(pX+17, pY+16, pZ+dia);
    }
    rotateX(-sWinkel);
    rotateY(-sWinkel);
    rotateZ(-(QUARTER_PI/4));
    textSize(dia*0.5);

    fill(farbe, sat, hell+12, trans+12);

    textAlign(LEFT);
    text(name, 0, 0);
    popMatrix();
}

    rX += 0.02;
    rY += 0.02;
  }

  void checkInter() {

    if ( (fokus) || (inter.mainBut[partOf].fokus) && ((dia == closeDia) || (dia == openDia))) {

      Iterator i = tcursorMap.values().iterator();
      while ( i.hasNext () ) {
        CHelper c = (CHelper) i.next();  
        if (  (c.posi.x > (pX-diaX/1.9)) && (c.posi.x < (pX+diaX/1.9)) && (c.posi.y > (pY-diaY/1.9)) && (c.posi.y < (pY+diaY/1.9))  ) {
          pressed = true;

          if (!used) {
            println(name+"  ON");

            inter.selected = id;
            used = true;
          }

          break;
        } 
        else {
          pressed = false;
        }
      }

      if ((used) && (!pressed)) {
        used = false;
        inter.selected = -1;
        sendCommand(id);
        pZ -=12;
        println(name+" OFF ");
      }

      if ((tcursorMap.size() == 0) && (pressed) && (!mousePressed)) {
        pressed = false;
        if (used) {
          used = false;
          inter.selected = -1;
          sendCommand(id);
          pZ -=12;
          println(name +" OFF ");
        }
      }


      if ( ((dia == closeDia) || (dia == openDia)) &&  (mousePressed) && (globalMaus.x > (pX-diaX/1.9)) && (globalMaus.x < (pX+diaX/1.9)) && (globalMaus.y > (pY-diaY/1.9)) && (globalMaus.y < (pY+diaY/1.9))  ) {
        pressed = true;
        inter.selected = id;
        if (!used) {
          println(name+"  ON");
          //sendCommand(id);
          inter.selected = id;
          used = true;
        }
      } 
      else {
        pressed = false;
      }
    }
  }
}

//setup configuration for every track, wave model, pitch  colour ect...
// (timbre menu)
class TrackSelect {

  iObject[] auswahl = new iObject[12];
  iObject pitch = new iObject();
  boolean auf, zu;
  // %5 verwenden 
  int selectOben ;
  int midiPitchint;
  int selectUnten ;
  float midiPitch;
  float obenY = (height/3)-100; 
  float untenY =  ((height/3))*2;
  float xOff = (((width-500)/6));
  float openZ = 100;
  float closeZ = 400;
  float zDesti;
  float bbbX = 656;
  float easing = 0.1;
  float closeX = width/2;
  float openDia = 30;
  float closeDia = 0;
  float tempDia = 0;
  String[] namen = {
    "SINE", "SQUARE", "RAMP", "PULSE", "TRIANGLE", "NOISE"
  };
  TrackSelect() {

    for (int i=0; i < auswahl.length/2; i++) {
      auswahl[i] = new iObject();
      auswahl[i].aktiv = true;
      auswahl[i].pZ = closeZ;
      auswahl[i].dia = openDia;
      auswahl[i].diaX = openDia;
      auswahl[i].diaY = openDia;
    } 


    auswahl[0].farbe  = 14;
    auswahl[1].farbe  = 48;
    auswahl[2].farbe  = 157;
    auswahl[3].farbe  = 219;
    auswahl[4].farbe  = 74;
    auswahl[5].farbe  = 337;



    for (int i=0; i < auswahl.length/2; i++) {
      auswahl[i+6] = new iObject();
      auswahl[i+6].aktiv = true;
      auswahl[i+6].pZ = closeZ;
      auswahl[i+6].dia = openDia;
      auswahl[i+6].diaX = openDia;
      auswahl[i+6].diaY = openDia;
      //  auswahl[i+5].editMode = false;
    } 


    auswahl[6].sat  = 80;
    auswahl[7].sat  = 70;
    auswahl[8].sat  = 60;
    auswahl[9].sat  = 50;
    auswahl[10].sat  = 40;
    auswahl[11].sat  = 30;

    pitch.pX = -15;
    pitch.pY = 15;
    pitch.pZ = 200;

    pitch.dia = 30;
    pitch.diaX = 30;
    pitch.diaY = 30;
    pitch.aktiv = true;


    auf = false;
    zu = true;

    midiPitch = 64;
  }


  void display() {

    pitch.checkMausInter();
    pitch.linkTcursor();
    pitch.delinkTcursor();


    if (tracks[fokusTrack].setupMode) {
      zDesti = openZ;
      tempDia = openDia;
      if ( (pitch.hoverMaus) && (mousePressed) ) {
        bbbX =  constrain(mouseX, xOff*0+300, xOff*5+300);
      }

      if ( pitch.linked) {
        CHelper temp = (CHelper) tcursorMap.get(pitch.linkedCursorId);
        if (temp != null) {
          bbbX = constrain(temp.xpos, xOff*0+300, xOff*5+300);
        }
      }
    } 
    else {
      zDesti = closeZ;
      tempDia = closeDia;
    }
    PVector nochEiner;
    if (tracks[fokusTrack].setupMode) {
      nochEiner = getWorldPos(bbbX, (height/2)+30);
    } 
    else {
      nochEiner = getWorldPos(width/2, (obenY+obenY/2));
    }
    //xxx
    float dx1 = nochEiner.x - pitch.pX;
    if (abs(dx1) > 0.1) {
      pitch.pX += dx1 * easing;
    } 
    else {
      pitch.pX =  nochEiner.x;
    }

    //yyy
    float dy1 = nochEiner.y - pitch.pY;
    if (abs(dy1) > 0.1) {
      pitch.pY += dy1 * easing;
    } 
    else {
      pitch.pY =  nochEiner.y;
    }

    //zzz
    float dz1 = zDesti - pitch.pZ;
    if (abs(dz1) > 0.1) {
      pitch.pZ += dz1 * easing;
    } 
    else {
      pitch.pZ =  zDesti;
    }

    //zzz
    float dd1 = tempDia - pitch.dia;
    if (abs(dd1) > 0.1) {
      pitch.dia += dd1 * easing;
      pitch.diaX = pitch.dia;
      pitch.diaY = pitch.dia;
    } 
    else {
      pitch.dia =  tempDia;
      pitch.diaX = pitch.dia;
      pitch.diaY = pitch.dia;
    }



    pushMatrix();

    translate(pitch.pX, pitch.pY, pitch.pZ);
    //rotateZ(pitch.rZ);
    // rotateX(pitch.rX);
    //rotateY(pitch.rY);        

    if ((pitch.linked) || (pitch.hoverMaus) ) {
      fill(0, 20, 30);
    } 
    else {
      fill(auswahl[selectOben].farbe, auswahl[selectUnten].sat, pitch.hell);
    }

    box(pitch.dia);
    textAlign(LEFT);
    textSize(pitch.dia*0.4);
    text((int) midiPitch, +20, 0, 10);
    popMatrix();


    noFill();
    stroke(auswahl[selectOben].farbe, auswahl[selectUnten].sat, pitch.hell);
    line(pitch.pX, pitch.pY, pitch.pZ, auswahl[selectOben].pX, auswahl[selectOben].pY, auswahl[selectOben].pZ);
    line(pitch.pX, pitch.pY, pitch.pZ, auswahl[selectUnten].pX, auswahl[selectUnten].pY, auswahl[selectUnten].pZ);

    // line( auswahl[0].pX, 68, pitch.pZ , auswahl[5].pX, 464, pitch.pZ);
    noStroke();



    PVector tempi = new PVector();
    for (int i = 0; i < auswahl.length/2; i++) {
      if ((tracks[fokusTrack].setupMode) ) {
        if (auswahl[i].dia !=0  ) {
          if (i == 0) {
            tempi = getWorldPos(xOff*i+300, obenY);
          } 
          else {
            tempi.x += 10*4.5;
            tempi.y += 10*8.2 ;
          }
        }
        tempDia = openDia;
      } 
      else {
        if ((auswahl[i].dia !=0  ) && (bewegung)) {
          //tempi = getWorldPos(closeX, obenY);
        }
        tempDia = closeDia;
      }

      //xxx
      float dx = tempi.x - auswahl[i].pX;
      if (abs(dx) > 0.1) {
        auswahl[i].pX += dx * easing;
      } 
      else {
        auswahl[i].pX =  tempi.x;
      }

      //yyy
      float dy = tempi.y - auswahl[i].pY;
      if (abs(dy) > 0.1) {
        auswahl[i].pY += dy * easing;
      } 
      else {
        auswahl[i].pY =  tempi.y;
      }

      //zzz
      float dz = zDesti - auswahl[i].pZ;
      if (abs(dz) > 0.1) {
        auswahl[i].pZ += dz * easing;
      } 
      else {
        auswahl[i].pZ =  zDesti;
      }

      //dia
      float dd = tempDia - auswahl[i].dia;
      if (abs(dd) > 0.1) {
        auswahl[i].dia += dd * easing;
        auswahl[i].diaX = pitch.dia;
        auswahl[i].diaY = pitch.dia;
      } 
      else {
        auswahl[i].dia =  tempDia;
        auswahl[i].diaX = pitch.dia;
        auswahl[i].diaY = pitch.dia;
      }

      pushMatrix();

      translate( auswahl[i].pX, auswahl[i].pY, auswahl[i].pZ );
      rotateZ(auswahl[i].rZ);
      fill(auswahl[i].farbe, auswahl[i].sat, auswahl[i].hell, auswahl[i].trans); 
      box(auswahl[i].dia);     
      popMatrix();


      pushMatrix();
      translate( auswahl[i].pX+25, auswahl[i].pY+10, auswahl[i].pZ -20);

      if (selectOben == i) {
        fill(auswahl[i].farbe, auswahl[i].sat, auswahl[i].hell, auswahl[i].trans);
      } 
      else {
        fill(auswahl[i].farbe, auswahl[i].sat, auswahl[i].hell, 20);
      }
      textAlign(LEFT);
      textSize(auswahl[i].dia*0.4);
      text(namen[i], 0, 0, 50);

      popMatrix();

      if (i == selectOben) {
        auswahl[i].rZ += 0.06;
      }
    }
    PVector tempi2 = new PVector();
    for (int i = 6; i < auswahl.length; i++) {
      if (tracks[fokusTrack].setupMode) {
        if ((auswahl[i].dia !=0  ) ) {
          if (i == 6) {
            tempi2 = getWorldPos(xOff*(i-6)+280, untenY);
          } 
          else {
            tempi2.x += 10*4.3;
            tempi2.y += 10*8.0;
          }
        }
        tempDia = openDia;
      } 
      else {
        if ((auswahl[i].dia !=0  ) && (bewegung)) {
          tempi2 = getWorldPos(closeX, untenY);
        }
        tempDia = closeDia;
      }

      //xxx
      float dx = tempi2.x - auswahl[i].pX;
      if (abs(dx) > 0.1) {
        auswahl[i].pX += dx * easing;
      } 
      else {
        auswahl[i].pX =  tempi2.x;
      }

      //yyy
      float dy = tempi2.y - auswahl[i].pY;
      if (abs(dy) > 0.1) {
        auswahl[i].pY += dy * easing;
      } 
      else {
        auswahl[i].pY =  tempi2.y;
      }

      //zzz
      float dz = zDesti - auswahl[i].pZ;
      if (abs(dz) > 0.1) {
        auswahl[i].pZ += dz * easing;
      } 
      else {
        auswahl[i].pZ =  zDesti;
      }

      //dia
      float dd = tempDia - auswahl[i].dia;
      if (abs(dd) > 0.1) {
        auswahl[i].dia += dd * easing;
        auswahl[i].diaX = pitch.dia;
        auswahl[i].diaY = pitch.dia;
      } 
      else {
        auswahl[i].dia =  tempDia;
        auswahl[i].diaX = pitch.dia;
        auswahl[i].diaY = pitch.dia;
      }

      pushMatrix();

      translate( auswahl[i].pX, auswahl[i].pY, auswahl[i].pZ );
      rotateZ(auswahl[i].rZ);
      fill(auswahl[i].farbe, auswahl[i].sat, auswahl[i].hell, auswahl[i].trans); 
      box(auswahl[i].dia);
      popMatrix();


      pushMatrix();
      translate( auswahl[i].pX+25, auswahl[i].pY+10, auswahl[i].pZ -20);

      if (selectUnten == i) {
        fill(auswahl[i].farbe, auswahl[i].sat, auswahl[i].hell, auswahl[i].trans);
      } 
      else {
        fill(auswahl[i].farbe, auswahl[i].sat, auswahl[i].hell, 20);
      }
      textAlign(LEFT);
      textSize(auswahl[i].dia*0.4);
      text(namen[i-6], 0, 0, 50);

      popMatrix();


      if (i == selectUnten) {
        auswahl[i].rZ += 0.06;
      }
    }

    //get midipitch
    if ((tracks[fokusTrack].setupMode) && (pitch.linked)) {
      float pitchTemp =(int) pitch.pX+pitch.pY;

      midiPitch =  map( pitchTemp, -325, 296, 1.0, 127.0) ;
    }

    //get selection
    if (tracks[fokusTrack].setupMode) {
      for (int i = 0; i < auswahl.length; i++) {
        auswahl[i].checkMausInter();
        Iterator itt = tcursorMap.values().iterator();
        while (  (itt.hasNext ()) ) {
          CHelper c = (CHelper) itt.next();  
          if (  (c.posi.x > (auswahl[i].pX-auswahl[i].diaX/1.9)) && (c.posi.x < (auswahl[i].pX+auswahl[i].diaX/1.9)) && (c.posi.y > (auswahl[i].pY-auswahl[i].diaY/1.9)) && (c.posi.y < (auswahl[i].pY+auswahl[i].diaY/1.9))  ) { 
            if (i<6) {
              selectOben = i;

              for (int k=0; k < auswahl.length/2; k++) {
                auswahl[k+6].farbe = auswahl[i].farbe;
              }
            } 
            else if (i > 5) {
              selectUnten= i;

              for (int j=0; j < auswahl.length/2; j++) {
                auswahl[j].sat = auswahl[i].sat;
              }
            }
            auswahl[i].pZ -= 8;
            setModW(fokusTrack, selectOben);
            setCarrierW(fokusTrack, selectUnten%6);
            break;
          }
        }
        if ( (auswahl[i].hoverMaus) && (mousePressed)  ) {       
          if (i<6) {
            selectOben= i;
            for (int k=0; k < auswahl.length/2; k++) {
              auswahl[k+6].farbe = auswahl[i].farbe;
            }
          } 
          else if (i > 5) {
            selectUnten = i;
            for (int j=0; j < auswahl.length/2; j++) {
              auswahl[j].sat = auswahl[i].sat;
            }
          }
          auswahl[i].pZ -= 8;
          setCarrierW(fokusTrack, selectOben);
          setModW(fokusTrack, selectUnten%6);
        }
      }
    }
  }



  void play() {

    if ( (frameCount%120==0)  ) {
      // println(selectOben+"  "+selectUnten+"  "+midiPitch);
      // setCarrierW(fokusTrack, selectOben%6);
      //setModW(fokusTrack, selectUnten);
      playNote(fokusTrack, midiPitch, 0.85, 100);
    }
  }
}


class Beat {
  float zeitYscreen, tempoYscreen;
  float zeitXOff, tempoXOff;
  boolean openAni, closeAni;
  iObject[] zeit = new iObject[12];
  boolean[] rythm = new boolean[12];
  boolean[] speed = new boolean[6];
  iObject[] tempo = new iObject[6];
  iObject harmonic = new iObject();
  iObject melodic = new iObject();
  boolean harmonicS, melodicS;
  float easing = 0.09;
  PVector pos = new PVector();
  PVector pos2 = new PVector();
  float openZeit = 24;
  float closeZeit = 0;
  float tempDia = 0.0;
  float tempTrans = 0;
  float openZ = 100;
  float closeZ = 600;
  float rotCounter = 0;
  Beat(int eID) {
    melodic.trans = 100;
    harmonic.trans = 10;
    melodicS = true;
    harmonicS = false;

    zeitYscreen = height/3;
    tempoYscreen = (height/3)* 2;
    zeitXOff = (880/12) ;
    tempoXOff = (640/6);
    openAni = false;
    closeAni = false;
    for (int i= 0; i < zeit.length; i++) {
      zeit[i] = new iObject();
      zeit[i].sat = 0;
      zeit[i].hell = 100;
    }

    for (int i= 0; i < tempo.length; i++) {
      tempo[i] = new iObject();
      tempo[i].sat = 0;
      tempo[i].hell = 100;
    }

    for (int i = 0; i < rythm.length; i++) {
      if (i%2 == 0) {
        rythm[i] =true;
      } 
      else {
        rythm[i] = false;
      }
    }

    for (int i = 0; i < speed.length; i++) {
      speed[i] = false;
    }

    speed[eID] = true;
  }

  void display() {


    //farbe für track menü
    if (tracks[fokusTrack].beatMode) {
      pushMatrix();
      pointLight(sketchFarbe, 100, 100, zeit[tracks[fokusTrack].rcTemp].pX*1.6, zeit[tracks[fokusTrack].rcTemp].pY*1.6, openZ);
      popMatrix();
      
      
       pushMatrix();
      translate( zeit[11].pX+25, zeit[11].pY+10, zeit[11].pZ -20);

      fill(sketchFarbe, sketchSat, sketchHell+20);
      textAlign(LEFT);
      textSize(zeit[11].dia*0.3);
      text("INTERVAL", 0, 0, 50);

      popMatrix();
      
      
      pushMatrix();
      translate( tempo[5].pX+25, tempo[5].pY+10, tempo[5].pZ -20);

      fill(sketchFarbe, sketchSat, sketchHell+20);
      textAlign(LEFT);
      textSize(tempo[5].dia*0.3);
      text("TEMPO", 0, 0, 50);

      popMatrix();
      
      
        pushMatrix();
      translate( melodic.pX+25, melodic.pY+10, melodic.pZ -20);

      fill(sketchFarbe, sketchSat, sketchHell+20, melodic.trans);
      textAlign(LEFT);
      textSize(melodic.dia*0.2);
      text("MELODIC", 0, 0, 50);

      popMatrix();
      
           pushMatrix();
      translate( harmonic.pX+25, harmonic.pY+10, harmonic.pZ -20);

      fill(sketchFarbe, sketchSat, sketchHell+20, harmonic.trans);
      textAlign(LEFT);
      textSize(harmonic.dia*0.2);
      text("HARMONIC", 0, 0, 50);

      popMatrix();
      
      
      
    }

    for (int i=0; i < zeit.length; i++) {


      if (tracks[fokusTrack].beatMode) {
        if ((zeit[i].dia != 0) ) {
          if (i == 0) {
            pos = getWorldPos((zeitXOff*i)+236, zeitYscreen);
          } 
          else {
            pos.x += 35;
            pos.y += 35;
          }
        }
        pos.z = openZ;
        tempDia = openZeit;
      } 
      else {
        if ((zeit[i].dia != 0) && (bewegung)) {
          if (i == 0) {
            pos = getWorldPos(width/2, zeitYscreen);
          } 
          else {
            pos.x += 1;
            pos.y += 1;
          }
        }
        pos.z = closeZ;
        tempDia = closeZeit;
      }


      //easing dia
      float dd = tempDia- zeit[i].dia;
      if (abs(dd) > 0.1) {
        zeit[i].dia += dd * easing;
        zeit[i].diaX += dd * easing;
        zeit[i].diaY += dd * easing;
      } 
      else {
        zeit[i].dia = tempDia;
        zeit[i].diaX = tempDia;
        zeit[i].diaY = tempDia;
      }

      //easing zzz
      float dz = pos.z - zeit[i].pZ;
      if (abs(dz) > 0.1) {
        zeit[i].pZ += dz * easing;
      } 
      else {
        zeit[i].pZ =  pos.z;
      }



      float dx = pos.x - zeit[i].pX;
      if (abs(dx) > 0.1) {
        zeit[i].pX += dx * easing;
      } 
      else {
        zeit[i].pX =  pos.x;
      }

      //easing ypos   
      float dy = pos.y - zeit[i].pY;
      if (abs(dy) > 0.1) {
        zeit[i].pY += dy * easing;
      } 
      else {
        zeit[i].pY =  pos.y;
      }
      //easing xpos   


      if (zeit[i].dia != 0) {
        pushMatrix();
        translate (zeit[i].pX, zeit[i].pY, zeit[i].pZ);

        if (rythm[i]) {
          zeit[i].trans = 100;
        } 
        else {
          zeit[i].trans = 20;
        }

        if (tracks[fokusTrack].rcTemp == i) {
          zeit[i].sat = sketchSat;
        } 
        else {
          zeit[i].sat =0;
        }
        fill(zeit[i].farbe, zeit[i].sat, zeit[i].hell, zeit[i].trans);
        box(zeit[i].dia);
        popMatrix();
      }
    }


    if (zeit[5].dia < openZeit) {
      melodic.pX = zeit[5].pX*1.27;
      melodic.pY = zeit[5].pY*1.27;
      melodic.pZ = zeit[5].pZ;
    }

    if (zeit[6].dia < openZeit) {
      harmonic.pX = zeit[6].pX*1.27;
      harmonic.pY = zeit[6].pY*1.27;
      harmonic.pZ = zeit[6].pZ;
    }

    pushMatrix();
    translate (melodic.pX, melodic.pY, melodic.pZ);
    melodic.dia = zeit[5].dia*1.6;
    melodic.diaX = melodic.dia;
    melodic.diaY = melodic.dia;

    fill(melodic.farbe, 0, 100, melodic.trans);       
    box(melodic.dia);        
    noFill();
    stroke(melodic.farbe, melodic.sat/2, melodic.hell, melodic.trans);        
    translate(0, 0, (melodic.dia/2)+2);
    ellipse(0, 0, melodic.dia*0.2, melodic.dia*0.2);
    noStroke();
    //anzeige für melodic
    for (int i = 0; i < 12; i++) {
      pushMatrix();
      rotateZ(QUARTER_PI);
      translate ( sin(((TWO_PI/12)*i))*15, cos(((TWO_PI/12)*i))*15, 0);

      if ((tracks[fokusTrack].rcTemp%12 == i) && (tracks[fokusTrack].beatMenu.rythm[tracks[fokusTrack].rcTemp]) ) {
        fill(sketchFarbe, sketchSat, sketchHell, melodic.trans);
      } 
      else {
        fill(sketchFarbe, sketchSat, melodic.hell, 0);
      }

      ellipse(0, 0, 5, 5);
      popMatrix();
    }  
    noStroke();
    popMatrix();

    pushMatrix();
    translate (harmonic.pX, harmonic.pY, harmonic.pZ);   
    harmonic.dia = zeit[6].dia*1.6; 
    harmonic.diaX = harmonic.dia;
    harmonic.diaY = harmonic.dia;

    fill(harmonic.farbe, 0, 100, harmonic.trans);
    box(harmonic.dia);
    noFill();
    stroke(harmonic.farbe, harmonic.sat/2, harmonic.hell, harmonic.trans);        
    translate(0, 0, (harmonic.dia/2)+2);
    ellipse(0, 0, harmonic.dia*0.2, harmonic.dia*0.2);
    noStroke();
    //anzeige for harmonic
    for (int i = 0; i < 12; i++) {
      pushMatrix();
      rotateZ(QUARTER_PI);
      translate ( sin(((TWO_PI/12)*i))*15, cos(((TWO_PI/12)*i))*15, 0);

      if ( (tracks[fokusTrack].beatMenu.rythm[tracks[fokusTrack].rcTemp]) ) {
        fill(sketchFarbe, sketchSat, sketchHell, harmonic.trans);
      } 
      else {
        fill(sketchFarbe, harmonic.sat/2, harmonic.hell, 0);
      }

      ellipse(0, 0, 5, 5);
      popMatrix();
    }  

    popMatrix();

    //TEMPO
    for (int i=0; i < tempo.length; i++) {
      tempo[i].rZ = rotCounter *(6-i);
      rotCounter += 0.002;

      if (tracks[fokusTrack].beatMode) {
        if ((tempo[i].dia != 0)) {
          if (i == 0) {
            pos2 = getWorldPos((tempoXOff*i)+373, tempoYscreen);
          } 
          else {
            pos2.x += 50;
            pos2.y += 50;
          }
        }
        tempDia = openZeit;
        pos2.z = openZ;
      } 
      else {

        if ( (tempo[i].dia != 0) && (bewegung) ) {
          if (i == 0) {
            pos2 = getWorldPos(width/2, tempoYscreen);
          } 
          else {
            pos2.x += 1;
            pos2.y += 1;
          }
        }
        tempDia = closeZeit;
        pos2.z = closeZ;
      }

      //easing dia
      float dd = tempDia- tempo[i].dia;
      if (abs(dd) > 0.1) {
        tempo[i].dia += dd * easing;
        tempo[i].diaX += dd * easing;
        tempo[i].diaY += dd * easing;
      } 
      else {
        tempo[i].dia = tempDia;
        tempo[i].diaX = tempDia;
        tempo[i].diaY = tempDia;
      }


      //easing zzz
      float dz = pos2.z - tempo[i].pZ;
      if (abs(dz) > 0.1) {
        tempo[i].pZ += dz * easing;
      } 
      else {
        tempo[i].pZ =  pos2.z;
      }

      //easing x 
      float dx = pos2.x - tempo[i].pX;
      if (abs(dx) > 0.1) {
        tempo[i].pX += dx * easing;
      } 
      else {
        tempo[i].pX =  pos2.x;
      }

      //easing ypos   
      float dy = pos2.y - tempo[i].pY;
      if (abs(dy) > 0.1) {
        tempo[i].pY += dy * easing;
      } 
      else {
        tempo[i].pY =  pos2.y;
      }

      if (tempo[i].dia != 0) {
        pushMatrix();

        translate (tempo[i].pX, tempo[i].pY, tempo[i].pZ+openZeit);   
        rotateZ(tempo[i].rZ);
        if (speed[i]) {
          tempo[i].trans = 100;
        } 
        else {
          tempo[i].trans = 20;
        }

        fill(tempo[i].farbe, tempo[i].sat, tempo[i].hell, tempo[i].trans);
        box(tempo[i].dia);
        popMatrix();
      }
    }
  }

  void animate() {
  }

  void interact() {

    for (int i = 0; i < zeit.length; i++) {

      Iterator ii = tcursorMap.values().iterator();
      while ( ii.hasNext () ) {
        CHelper c = (CHelper) ii.next();  
        if (  (c.posi.x > (zeit[i].pX-zeit[i].diaX/1.9)) && (c.posi.x < (zeit[i].pX+zeit[i].diaX/1.9)) && (c.posi.y > (zeit[i].pY-zeit[i].diaY/1.9)) && (c.posi.y < (zeit[i].pY+zeit[i].diaY/1.9))  ) {
          zeit[i].pressed = true;

          if (!zeit[i].used) {
            println("  ON");


            zeit[i].used = true;
          }

          break;
        } 
        else {
          zeit[i].pressed = false;
        }
      }

      if ((zeit[i].used) && (!zeit[i].pressed)) {
        zeit[i].used = false;
        rythm[i] = !rythm[i];

        zeit[i].pZ -= 12;
        println(" OFF ");
      }

      if ((tcursorMap.size() == 0) && (zeit[i].pressed) && (!mousePressed)) {
        zeit[i].pressed = false;
        if (zeit[i].used) {
          zeit[i].used = false;
          rythm[i] = !rythm[i];

          zeit[i].pZ -= 12;

          println(" OFF ");
        }
      }


      if ( (mousePressed) && (globalMaus.x > (zeit[i].pX-zeit[i].diaX/1.9)) && (globalMaus.x < (zeit[i].pX+zeit[i].diaX/1.9)) && (globalMaus.y > (zeit[i].pY-zeit[i].diaY/1.9)) && (globalMaus.y < (zeit[i].pY+zeit[i].diaY/1.9))  ) {
        zeit[i].pressed = true;

        if (!zeit[i].used) {

          println("on");
          zeit[i].used = true;
        }
      } 
      else {
        zeit[i].pressed = false;
      }
    }

    for (int i = 0; i < tempo.length; i++) {

      Iterator ii = tcursorMap.values().iterator();
      while ( ii.hasNext () ) {
        CHelper c = (CHelper) ii.next();  
        if (  (c.posi.x > (tempo[i].pX-tempo[i].diaX/1.9)) && (c.posi.x < (tempo[i].pX+tempo[i].diaX/1.9)) && (c.posi.y > (tempo[i].pY-tempo[i].diaY/1.9)) && (c.posi.y < (tempo[i].pY+tempo[i].diaY/1.9))  ) {
          zeit[i].pressed = true;

          if (!tempo[i].used) {

            tempo[i].used = true;
          }

          break;
        } 
        else {
          tempo[i].pressed = false;
        }
      }

      if ((tempo[i].used) && (!tempo[i].pressed)) {
        tempo[i].used = false;
        tempo[i].pZ -= 12;

        for (int g = 0; g < speed.length; g++) { 
          if ( i == g) {
            speed[i] = true;
            closeSound();
            adsrSetup(fokusTrack, i+1);
            tracks[fokusTrack].speedSetting = i;
            for (int b= 0; b < tracks.length; b++) {
              tracks[b].rythmCounter = 0;
            }
          } 
          else {
            speed[g] = false;
          }
        }
      }

      if ((tcursorMap.size() == 0) && (tempo[i].pressed) && (!mousePressed)) {
        tempo[i].pressed = false;
        if (tempo[i].used) {
          tempo[i].used = false;
          tempo[i].pZ -= 12;

          for (int g = 0; g < speed.length; g++) { 
            if ( i == g) {
              speed[i] = true;
              closeSound();
              adsrSetup(fokusTrack, i+1);
              tracks[fokusTrack].speedSetting = i;

              for (int b= 0; b < tracks.length; b++) {
                tracks[b].rythmCounter = 0;
              }
            } 
            else {
              speed[g] = false;
            }
          }
        }
      }


      if ( (mousePressed) && (globalMaus.x > (tempo[i].pX-tempo[i].diaX/1.9)) && (globalMaus.x < (tempo[i].pX+tempo[i].diaX/1.9)) && (globalMaus.y > (tempo[i].pY-tempo[i].diaY/1.9)) && (globalMaus.y < (tempo[i].pY+tempo[i].diaY/1.9))  ) {
        tempo[i].pressed = true;

        if (!tempo[i].used) {

          println("on");
          tempo[i].used = true;
        }
      } 
      else {
        tempo[i].pressed = false;
      }
    }


    ////harmonic melodic toggle

      //harmonic
    Iterator ii = tcursorMap.values().iterator();
    while ( ii.hasNext () ) {
      CHelper c = (CHelper) ii.next();  
      if (  (c.posi.x > (harmonic.pX-harmonic.diaX/1.9)) && (c.posi.x < (harmonic.pX+harmonic.diaX/1.9)) && (c.posi.y > (harmonic.pY-harmonic.diaY/1.9)) && (c.posi.y < (harmonic.pY+harmonic.diaY/1.9))  ) {
        harmonic.pressed = true;

        if (!harmonic.used) {

          harmonic.used = true;
        }

        break;
      } 
      else {
        harmonic.pressed = false;
      }
    }

    if ((harmonic.used) && (!harmonic.pressed)) {
      harmonic.used = false;
      //harmonic.pZ -= 12;
      harmonic.trans = 100;
      melodic.trans = 10;
      harmonicS = true;
      melodicS = false;
      tracks[fokusTrack].melodic = false;
      tracks[fokusTrack].harmonic = true;
      closeSound();
      for (int b= 0; b < tracks.length; b++) {
        tracks[b].rythmCounter = 0;
      }
      ////hier einschalten
      println("MELODIC "+melodicS);
      println("HARMONIC "+harmonicS);
    }

    if ((tcursorMap.size() == 0) && (harmonic.pressed) && (!mousePressed)) {
      harmonic.pressed = false;
      if (harmonic.used) {
        harmonic.used = false;
        // harmonic.pZ -= 12;
        harmonic.trans = 100;
        melodic.trans = 10;
        harmonicS = true;
        melodicS = false;
        tracks[fokusTrack].melodic = false;
        tracks[fokusTrack].harmonic = true;
        closeSound();
        for (int b= 0; b < tracks.length; b++) {
          tracks[b].rythmCounter = 0;
        }
        println("MELODIC "+melodicS);
        println("HARMONIC "+harmonicS);
        //hier einschalten
      }
    }


    if ( (mousePressed) && (globalMaus.x > (harmonic.pX-harmonic.diaX/1.9)) && (globalMaus.x < (harmonic.pX+harmonic.diaX/1.9)) && (globalMaus.y > (harmonic.pY-harmonic.diaY/1.9)) && (globalMaus.y < (harmonic.pY+harmonic.diaY/1.9))  ) {
      harmonic.pressed = true;

      if (!harmonic.used) {

        println("on");
        harmonic.used = true;
      }
    } 
    else {
      harmonic.pressed = false;
    }


    //melodic

    Iterator iii = tcursorMap.values().iterator();
    while ( iii.hasNext () ) {
      CHelper c = (CHelper) iii.next();  
      if (  (c.posi.x > (melodic.pX-melodic.diaX/1.9)) && (c.posi.x < (melodic.pX+melodic.diaX/1.9)) && (c.posi.y > (melodic.pY-melodic.diaY/1.9)) && (c.posi.y < (melodic.pY+melodic.diaY/1.9))  ) {
        melodic.pressed = true;

        if (!melodic.used) {

          melodic.used = true;
        }

        break;
      } 
      else {
        melodic.pressed = false;
      }
    }

    if ((melodic.used) && (!melodic.pressed)) {
      melodic.used = false;
      //melodic.pZ -= 12;
      melodic.trans = 100;
      harmonic.trans = 10;
      harmonicS = false;
      melodicS = true;
      ////hier einschalten
      tracks[fokusTrack].melodic = true;
      tracks[fokusTrack].harmonic = false;
      closeSound();
      for (int b= 0; b < tracks.length; b++) {
        tracks[b].rythmCounter = 0;
      }
      println("MELODIC "+melodicS);
      println("HARMONIC "+harmonicS);
    }

    if ((tcursorMap.size() == 0) && (melodic.pressed) && (!mousePressed)) {
      melodic.pressed = false;
      if (melodic.used) {
        melodic.used = false;
        // melodic.pZ -= 12;
        melodic.trans = 100;
        harmonic.trans = 10;
        harmonicS = false;
        melodicS = true;
        tracks[fokusTrack].melodic = true;
        tracks[fokusTrack].harmonic = false;
        closeSound();
        for (int b= 0; b < tracks.length; b++) {
          tracks[b].rythmCounter = 0;
        }
        println("MELODIC "+melodicS);
        println("HARMONIC "+harmonicS);

        //hier einschalten
      }
    }


    if ( (mousePressed) && (globalMaus.x > (melodic.pX-melodic.diaX/1.9)) && (globalMaus.x < (melodic.pX+melodic.diaX/1.9)) && (globalMaus.y > (melodic.pY-melodic.diaY/1.9)) && (globalMaus.y < (melodic.pY+melodic.diaY/1.9))  ) {
      melodic.pressed = true;

      if (!melodic.used) {

        println("on");
        melodic.used = true;
      }
    } 
    else {
      melodic.pressed = false;
    }
  }
}

