# Aplikacja do sprawdzania jakości powietrza

Aplikacja służy do monitorowania aktualnych danych odnośnie powietrza z wybranych lokalizacji w Polsce. Dane są pobierane z API Głównego Inspektoratu Ochrony Środowiska GIOŚ.

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

## Opis funkcjonalności
Główny ekran aplikacji zawiera mapę z lokalizacjami stacji pomiarowych. Po wybraniu jednej ze stacji pomiarowych na dole ekranu pojawi się jej nazwa oraz możliwość sprawdzenia szczegółów ze stacji. Po wejściu w szczegóły aplikacja wyświetla aktualne dane ze stacji:
- Dane z czujników, np. zawartości tlenku węgla (CO), dwutlenku Azotu (NO2), ozonu (O3), pyłu zawieszonego PM2.5 oraz PM10
- Dla każdej stacji wyświetlany jest również wskaźnik jakości powietrza, który może przyjąć wartości: bardzo dobry, dobry, umiarkowany, dostateczny, zły oraz bardzo zły.
- Wyświetlana jest również dokładna lokalizacja czujnika na mapie
<p align="center">
  <img src="https://github.com/user-attachments/assets/e49992af-92e2-4cf7-8024-5d115aacf0ec" width="240"/>
  <img src="https://github.com/user-attachments/assets/a9844bab-b286-4fe6-9eec-d88cea687bba" width="240"/>
</p>

- Po kliknięciu w jeden z czujników, aplikacja wyświetli wykres dla wybranego czujnika zawierający dane historyczne zanieczyszczenia
- Istnieje również możliwość dodania stacji do ulubionych za pomocą przycisku z symbolem gwiazdy w oknie ze szczegółami stacji. Lista ulubionych otwiera się po naciśnieciu przycisku na głównym ekranie. Po wybraniu jednej z ulubionych stacji, aplikacja przeniesie nas automatycznie to tej lokalizacji na mapie.
<p align="center">
  <img src="https://github.com/user-attachments/assets/d5009bab-fca3-4c9f-bb1d-be3ed99f1a02" width="240"/>
  <img src="https://github.com/user-attachments/assets/56b087af-d000-4805-b82f-41c9bd1d7693" width="240"/>
</p>

### Widgety
Aplikacja posiada również widgety w dwóch rozmiarach, które można wyswietlić na ekranie głównym.
Widget małego rozmiaru pokazuje wskaźnik jakości powietrza dla wybranej w konfiguracji widgeta stacji, natomiast widget średniej wielkości pokazuje dodatkowo wartość wybranego czujnika ze stacji oraz wykres jego danych historycznych.


Zostało zaiplementowane również wysyłanie podstawowych powiadomień, które przypominają użytkownikowi, aby sprawdził jakość powietrza w okolicy.
