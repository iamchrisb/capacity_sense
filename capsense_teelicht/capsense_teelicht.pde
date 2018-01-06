import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
float inByteA = 0;
float inByteB = 0;
float inByteC = 0;

void setup () {
  // set the window size:
  size(1920, 1000);

  // List all the available serial ports
  // if using Processing 2.1 or later, use Serial.printArray()
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, "COM6", 9600);

  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

  // set inital background:
  background(0);
  //delay(20);
}
void draw () {
  // draw the line:
  
  float maxHeight = 200;
  
  float lowerClick = 0;
  float upperClick = 1023;
  
  if(Float.NaN!=inByteA) {
    float mappedValueA = map(inByteA, lowerClick, upperClick, 0, maxHeight);
    float firstLineStartHeight = 50;
    stroke(0, 0, 255);
    line(xPos, firstLineStartHeight, xPos, firstLineStartHeight + mappedValueA);  
  }
  
  
  // next line
  float secondLineStartHeight = 300;
  float mappedValueB = map(inByteB, lowerClick, upperClick, 0, maxHeight);
  
  stroke(255, 0, 00);
  line(xPos, secondLineStartHeight, xPos, secondLineStartHeight + mappedValueB);
  
  float thirdLineStartHeight = 500;
  float mappedValueC = map(inByteC, lowerClick, upperClick, 0, maxHeight);
  
  stroke(0, 255, 0);
  line(xPos, thirdLineStartHeight, xPos, thirdLineStartHeight + mappedValueC);
  
  
  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    background(0);
  } else {
    // increment the horizontal position:
    xPos++;
  }
 
}


void serialEvent (Serial myPort) {
  // get the ASCII string:
  try {
    readSerialData(myPort);
  }catch(RuntimeException e) {
    //e.printStackTrace();
  }
}

void readSerialData(Serial myPort) {
   String inString = myPort.readStringUntil('\n');
  println("Values: " + inString);
  

  if (inString != null) {
    // trim off any whitespace:
    String[] tokenizedStrings = split(trim(inString), ' ');
    // convert to an int and map to the screen height:
    inByteA = float(trim(tokenizedStrings[0]));
    println("byteA: " + inByteA);
    
    inByteB = float(trim(tokenizedStrings[1]));
    println("byteB: " + inByteB);
    
   inByteC = float(trim(tokenizedStrings[2]));
    //println("byteC: " + inByteC);
  } 
}