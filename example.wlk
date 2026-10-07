object pepita {
  var energy = 100

  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}

class Nave {
  var cantPasajeros = 0
  var velocidad = 100
  var direccion = 0
  var combustible = 0
  method cantPasajeros() = cantPasajeros
  method velocidad() = velocidad
  method direccion() = direccion
  method acelerar(nro){
    if (self.velocidad().max(100000) and self.velocidad().min(0)) {
      velocidad += nro
    }  
  }
  method desacelerar(nro) {
    if (velocidad <= 100000 and velocidad >= 0) {
      velocidad -= nro
    }
  }
  method irHaciaSol() {
    direccion = 10
  }
  method escaparDelSol() {
    direccion = - 10
  }
  method ponerseParaleloAlSol() {
    direccion = 0
  }
  method acercarseUnPocoAlSol() {
    if(self.direccion().max(10) and self.direccion().min(-10)) {
      direccion += 1
    }
  }
  method alejarseUnPocoAlSol() {
    if(self.direccion().max(10) and self.direccion().min(-10)) {
      direccion -= 1
    }
  }
  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }
  method cargarCombustible(nro) {
    combustible += nro
  }
  method descargarCombustible(nro) {
    combustible -= nro
  }
  method estaTranquila() {
    return combustible >= 4000 and velocidad <= 12000
  }
  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }
  method escapar() {}
  method avisar() {}
  method tienePocaActividad() {}
  method estaDeRelajo() {
    self.estaTranquila()
    self.tienePocaActividad()
  }
}

class NaveBaliza inherits Nave {
  var color = "rojo"
  var cantCambios = 0
  method cambiarColorBaliza(colorNuevo) {
    color = colorNuevo
    cantCambios += 1
  }
  override method prepararViaje() {
    super()
    self.cambiarColorBaliza("verde")
    self.ponerseParaleloAlSol()
  }
  override method estaTranquila() {
    self.cambiarColorBaliza("azul")
    return super() and color != "rojo"
  }
  override method escapar() {
    self.irHaciaSol()
  }
  override method avisar() {
    self.cambiarColorBaliza("rojo")
  }
  override method tienePocaActividad() {
    return cantCambios == 0
  }
}
class NavePasajeros inherits Nave {
  var racionesComida = 0
  var racionesBebida = 0
  var cantComidaServida = 0
  method cargarBebida(cant) {
    racionesBebida += cant
  }
  method cargarComida(cant) {
    racionesComida += cant
  }
  method descargarBebida(cant) {
    racionesBebida -= cant
  }
  method descargarComida(cant) {
    racionesComida -= cant
    cantComidaServida += cant
  }
  override method prepararViaje() {
    super()
    self.acercarseUnPocoAlSol()
    self.cargarComida(4 * cantPasajeros)
    self.cargarBebida(6 * cantPasajeros)
  }
  override method escapar() {
    velocidad = velocidad * 2
  }
  override method avisar() {
    self.descargarComida(cantPasajeros)
    self.descargarBebida(2 * cantPasajeros)
  }
   override method tienePocaActividad() {
    return cantComidaServida < 50
  }
}
class NaveHospital inherits NavePasajeros {
  var quirofanoListo = true
  method elQuirofanoEstaListo() {
    quirofanoListo = true
  }
  method elQuirofanoNoEstaListo() {
    quirofanoListo = false
  }
  override method estaTranquila() {
    self.elQuirofanoNoEstaListo()
    return super() and quirofanoListo == false
  }
  override method recibirAmenaza() {
    super()
    self.elQuirofanoEstaListo()
  }
}

class NaveCombate inherits Nave {
  var visible = true
  var hayMisiles = true
  var mensajes = []
  method estaVisible() = visible
  method ponerseVisible() {
    visible = true
  }
  method ponerseInvisible() {
    visible = false
  }
  method misilesDesplegados() = hayMisiles
  method desplegarMisiles() {
    hayMisiles = true
  }
  method repelgarMisiles() {
    hayMisiles = false
  }
  method emitirMensaje(mensaje) {
    mensajes.add(mensaje)
    return mensaje
  }
  method mensajesEmitidos() {
    return mensajes.size()
  }
  method primerMensajeEmitico() {
    return mensajes.first()
  }
  method ultimoMensajeEmitido() {
    return mensajes.last()
  }
  method esEscueta() {
    return mensajes.all({m => m.size()}) > 30
  } //VER 
  method emitioMensaje(mensaje) {
    return mensajes.remove(mensaje)
  }
  override method prepararViaje() {
    super()
    self.ponerseVisible()
    self.repelgarMisiles()
    self.acelerar(15000)
    self.emitioMensaje("Saliendo en Mision")
  }
  override method estaTranquila() {
    self.repelgarMisiles()
    return super() and hayMisiles == false
  }
  override method escapar() {
    2.repeat{
      self.acercarseUnPocoAlSol()
    }
  }
  override method avisar() {
    self.emitioMensaje("Amenaza recibida")
  }
}
class NaveSigilosa inherits NaveCombate {
  var tranquilidad
  override method estaTranquila() {
    self.estaVisible()
    return super() and visible == true
  }
  override method escapar() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}