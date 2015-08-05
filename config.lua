--Calcula el tamañano del dispositivo
local dimenciones = display.pixelHeight / display.pixelWidth
application = {
   content = {
	  -- Compatibilidad gráficos = 1, - Activar el modo de compatibilidad V1
      width = dimenciones > 1.5 and 800 or math.ceil( 1200 / dimenciones ),
      height = dimenciones < 1.5 and 1200 or math.ceil( 800 * dimenciones ),
      scale = "letterBox",
      fps = 30,

      imageSuffix = {
         ["@2x"] = 1.3
      },
   },
}