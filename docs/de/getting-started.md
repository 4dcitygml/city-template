<!-- Copyright (c) 2026 4dcitygml -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

# Erste Schritte: vom Klonen bis zum ersten Änderungsvorschlag

<!-- Übersetzung. Bei Abweichungen gilt die englische Fassung (../getting-started.md). -->

Diese Anleitung führt einmal komplett durch den Übungsablauf: dieses Repository auf
den eigenen Rechner holen, die gemeinsamen Bearbeitungswerkzeuge starten, sie mit dem
eigenen GitHub-Konto verbinden und den ersten Änderungsvorschlag (Pull Request)
senden. Beim ersten Mal dauert das etwa 15 Minuten. Nichts davon ändert die
Stadtdaten direkt: Jede Bearbeitung wird ein Vorschlag, den eine Betreuerin oder ein
Betreuer prüft.

Die Regeln für Vorschläge stehen in der [PR-Anleitung](pr-operations.md) und in den
[Regeln zur Quellenerfassung](provenance-rules.md); was beigetragen werden darf, in der
[Richtlinie für Datenbeiträge](data-contribution-policy.md).

## 1. Schnellstart: Starter-Kit herunterladen

Zum Anfangen brauchen Sie weder Git noch ein GitHub-Konto noch eine Kopie der
Stadtdaten. Was fehlt, erklären die Werkzeuge Schritt für Schritt.

1. Laden Sie das **Starter-Kit** herunter, das in der README dieses Repositorys
   (Punkt *Loslegen*) verlinkt ist. Es ist ein kleines Zip mit den Startskripten und der
   Konfiguration dieser Stadt.
2. Entpacken Sie es. Sie erhalten einen Ordner wie `<stadt>-starter/`.
3. Starten:
   - macOS: `start-mac.command` doppelklicken. Beim ersten Mal blockiert macOS die Datei:
     Ab macOS 15 *Systemeinstellungen → Datenschutz & Sicherheit* öffnen, neben dem Hinweis
     zur Datei *Dennoch öffnen* wählen und erneut doppelklicken; bei älteren Versionen
     Rechtsklick → *Öffnen*. Fragt das Terminal nach Zugriff auf den Ordner „Dokumente“,
     erlauben Sie ihn.
   - Windows: `start-windows.bat` doppelklicken. Erscheint SmartScreen, *Weitere
     Informationen* und dann *Trotzdem ausführen* wählen.

Was der Reihe nach passiert:

1. Der Starter liest `tools-release.json`; dort ist die genaue Werkzeug-Version festgelegt
   (Tag, Dateiname, SHA-256).
2. Er lädt diese Version von den Releases von `4dcitygml/tools` und prüft die Prüfsumme.
   Stimmt sie nicht, wird nichts entpackt und der Starter bricht ab.
3. Die Werkzeuge werden nach `~/Documents/citygml-tools/citygml-hub/` entpackt.
4. Der Hub öffnet sich im Browser unter `http://localhost:8760/`, bereits mit dieser
   Stadt verbunden. Lassen Sie das Terminalfenster während der Arbeit offen; schließen
   beendet die Werkzeuge.

Heruntergeladen wird beim ersten Mal und immer dann, wenn die Stadt eine neuere
Werkzeug-Version festlegt; der Starter ersetzt die alte Kopie erst nach der Prüfung.
Sonst beginnen spätere Starts direkt bei Schritt 4.
Ihre eigene Kopie der Stadtdaten legt der Hub im nächsten Abschnitt an; das Repository
selbst müssen Sie nie herunterladen.

## 2. Voraussetzungen

- macOS 12 oder neuer, oder Windows 10 oder neuer.
- Nur macOS: Apples Kommandozeilenwerkzeuge (`git` und `python3`). Bietet macOS beim
  ersten Start des Starters die Installation an, nehmen Sie sie an. Meldet der Hub später,
  dass eine Komponente für den Import fehlt, folgen Sie der `READ-ME-FIRST.html` im
  entpackten Werkzeugordner und starten erneut; die Einrichtung setzt dort fort, wo sie
  stehen blieb. Windows braucht nichts: Git und Python sind im Download enthalten.
- Etwa 400 MB freier Speicher (Werkzeuge plus Ihre Kopie der Stadtdaten).
- Ein GitHub-Konto wird, falls Sie keines haben, im Schritt *Verbinden* angelegt
  (kostenlos; E-Mail-Adresse und Passwort).

## 3. Sie arbeiten schon mit Git oder GitHub? Siehe Ende der Anleitung

