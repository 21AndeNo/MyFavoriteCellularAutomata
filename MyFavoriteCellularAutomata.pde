/**
 * MFCA
 * My Favorite Cellular Automata
 *
 * @template Andrew Smith
 * @student Noah Anderson
 */

import processing.svg.*;
CellularAutomaton c;
int requestedCellsPerGeneration;
int requestedRuleNumber;
float drawScaleFactor;

void setup() {
  size(600, 450);
  frameRate(60);
  background(255);
  ellipseMode(CORNER);
  requestedCellsPerGeneration = 600;
  requestedRuleNumber = 99;
  drawScaleFactor = 0.9;
  c = new CellularAutomaton(requestedCellsPerGeneration, requestedRuleNumber);
}

void draw() {
  if (c.canGrow()) {
    c.show();
    c.evolve();
  } else {
    c.showLabel();  // TODO: uncomment this line after the rest of your code is done
    noLoop();
  }
}

class CellularAutomaton {
  private String[]  cellArray;
  private int       ruleNumber;
  private int       currentGenerationNumber;
  private boolean   canGrow;

  /**
   * Initializes a new CellularAutomaton having array size n with rule number r.
   * The cellArray is initially populated with all 0s, except the middle cell
   * (or near middle if there is no exact middle), which is 1. Additionally,
   * the currentGenerationNumber is set to 0 and canGrow is set to true.
   *
   * @param n The size of the array of cells.
   *  Precondition: n > 0
   * @param r The rule number (base 10) for this CellularAutomaton
   *  Precondition: none
   */
  public CellularAutomaton(int n, int r) {
    cellArray = new String[n];
    for (int i = 0; i < cellArray.length; i++) {
      cellArray[i] = "0";
    }
    cellArray[n/2] = "1";
    ruleNumber = r;
    currentGenerationNumber = 0;
    canGrow = true;
  }

  public void updateCurrentGenerationNumber() {
    currentGenerationNumber++;
  }

  public int getCurrentGenerationNumber() {
    return currentGenerationNumber;
  }

  public boolean canGrow() {
    return canGrow;
  }

  /**
   * Setter method for the ruleNumber instance variable.
   * If 0 <= n <= 255, then ruleNumber is assigned that value.
   * If n is outside those bounds, then ruleNumber is assigned
   * the 0 or 255, whichever is closer.
   *
   * @param n The rule number
   *  Precondition: none
   */
  public void setRuleNumber(int n) {
    if (n > 255) {
      ruleNumber = 255;
    } else if (n < 0) {
      ruleNumber = 0;
    } else {
      ruleNumber = n;
    }
  }

  public int getRuleNumber() {
    return ruleNumber;
  }

  /**
   * Builds a string of binary digits (0 or 1) which represents
   * this CA's rule pattern, padding the string with extra 0s
   * on the left so that it is 8-digits long.
   *
   * @return 8-digit binary equivalent of ruleNumber
   */
  public String getRulePatternAsString() {
    String output = Integer.toBinaryString(getRuleNumber());
    while (output.length() < 8) {
      output = "0" + output;
    } 
    return output;
  }

  /**
   * Converts a String of binary digits (0 or 1), having length 8,
   * into an 8-element array of Strings. Each of those Strings is
   * equal to "0" or "1".
   *
   * @return 8-element array containing the rule pattern of this CA
   */
  public String[] getRulePatternAsArray() {
    String[] output = new String[8];
    String s = this.getRulePatternAsString();
    for (int i = 0; i < s.length(); i++) output[i] = s.substring(i, i + 1);
    return output;
  }

  public void evolve() {
    if (getCurrentGenerationNumber() < width / getCellSize() * 0.49) {
      updateCellArray();
      updateCurrentGenerationNumber();
    } else {
      canGrow = false;
    }
  }

