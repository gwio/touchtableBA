class Track {
  PVector mapPos;
  int aktiveCubes;
  int aktiveInst;
  int ebeneId;
  float playedNote;
  boolean fokus;

  //setup mode for new tracks
  boolean buildMode;
  boolean playMode;
  boolean setupMode;
  boolean beatMode;
  boolean pause;
  boolean harmonic;
  boolean melodic;
  boolean playing;
  int melodicTemp = -1;
  Block[] rock;
  int melodicCounter = 0;
  raster[][] ebene;

  TrackSelect trackMenu;
  Beat beatMenu;
  float pitch = 64;
  int carrierW;
  int modW;
  int speedSetting;
  int rythmCounter;
  int miniXoff;
  int miniYoff;
  float miniScale = 0.07;
  float rZ;
  int rcTemp;
  ////////////////
  //constructor init
  Track (int id, boolean fokus_) {

    //default speed

    rythmCounter = 11;
    fokus = fokus_;
    ebeneId = id;
    setupMode = false;
    playMode = false;
    buildMode = true;
    beatMode = false;
    pause = false;
    mapPos = new PVector();
    harmonic = false;
    melodic = true;
    miniXoff = ((width/3)/2) + ((width/3)*ebeneId);
    miniYoff = height -40;
    //2d grid init und füllen [x][y]
    ebene = new raster[ (int) (1200/iSize) ][ (int) (1200/iSize)];
    for (int i = 0; i < ebene.length; i++) {
      for (int j = 0; j < ebene[i].length; j++) {
        ebene[i][j] = new raster();
      }
    }

    rock = new Block[blockAmount];
    for (int i=0; i < rock.length; i++) {
      rock[i] = new Block( i, id);
    }

    trackMenu = new TrackSelect();
    trackMenu.selectOben = 0+ebeneId;
    trackMenu.selectUnten = 6+ebeneId;
    beatMenu = new Beat(ebeneId);

    setCarrierW(ebeneId, ebeneId);
    setModW(ebeneId, ebeneId);

    speedSetting = ebeneId;
  }


  /////////////

  void animate() {

    if (setupMode) {
      trackMenu.display();
      trackMenu.play();
      carrierW = trackMenu.selectOben%5;
      modW = trackMenu.selectUnten;
      pitch = trackMenu.midiPitch;
      //println(carrierW+"  "+modW+"  "+pitch);
    } 
    else if (beatMode) {

      beatMenu.display();
      beatMenu.interact();
    }
    else {


      beatMenu.display();
      trackMenu.display();
    }

    for (int i=0; i < rock.length; i++) {
      rock[i].animation();
      rock[i].display();
    }
  }

  void notDisplay() {
    for (int i=0; i < rock.length; i++) {
      rock[i].notDisplay();
    }
    

  }

  void mini() {


    mapPos = getWorldPos(miniXoff, miniYoff);


    pushMatrix();
    translate(mapPos.x, mapPos.y, globalMenuZ);
    rotateX(TWO_PI+0.65);
    rotateY(TWO_PI+0.65);
    rotateZ(rZ);


    translate(0, 0, -10);    
    fill(0, 0, 100, 100);
    rect(0, 0, iSize+4, iSize+4);  

    popMatrix();

    if ( rZ > TWO_PI) {
      //rZ=0.00;
    } 

    rZ += 0.002*(6-speedSetting);

    //miniSelector

 if ( ( (!inter.aktiv) && (!tracks[fokusTrack].setupMode) && (!tracks[fokusTrack].beatMode) ) ) {
    Iterator ii = tcursorMap.values().iterator();
    while ( ii.hasNext () ) {     
        CHelper c = (CHelper) ii.next();  
        if (  (c.posi.x > (mapPos.x-iSize/1.9)) && (c.posi.x < (mapPos.x+iSize/1.9)) && (c.posi.y > (mapPos.y-iSize/1.9)) && (c.posi.y < (mapPos.y+iSize/1.9))  ) {

          switchTrack.offer(ebeneId);
        }
      }
    }

    if ( ((!inter.aktiv) && (!tracks[fokusTrack].setupMode) && (!tracks[fokusTrack].beatMode)) && (mousePressed) && (globalMaus.x > (mapPos.x-iSize/1.9)) && (globalMaus.x < (mapPos.x+iSize/1.9)) && (globalMaus.y > (mapPos.y-iSize/1.9)) && (globalMaus.y < (mapPos.y+iSize/1.9))  ) {
      switchTrack.offer(ebeneId);
    }
  }


  void countActiveCubes() {
    if (buildMode) {
      for (int i=0; i<rock.length; i++) {
        if (rock[i].aktiv) {
          aktiveCubes++;
        }
      }
    }
  }

  void cursorInteraction() { 

    if ((buildMode) && (!inter.aktiv)) {   
      for (int i=0; i< rock.length; i++) {
        rock[i].linkTcursor();
        rock[i].moveWithCursor();
        rock[i].delinkTcursor();
      }
    }

    if ((buildMode) && (!inter.aktiv)) {
      tapAdd();
    }
  }

  void piano() {
    if ((playMode) && (!inter.aktiv)) {

      for (int i = 0; i <rock.length; i++) {
        if (rock[i].visible) {
          //rock[i].linkTcursor();
          // rock[i].delinkTcursor();
          rock[i].playPiano();
        }
      }
    }
  }

  void music() {
    
    
    
    if ((!pause) && (!playMode)) {
      if ( (globalTimer%(7*(speedSetting+1))) == 0) {

        if (harmonic) {
          if (rythmCounter != 0) {
            rcTemp = rythmCounter-1;
          } 
          else {
            rcTemp = 11;
          }

          if ( (beatMenu.rythm[rcTemp]) ) {
            Iterator i = soundBodys.values().iterator();
            while  (i.hasNext () ) {
              Instrument ins = (Instrument) i.next();          


              if ( (ins.trackNr == ebeneId) && (!ins.playing) ) {

                ins.playing = true;
                playing = true;
                ins.playedNote = tracks[ebeneId].pitch+scales[scalesArray][(int) random(scales[scalesArray].length) ];
                ins.sendSetup();
                noteOn(ebeneId, ins.playedNote);
                //println("NOTEON "+ rythmCounter);
              }
            }
          } 
          else if (!beatMenu.rythm[rcTemp]) {
            Iterator i = soundBodys.values().iterator();
            while  (i.hasNext () ) {
              Instrument ins = (Instrument) i.next();          
              if ((ins.trackNr == ebeneId) && (ins.playing)) {
                noteOff(ebeneId, ins.playedNote);
                ins.playing = false;
                playing = false;
                //println("NOTEOFF "+ rythmCounter);
              }
            }
          }
        }


        if (melodic) {

          if (rythmCounter != 0) {
            rcTemp = rythmCounter-1;
          } 
          else {
            rcTemp = 11;
          }
          if (beatMenu.rythm[rcTemp]) {
            if ( !playing ) {

              Iterator iq = soundBodys.values().iterator();
              while  (iq.hasNext () ) {
                Instrument ins = (Instrument) iq.next(); 
                

        
                if ( (ins.trackNr == ebeneId) && (!ins.used) ) {
                  playing  = true;
                  playedNote =  tracks[ebeneId].pitch+scales[scalesArray][(int) random(scales[scalesArray].length) ];
                  ins.sendSetup();
                  ins.used = true;
                  noteOn(ebeneId, playedNote);
                  melodicCounter ++;
                  melodicTemp = ins.id;
                  ins.playing = true;
                  break;
                }
              }
            }
          }
          else if (aktiveInst > 0) {
            playing = false;
            Instrument bla = (Instrument) soundBodys.get(melodicTemp);
            if (bla != null) {
              bla.playing = false;
            }
            noteOff(ebeneId, playedNote);
          }
          if (melodicCounter >= aktiveInst) {
            melodicCounter = 0;
            Iterator iqq = soundBodys.values().iterator();
            while  (iqq.hasNext () ) {
              Instrument ins = (Instrument) iqq.next();    
              if ( (ins.trackNr == ebeneId) ) {
                ins.used = false;
              }
            }
          }
        }



        rythmCounter++;
      }
    }


    if (rythmCounter > 11) {
      rythmCounter = 0;
    }
  }


  void reset() {

    Iterator ib = soundBodys.values().iterator();
    while  (ib.hasNext () ) {
      Instrument ins = (Instrument) ib.next();
      if ((ins.trackNr ==  ebeneId) && (ins.playing)) {
        noteOff(ebeneId, ins.playedNote);
        ins.playing = false;
      }
    }


    for (int i = 0; i < ebene.length; i++) {
      for (int j = 0; j < ebene[i].length; j++) {
        ebene[i][j].frei = true;
        ebene[i][j].rockArId = -1;
      }
    }
    for (int i= 0; i< rock.length; i++) {
      rock[i].dia = iSize;
      rock[i].buffered = false;
      rock[i].aktiv = false;
      rock[i].linked = false;
      rock[i].isPartOfBody = false;
      rock[i].deactivateANI = true;
      rock[i].bodyNr = -1;
      //rock[i].dia = iSize;
    }
  }

  void checkMaus() {
    for (int i=0; i < rock.length; i++) {    
      rock[i].checkMausInter();
    }
  }
}