Das Starter-Kit ist für alle der einfachste Einstieg, auch für Entwicklerinnen und
Entwickler. Wer lieber direkt mit Git und GitHub arbeitet oder ein eigenes Werkzeug bauen
möchte, liest nach dem Durchgang
[Fortgeschritten: Git, GitHub und eigene Werkzeuge](#fortgeschritten-git-github-und-eigene-werkzeuge).
Die Regeln für Vorschläge sind auf jedem Weg dieselben.

## 4. Ersteinrichtung im Hub (drei Schritte)

Bis Ihre Arbeitskopie existiert, zeigt der Hub eine Einrichtung in drei Schritten.

1. **Verbinden.** Der Bildschirm nennt genau, was Sie erlauben: die Berechtigung
   `public_repo`, mit der die Werkzeuge in Ihrem Namen Kopien öffentlicher Repositorys
   anlegen und Pull Requests eröffnen dürfen. Klicken Sie *Nummer kopieren und GitHub
   öffnen*, fügen Sie die Nummer auf der GitHub-Seite ein und bestätigen Sie. Die
   Anmeldung allein hinterlässt keine öffentliche Spur; die Erlaubnis steht nur in Ihren
   eigenen GitHub-Einstellungen und lässt sich dort jederzeit widerrufen.
2. **Kopie erstellen.** Der Hub forkt dieses Repository in Ihr GitHub-Konto. Ab jetzt ist
   die Kopie öffentlich unter Ihrem Namen, wie jeder Fork auf GitHub.
3. **Importieren.** Der Hub klont Ihre Kopie nach `~/Documents/CityGML Data/` (existiert
   der Ordner schon, wird ein nummerierter verwendet). Große Städte brauchen einige Minuten.

Klicken Sie *Loslegen*, wenn der dritte Schritt fertig ist. Schlägt ein Schritt fehl,
wird die Schaltfläche zu einem erneuten Versuch; meist liegt es an einer
Netzunterbrechung.

## 5. Der Hub-Bildschirm

Nach der Einrichtung listet der Hub die Werkzeuge und Ihre Vorschläge:

- **Attribut-Editor**: Gebäudeattribute auf der Karte ansehen, bearbeiten und einen
  Vorschlag senden.
- **Textur-Editor**: Fassadentexturen ersetzen oder ergänzen (nur wo die Stadt welche hat).
- **Ihre Beiträge**: die gesendeten Vorschläge (und Issues) mit dem Ergebnis der
  automatischen Prüfungen und dem Stand der Begutachtung.

Jedes Werkzeug öffnet sich in einem neuen Browser-Tab auf einem eigenen lokalen Port. Der
Hub zeigt auch, wo Ihre Arbeitskopie liegt.

## 6. Der erste Änderungsvorschlag

Im Attribut-Editor:

1. Einen Kachelrahmen auf der Karte anklicken; die Gebäudegrundrisse der Kachel erscheinen.
2. Ein Gebäude anklicken. Eine 3D-Vorschau und eine Attributkarte öffnen sich.
3. Einen Wert anklicken, um ihn zu bearbeiten. Geänderte Werte werden gelb markiert.
4. Beim Bestätigen öffnet sich in derselben Zeile ein Quellenfeld: das geprüfte Dokument
   wählen. Solange ein geändertes Attribut ohne Quelle ist, lässt sich nichts senden.
5. *Änderungen senden* wählen, bei Bedarf Notiz oder URL ergänzen und die Vorprüfung
   durchlaufen lassen (ein Zielgebäude, gültiges XML, nur Gebäudedaten geändert, Quellen
   erfasst).
6. Der Vorschlag wird in diesem Repository angelegt, mit automatisch erzeugtem Titel und
   Beschreibung in der Arbeitssprache des Repositorys. Der Editor zeigt den Link *Einreichung
   auf GitHub ansehen*; der Hub führt ihn unter Ihren Beiträgen.

Innerhalb weniger Minuten kommentieren die automatischen Prüfungen den Vorschlag: eine
Zusammenfassung der Änderung, eine Prüfung der Nachvollziehbarkeit und eine Tabelle mit
dreizehn Prüfpunkten. Punkte, die Aufmerksamkeit brauchen, kommen mit Hinweisen; im Editor
korrigieren und vom selben Gebäude erneut senden, dann laufen die Prüfungen wieder. Sind
alle bestanden, prüft und übernimmt die Betreuung den Vorschlag. Ihr Name in der Historie
ist Ihr GitHub-Konto, wie bei jedem Pull Request.

## 7. Beim nächsten Mal

Denselben Starter erneut ausführen. Die Einrichtung entfällt, der Hub öffnet sich direkt.
Melden die Prüfungen, dass Ihre Kopie hinter der Stadt zurückliegt (*base stale*), öffnen
Sie Ihren Fork auf GitHub, wählen *Sync fork → Update branch* und starten erneut.

## 8. Übungs-Repositorys

Die Beispielstädte sind Übungsumgebungen. Vorschläge, Kommentare und Begutachtung dort sind
echte GitHub-Historie, die Daten werden aber regelmäßig auf den Ausgangsstand
zurückgesetzt. Eine übernommene Übungsänderung muss nicht „richtig“ sein, sie muss den
Regeln folgen. Nutzen Sie sie frei, bevor Sie an einer echten Stadt arbeiten.

## 9. Fehlerbehebung

- *Port 8760 ist belegt*: Ein anderer Hub läuft. Schließen Sie ihn oder geben Sie einen
  anderen Port an (Beispiel für macOS): `python3 ~/Documents/citygml-tools/citygml-hub/program/hub.py --port 8761`.
- *SHA-256 stimmt nicht*: Der Download war beschädigt oder verändert. Starter erneut
  ausführen; bleibt es dabei, melden Sie es über die Wege in der
  [SUPPORT.md](https://github.com/4dcitygml/.github/blob/main/SUPPORT.md) der Organisation.
- *`python3` oder `git` nicht gefunden (macOS)*: Apples Kommandozeilenwerkzeuge mit
  `xcode-select --install` installieren und erneut starten.
- *Die Einrichtung erscheint, obwohl sie abgeschlossen war*: Die Arbeitskopie wurde
  verschoben oder gelöscht. Erneut importieren oder in `~/.citygml_attr_editor.json` den
  neuen Ort eintragen.

## 10. Wo alles liegt und wie man es entfernt

| Was | Wo |
|---|---|
| Die Werkzeuge | `~/Documents/citygml-tools/` |
| Ihre Arbeitskopie der Stadt | `~/Documents/CityGML Data/` |
| Anmeldetoken und Einstellungen | `~/.citygml_auth.json`, `~/.citygml_attr_editor.json`, `~/.citygml_git_credentials` |

Um alles zu entfernen, löschen Sie diese Einträge und widerrufen *4dcitygml hub* unter
*Settings → Applications → Authorized OAuth Apps* auf GitHub. Ihr Fork und gesendete
Vorschläge bleiben auf GitHub; löschen Sie den Fork über seine Einstellungsseite, wenn Sie
ihn nicht mehr möchten.

## Fortgeschritten: Git, GitHub und eigene Werkzeuge

Alles, was der Hub tut, ist gewöhnliches Git und GitHub; Sie können den Hub also ganz
weglassen.

- **Von Hand klonen und verzweigen.** `git clone` dieses Repository (oder Ihren Fork),
  bearbeiten Sie das CityGML mit einem beliebigen Editor, committen Sie und eröffnen Sie
  einen Pull Request. Alle GitHub-Funktionen stehen Ihnen offen: Forks, Branches, der
  Web-Editor, Codespaces, die API, die CLI, Actions in Ihrem Fork.
- **Die Regeln liegen im Pull Request, nicht im Werkzeug.** Die automatischen Prüfungen
  wenden auf jeden Vorschlag dieselben dreizehn Prüfpunkte an, egal wie er entstand.
  Lesen Sie vor dem ersten manuellen Vorschlag die [PR-Anleitung](pr-operations.md) (eine
  Änderung = ein Gebäude, Commit-Trailer, Begründungsabschnitt, bytegenaue Bearbeitung),
  die [Regeln zur Quellenerfassung](provenance-rules.md) und den maschinenlesbaren
  [PR Exchange Contract](https://github.com/4dcitygml/tools/blob/main/docs/exchange-contract.md),
  der genau festhält, was die CI erzwingt, und einen lokalen Prüfer anbietet, der denselben
  Code wie die CI ausführt.
- **Ein eigenes Werkzeug bauen.** Jedes Programm, das vertragskonforme Vorschläge erzeugt,
  ist willkommen, vom Skript bis zum vollständigen Editor oder QGIS-Plugin. Fügen Sie einen
  `Created-By:`-Trailer hinzu, damit die Betreuung Clients unterscheiden kann, nutzen Sie
  die Übungs-Repositorys als Sandkasten und berichten Sie in einem Issue in
  `4dcitygml/tools` davon.
- **Wo die Kopie des Hubs liegt.** Wenn Sie zusätzlich den Hub verwenden, ist seine
  Arbeitskopie der Klon unter `~/Documents/CityGML Data/`; der Hub liest die verbundene
  Stadt aus dem `origin` des Klons, sodass ein Umlenken auf einen anderen Fork oder Branch
  wie erwartet funktioniert.
