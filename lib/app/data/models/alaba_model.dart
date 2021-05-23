class Alaba {
  String nombreApp = "";
  List<Canciones> canciones = <Canciones>[];

  Alaba({ this.nombreApp,  this.canciones });

  Alaba.fromJson(Map<String, dynamic> json) {
    nombreApp = json['nombreApp'];
    if (json['canciones'] != null) {
      canciones = <Canciones>[];
      json['canciones'].forEach((v) {
        canciones.add(Canciones.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nombreApp'] = nombreApp;
    if (canciones != <Canciones>[]) {
      data['canciones'] = canciones.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Canciones {
  int cancionId = -1;
  String titulo = "";
  String cancion = "";
  bool favorito = false;

  Canciones({this.cancionId=-1, this.titulo="", this.cancion="",this.favorito=false});

  Canciones.fromJson(Map<String, dynamic> json) {
    cancionId = json['cancion_id'];
    titulo = json['titulo'];
    cancion = json['cancion'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cancion_id'] = cancionId;
    data['titulo'] = titulo;
    data['cancion'] = cancion;
    return data;
  }
}
