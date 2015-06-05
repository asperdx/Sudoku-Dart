import 'dart:html';


TableElement board;
var tbody;
var tableCell;
var currentRow = 0;
var currentCell = 0;
String puzzle = "542731869187296345936485127213549678869127453475368912351974286694852731728613590";
int counter = 0;


void main() {
   board = new TableElement();
   board..setAttribute("border", "1");
   tbody = board.createTBody();
  makeSudokuBoard();
  ChangeCurrentCell();
  window.onKeyDown.listen(mykeyDown);
  window.onKeyUp.listen(callCheckBoard);
  window.onClick.listen(clickDown);

}

void clickDown(Event e){
  CheckCurrentCell();  
  ChangeCurrentCell();
  CheckBoard();
}

void mykeyDown(Event e){
  if(e is KeyboardEvent){ 
    KeyboardEvent kevent = e;
    
    switch(e.keyCode){
   
      case 38:
        currentRow--;
        while(!CheckNextCell())currentRow--;

        ChangeCurrentCell();
        CheckBoard();
        break;
      case 40:
        currentRow++;
        while(!CheckNextCell())currentRow++;

        ChangeCurrentCell();
        CheckBoard();
        break;
      case 37:
        currentCell--;
        while(!CheckNextCell())currentCell--;
        ChangeCurrentCell();
        CheckBoard();
        break;
      case 39:
        currentCell++;
        while(!CheckNextCell())currentCell++;

        ChangeCurrentCell();
        CheckBoard();
        break;
        
      default:
        CheckCurrentCell();
        ChangeCurrentCell();
        CheckBoard();
        break;
      
    }
  }
}

void callCheckBoard(Event e){
  CheckBoard();
}

void CheckBoard(){
  var check = 0;
  TableRowElement r = board.rows[currentRow];
  bool worked = true;
  List<TableCellElement> c = r.cells;
  var current = tableCell.text;
  try{
    var foo = int.parse(current);
  }catch(e){
    worked = false;
  }
  
  if(current == ""){}
  else if(!(worked)){ChangeColor(); return;}
  else{
    
  for(var i = 0; i < c.length; i++){
    if(currentCell == i){}
    else if(current == c[i].text){
     ChangeColor();
     return;
    }
    
    for(var i = 0; i < board.rows.length; i++){
      
      if(i == currentRow){}
      else if(board.rows[i].cells[currentCell].text == current){
        
        ChangeColor();
        return;
      }
    }
    

        int boxRowOffset = (currentRow ~/ 3)*3;
        int boxColOffset = (currentCell ~/ 3)*3;
        for (int k = 0; k < 3; ++k) // box
            for (int m = 0; m < 3; ++m)
                if (currentCell == boxColOffset+m && currentRow == boxRowOffset+k){}
                else if(board.rows[boxRowOffset+k].cells[boxColOffset+m].text == current){
                  ChangeColor();
                  return;
                }
        
        
    
  }
  
  

  }
  for(var i = 0; i < board.rows.length; i++)
          {for(var j = 0; j < board.rows[i].cells.length; j++){
            
            if(board.rows[i].cells[j].text != "") check++;
            
          }
  tableCell.style.background = "";
  if(check == 81)
    document.querySelector("#pageTitle").text = "winner";
}}


void CheckCurrentCell(){
  List<TableRowElement> r = board.rows;
  for(var i = 0; i < r.length; i++){
   List<TableCellElement> c = r[i].cells;
     for(var j = 0; j < c.length; j++){
      if(c[j] == querySelector(":focus")){
        currentRow = i;
        currentCell = j;
      }
     }
  }
  
}

bool CheckNextCell(){
  
  if(currentRow == -1) currentRow = 8;
  else if(currentRow == 9) currentRow = 0;
  else if(currentCell == -1) currentCell = 8;
  else if(currentCell == 9) currentCell = 0;
  var tableRow = board.rows[currentRow];
  tableCell = tableRow.cells[currentCell];
  return tableCell.isContentEditable;
  
}

void ChangeCurrentCell() {
    if(currentRow == -1) currentRow = 8;
    if(currentRow == 9) currentRow = 0;
    if(currentCell == -1) currentCell = 8;
    if(currentCell == 9) currentCell = 0;
    var tableRow = board.rows[currentRow];
    tableCell = tableRow.cells[currentCell];
    tableCell.focus();

}

void ChangeColor(){
  
  //tableCell.style.color = "red";
  tableCell.style.background = "#f44";
}
    
void makeSudokuBoard(){
  
  
    for(var i = 0; i < 9; i++){
      
      TableRowElement rows = tbody.addRow();
  
      for(var j = 0; j < 9; j++){
       
        String puzzleplace = puzzle.substring(counter, counter+1);
        if(puzzleplace == "0"){ 
  
          rows.insertCell(j).text = "";
                rows.cells[j].setAttribute("contenteditable","true");
        
        
        }else{
        rows.insertCell(j).text = puzzleplace;
        rows.cells[j].setAttribute("contenteditable","false");
        rows.cells[j].classes.add("default");
        
        }
        rows.cells[j].setAttribute("onkeypress", "return (this.innerText.length <= 0)");
        counter++;
      }
  
    }

  document.querySelector('#container').append(board);


}
