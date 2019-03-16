-----------------------------------------------------------------------------------------
-- main.lua

--Name - Meharban singh
--Studentno- 10352902
--Course - Bachelor of IT
--University - Edith Cowan University
--This is Assignment2
-----------------------------------------------------------------------------------------

-- require widget library for Creating button in Corona---

 local widget = require( "widget" )


---Function to clear the score and write them in file

 local function clearFile()

      wins = 0
      looses = 0
      draw = 0
      saveData = 0
      saveData1 = 0
      saveData2 = 0
      -- Path for the file to write
     local path = system.pathForFile( "myfile.txt", system.DocumentsDirectory )
 
       -- Open the file handle
     local file, errorString = io.open( path, "w" )
 
       if not file then
           -- Error occurred; output the cause
           print( "File error: " .. errorString )
      else
          -- Write data to file
          file:write( saveData..'\n' )
	      file:write( saveData1..'\n' )
	      file:write( saveData2..'\n' )
          -- Close the file handle
          io.close( file )
       end

      file = nil

   end

 local function fileWrite()

     saveData = wins
     saveData1 = looses
     saveData2 = draw
 
     -- Path for the file to write
     local path = system.pathForFile( "myfile.txt", system.DocumentsDirectory )
     -- Open the file handle
     local file, errorString = io.open( path, "w" )
 
       if not file then
          -- Error occurred; output the cause
	      print( "File error: " .. errorString )
      else
          -- Write data to file
          file:write( saveData..'\n' )
	      file:write( saveData1..'\n' )
	      file:write( saveData2..'\n' )
          -- Close the file handle
          io.close( file )
       end

      file = nil

   end



  local function readFile()
      array ={}
      local path = system.pathForFile( "myfile.txt", system.DocumentsDirectory )
 
      -- Open the file handle
      local file, errorString = io.open( path, "r" )
       if not file then
	   
         winsUpdate = 0
         loosesUpdate = 0
         drawUpdate = 0

         -- Error occurred; output the cause
         print( "File error: " .. errorString )
      else
         -- Read data from file
	       for line in file:lines() do
	         table.insert(array,line)  
		     
	       end
	
	     winsUpdate = array[1]
	     loosesUpdate = array[2]
	     drawUpdate = array[3]
         -- Close the file handle
         io.close( file )
	
       end
      file = nil
   end

----To display image at background
 local function backgroundImage()
      local image = display.newImageRect( "lk.jpg", 400, 600 )
      image.x = display.contentCenterX
      image.y = display.contentCenterY
  end

 backgroundImage()

---declaring all dimensions

local d = display 
local w20 = d.contentWidth * .2
local h20 = d.contentHeight * .2
local w40 = d.contentWidth * .4 
local h40 = d.contentHeight * .4 
local w60 = d.contentWidth * .6 
local h60 = d.contentHeight * .6 
local w80 = d.contentWidth * .8 
local h80 = d.contentHeight * .8 
 
----DRAW LINES FOR BOARD
 local lline = d.newLine(w40,h20,w40,h80 )
 lline.strokeWidth = 5
 lline:setStrokeColor(0,0.6,1)
 
local rline = d.newLine(w60,h20,w60,h80 )
 rline.strokeWidth = 5 
 rline:setStrokeColor(0,0.5,1)
 
local bline = d.newLine(w20,h40,w80,h40 )
bline.strokeWidth = 5 
bline:setStrokeColor(0,0.6,1)
 
local tline = d.newLine(w20,h60,w80,h60 )
tline.strokeWidth = 5
tline:setStrokeColor(0,0.6,1.2) 


 
 
--PLACE BOARD COMPARTMENT DIMENSIONS IN TABLE 
local board ={ 
 
{"tl", 1, w20, h40, w40, h20,0,true},
 {"tm",2, w40,h40,w60,h20,0,true},
 {"tr",3, w60,h40,w80,h20,0,true}, 
 
{"ml", 4, w20, h60, w40, h40,0,true},
 {"mm",5, w40,h60,w60,h40,0,true},
 {"mr",6, w60,h60,w80,h40,0,true}, 
 
{"bl", 7, w20, h80, w40, h60,0,true}, 
{"bm",8, w40,h80,w60,h60,0,true}, 
{"br",9, w60,h80,w80,h60,0,true} 
        }
 
