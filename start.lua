local composer = require( "composer" ) --Genera una escena apartir de una libreria
local scene = composer.newScene()
local physics = require "physics"
physics.start()
local datos = require( "datos" )
--physics.setDrawMode( "hybrid" ); --Se inician los vectores
--Comienza el juego
function comienzo(event)
     if event.phase == "ended" then --phase identifica la secuencia del evento
		composer.gotoScene("juego")
     end
end
function animacionBarra(self,event)
	if (self.x < (-900 + (self.speed*2))) then
		self.x = 900
	else 
		self.x = self.x - self.speed
	end
end
function introDown()
	downTransition = transition.to(intro,{time=400, y=intro.y+20,onComplete=introUp})	
end
function introUp()
	upTransition = transition.to(intro,{time=400, y=intro.y-20, onComplete=introDown})
	
end
function tituloAnimation()
	introDown()
end
---------------------------------------------------------------------------------
function scene:create( event )
	--Generando la escena 
   local escena = self.view 
    fondo = display.newImageRect("img/fondo1.png",900,1425)
	fondo.anchorX = 0.5
	fondo.anchorY = 1
	fondo.x = display.contentCenterX
	fondo.y = display.contentHeight
	escena:insert(fondo)
	--Imagen del logo
	titulo = display.newImageRect("img/titulo.png",520,150)
	titulo.anchorX = 0.5
	titulo.anchorY = 0.5
	titulo.x = display.contentCenterX - 80
	titulo.y = display.contentCenterY 
	escena:insert(titulo)
	--Barra 1
	barra = display.newImageRect('img/barra.png',900,163)
	barra.anchorX = 0
	barra.anchorY = 1
	barra.x = 0
	barra.y = display.viewableContentHeight - 0
	physics.addBody(barra, "static", {density=.1, bounce=0.1, friction=.2})
	barra.speed = 4
	escena:insert(barra)
	--Barra 2
	barra2 = display.newImageRect('img/barra.png',900,163)
	barra2.anchorX = 0
	barra2.anchorY = 1
	barra2.x = barra2.width
	barra2.y = display.viewableContentHeight - 0
	physics.addBody(barra2, "static", {density=.1, bounce=0.1, friction=.2})
	barra2.speed = 4
	escena:insert(barra2)
	--Boton del play
	play = display.newImageRect("img/play.png",217,137)
	play.anchorX = 0.5
	play.anchorY = 1
	play.x = display.contentCenterX
	play.y = display.contentHeight - 400
	escena:insert(play)
	-- Contenedor de el conjunto de imagenes en la pantalla principal
	intro = display.newGroup()
	intro.anchorChildren = true
	intro.anchorX = 0.5
	intro.anchorY = 0.5
	intro.x = display.contentCenterX
	intro.y = display.contentCenterY - 250
	intro:insert(titulo)
	escena:insert(intro)
	tituloAnimation()
end
function scene:show( event )
   local escena = self.view
   local phase = event.phase
   if ( phase == "will" ) then
   elseif ( phase == "did" ) then
      	--Comienza a dar vida a la escena
		composer.removeScene("restart")
		play:addEventListener("touch", comienzo)
		barra.enterFrame = animacionBarra
		Runtime:addEventListener("enterFrame", barra)
		barra2.enterFrame = animacionBarra
		Runtime:addEventListener("enterFrame", barra2)
   end
end
function scene:hide( event )
   local escena = self.view
   local phase = event.phase
   if ( phase == "will" ) then
	    play:removeEventListener("touch", comienzo)
		Runtime:removeEventListener("enterFrame", barra)
		Runtime:removeEventListener("enterFrame", barra2)
		transition.cancel(downTransition)
		transition.cancel(upTransition)
   elseif ( phase == "did" ) then
   end
end
-- Destruccion de la escena 
function scene:destroy( event )
   local escena = self.view
end
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------

return scene










