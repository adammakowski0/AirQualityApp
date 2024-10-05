# Aplikacja do sprawdzania jakości powietrza

Aplikacja służy do monitorowania aktualnych danych odnośnie powietrza z wybranych lokalizacji w Polsce. Dane są pobierane z API Głównego Inspektoratu Ochrony Środowiska GIOŚ.

Główny ekran aplikacji zawiera mapę z lokalizacjami stacji pomiarowych. Po wybraniu jednej ze stacji pomiarowych na dole ekranu pojawi się jej nazwa oraz możliwość sprawdzenia szczegółów ze stacji. Po wejściu w szczegóły aplikacja wyświetla aktualne dane ze stacji:
- Dane z czujników, np. zawartości tlenku węgla (CO), dwutlenku Azotu (NO2), ozonu (O3), pyłu zawieszonego PM2.5 oraz PM10
- Po kliknięciu w jeden z czujników, aplikacja wyświetli wykres dla wybranego czujnika zawierający dane historyczne zanieczyszczenia
- Dla każdej stacji wyświetlany jest również wskaźnik jakości powietrza, który może przyjąć wartości: bardzo dobry, dobry, umiarkowany, dostateczny, zły oraz bardzo zły.
- Wyświetlana jest również dokładna lokalizacja czujnika na mapie
<p float="left">
  <img src="https://github.com/adammakowski0/AirQualityApp/blob/main/HomeView_light.png" alt="HomeView" width="250"/>

</p>
Istnieje również możliwość dodania stacji do ulubionych za pomocą przycisku z symbolem gwiazdy w oknie ze szczegółami stacji.

Aplikacja posiada również widgety w dwóch rozmiarach, które można wyswietlić na ekranie głównym.
Widget małego rozmiaru pokazuje wskaźnik jakości powietrza dla wybranej w konfiguracji widgeta stacji, natomiast widget średniej wielkości pokazuje dodatkowo wartość wybranego czujnika ze stacji oraz wykres jego danych historycznych.

Zostało zaiplementowane również wysyłanie podstawowych powiadomień, które przypominają użytkownikowi, aby sprawdził jakość powietrza w okolicy.

## Użyte technologie
- Swift
- SwiftUI
- MapKit
- Combine
- Swift concurrency
- CoreData
- Charts
- WidgetKit
- AppIntents
- UserNotifications