  /**
   * Updates the cellArray instance variable according to the rule pattern.
   * The first and last elements of the array are always assigned 0.
   *
   * Postcondition: the cellArray instance variable represents the 
   * a new generation of states, which is the result of applying the
   * CA's rule pattern to the previous generation.
   */
  private void updateCellArray() {
    String[] newArray = new String[cellArray.length];
    for (int i = 1; i < newArray.length - 1; i++) {
      newArray[i] = getNewCellState(cellArray[i - 1] + cellArray[i] + cellArray[i + 1]);
    }
    newArray[0] = "0";
    newArray[newArray.length - 1] = "0";
    cellArray = newArray;
  }

  /**
   * Helper method to calculate the new state of a cell based on its neighborhood
   * in the previous generation.
   *
   * @param  neighborhood  An string of length 3, composed only of a combination of "0" and/or "1"
   * representing the states of the relevant cells in the previous generation. 
   * @return A string of length 1 representing a cell's new state.
   */
  private String getNewCellState(String neighborhood) {
    String[] arr = getRulePatternAsArray();
    String output;
    switch(neighborhood) {
    case "111":
      output = arr[0];
      break;
    case "110":
      output = arr[2];
      break;
    case "101":
      output = arr[3];
      break;
    case "100":
      output = arr[4];
      break;
    case "010":
      output = arr[5];
      break;
    case "001":
      output = arr[6];
      break;
    default:
      output = arr[7];
    }
    return output;
  }
  // TODO: change this method so it handles all possible 3-digit neighborhoods

  private float getCellSize() {
    return (float)width / cellArray.length;
  }

  private float getDrawSize() {
    return getCellSize() * drawScaleFactor;
  }

  public void show() {
    for (int i = 0; i < cellArray.length; i++) {
      if (cellArray[i].equals("1")) {
        fill(0);
        noStroke();
        rect(i * getCellSize(), 30 + getCurrentGenerationNumber() * getCellSize(), getDrawSize(), getDrawSize());
      }
    }
    // TODO: optionally change any of the code in this method to uniquify the drawing style of your program
  }

  public void showLabel() {
    int xAnchor = width/2;
    int yAnchor = width/2 + 45;
    int ruleWidth = width/8;
    int boxWidth = 10;
    int internalPadding = 40;
    textAlign(CENTER, TOP);
    fill(0);
    textFont(createFont("Courrier", 32));
    text("Rule " + getRuleNumber(), xAnchor, yAnchor);
    String[] rulePattern = getRulePatternAsArray();
    for (int i = 0; i < rulePattern.length; i++) {
      int localAnchor = i * ruleWidth + ruleWidth/2;
      String unpaddedBinary = Integer.toBinaryString(7-i); 
      String paddedBinary = "000".substring(unpaddedBinary.length()) + unpaddedBinary;
      String r = rulePattern[i];
      for (int b = 0; b < 3; b++) {
        if (paddedBinary.substring(b, b+1).equals("1")) {
          fill(0);
        } else {
          noFill();
        }
        stroke(0);
        strokeWeight(1);
        rect(localAnchor + boxWidth*(b-1) - boxWidth/2, yAnchor + internalPadding, boxWidth, boxWidth);
      }
      if (r.equals("1")) {
        fill(0);
      } else {
        noFill();
      }
      rect(localAnchor - boxWidth/2, yAnchor + internalPadding + boxWidth, 10, 10);
      textAlign(CENTER, TOP);
      textFont(createFont("Courier", 14));
      text(r, localAnchor, yAnchor + internalPadding + boxWidth*2.5);
    }
  }
}

void keyPressed() {
  if (key == 'r') {
    println(":-)");
    beginRecord(SVG, "output.svg");
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(0, 0, width, height);
    ellipseMode(CORNER);
    ellipse(10, 10, 15, 15);
    ellipse(width - 25, 10, 15, 15);
    c = new CellularAutomaton(requestedCellsPerGeneration, requestedRuleNumber);
    while (c.canGrow()) {
      c.show();
      c.evolve();
    }
    c.showLabel();
    endRecord();
  }
}