-- declare all variables
local EMPTY, X, O = 0, 1, 2
local whichturn = X -- X is starting game
local gameRunning = false
local computerButton
local humanButton
local computerFirst = false
local humanFirst = false
local difficulty = " "
local displayO
local displayX
local objectsOnScreen = {}
local turnCountHuman = 0
local turnCountComputer = 1
local copy = {} 
local replayCopy = {}
local replayCopyO={}

----All displaying texts on screen------

 local winText = d.newText("",50,500,Arial,20)
       winText:setFillColor(0,0,0)

 local looseText = d.newText("",160,500,Arial,20)
       looseText:setFillColor(0,0,0)

 local drawText = d.newText("",250,500,Arial,20)
       drawText:setFillColor(0,0,0)

 local text = d.newText("Please choose who will go first",160,10,Arial,20)
      text:setFillColor(0,0,0)

  local function dft()
        difficultyText = d.newText("Please choose the difficulty level",160,10,Arial,20)
        difficultyText:setFillColor(0,0,0)
   end 


-- call function to readFile to get value of variables winUpdate,loosesUpdate,drawUpdate

readFile()

--global variables
 wins = winsUpdate
 looses = loosesUpdate
 draw = drawUpdate
 
-- create a function to remove objects from the screen
 
 local function removeAllScreenObjects()
       for i=1, #objectsOnScreen do
           if(objectsOnScreen[i] ~= nil )then
	          print(objectsOnScreen[i])
              objectsOnScreen[i]:removeSelf()
              objectsOnScreen[i] = nil
           end
      end
  end
  
  --Create undo buttonFunction--
  
  function undoButtonFunction( event )
 
     if ( "ended" == event.phase ) then
	
	     table.remove(replayCopy)
	     table.remove(replayCopyO)
	     undoButton:setEnabled( false )  
	     turnCountComputer=turnCountComputer-1
	     n=#copy
	     a = 2
	
	       if(gameRunning) then
		      while a ~=0 do
			       for w = n,1,-1 do
				       if(copy[w]~=nil)then
				          copy[w]:removeSelf()
				          copy[w] = nil
				          objectsOnScreen[w]:removeSelf()
				          objectsOnScreen[w]=nil
				          n = n-1
				          board[rowid][7]=0
				          board[rowid][8]=true
				          board[comprow][7]=0
				          board[comprow][8]=true
				          break
				       end
		           end
			     a=a-1
		      end
	      end
      end
  end

--create Undo button--

 local function undo()

     undoButton = widget.newButton(
     {
        id = "undobutton",
        label = "Undo",
        onEvent = undoButtonFunction,
		shape = "roundedRect",
        width = 60,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
      }
        )
     undoButton.x = 260
     undoButton.y = 410

   end

