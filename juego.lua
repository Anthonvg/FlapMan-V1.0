local composer = require( "composer" )
local scene = composer.newScene()
local physics = require "physics"
physics.start()
physics.setGravity( 0, 100 )
local datos = require( "datos" )
local elJuegoComenzo = false

function colision( event )
	local soundEffect = audio.loadSound( "sounds/smack.wav" );
	if ( event.phase == "began" ) then
		composer.gotoScene( "restart" )
		audio.play(soundEffect);
	end
end

function animacionBarra(self,event)
	if self.x < (-900 + (self.speed*2)) then
		self.x = 900
	else 
		self.x = self.x - self.speed
	end
end

function volar(event)
	local soundEffect = audio.loadSound( "sounds/flap.wav" );
   if event.phase == "began" then
       audio.play(soundEffect);
		if elJuegoComenzo == false then
			 pajaro.bodyType = "dynamic"
			 instrucciones.alpha = 0
			 tb.alpha = 1
			 tiempoAgregarTubo = timer.performWithDelay(2000, agregarTubos, -1)
			 tiempoMoverTubo = timer.performWithDelay(2, moverTubos, -1)
			 elJuegoComenzo = true
			 pajaro:applyForce(0, -300, pajaro.x, pajaro.y)

		else 
	    pajaro:applyForce(0, -600, pajaro.x, pajaro.y)
		
      end
	end
end
function moverTubos()
	local soundEffect = audio.loadSound( "sounds/campana.wav" );
		for a = elementos.numChildren,1,-1  do
			
			if(elementos[a].x < display.contentCenterX - 170) then
				if elementos[a].scoreAdded == false then
					datos.score = datos.score + 1
					tb.text = datos.score
					elementos[a].scoreAdded = true
					audio.play(soundEffect);
				end
			end
			if(elementos[a].x > -100) then
				elementos[a].x = elementos[a].x - 13 --velocidad
			else 
				elementos:remove(elementos[a])
			end	
		end
end
function agregarTubos()
	
	altura = math.random(display.contentCenterY - 200, display.contentCenterY + 200)

	tuboSuperior = display.newImageRect('img/tubo2.png',130,714)
	tuboSuperior.anchorX = 0.5
	tuboSuperior.anchorY = 20
	tuboSuperior.x = display.contentWidth + 100
	tuboSuperior.y = altura - 160
	tuboSuperior.scoreAdded = false
	physics.addBody(tuboSuperior, "static", {density=1, bounce=0.1, friction=.2})
	elementos:insert(tuboSuperior)
	
	tuboInferior = display.newImageRect('img/tubo.png',130,714)
	tuboInferior.anchorX = 0.5
	tuboInferior.anchorY = -20
	tuboInferior.x = display.contentWidth + 100
	tuboInferior.y = altura + 160
	physics.addBody(tuboInferior, "static", {density=1, bounce=0.1, friction=.2})
	elementos:insert(tuboInferior)
end	

local function checkMemory()
   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   --print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
end
--Creando la escena
function scene:create( event )
   local escena = self.view
   elJuegoComenzo = false
   datos.score = 0
   local background = display.newImage("img/fondo1.png")
	escena:insert(background)

    fondo = display.newImageRect('img/fondo1.png',900,1425)
	fondo.anchorX = 0
	fondo.anchorY = 1
	fondo.x = 0
	fondo.y = display.contentHeight
	fondo.speed = 4
	escena:insert(fondo)
    
    elementos = display.newGroup()
	elementos.anchorChildren = true
	elementos.anchorX = 0
	elementos.anchorY = 1
	elementos.x = 0
	elementos.y = 0
	escena:insert(elementos)

	barra = display.newImageRect('img/barra.png',900,165)
	barra.anchorX = 0
	barra.anchorY = 1
	barra.x = 0
	barra.y = display.viewableContentHeight - 0
	physics.addBody(barra, "static", {density=.1, bounce=0.1, friction=.2})
	barra.speed = 4
	escena:insert(barra)

	barra2 = display.newImageRect('img/barra.png',900,165)
	barra2.anchorX = 0
	barra2.anchorY = 1
	barra2.x = barra2.width
	barra2.y = display.viewableContentHeight - 0
	physics.addBody(barra2, "static", {density=.1, bounce=0.1, friction=.2})
	barra2.speed = 4
	escena:insert(barra2)
	
	p_options = 
	{
		-- Required params
		width = 110,
		height = 73,
		numFrames = 2,
		-- content scaling
		sheetContentWidth = 240,
		sheetContentHeight = 73,
	}

	imagenBatman = graphics.newImageSheet( "img/bat2.png", p_options )
	pajaro = display.newSprite( imagenBatman, { name="pajaro", start=1, count=2, time=500 } )
	pajaro.anchorX = 0.5
	pajaro.anchorY = 0.5
	pajaro.x = display.contentCenterX - 160
	pajaro.y = display.contentCenterY
	physics.addBody(pajaro, "static", {density=.04, bounce=0.1, friction=1})
	pajaro:applyForce(0, -300, pajaro.x, pajaro.y)
	pajaro:play()
	escena:insert(pajaro)
	
	tb = display.newText(datos.score,display.contentCenterX,
	150, "pixelmix", 58)
	tb:setFillColor(0,0,0)
	tb.alpha = 0
	escena:insert(tb)

	instrucciones = display.newImageRect("img/tap.png",300,278)
	instrucciones.anchorX = 0.5
	instrucciones.anchorY = 0.5
	instrucciones.x = display.contentCenterX
	instrucciones.y = display.contentCenterY
	escena:insert(instrucciones)


	
   
end
function scene:show( event )

   local escena = self.view
   local phase = event.phase

   if ( phase == "will" ) then

   elseif ( phase == "did" ) then
   
	composer.removeScene("start")
	Runtime:addEventListener("touch", volar)

	barra.enterFrame = animacionBarra
	Runtime:addEventListener("enterFrame", barra)

	barra2.enterFrame = animacionBarra
	Runtime:addEventListener("enterFrame", barra2)
    
    Runtime:addEventListener("collision", colision)
   
    memTimer = timer.performWithDelay( 1000, checkMemory, 0 )
	  
   end
end

function scene:hide( event )

   local escena = self.view
   local phase = event.phase

   if ( phase == "will" ) then
    
	Runtime:removeEventListener("touch", volar)
	Runtime:removeEventListener("enterFrame", barra)
	Runtime:removeEventListener("enterFrame", barra2)
	Runtime:removeEventListener("collision", colision)
	timer.cancel(tiempoAgregarTubo)
	timer.cancel(tiempoMoverTubo)
	timer.cancel(memTimer)
	  
	  
   elseif ( phase == "did" ) then
     
   end
end
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













