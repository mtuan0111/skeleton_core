// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'core_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class CoreLocalizationsEs extends CoreLocalizations {
  CoreLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String get exit => 'Salir';

  @override
  String get share => 'Compartir';

  @override
  String get restart => 'Reiniciar';

  @override
  String get start => 'Comenzar';

  @override
  String get ready => 'Listo';

  @override
  String get go => '¡Ya!';

  @override
  String get waiting => 'Esperando';

  @override
  String get setting => 'Configuración';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get name => 'Nombre';

  @override
  String get fontSize => 'Tamaño de fuente';

  @override
  String get volume => 'Volumen';

  @override
  String get vibrate => 'Vibrar';

  @override
  String get language => 'Idioma';

  @override
  String get updateRequired => 'Actualización requerida';

  @override
  String get updateAvailable => 'Actualización disponible';

  @override
  String get currentVersion => 'Versión actual';

  @override
  String get newVersion => 'Nueva versión';

  @override
  String get whatsNew => 'Novedades';

  @override
  String get forceUpdateMessage =>
      'Esta actualización es necesaria para continuar usando la aplicación. Por favor actualiza ahora.';

  @override
  String get later => 'Más tarde';

  @override
  String get updateNow => 'Actualizar ahora';

  @override
  String get update => 'Actualizar';

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String get appUpdates => 'Actualizaciones de la aplicación';

  @override
  String get tapToCheckUpdates =>
      'Toque el botón de abajo para buscar actualizaciones de la aplicación.';

  @override
  String get checkingForUpdates => 'Buscando actualizaciones...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return '¡Nueva versión $version disponible! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'Esta actualización es obligatoria.';

  @override
  String get usingLatestVersion => '¡Estás usando la última versión!';

  @override
  String unableToCheckUpdates(String error) {
    return 'No se pudo buscar actualizaciones. $error';
  }

  @override
  String get tryAgainLater => 'Por favor inténtelo de nuevo más tarde.';

  @override
  String get updatePostponed => 'Actualización disponible pero pospuesta.';

  @override
  String get welcome => '¡Bienvenido/a!';

  @override
  String welcomeUser(String username) {
    return '¡Bienvenido/a $username!';
  }

  @override
  String get mainMenu => 'Menú principal';

  @override
  String get anonymous => 'Anónimo';

  @override
  String get level => 'Nivel';

  @override
  String get score => 'Puntuación';

  @override
  String get rank => 'Rango';

  @override
  String get topScore => 'Mejor puntuación';

  @override
  String get global => 'Global';

  @override
  String get personal => 'Personal';

  @override
  String get areYouSure => '¿Estás seguro?';

  @override
  String get confirmExit => '¿Estás seguro de que quieres salir?';

  @override
  String get doYouWantToExit => '¿Quieres salir?';

  @override
  String get gameOver => 'Juego terminado';

  @override
  String get playAgain => 'Jugar de Nuevo';

  @override
  String get returnToMenu => 'Volver al Menú';

  @override
  String get thankYou => 'Gracias por jugar';

  @override
  String get thankYouMessage =>
      'Gracias por jugar nuestro juego. Esperamos que lo hayas disfrutado. Si tienes algún comentario o sugerencia, no dudes en hacérnoslo saber.';

  @override
  String get authorName => 'Autor';

  @override
  String get connectWithUs => 'Conéctate con nosotros';

  @override
  String get connectWithUsMessage =>
      'Si tienes alguna pregunta o comentario, no dudes en contactarnos en nuestras redes sociales.';

  @override
  String get difficulty => 'Dificultad';

  @override
  String get difficultySetting => 'Ajuste de dificultad';

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Medio';

  @override
  String get hard => 'Difícil';

  @override
  String get veryHard => 'Muy difícil';

  @override
  String get extreme => 'Extremo';

  @override
  String get selectDifficulty => 'Seleccionar dificultad';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return 'Hoy es $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => 'Año Nuevo';

  @override
  String get greetingNewYear => '¡Feliz Año Nuevo!';

  @override
  String get holidayLunarNewYear => 'Año Nuevo Lunar';

  @override
  String get greetingLunarNewYear => '¡Feliz Año Nuevo Lunar!';

  @override
  String get holidayValentine => 'Día de San Valentín';

  @override
  String get greetingValentine => '¡Feliz Día de San Valentín!';

  @override
  String get holidayHoli => 'Holi';

  @override
  String get greetingHoli => '¡Feliz Holi!';

  @override
  String get holidayEarthDay => 'Día de la Tierra';

  @override
  String get greetingEarthDay =>
      '¡Feliz Día de la Tierra! ¡Protege nuestro planeta!';

  @override
  String get holidayEaster => 'Pascua';

  @override
  String get greetingEaster => '¡Felices Pascuas!';

  @override
  String get holidayPride => 'Mes del Orgullo';

  @override
  String get greetingPride => '¡Feliz Orgullo! ¡Amor es Amor!';

  @override
  String get holidayHalloween => 'Halloween';

  @override
  String get greetingHalloween => '¡Feliz Halloween!';

  @override
  String get holidayDiwali => 'Diwali';

  @override
  String get greetingDiwali => '¡Feliz Diwali!';

  @override
  String get holidayHanukkah => 'Jánuca';

  @override
  String get greetingHanukkah => '¡Feliz Jánuca!';

  @override
  String get holidayChristmas => 'Navidad';

  @override
  String get greetingChristmas => '¡Feliz Navidad!';

  @override
  String get holidayKwanzaa => 'Kwanzaa';

  @override
  String get greetingKwanzaa => '¡Feliz Kwanzaa!';
}
