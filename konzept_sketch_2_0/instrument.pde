

class Instrument {
  int anzahlCubes;
  int openSpace;
  int id;
  int wideXmin, wideYmin;
  int wideXmax, wideYmax;
  int wideX, wideY;
  int trackNr;
  float playedNote;
  boolean playing;
  boolean used;


  Instrument(int id_, int track_) {

    id = id_;
    anzahlCubes = 1;
    trackNr = track_;
  }


  void updateCubesCount() {
    anzahlCubes = 0;
    openSpace = 0;
    wideXmax = -1;
    wideXmin = 1000;
    wideYmax = -1;
    wideYmin = 1000;




    for (int j = 0; j < tracks.length; j++) {
      for (int i= 0; i < tracks[j].rock.length; i++ ) {
        if ( (tracks[j].rock[i].aktiv) && (tracks[j].rock[i].bodyNr == id) ) {
          anzahlCubes ++;
          openSpace += tracks[j].rock[i].openSpace;
          //get grid position
          int ii = (int) ((tracks[j].rock[i].pX+(iSize/2))/iSize)+tracks[j].ebene.length/2;
          int jj = (int) ((tracks[j].rock[i].pY+(iSize/2))/iSize)+tracks[j].ebene.length/2;

          //calculate x,y width
          if (ii > wideXmax) {
            wideXmax = ii;
          }

          if (ii < wideXmin) {
            wideXmin = ii;
          }

          if (jj > wideYmax) {
            wideYmax = jj;
          }

          if (jj < wideYmin) {
            wideYmin = jj;
          }
        }
      }
    }

    wideX = (wideXmax - wideXmin)+1;
    wideY = (wideYmax - wideYmin)+1;
  }

 

  void sendSetup() {


    if (  ((float)wideX/(float)wideY) != 1.0) { 
      OscMessage ratF = new OscMessage("/s"+trackNr+"/osc/mod/ratorfreq");
      ratF.add(0);
      oscP5.send(ratF, pd);

      OscMessage play = new OscMessage("/s"+trackNr+"/osc/mod/amount");
      float amount = map(wideX*iSize, 0.0, 800.0, 0.0, 1.0);
      // println(amount);
      play.add(amount);
      oscP5.send(play, pd);

      OscMessage play3 = new OscMessage("/s"+trackNr+"/osc/mod/freq");
      float amountY = map(wideY*iSize, 0.0, 800.0, 0.0, 1.0);
      //println(amountY);
      play3.add(amountY);
      oscP5.send(play3, pd);

      OscMessage pan = new OscMessage("/s"+trackNr+"/pan/position");
      float panTemp = map( ((wideXmin+(wideX/2)) + (wideYmin+(wideY/2))), 25, 57, 0, 1);
      pan.add(panTemp);

      oscP5.send(pan, pd);
    }

    else { 
      OscMessage ratF = new OscMessage("/s"+trackNr+"/osc/mod/ratorfreq");
      ratF.add(1);
      oscP5.send(ratF, pd);

      OscMessage play22 = new OscMessage("/s"+trackNr+"/osc/mod/amount");
      play22.add(0.5);
      oscP5.send(play22, pd);

      OscMessage play11 = new OscMessage("/s"+trackNr+"/osc/mod/freq");
      play11.add(0.5);
      oscP5.send(play11, pd);

      OscMessage pan = new OscMessage("/s"+trackNr+"/pan/position");
      float panTemp = map( ((wideXmin+(wideX/2)) + (wideYmin+(wideY/2))), 25, 57, 0, 1);
      pan.add(panTemp);

      oscP5.send(pan, pd);
    }
  }
}