---create replay button function


 function replayButtonFunction(event)
       
       if ( "ended" == event.phase ) then
	        replayButton:setEnabled(false)
	
	       for v = 1,#objectsOnScreen do
		   
		       objectsOnScreen[v]:removeSelf()
			   objectsOnScreen[v]=nil
		   end
	       
		  u=1 
	      local function action(event)
		 
	          for i = u,#replayCopy do
		          --print(replayCopy[i])
		          new = replayCopy[i]
		          board[new][7]=X
		           if(board[new][7]==1) then
			          displayX = d.newText("X",board[new][3]+30,board [new][6]+40,Arial,30)
			          displayX:setFillColor( 1, 0, 0 )
				      table.insert(objectsOnScreen,displayX)
				   end
		         break
	           end
		       for i = u,#replayCopyO do
		          newO = replayCopyO[i]
		          board[newO][7]=O
		
		          if(board[newO][7]== 2) then
                      displayO = d.newText("O",board[newO][3]+30,board [newO][6]+40,Arial,30)
			          displayO:setFillColor( 0.2, 0, 1 )
				      table.insert(objectsOnScreen,displayO)
			        end
		         break
	           end
			   u=u+1
   	       end
	      timer.performWithDelay(1000,action,#replayCopy)
       end
  end

--create replay button--

local function replay()

    replayButton = widget.newButton(
    {
        
        id = "undobutton",
        label = "replay",
        onEvent = replayButtonFunction,
		shape = "roundedRect",
        width = 60,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)


replayButton.x = 60
replayButton.y = 410

end

---Creating clearbutton function and clear Score Button 

 function clearButtonFunction( event )
 
       if ( "ended" == event.phase ) then
		  winText.text = "wins\n".."0"
          looseText.text = "looses\n".."0"
          drawText.text = "draw\n".."0"
		  clearFile()	
       end
	
   end


local function clearScoreButton()

    clearButton = widget.newButton(
    {
        
        id = "clearScore",
        label = "clear Score",
        onEvent = clearButtonFunction,
		shape = "roundedRect",
        width = 100,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)

clearButton.x = 150
clearButton.y = 455

end



--Create Reset Button---

local function rB()

    resetButton = widget.newButton(
    {
        
        id = "resetButton",
        label = "ResetBoard",
        onEvent = resetButtonFunction,
		shape = "roundedRect",
        width = 100,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)

-- place the human button on screen
resetButton.x = 150
resetButton.y = 410

end

 local function difficultyButtonEasy( event )


       if ( "ended" == event.phase ) then
	
          difficulty = "easy"
		  gameRunning = true
		  easyBtn:removeSelf() 
		  mediumBtn:removeSelf()
		  hardBtn:removeSelf()
		  difficultyText:removeSelf()
		  rB()
		  undo()
		  undoButton:setEnabled( false )  
		
		   if(computerFirst) then
			  a = math.random(1,9) -- Generate random number between (1 to 9)
			  board[a][7] = X -- Place "X" on board at random place.
			  table.insert(replayCopy,a)
			 --display "X" on screen
			   for k = 1,9 do
			  
				   if(board[k][7]==1) then
				      r = d.newText("X",board[k][3]+30,board [k][6]+40,Arial,30)
				      r:setFillColor( 1, 0, 0 )
					  table.insert(objectsOnScreen,r)
					  table.insert(copy,r)
			       end
			  
			   end
		   end	 
	   end
  end

---Creating easy button displaying function

local function easy()

easyBtn = widget.newButton(
    {
       
        id = "easyButton",
        label = "Easy",
        onEvent = difficultyButtonEasy,
		shape = "roundedRect",
        width = 60,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)

-- place the human button on screen
easyBtn.x = 70
easyBtn.y = 50


end

local function medium()

mediumBtn = widget.newButton(
    {
       
        id = "mediumBtn",
        label = "Medium",
        onEvent = difficultyButtonMedium,
		shape = "roundedRect",
        width = 80,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)

-- place the human button on screen
mediumBtn.x = 160
mediumBtn.y = 50


end

local function hard()

hardBtn = widget.newButton(
    {
        left = 100,
        top = 200,
        id = "hardButton",
        label = "Hard",
        onEvent = difficultyButtonHard,
		shape = "roundedRect",
        width = 80,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)

-- place the human button on screen
hardBtn.x = 260
hardBtn.y = 50


end

 function difficultyButtonMedium( event )
 
       if ( "ended" == event.phase ) then
           difficulty = "medium"
		   gameRunning = true
		   easyBtn:removeSelf()   
		   mediumBtn:removeSelf()      
		   hardBtn:removeSelf()
		   difficultyText:removeSelf()
		   rB()
		   undo()
		   undoButton:setEnabled( false )
		   
		   if(computerFirst) then
			  a = math.random(1,9) -- Generate random number between (1 to 9)
		      board[a][7] = X  -- Place "X" on board at random place.
		      table.insert(replayCopy,a)
		      -- display "X" on screen
	          for k = 1,9 do
		  
		           if(board[k][7]==1) then
			          r = d.newText("X",board[k][3]+30,board [k][6]+40,Arial,30)
			          r:setFillColor( 1, 0, 0 )
			          table.insert(objectsOnScreen,r)
				      table.insert(copy,r)
		  
		           end
		      end
          end
		
       end
	
   end

 function difficultyButtonHard( event )
 
      if ( "ended" == event.phase ) then
		   difficulty = "hard"
		   gameRunning = true
		   easyBtn:removeSelf()   
		   mediumBtn:removeSelf()      
		   hardBtn:removeSelf()
		   difficultyText:removeSelf()
		   rB()
		   undo()
		   undoButton:setEnabled( false )  
					 
		   if(computerFirst) then
			   board[5][7] = X
			   table.insert(replayCopy,5)
					 
			   for k = 1,9 do
		  
		           if(board[k][7]==1) then
			         r = d.newText("X",board[k][3]+30,board [k][6]+40,Arial,30)
			         r:setFillColor( 1, 0, 0 )
			         table.insert(objectsOnScreen,r)
				     table.insert(copy,r)
		  
		           end
		       end
				
			
		   end
		 
       end
	
   end






 function resetButtonFunction( event )
 
       if ( "ended" == event.phase ) then
       
	        removeAllScreenObjects()  
		
		  for q = 1,9 do
			  board[q][7] = EMPTY
			  board[q][8] = true
			  print(board[q][7])
			  copy[q] = nil
			  replayCopy[q]=nil
			  replayCopyO[q]=nil
			
		  end
		 
		  gameRunning = false
		  resetButton:removeSelf()
		  undoButton:removeSelf()
		  dft()
		  easy()
		  medium()
		  hard()
		  turnCountComputer = 1
		  turnCountHuman = 0		  
		 
      end
	
  end




 -- creating button's on screen for choosing between Human go first or Computer go first
 
--Creating Computer go first button
 function computerButton( event )
 
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
		gameRunning = false  -- if button pressed switch the game on
		computerFirst = true   --Switch the ComputerFirst variable true
		humanButton:removeSelf() --remove the button after button pressed
		computerButton:removeSelf() --remove the button after button pressed
		text:removeSelf()
		dft()
		easy()
		medium()
		hard()
		clearScoreButton()
    end  
end

--Properties of Computer button
  computerButton = widget.newButton(
    {
        left = 100,
        top = 200,
        id = "button1",
        label = "Computer go first",
        onEvent = computerButton,
		
		shape = "roundedRect",
        width = 150,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)

-- place the Computer button
computerButton.x = d.contentWidth-90
computerButton.y = d.contentHeight

--Create Human go first Button

 function humanButton( event )
 
    if ( "ended" == event.phase ) then
       print( "Button was pressed and released" )
	   gameRunning = false
	   humanFirst = true
	   humanButton:removeSelf()
	   computerButton:removeSelf()
		text:removeSelf()
	 ---Display choose difficulty level text
		dft()
		--Create Difficulty levels  buttons
		easy()
		medium()
		hard()
		clearScoreButton()
		
	end
	
end

-- Properties of human Button
 humanButton = widget.newButton(
    {
        left = 100,
        top = 200,
        id = "button1",
        label = "Human go first",
        onEvent = humanButton,
		
		shape = "roundedRect",
        width = 130,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)

-- place the human button on screen
humanButton.x = d.contentWidth-240
humanButton.y = d.contentHeight


-- check if board is full then return true other wise if one or more than one grid is empty then return false
 
 local function boardIsFull()

	   local bd = board

	   for i = 1, 9 do
	
			if( bd[i][7] == EMPTY ) then 
				return false 
			end
	   end
     
	  return true
  end


----Create a function find two in a row
 local function twoinrow(turn,O)
 
 local bd = board
           
		   
         
		if(bd[1][7]== O and  bd[2][7] == O and bd[3][7]== 0) then -- COL 1
		 bd[3][7]= O
		 comprow = 3
		elseif(bd[4][7]== O and  bd[5][7] == O and bd[6][7]== 0) then
		 bd[6][7] = O
		 comprow = 6
		elseif(bd[7][7]== O and  bd[8][7] == O and bd[9][7]== 0) then
		 bd[9][7] = O
		 comprow = 9
		elseif(bd[1][7]== O and  bd[4][7] == O and bd[7][7]== 0) then
		 bd[7][7] = O
		 comprow = 7
		elseif(bd[2][7]== O and  bd[5][7] == O and bd[8][7]== 0) then
		 bd[8][7] = O
		 comprow = 8
		elseif(bd[3][7]== O and  bd[6][7] == O and bd[9][7]== 0) then
		 bd[9][7] = O
		 comprow = 9
		elseif(bd[1][7]== O and  bd[5][7] == O and bd[9][7]== 0) then
		 bd[9][7] = O
		 comprow = 9
		elseif(bd[3][7]== O and  bd[5][7] == O and bd[7][7]== 0) then
		 bd[7][7] = O
		 comprow = 7
		 
		 
		 elseif(bd[1][7]== O and  bd[2][7] == 0 and bd[3][7]== O) then -- COL 1
		  bd[2][7]= O
		  comprow = 2
		elseif(bd[4][7]== O and  bd[5][7] == 0 and bd[6][7]== O) then
		 bd[5][7] = O
		 comprow = 5
		elseif(bd[7][7]== O and  bd[8][7] == 0 and bd[9][7]== O) then
		 bd[8][7] = O
		 comprow = 8
		elseif(bd[1][7]== O and  bd[4][7] == 0 and bd[7][7]== O) then
		 bd[4][7] = O
		 comprow = 4
		elseif(bd[2][7]== O and  bd[5][7] == 0 and bd[8][7]== O) then
		 bd[5][7] = O
		 comprow = 5
		elseif(bd[3][7]== O and  bd[6][7] == 0 and bd[9][7]== O) then
		 bd[6][7] = O
		 comprow = 6
		elseif(bd[1][7]== O and  bd[5][7] == 0 and bd[9][7]== O) then
		 bd[5][7] = O
		 comprow = 5
		elseif(bd[3][7]== O and  bd[5][7] == 0 and bd[7][7]== O) then
		 bd[5][7] = O
		 comprow = 5
		 
		 
		 elseif(bd[1][7]== 0 and  bd[2][7] == O and bd[3][7]== O) then -- COL 1
		  bd[1][7]= O
		  comprow = 1
		elseif(bd[4][7]== 0 and  bd[5][7] == O and bd[6][7]== O) then
		 bd[4][7] = O
		 comprow = 4
		elseif(bd[7][7]== 0 and  bd[8][7] == O and bd[9][7]== O) then
		 bd[7][7] = O
		 comprow = 7
		 elseif(bd[1][7]== 0 and  bd[4][7] == O and bd[7][7]== O) then
		 bd[1][7] = O
		 comprow = 1
		elseif(bd[2][7]== 0 and  bd[5][7] == O and bd[8][7]== O) then
		 bd[2][7] = O
		 comprow = 2
		elseif(bd[3][7]== 0 and  bd[6][7] == O and bd[9][7]== O) then
		 bd[3][7] = O
		 comprow = 3
		elseif(bd[1][7]==0 and  bd[5][7] == O and bd[9][7]== O) then
		bd[1][7] = O
		comprow = 1
		elseif(bd[3][7]== 0 and  bd[5][7] == O and bd[7][7]== O) then
		 bd[3][7] = O
		 comprow = 3
	 

	   elseif(bd[1][7]== turn and  bd[2][7] == turn and bd[3][7]== 0) then -- COL 1
		  bd[3][7]= O
		  comprow = 3
		elseif(bd[4][7]== turn and  bd[5][7] == turn and bd[6][7]== 0) then
		 bd[6][7] = O
		 comprow = 6
		elseif(bd[7][7]== turn and  bd[8][7] == turn and bd[9][7]== 0) then
		 bd[9][7] = O
		 comprow = 9
		elseif(bd[1][7]== turn and  bd[4][7] == turn and bd[7][7]== 0) then
		 bd[7][7] = O
		 comprow = 7
		elseif(bd[2][7]== turn and  bd[5][7] == turn and bd[8][7]== 0) then
		 bd[8][7] = O
		 comprow = 8
		elseif(bd[3][7]== turn and  bd[6][7] == turn and bd[9][7]== 0) then
		 bd[9][7] = O
		 comprow = 9
		elseif(bd[1][7]== turn and  bd[5][7] == turn and bd[9][7]== 0) then
		 bd[9][7] = O
		 comprow = 9
		elseif(bd[3][7]== turn and  bd[5][7] == turn and bd[7][7]== 0) then
		 bd[7][7] = O
		 comprow = 7
		 
		 
		 elseif(bd[1][7]== turn and  bd[2][7] == 0 and bd[3][7]== turn) then -- COL 1
		  bd[2][7]= O
		  comprow = 2
		elseif(bd[4][7]== turn and  bd[5][7] == 0 and bd[6][7]== turn) then
		 bd[5][7] = O
		 comprow = 5
		elseif(bd[7][7]== turn and  bd[8][7] == 0 and bd[9][7]== turn) then
		 bd[8][7] = O
		 comprow = 8
		 elseif(bd[1][7]== turn and  bd[4][7] == 0 and bd[7][7]== turn) then
		 bd[4][7] = O
		 comprow = 4
		elseif(bd[2][7]== turn and  bd[5][7] == 0 and bd[8][7]== turn) then
		 bd[5][7] = O
		 comprow = 5
		elseif(bd[3][7]== turn and  bd[6][7] == 0 and bd[9][7]== turn) then
		 bd[6][7] = O
		 comprow = 6
		elseif(bd[1][7]== turn and  bd[5][7] == 0 and bd[9][7]== turn) then
		 bd[5][7] = O
		 comprow = 5
		elseif(bd[3][7]== turn and  bd[5][7] == 0 and bd[7][7]== turn) then
		 bd[5][7] = O
		 comprow = 5
		 
		 
		 elseif(bd[1][7]== 0 and  bd[2][7] == turn and bd[3][7]== turn) then
		  bd[1][7]= O
		  comprow = 1
		elseif(bd[4][7]== 0 and  bd[5][7] == turn and bd[6][7]== turn) then
		 bd[4][7] = O
		 comprow = 4
		elseif(bd[7][7]== 0 and  bd[8][7] == turn and bd[9][7]== turn) then
		 bd[7][7] = O
		 comprow = 7
		 elseif(bd[1][7]== 0 and  bd[4][7] == turn and bd[7][7]== turn) then
		 bd[1][7] = O
		 comprow = 1
		elseif(bd[2][7]== 0 and  bd[5][7] == turn and bd[8][7]== turn) then
		 bd[2][7] = O
		 comprow = 2
		elseif(bd[3][7]== 0 and  bd[6][7] == turn and bd[9][7]== turn) then
		 bd[3][7] = O
		 comprow = 3
		elseif(bd[1][7]==0 and  bd[5][7] == turn and bd[9][7]== turn) then
		 bd[1][7] = O
		 comprow = 1
		elseif(bd[3][7]== 0 and  bd[5][7] == turn and bd[7][7]== turn) then
		 bd[3][7] = O
		 comprow = 3
		 
	     --Play at center
	     elseif (bd[5][7]==0)then
		     bd[5][7] = O
			 comprow = 5
		  --Play at corner
	     elseif(bd[1][7]==0)then
		        bd[1][7]=O
				comprow = 1
				
	     elseif(bd[3][7]==0)then
		        bd[3][7]=O
				comprow = 3
		 elseif(bd[7][7]==0)then
		        bd[7][7]=O
				comprow = 7
		 elseif(bd[9][7]==0)then
		        bd[9][7]=O
				comprow = 9
		--Play at any empty corner
          elseif(bd[2][7]==0)then
                bd[2][7]=O
                comprow = 2				
		 
		elseif(bd[4][7]==0)then
                bd[4][7]=O
		        comprow = 4
		elseif(bd[6][7]==0)then
                bd[6][7]=O
				comprow = 6
		
		elseif(bd[8][7]==0)then
               bd[8][7]=O
			   comprow = 8
				 
		
		end
		
		
       
 end

 

 -- creating Computer play function. 
 
  local function computerAI()
  
       if (humanFirst and gameRunning == true and difficulty == "easy") then
  
           local r = math.random(1,9)
  
           if(board[r][7] == EMPTY)then
               board[r][7] = O
		       comprow = r
	      elseif(not boardIsFull()) then
               computerAI()
           end
	   
	  elseif(humanFirst and gameRunning == true and difficulty == "medium") then
	   
	       if(turnCountHuman==1 or turnCountHuman==3 or turnCountHuman==5 or turnCountHuman==7 or turnCountHuman==9)then
		        --print("random turn")
		        local r = math.random(1,9)
               if(board[r][7] == EMPTY)then
                  board[r][7] = O
			      comprow = r
	          elseif( not boardIsFull()) then
                  computerAI()
               end
				
	       else
			   --print("Smart turn")	
			    twoinrow(X,O)
			
		   end
	   
	   
	  elseif (humanFirst and gameRunning == true and difficulty == "hard") then
           
		  twoinrow(X,O)
  
      elseif(computerFirst and gameRunning == true and difficulty == "easy") then
            local r = math.random(1,9)
  
           if(board[r][7] == EMPTY)then
               board[r][7] = X
			   comprow = r
	           return r
	      elseif( not boardIsFull() ) then
	           computerAI()
           end
          
	 elseif (computerFirst and gameRunning == true and difficulty == "medium") then
		  
		   if(turnCountComputer==1 or turnCountComputer==3 or turnCountComputer==5 or turnCountComputer==7 or turnCountComputer==9)then
		       print("random")
			   local r = math.random(1,9)
               if(board[r][7] == EMPTY)then
                   board[r][7] = X
			       comprow = r
	          elseif(not boardIsFull()) then
                    computerAI()
               end
					
		   else
				
			   twoinrow(O,X)
				
		   end
  
           
     elseif (computerFirst and gameRunning == true and difficulty == "hard") then
         
		    twoinrow(O,X)
		
	
       end
 
   
  end  
  
 
--- check for winner
checkForWinner = function( turn )

	 local bd = board
	 row1,row2,row3,coln1,coln2,coln3,dgn1,dgn2=0,0,0,0,0,0,0,0

	
     for i = 1,3 do
	    
	          if(bd[i][7]==turn) then
			  row1=row1+1
			  elseif(bd[i+3][7]==turn) then
			  row2=row2+1
			  elseif(bd[i+6][7]==turn) then
			  row3=row3+1
			  end
	   end 
	   for j = 1,9,3 do
	    
	          if(bd[j][7]==turn) then
			  coln1=coln1+1
			  elseif(bd[j+1][7]==turn) then
			  coln2=coln2+1
			  elseif(bd[j+2][7]==turn) then
			  coln3=coln3+1
			  end
	   end 
	   
	    for k = 1,9,4 do
	    
	          if(bd[k][7]==turn) then
			  dgn1=dgn1+1
			  
			  end
	   end 
	   
	    for l = 3,7,2 do
	    
	       if(bd[l][7]==turn) then
			  dgn2=dgn2+1 
			  
			end
	   end 
	   
	   if(row1==3 or row2==3 or row3==3 or coln1==3 or coln2==3 or coln3==3 or dgn1==3 or dgn2==3) then 
	     return true
	   else
	     return false
	   end
	   
	
  end

  local function winOrDraw()

       if( checkForWinner(X)) then
		  w = d.newText("X".." ".."wins",150,10,Arial,40)
		  w:setFillColor(0,0,0)
		  table.insert(objectsOnScreen,w)
		  gameRunning = false
		  replay()
		  table.insert(objectsOnScreen,replayButton)
		
		 
	 elseif( checkForWinner(O)) then
		  bw = d.newText("O".." ".."wins",150,10,Arial,40)
		  bw:setFillColor(0,0,0)
		  table.insert(objectsOnScreen,bw)
		  gameRunning = false
		  replay()
		  table.insert(objectsOnScreen,replayButton)
		
	 elseif(boardIsFull()) then
         n = d.newText("NO wins",150,10,Arial,40)
		 n:setFillColor(0,0,0)
		 table.insert(objectsOnScreen,n)
		 gameRunning = false
		 replay()
		 table.insert(objectsOnScreen,replayButton)
			
			
		
	   end
   
  end

 local function updateScore()


       if (humanFirst) then

          if checkForWinner(X) then
             wins = wins+1
          elseif checkForWinner(O) then
             looses = looses+1
          elseif(boardIsFull()) then
              draw = draw+1
          end
   
     elseif(computerFirst) then
    
           if checkForWinner(O) then
              wins = wins+1
          elseif checkForWinner(X) then
              looses = looses+1
          elseif(boardIsFull()) then
              draw = draw+1
          end
   
   
       end

       winText.text = "wins\n"..wins
       looseText.text = "looses\n"..looses
       drawText.text = "draw\n"..draw
   end

----------------------------------

 local function undoTimer()

      local counter = 5

       if (gameRunning) then
  
  
         --timeDisplay = display.newText(counter,270,360,Arial,30)
         --timeDisplay:setFillColor(0,0,0)
           undoButton:setEnabled( true )  

         local function updateTimer(event)
              counter = counter-1
             --timeDisplay.text = counter
               print(counter)
               if(counter == 0) then
                 --timeDisplay.isVisible = false
                   undoButton:setEnabled( false )  
               end
  
           end
		   
          timer.performWithDelay(1000,updateTimer,5)


    
       end
   end

-----



--FILL COMPARTMENT With "X" or "O" WHEN TOUCHED


  local function fill (event)
 
      -- ignore the touch if game is over or not on yet
        if ( not gameRunning ) then
		   return true
       end
	   
	 
      if (event.phase == "ended") then
  
          for t = 1, 9 do
 
               if event.x > board[t][3] and event.x < board [t][5] then 
                   if event.y < board[t][4] and event.y > board[t][6] then
			 
                       if (humanFirst) then   --if human go first button selected
                           if (board[t][7] == EMPTY) then
                               board[t][7] = X
							   table.insert(replayCopy,t)
							   rowid= t
			                   winOrDraw()
				               turnCountHuman = turnCountHuman+1
			                   computerAI()
							   table.insert(replayCopyO,comprow)
							   winOrDraw()
				               updateScore()
				               fileWrite()
							   undoButton:setEnabled( true )  
							   undoTimer()
							    
								 
							   
				           end
		              end
	
	                  if (computerFirst) then --if computer go first button selected
	                       if (board[t][7] == EMPTY) then
			                 board[t][7] = O
							 table.insert(replayCopyO,t)
							 rowid=t
				             winOrDraw()
				             turnCountComputer = turnCountComputer+1
			                 computerAI()
							 table.insert(replayCopy,comprow)
			                 winOrDraw()
			                 updateScore()
			                 fileWrite()
							 undoButton:setEnabled( true ) 
							 undoTimer()
		                  end
		               end 
	               end
		      end
		 
		 
		       
				
		  end
	   end
		        for i = 1,9 do
		            if(board[i][7]==1 and board[i][8]==true) then
			          displayX = d.newText("X",board[i][3]+30,board [i][6]+40,Arial,30)
			          displayX:setFillColor( 1, 0, 0 )
				      table.insert(objectsOnScreen,displayX)
				      table.insert(copy,displayX)
					  board[i][8]=false
		            elseif(board[i][7]== 2 and board[i][8]==true) then
                      displayO = d.newText("O",board[i][3]+30,board [i][6]+40,Arial,30)
			           displayO:setFillColor( 0.2, 0, 1 )
				       table.insert(objectsOnScreen,displayO)
					   table.insert(copy,displayO)
					   board[i][8]=false
			        end
               end	
  end

Runtime:addEventListener("touch", fill)




