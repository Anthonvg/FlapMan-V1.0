local composer = require( "composer" )
local scene = composer.newScene()
local datos = require( "datos" )
local score = require( "score" )

-- Fondo
function reiniciar(event)
     if event.phase == "ended" then
		saveScore()
		composer.gotoScene("start")
     end
end
function Start()
	startTransition = transition.to(play,{time=200, alpha=1})
	puntajeTextoTransition = transition.to(puntajeTexto,{time=600, alpha=1})
	puntajeTextoTransition = transition.to(bestText,{time=600, alpha=1})
end

function Score()
	scoreTransition = transition.to(scoreFondo,{time=600, y=display.contentCenterY,onComplete=Start})
end

function GameOver()
	fadeTransition = transition.to(gameOver,{time=600, alpha=1,onComplete=Score})
end
function loadScore()
	local prevScore = score.load()
	if prevScore ~= nil then
		if prevScore <= datos.score then
			score.set(datos.score)
		else 
			score.set(prevScore)
		end
	else 
		score.set(datos.score)
	end
end

function saveScore()
	score.save()
end
-- Creando la escena
function scene:create( event )
   local sceneGroup = self.view

    fondo = display.newImageRect("img/fondo1.png",900,1425)
	fondo.anchorX = 0.5
	fondo.anchorY = 0.5
	fondo.x = display.contentCenterX
	fondo.y = display.contentCenterY
	sceneGroup:insert(fondo)
	
	gameOver = display.newImageRect("img/gameOver.png",500,120)
	gameOver.anchorX = 0.5
	gameOver.anchorY = 0.5
	gameOver.x = display.contentCenterX 
	gameOver.y = display.contentCenterY - 400
	gameOver.alpha = 0
	sceneGroup:insert(gameOver)
	
	scoreFondo = display.newImageRect("img/menu.png",530,340)
	scoreFondo.anchorX = 0.5
	scoreFondo.anchorY = 0.5
    scoreFondo.x = display.contentCenterX
    scoreFondo.y = display.contentHeight + 500
    sceneGroup:insert(scoreFondo)
	
	play = display.newImageRect("img/play.png",217,137)
	play.anchorX = 0.5
	play.anchorY = 1
	play.x = display.contentCenterX
	play.y = display.contentCenterY + 400
	play.alpha = 0
	sceneGroup:insert(play)
	
	puntajeTexto = display.newText(datos.score,display.contentCenterX + 160,
	display.contentCenterY - 45, native.systemFont, 50)
	puntajeTexto:setFillColor(252,120,88)
	puntajeTexto.alpha = 0 
	sceneGroup:insert(puntajeTexto)
	
	bestText = score.init({
	fontSize = 50,
	font = "Helvetica",
	x = display.contentCenterX + 120,
	y = display.contentCenterY + 85,
	maxDigits = 7,
	leadingZeros = false,
	filename = "puntaje.txt",
	})
	bestScore = score.get()
	bestText.text = bestScore
	bestText.alpha = 0
	bestText:setFillColor(252,120,88)
	sceneGroup:insert(bestText)
end
-- Mostrando la escena
function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase
   if ( phase == "will" ) then
   elseif ( phase == "did" ) then
	composer.removeScene("juego")
	play:addEventListener("touch", reiniciar)
	GameOver()
	--Salva el puntaje
	loadScore()
   end
end

function scene:hide( event )
   local sceneGroup = self.view
   local phase = event.phase
   if ( phase == "will" ) then
		play:removeEventListener("touch", reiniciar)
		transition.cancel(fadeTransition)
		transition.cancel(scoreTransition)
		transition.cancel(puntajeTextoTransition)
		transition.cancel(startTransition)
   elseif ( phase == "did" ) then
     
   end
end
function scene:destroy( event )
   local sceneGroup = self.view
end
---------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene













