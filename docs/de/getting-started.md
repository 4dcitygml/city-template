<!-- Copyright (c) 2026 4dcitygml -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

# Erste Schritte: vom Klonen bis zum ersten Änderungsvorschlag

Diese Anleitung führt einmal komplett durch den Übungsablauf: dieses Repository auf
den eigenen Rechner holen, die gemeinsamen Bearbeitungswerkzeuge starten, sie mit dem
eigenen GitHub-Konto verbinden und den ersten Änderungsvorschlag (Pull Request)
senden. Beim ersten Mal dauert das etwa 15 Minuten. Nichts davon ändert die
Stadtdaten direkt: Jede Bearbeitung wird ein Vorschlag, der automatisch geprüft und von den
Genehmigenden der Stadt freigegeben wird.

Danach: die automatischen Prüfungen laufen in wenigen Minuten ab und veröffentlichen
ihren Bericht, und die Genehmigenden der Stadt geben den Vorschlag frei — Sie
müssen nur handeln, wenn jemand bittet, etwas zu ändern. Für die Regeln, denen Vorschläge
folgen müssen, siehe die [PR-Anleitung](pr-operations.md)
und die [Regeln zur Quellenerfassung](provenance-rules.md). Was beigetragen werden darf, siehe die
[Richtlinie für Datenbeiträge](data-contribution-policy.md).

## 1. Schnellstart: ein Befehl

Sie brauchen weder Git noch ein GitHub-Konto noch eine Kopie der
Stadtdaten zum Anfangen. Was fehlt, erklären die Werkzeuge Schritt für Schritt. Die folgende Zeile ist
die gesamte Installation; Sie ist auf jedem Rechner gleich und wird nie veraltet.

- **macOS**: öffnen Sie *Terminal* (Spotlight → „Terminal"), fügen Sie die Zeile aus der README dieses
  Repositorys (*Loslegen*) ein, drücken Sie Return:

  ```
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/4dcitygml/tools/install-v1/install/citygml.sh)" -- <owner>/<repo>
  ```
  Bietet macOS an, die *Kommandozeilenwerkzeuge* zu installieren, nehmen Sie das an und führen Sie
  die Zeile danach erneut aus. Fragt es, ob das Terminal auf Ihren Ordner „Dokumente"
  zugreifen darf, erlauben Sie es.
- **Windows**: öffnen Sie *PowerShell* (Start → „PowerShell"), fügen Sie die Zeile aus der README
  ein, drücken Sie Enter. Git und Python reisen im Download mit; nichts anderes wird installiert.

Was der Reihe nach passiert:

1. Der Befehl holt die neueste Veröffentlichung der Bearbeitungswerkzeuge von
   `4dcitygml/tools` und prüft sie gegen die SHA-256-Prüfsumme, die GitHub
   für diese Datei veröffentlicht. Stimmt die Prüfsumme nicht, wird nichts installiert und der Befehl bricht ab.
2. Die Werkzeuge werden nach `~/Documents/citygml-tools/citygml-hub/<version>/` gelegt, und eine
   Kopie des Launcher-Skripts bleibt in `~/Documents/citygml-tools/`.
3. Der Hub öffnet sich im Browser, bereits mit dieser Stadt verbunden. Lassen Sie das Terminalfenster
   während der Arbeit offen; schließen beendet die Werkzeuge.
4. Nach der Einrichtung unten bietet der Hub an, ein **Desktop-Symbol** für diese Stadt zu erstellen.
   Von dann an öffnen Sie die Werkzeuge mit diesem Symbol; die Terminal-Zeile ist nur für das
   erste Mal (oder einen anderen Rechner).

Dieses Repository enthält nur Daten, Dokumente und Einstellungen. Jedes Programm, das auf
Ihrem Rechner läuft, kommt aus `4dcitygml/tools`-Veröffentlichungen — dasselbe für jede Stadt.

## 2. Voraussetzungen

- macOS 12 oder neuer, oder Windows 10 oder neuer.
- Nur macOS: Apples Kommandozeilenwerkzeuge (`git` und `python3`). Bietet macOS beim
  ersten Ausführen des Befehls die Installation an, nehmen Sie sie an. Windows braucht nichts:
  Git und Python reisen im Download mit.
- Ungefähr 400 MB freier Speicherplatz (Werkzeuge plus Ihre Kopie der Stadtdaten).
- Ein GitHub-Konto wird, falls Sie keines haben, im Schritt *Verbinden*
  unten angelegt (kostenlos; eine E-Mail-Adresse und ein Passwort).

## 3. Arbeiten Sie bereits mit Git oder GitHub? Siehe Ende dieser Anleitung

Der Befehl ist der einfachste Weg für alle, auch für Entwicklerinnen und Entwickler. Wer lieber
direkt mit Git und GitHub arbeitet, oder ein eigenes Werkzeug bauen möchte, liest nach dem Durchgang
[Fortgeschritten: Git, GitHub und eigene Werkzeuge](#fortgeschritten-git-github-und-eigene-werkzeuge).
Die Regeln, denen Vorschläge entsprechen müssen, sind in jedem Fall gleich.

## 4. Ersteinrichtung im Hub (drei Schritte)

Bis Ihre Arbeitskopie existiert, zeigt der Hub einen Einrichtungsbildschirm in drei Schritten.

1. **Verbinden.** Der Bildschirm nennt genau, was Sie erlauben: die Berechtigung
   `public_repo`, mit der die Werkzeuge in Ihrem Namen Kopien öffentlicher Repositorys
   erstellen und Pull Requests öffnen dürfen. Klicken Sie *Nummer kopieren und GitHub
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
vierzehn Prüfpunkten. Punkte, die Aufmerksamkeit brauchen, kommen mit Hinweisen; im Editor
korrigieren und vom selben Gebäude erneut senden, dann laufen die Prüfungen wieder. Sind
alle bestanden, geben die Genehmigenden der Stadt den Vorschlag frei, und er wird übernommen. Ihr Name in der Historie
ist Ihr GitHub-Konto, wie bei jedem Pull Request.

## 7. Beim nächsten Mal

Doppelklicken Sie auf das Desktop-Symbol, das der Hub erstellt hat (oder führen Sie denselben Befehl
erneut aus — es ist sicher zu wiederholen). Die Einrichtung entfällt, der Hub öffnet sich direkt. Der Hub
bringt Ihre Kopie der Stadtdaten im Hintergrund auf den neuesten Stand und zeigt den Zustand
auf dem Bildschirm; wird ein Vorschlag als hinter der Stadt (*base stale*) gemeldet,
senden Sie ihn vom selben Gebäude erneut, nach der Synchronisation.

Wenn eine neuere Version der Werkzeuge veröffentlicht wird, zeigt der Hub ein Banner. *Jetzt
abrufen* lädt und prüft sie; die neue Version wird beim nächsten Start verwendet. Nichts wird
ohne Ihren Klick heruntergeladen oder neu gestartet.

## 8. Übungs-Repositorys

Die Beispielstädte sind Übungsumgebungen. Vorschläge, Kommentare und Begutachtung dort sind
echte GitHub-Historie, die Daten werden aber regelmäßig auf den Ausgangsstand
zurückgesetzt. Ein übernommener Übungsvorschlag muss nicht „richtig" sein, er muss den
Regeln folgen. Nutzen Sie sie frei, bevor Sie an einer echten Stadt arbeiten.

## 9. Fehlerbehebung

- *Der Browser öffnete einen anderen Port als beim letzten Mal*: ein anderer Hub (eine andere Stadt)
  lief bereits auf dem üblichen Port, daher kam dieser zum nächsten freien Port. Beide
  laufen weiter; jede Stadt hat sein Fenster.
- *SHA-256 stimmt nicht*: Der Download war beschädigt oder verändert. Führen Sie den Befehl erneut
  aus; bleibt es dabei, melden Sie es über die Wege in der
  [SUPPORT.md](https://github.com/4dcitygml/.github/blob/main/SUPPORT.md) der Organisation.
- *`python3` oder `git` nicht gefunden (macOS)*: Apples Kommandozeilenwerkzeuge mit
  `xcode-select --install` installieren, dann den Befehl erneut ausführen.
- *Der Einrichtungsbildschirm erscheint, obwohl die Einrichtung fertig war*: die Arbeitskopie wurde
  verschoben oder gelöscht. Erneut importieren, oder in `~/.citygml_attr_editor.json`
  (`cities`) den Eintrag dieser Stadt auf den neuen Ort verweisen.
- *Die Werkzeuge können nicht aktualisiert werden (offline)*: der Hub führt die installierte
  Version weiter aus; das Banner kehrt zurück, wenn Sie online sind.

## 10. Wo alles liegt und wie man es entfernt

| Was | Wo |
|---|---|
| Die Werkzeuge (ein Ordner pro Version) und das Launcher-Skript | `~/Documents/citygml-tools/` |
| Das Desktop-Symbol | wo Sie es hingezogen haben (verweist nur auf das Launcher-Skript) |
| Ihre Arbeitskopie der Stadt | `~/Documents/CityGML Data/` |
| Konten und Einstellungen | `~/.citygml/auth/` (eine Datei je verbundenem GitHub-Konto), `~/.citygml_attr_editor.json` |

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
  wenden auf jeden Vorschlag dieselben vierzehn Prüfpunkte an, egal wie er entstand.
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