////////SYNTH OSC/////////

void setCarrierW(int synth, int nr) {
  OscMessage play = new OscMessage("/s"+synth+"/osc/carrier/wave");
  play.add(nr); 
  oscP5.send(play, pd);
}

void setModW(int synth, int nr) {
  OscMessage play = new OscMessage("/s"+synth+"/osc/mod/wave");
  play.add(nr); 
  oscP5.send(play, pd);
}


void playNote( int synth, float note, float velo, int duration) {
  OscMessage play = new OscMessage("/direct"+synth+"/synth");

  play.add( note );
  if (velo <=1.0) {
    play.add(velo);
  } 
  else {
    play.add(1.0);
  }
  play.add(duration);
  oscP5.send(play, pd);
}

void noteOn(int synth, float note) {
  OscMessage noteOn = new OscMessage("/direct"+synth+"/piano");
  noteOn.add(note);
  noteOn.add(master);
  oscP5.send(noteOn, pd);
  //println(note);
}

void noteOff(int synth, float note) {
  OscMessage noteOff = new OscMessage("/direct"+synth+"/piano");
  noteOff.add(note);
  noteOff.add(0.0);
  oscP5.send(noteOff, pd);
}

void adsrSetup(int synth, int speed) {
  OscMessage a = new OscMessage("/s"+synth+"/osc/env/atk");
  a.add(50*(speed+(speed/2)));
  oscP5.send(a, pd);
  a =  new OscMessage("/s"+synth+"/osc/env/dec");
  a.add((100*speed)+1200);
  oscP5.send(a, pd);
  a =   new OscMessage("/s"+synth+"/osc/env/rel");
  a.add(50*speed);
  oscP5.send(a, pd);

  a =   new OscMessage("/s"+synth+"/osc/carrier/detune");
  a.add(-100*(speed-1));
  oscP5.send(a, pd);
}

