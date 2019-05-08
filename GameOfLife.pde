class GameOfLife {

  // How likely for a cell to be alive at start (in percentage)
  float probabilityOfAliveAtStart = 3;

  int totalX, totalY; 
  // Array of cells
  int[][] cells; 
  // Buffer to record the state of the cells and use this while changing the others in the interations
  int[][] cellsBuffer;

  String[][] neighborsBinary;  

  GameOfLife(int wSize, int hSize) {
    totalX = wSize; 
    totalY = hSize; 
    // Instantiate arrays 
    cells = new int[totalX][totalY];
    cellsBuffer = new int[totalX][totalY];
    neighborsBinary = new String[totalX][totalY];
    //initializeCells();
    loadCells("../design/"+DESIGN_FILENAME+".csv");
    //printCells();
  }

  //randomnly generate cells 
  void initializeCells() {
    for (int x=0; x<totalX; x++) {
      for (int y=0; y<totalY; y++) {
        float state = random (100);
        if (state > probabilityOfAliveAtStart) { 
          state = 0;
        } else {
          state = 1;
        }
        cells[x][y] = int(state); // Save state of each cell
        neighborsBinary[x][y] = "0000"; //getNeighborsBinary(x,y) ;
      }
    }
    
  }

  void loadCells(String filename) {
    // Load csv file as a table
    Table table = loadTable(filename);
    for (int i = 0; i< min(table.getColumnCount(),totalX); i++) {
       for (int j=0; j< min(table.getRowCount(),totalY); j++){
         cells[i][j]= table.getInt(i,j); 
       }  
    }
  }

//save the drawing as a csv file 
  void saveCells(String filename){
    
    Table table = new Table() ;
    
    for (int i = 0; i< totalX; i++) {
       table.addColumn() ;
    }
    for (int j=0; j< totalY; j++){
      table.addRow() ;
    }         
    for (int i = 0; i< totalX; i++) {
       for (int j=0; j< totalY; j++){        
          table.setInt(i,j, cells[i][j]); 
       }  
    }
    saveTable(table, "design/"+filename);
    println("saved current design to ",filename);
  }
  
  void clearAllCells(){
    for (int x=0; x<totalX; x++) {
      for (int y=0; y<totalY; y++) {
        cells[x][y] = 0;
      }
    }
  }

  void printCells() {
    for (int x=0; x<totalX; x++) {
      for (int y=0; y<totalY; y++) {
        print(cells[x][y]);
        print(' ' );
      }
      println();
    }
  }

  void setCell(int x, int y) {
    //wrap
    x = (x+totalX) % totalX;
    y = (y+totalY) % totalY;
    //int a = 1+int(random(modules.length));//offset by 1 since 0 means not rendering
    int a = 1+int(random(4));//offset by 1 since 0 means not rendering
    cells[x][y] = a;
  }
  
  void setCellStateFromChar(int x, int y, char c){
    x = (x+totalX) % totalX;
    y = (y+totalY) % totalY; 
    cells[x][y] = int(c)-64; //turn 'A' to 1. 
  }

  void unSetCell(int x, int y) {
    x = (x+totalX) % totalX;
    y = (y+totalY) % totalY; 
    cells[x][y] = 0;
  }

  int getCellStateInt(int x, int y){
    if (x > 0 && x<totalX && y > 0 && y < totalY) {
      return cells[x][y];
    }
    return 0;
  }
  
  char getCellStateChar(int x, int y) {
    if (x > 0 && x<totalX && y > 0 && y < totalY) {
      return char(cells[x][y]+48);
    }
    return '0';
  }

  String getNeighborsBinary(int gridX, int gridY) {
    String binaryResult = "";
    // check the four neighbours. is it active (not '0')? 
    // create a binary result out of it, eg. 1011
    // binaryResult = north + west + south + east;
    // north
    if (gol.getCellStateChar(gridX, gridY-1) != '0') binaryResult = "1";
    else binaryResult = "0";
    // west
    if (gol.getCellStateChar(gridX-1, gridY) != '0') binaryResult += "1";
    else binaryResult += "0";  
    // south
    if (gol.getCellStateChar(gridX, gridY+1) != '0') binaryResult += "1";
    else binaryResult += "0";
    // east
    if (gol.getCellStateChar(gridX+1, gridY) != '0') binaryResult += "1";
    else binaryResult += "0";

    // convert the binary string to a decimal value from 0-15
    //int decimalResult = unbinary(binaryResult);

    return binaryResult;
  }

  void iterate() {
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<totalX; x++) {
      for (int y=0; y<totalY; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }

    //  //CONVAY'S GAME OF LIFE 
    //  // Visit each cell:
    //  for (int x=0; x<totalX; x++) {
    //    for (int y=0; y<totalY; y++) {
    //      // And visit all the neighbours of each cell
    //      int neighbours = 0; // We'll count the neighbours
    //      for (int xx=x-1; xx<=x+1; xx++) {
    //        for (int yy=y-1; yy<=y+1; yy++) {  
    //          if (((xx>=0)&&(xx<totalX))&&((yy>=0)&&(yy<totalY))) { // Make sure you are not out of bounds
    //            if (!((xx==x)&&(yy==y))) { // Make sure to to check against self
    //              if (cellsBuffer[xx][yy]==1) {
    //                neighbours ++; // Check alive neighbours and count them
    //              }
    //            } // End of if
    //          } // End of if
    //        } // End of yy loop
    //      } //End of xx loop
    //      // We've checked the neigbours: apply rules!
    //      if (cellsBuffer[x][y]==1) { // The cell is alive: kill it if necessary
    //        if (neighbours < 2 || neighbours > 3) {
    //          cells[x][y] = 0; // Die unless it has 2 or 3 neighbours
    //        }
    //      } else { // The cell is dead: make it live if necessary      
    //        if (neighbours == 3 ) {
    //          cells[x][y] = 1; // Only if it has 3 neighbours
    //        }
    //      } // End of if
    //    } // End of y loop
    //  } // End of x loop
    //}


    ////EXPERIMENT WITH RULES  
    // Visit each cell:
    for (int x=0; x<totalX; x++) {
      for (int y=0; y<totalY; y++) {
        //only apply to a small portion of the cells 
        if (getCellStateChar(x, y) != '0' && random(1)> RATIO_TO_ANIMATE ) {
          String neighbor = getNeighborsBinary(x, y); 
          int r = int(random(0, 2))*2-1; //-1 or 1 
          //int r =  0 ;
          //println(x , y, r);
          switch(neighbor) {
          case "1111":
            unSetCell(x, y);
            break;
          case "0000":
            unSetCell(x, y);
            break;
          case "0001":
            
            setCell(x-1, y); 
            unSetCell(x+1, y);
            break;
          case "0010":
            setCell(x, y+1); 
            unSetCell(x, y-1);
            break;
          case "0100":
            setCell(x+1, y); 
            unSetCell(x-1, y);
            break;
          case "1000":
            setCell(x, y+1); 
            unSetCell(x, y-1);
            break;
          case "1011":
            setCell(x, y+2);
            //unSetCell(x, y);
            break;
          case "1101":
            setCell(x, y-2);
            //unSetCell(x, y);
            break;
          case "1110":
            setCell(x-2, y);
            //unSetCell(x, y);
            break;
          case "0111":
            setCell(x, y+2);
            //unSetCell(x, y);
            break;

          case "0101":
            setCell(x+2*r, y);
            break;
          case "1010":
            setCell(x, y+r*2);
            break;
          case "0011":
            setCell(x+2, y);
            unSetCell(x, y+1);
            break;
          case "0110":
            setCell(x-2, y);
            unSetCell(x, y+1);
            break;
          case "1100":
            setCell(x, y+2);
            unSetCell(x-1, y);
            break; 
          case "1001":
            setCell(x, y-2);
            unSetCell(x+1, y);
            break;
          }
        }
      } // End of y loop
    } // End of x loop
  }
}//end of class def