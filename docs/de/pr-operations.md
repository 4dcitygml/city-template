<!-- Copyright (c) 2026 4dcitygml -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

# Pull-Request-Operationen nach der Veröffentlichung

> Deutsche Übersetzung des englischen Originals: [../pr-operations.md](../pr-operations.md).
> Bei Abweichungen gilt das englische Original.

- Status: angenommenes Verfahren für Post-Publikationsbetrieb (PR-Typen ohne dedizierte CI bleiben gated, bis es existiert). Zweite Auflage: Sitze und das zweistufige Review.
- Gilt für: veröffentlichte Stadt-Daten-Repositorys

日本語版: [docs/ja/pr-operations.md](../ja/pr-operations.md)

Dieses Dokument ist das **kanonische Verfahren für die Abläufe von Pull Requests nach der Veröffentlichung**. Andere Dokumente erklären Design-Rationale oder einzelne Werkzeuge; die Reihenfolge der täglichen Arbeit — Start, Erläuterung, Genehmigung, Zusammenführung, Veröffentlichung — folgt diesem.

## 1. Zunächst festgelegte Grundsätze

1. **1 Commit = 1 `uro:buildingID`** ist die minimale Einheit eines normalen Updates.
2. Building-Commits, die unter demselben Nachweis, derselben Quelle und
   derselben Änderungsregel geprüft werden können, dürfen in einem PR gebündelt
   werden. Die Editoren eröffnen **einen PR pro Building**; das ist die normale
   Form eines Vorschlags von Einwohnern oder Mitarbeitenden. Gebündelt wird nur
   in PRs, die ein Betreiber erstellt und die eine gemeinsame Nachweisquelle
   haben (zum Beispiel ein Erhebungsdokument, das mehrere Buildings korrigiert)
   — niemals als zeitlich gesammelter Digest. Der PR bleibt die Einheit der
   inhaltlichen Prüfung und des Rollbacks (Bedingungen in §4.1.1).
3. Teilen Sie niemals dieselbe buildingID über mehrere Commits eines Pull Requests auf. Sie kann in einem anderen Pull Request oder einer anderen jährlichen Attributfamilie erneut angezeigt werden.
4. Eine Building-Zusammenführung, -Aufspaltung oder -Neubau ist ein `lifecycle`-Ereignis, das mehrere IDs behandelt.
5. Stadt-Daten-Pull Requests werden mit einem **Merge-Commit zusammengeführt, niemals gequetscht**, wobei jeder Building-Commit auf main erhalten bleibt. Das Regelwerk erlaubt daher die `merge`-Methode (plus `squash` für Dokumentation); es ist niemals nur squash.
6. Code-, Dokumentations- und Tooling-Update-Pull Requests werden getrennt von Stadt-Daten gehalten und können gequetscht zusammengeführt werden.
7. Pull-Request-**Erläuterung**, **Genehmigung**, **Zusammenführung** zu main und stabile **Veröffentlichung** sind separate Abschluss-Zustände.
8. **Der Endfreigeber ist immer die Stadt** (das `maintainers`-Team). Betreiber — ein Auftragnehmer oder 4dcitygml in seiner Rolle als Betreiber — erläutern und führen zusammen; sie haben keine Genehmigungsbefugnis.
9. Ein Pull Request, bei dem selbst ein Building oder ein Commit eine blockierende Prüfung nicht besteht, wird nicht teilweise zusammengeführt.
10. main kann In-Progress-Arbeit enthalten. Regelmäßige Benutzer werden auf die neueste stabile Veröffentlichung hingewiesen. Die offizielle Ausgabe ist *eine Ausgabe des zusammengeführten Inhalts*; ob sie als offiziell übernommen wird, ist die Entscheidung der Stadt.

Sprache des PR-Textes: die Bearbeitungswerkzeuge erzeugen PR-Titel und -Text in der **Arbeitssprache des Repositorys** (`lang` in `4dcitygml.json`); Commit-Titel, `Building:`-Trailer und Branch-Präfixe bleiben Englisch/literal (die Historie und Maschinenverträge sind sprachunabhängig). Da Stadt-Daten-PRs mit einem Merge-Commit zusammengeführt werden (Regel 5), wird der PR-Titel niemals zu einer Historie-Titelzeile auf main. (Die Übungs-Repositorys weichen ab: ihr Auto-Merge quetscht, daher erscheint der PR-Titel in Repo-Sprache in der periodisch zurückgesetzten Übungshistorie.)

```text
Issue / offizielle Quelle / Vorschlag eines Einwohners
  → Entwurf-Pull Request (In-Progress-Arbeit, CI-Prüfungen)
  → automatisierte Prüfungen (13 Gates)
  → Bereit zur Überprüfung (Code-Besitzer werden automatisch angefordert = Eingang)
  → Erläuterungs-Review des Betreibers (Kommentar; fragt @maintainers zur Genehmigung auf)
  → Endfreigabe der Stadt (Genehmigen)
  → Betreiber führt mit einem Merge-Commit zusammen
  → Seiten / Verlaufsindex-Aktualisierung
  → stabile Veröffentlichung, nachdem das Release-Gate bestanden wurde → die Stadt übernimmt es als offiziell
```

## 2. Sitze (Rollen) und Abschluss-Verantwortung

Jeder Sitz wird auf GitHub durch ein Team oder eine Organisationsrolle vertreten, und **die CODEOWNERS-Datei wird niemals bearbeitet** — Personen treten bei und treten aus durch Änderung der Team-Mitgliedschaft.

| Sitz | Auf GitHub | Hauptarbeit | Zeichen der Fertigstellung |
|---|---|---|---|
| **Einreichender** | Ein beliebiges Konto außerhalb der Organisation (Einwohner, Personal, Forscher) oder ein Betreiber | Bereitet die Änderung, den Nachweis, Commits und PR-Body vor (der Hub automatisiert Fork → PR) | Markiert den PR als bereit zur Überprüfung |
| **CI** | `analyze` (erforderliche Prüfung) und Begleiter | Mechanische Prüfungen: Commit-Umfang, XML, Referenzen, Format, Geometrie, Manifest. Ergebnisse erscheinen als PR-Kommentar (Repository-Sprache) und als Checkpunkt-Liste des Hubs | Alle erforderlichen Prüfungen grün |
| **Betreiber** | Team **`operators`** (Schreibzugriff; kein Code-Besitzer) | Erläuterungs-Review (Kommentar), Rückgabe von Mängeln (Request changes), Zusammenführung nach Genehmigung, Release-Arbeit, jährliche Updates, Verifizierung von Tooling-Update-PRs | Erläuterung gepostet und `city-review`-Label gesetzt / Merge-Commit landet auf main |
| **Endfreigeber** | Team **`maintainers`** (Stadt-Personal; CODEOWNERS `* @<org>/maintainers`) | Semantische Beurteilung: Werte, Formen, Quellen, Lifecycle-Gründe. Liest die Erläuterung und genehmigt oder fordert Änderungen an | Genehmigen |
| **Eigentümer** | Organisationseigentümer (die Stadt) | Einstellungen, Abrechnung, Mitgliedschaft, Admin-Bypass (Grund aufgezeichnet in einem Issue) | — |
| **Sammel-Einreicher** | Ein Maschinenkonto in `operators`, Anmeldedaten von der Eigentümer der Stadt verwaltet | Erzeugt Konversions-PRs aus einer deklarierten Quelle mit einem Herkunfts-Manifest; bearbeitet niemals von Hand | Reproduktions-Gate grün, Manifest überprüft, Stichproben-Audit aufgezeichnet |
| **Werkzeuganbieter** | Die 4dcitygml-Organisation (`tools`, `city-template`, OAuth-App) | Veröffentlichungen, gemeinsame CI-Logik, schlägt Tooling-Update-PRs vor. Hält keine Berechtigung im Stadt-Repository | — |

Eine Person kann mehrere Sitze bekleiden, aber die Schritte und Aufzeichnungen bleiben getrennt (ein Betreiber, der auch einen PR vorgeschlagen hat, postet die Erläuterung als eigenständigen Kommentar). Jede Stadt hält ihre eigenen CODEOWNERS und Endfreigabe-Autorität; sie werden nicht über Städte hinweg geteilt. Der Betreiber-Sitz ist derselbe für einen Auftragnehmer und für 4dcitygml; ein Übergabe ist eine Änderung der Team-Mitgliedschaft.

## 3. Gemeinsame Schritte für jeden Pull Request

### 3.1 Bevor Sie beginnen

```text
[ ] Entschieden Sie den Ausgangspunkt: ein Issue, eine offizielle Quelle, ein Vorschlag eines Einwohners oder geplante Wartung
[ ] Identifiziert: Zielstadt, uro:buildingID, Mesh und Änderungstyp
[ ] Der Nachweis kann veröffentlicht werden, ohne Lizenz- / Personalinformations- / Datenschutzprobleme
[ ] Kein früherer offener PR ändert denselben Mesh-GML
[ ] Die Grenze zwischen diesem PR und anderen PRs ist entschieden
```

PRs, die denselben Mesh-GML ändern, werden serialisiert: erstellen Sie den nächsten PR vom aktuellen main, nachdem der frühere zusammengeführt wurde. Verschiedene Meshes können parallel fortgesetzt werden, nur wenn gemeinsame Schema-Migrationen durchgeführt sind und keine gemeinsamen Texturen oder XLinks berührt werden.

### 3.2 Branch und Commits

```text
[ ] Erstellter Working-Branch vom aktuellen main zum Start-Zeitpunkt
[ ] Die PR-Historie ist linear, ohne Merge-Commits innerhalb des Branches
[ ] Jeder Normal-Update-Commit ändert genau eine buildingID
[ ] Die gleiche buildingID wird nicht über Commits innerhalb des PR aufgeteilt
[ ] Building-Commits werden in aufsteigender uro:buildingID-Reihenfolge angeordnet
[ ] Building:, Building-Added:, Building-Deleted: Trailer entsprechen der aktuellen Änderung
[ ] Nur-Formatierung-Diffs außerhalb des Ziels werden mit der minimal-diff-Version entfernt
```

Nutzen Sie `Draft` zum Speichern von Arbeit und Überprüfung von CI. **Code-Besitzer werden automatisch angefordert, in dem Moment, in dem ein PR als bereit zur Überprüfung markiert wird** (nicht während es Entwurf ist), also erledigen Sie die automatisierten Prüfungen und die Selbstüberprüfung zuerst.

### 3.3 PR-Body

```text
[ ] Genau einen PR-Typ ausgewählt
[ ] Geschrieben, was ändert, warum und auf welchem Nachweis
[ ] Aufgelistet jede Ziel-buildingID oder das Manifest
[ ] Angegeben erlaubte Pfade und was nicht geändert werden darf
[ ] Verlinkt verwandte Issues mit Fixes #<number> oder Refs #<number>
[ ] Hinzugefügt Nachweis-URLs, Dokumentnamen, Abrufdaten, Ausgaben, Hashes
[ ] Falls Form, LOD, Attribute, IDs und Lifecycle gemischt sind, erklärt, warum sie nicht getrennt werden können
```

Jährliche `source-update`-PRs benötigen zusätzlich:

```text
Source-From, Source-To, Scope-Mesh, Attribute-Family, Allowed-Paths,
History-Manifest, Manifest-SHA256, Building-Count,
First-Building-ID, Last-Building-ID
```

### 3.4 Automatisierte Prüfungen und Bestätigung durch den Einreichenden

Die dreizehn Gates laufen bei jedem Push, und die Editoren erfüllen die
Listen aus §3.1–§3.3 von Konstruktion her; diese Liste gilt für von Hand
erstellte PRs.

```text
[ ] Alle erforderlichen Prüfungen sind auf der Head-SHA des letzten Pushs grün (einschließlich Base Freshness)
[ ] Warnungen und Hinweise wurden gelesen; bleibt einer stehen, steht der Grund im PR
[ ] Nach einem Churn-Hinweis wurde die Minimal-Diff-Version angewendet und erneut geprüft
```

Die aktuelle Churn-Behandlung endet bei der Benachrichtigung und der
Erzeugung der Minimal-Diff-Version; die automatische Anwendung auf den
PR-Head ist nicht implementiert. Bis dahin wendet der Einreichende oder ein
Betreiber sie an.

### 3.5 Erläuterungs-Review des Betreibers (erste Stufe — der *Reviewer*)

Bevor die Stadt um Freigabe gebeten wird, prüft ein Betreiber den PR und
postet eine **Erläuterung**. Der Review-Typ ist **Comment**: die Freigabe ist
allein Sache der Stadt. Im Vokabular des Kubernetes-OWNERS-Modells ist der
Betreiber der *Reviewer* und die maintainers der Stadt sind die *Approver*.

```text
[ ] Werte, Formen, Quellen und alt/neu-ID-Beziehungen sind schlüssig; offene Fragen wurden mit dem Einreichenden geklärt
[ ] Der Nachweis ist veröffentlichbar (Lizenz, personenbezogene Daten, Persönlichkeitsrechte)
[ ] Die Erläuterung wurde im Fünf-Zeilen-Template gepostet, mit Erwähnung von @<org>/maintainers und dem Label city-review
[ ] Mängel gingen mit Request changes zurück, statt an die Stadt weitergereicht zu werden
```

Template (in der Repository-Sprache; mit demselben Vokabular wie die
Checkpunkte des Hubs):

```text
## Erläuterung (Betreiber)
- Änderung: <building ID> — <Attribut/Form> von <alt> zu <neu>.
- Nachweis: <Zusammenfassung der Quellen des PR-Body / sec:reason>.
- Prüfungen: alle 13 Gates bestanden. Achtung: <falls vorhanden>.
- Auswirkung: nur dieses Building. Erreicht die offizielle Ausgabe mit der nächsten Veröffentlichung.
- Empfehlung: bereit zur Freigabe. @<org>/maintainers
```

- Behebbare Mängel → `Request changes` mit Hinweis auf die zu behebenden Stellen.
- Doppelte PRs, Änderungen außerhalb des Umfangs, nicht veröffentlichbare
  Nachweise oder unlösbare Rechtsprobleme → Schließen mit dokumentiertem Grund.
- Bei Tooling-Update-PRs (§4.9) beginnt die Erläuterung mit „keine Datenänderung".

### 3.6 Endfreigabe der Stadt (zweite Stufe — der *Approver*)

Der Approver bestätigt; er prüft nicht erneut. Alles Mechanische erzwingt
das Regelwerk: die erforderlichen Prüfungen müssen grün sein, jeder spätere
Push verwirft die Freigabe, und nur die Freigabe eines Code Owners zählt.

```text
[ ] Der Empfehlung der Erläuterung wird zugestimmt (sonst Request changes zurück an den Betreiber)
[ ] Wo ein Label es verlangt (lifecycle, identity-review, texture-override), ist die Zusatzbedingung erfüllt
```

Freigabe auf der GitHub-PR-Seite oder im Hub, der die Prüfergebnisse in der
Repository-Sprache zeigt. „Freigabe des letzten prüfbaren Pushs" bedeutet
*freigegeben von jemand anderem als der zuletzt pushenden Person*; wer selbst
gepusht hat, kann den eigenen Push nicht freigeben. Bei mehreren
Mitarbeitenden leitet die Code-Review-Zuweisung des Teams jede Anfrage an
eine Person.

### 3.7 Zusammenführung

Das Regelwerk erzwingt grüne Prüfungen, eine gültige Code-Owner-Freigabe und
aufgelöste Unterhaltungen. Der Betreiber bestätigt nur:

```text
[ ] „Create a merge commit" für Stadtdaten-PRs (Dokumentations- und Tooling-PRs dürfen squashen)
[ ] PR-Typ und Ziel-Mesh entsprechen der Erläuterung
```

Ein Betreiber (oder die Stadt) führt zusammen. Kein Auto-Merge. Ein
Admin-Bypass im Notfall ist dem Eigentümer der Stadt vorbehalten, mit
dokumentiertem Grund in einem Issue.

### 3.8 Nach der Zusammenführung

```text
[ ] Prüfungen und der Pages-Historienindex auf main waren erfolgreich
[ ] Bei Jahresaktualisierungen wurde der Zustand des Release-Plans aktualisiert
[ ] Bei Auffälligkeiten wurde ein Revert-PR eröffnet — die Historie wird nie umgeschrieben
```

Keine Nachfolge-Commits, die PR-Nummern oder SHAs in das Manifest selbst
schreiben. Der Pages-Index wird aus der Git-Historie und GitHub neu erzeugt.

### 3.9 Benachrichtigungen

- **Eingang**: die automatische Code-Owner-Anfrage, wenn ein PR bereit zur Überprüfung wird. Sie kann nicht ausgeschaltet werden; Entwurf verschiebt sie.
- **Freigabeanfrage**: die `@<org>/maintainers`-Erwähnung in der Erläuterung. Das Deaktivieren von Team-Benachrichtigungen stummschaltet Erwähnungen, aber *nicht* Review-Anfragen (GitHub-Dokumentation); wenn eine Stadt sie deaktiviert, erwähnen Sie stattdessen Personen einzeln.
- Ein Personal-Mitglied erhält zwei Benachrichtigungen pro PR. Mit mehreren Personal-Mitgliedern verengt die Code-Review-Zuweisung die Anfrage auf eine Person.

## 4. Wahl des PR-Typs

| PR-Typ | Einheit eines PR | Building-Commits | Erforderliche zusätzliche Aufzeichnungen | Üblicher Sitz |
|---|---|---|---|---|
| `correction` | Ein Nachweis / Änderungsregel | Ein buildingID pro Commit | Issue, Nachweis, Vorher/Nachher | Einreichender, Betreiber |
| `lifecycle` | Ein Rebuild / Split / Merge | Ein dedizierten Commit, mehrere IDs erlaubt | Alt-/Neu-ID-Beziehungen, Grund, Manifest, zusätzliche Genehmigung | Betreiber |
| `identity-correction` | Ein Fehlverbindungs- / ID-Korrektur-Ereignis | Folgt dem dedizierten Gate | Vorher-/Nachher-IDs, Beweis des Fehlers, zusätzliche Genehmigung | Sammel-Einreicher |
| `source-update` | 1 Quelle-Übergabe × 1 Mesh × 1 Attribut-Familie / Regel | Ein buildingID pro Commit | Quellen-/Änderungs-Manifest, erlaubte Pfade, Anzahlen, Stichproben-Prüfung | Sammel-Einreicher |
| `schema-update` | Ein Schema-Bundle | Keine GML-Änderung | Hashes von XSD / Code-Listen, Profil | Betreiber |
| `carry-forward` | 1 Editionswechsel × 1 Mesh (vorherige offizielle, Repository, neue offizielle) | Ein `Building:` Commit pro erneut angewendetem Building, nach dem `source-baseline` der neuen Edition | Herkunfts-Manifest: erneut angewendet / übernommen / Konflikte / nicht abbildbar / mit altem codeSpace übernommen | Sammel-Einreicher |
| `schema-migration` | 1 Editionswechsel × 1 Mesh wenn keine offizielle neue-Edition-Datei existiert (das Repository ist die Master-Kopie): Registry-gesteuerte Neuserialisierung des i-UR-Subtree | Ein erzeugter `source-baseline` der neuen Edition | Herkunfts-Manifest; semantische-Gleichheit-Prüfung pro Registry-Schlüssel (erhalten / abgebildet / übernommen / nicht abbildbar) — Gate noch nicht implementiert | Sammel-Einreicher |
| `layout` | Eine Einschritt-Unterteilung eines Eltern-Mesh | Ein Semantik-erhaltender Commit | Wiederaggregations-Prüfung, ID / Referenz / Größe-Prüfungen | Betreiber |
| `texture-gc` | Ein Sammlung unreferenzierter Bilder | Keine Building-Änderung | Beweis der Nicht-Referenzierung für alle imageURIs, Löschungs-Liste | Betreiber |
| `revert` | Rückgängigmachung eines Building-Commit oder eines PR | Behält die ursprüngliche Einheit | Ziel, Grund, betroffene Veröffentlichungen | Betreiber |
| **`tooling`** | Ein Update auf eine neue `tools`-Veröffentlichung | Keine Building-Änderung | Alt-/Neu-Tag · Asset · sha256, Link zu Veröffentlichungs-Notizen, "keine Datenänderung" | Vorgeschlagen von 4dcitygml, verifiziert von einem Betreiber |
| Code / Dokumentation | Ein Werkzeug- oder Dokumentationsänderung | Keine Building-Änderung | Tests, Doc-Links, Auswirkung | Betreiber |

`source-baseline`, `scope-extract` und `identity-baseline` sind nur für die anfängliche Konstruktion der veröffentlichten Historie; sie werden nicht als tägliche PRs nach Veröffentlichung wiederholt. Das Hinzufügen weiterer Themen später (Transport, Überflutung, Terrain …) als pro-Thema `source-baseline` hat noch kein Gate; fügen Sie sie nicht hinzu, bis es existiert.

### 4.1 Tägliche `correction`

```text
[ ] Es gibt ein Daten-Issue oder veröffentlichbaren Nachweis
[ ] Buildings, die zum PR gebündelt sind, können unter denselben Nachweis und Regel überprüft werden
[ ] Jeder Commit hat genau einen Building: <uro:buildingID>
[ ] Textur-Ersetzung wurde durch Hinzufügen neuer Bilder + Aktualisieren von imageURI durchgeführt
[ ] Nach Geometrieänderungen wurden abgeleitete Attribute (Höhe, Fläche, …) auf Konsistenz überprüft
```

Das Überschreiben einer existierenden Textur unter demselben Namen ist grundsätzlich verboten. Nur für legitime Ausnahmen (gemeinsame Atlanten usw.), nach Überprüfung jedes betroffenen Buildings, wendet ein Betreiber das `texture-override`-Label an und die Stadt genehmigt.

### 4.1.1 Wann mehrere Buildings einen PR teilen dürfen

- Die Editoren eröffnen **einen PR pro Building**; das ist die normale Form.
- Ein von Hand erstellter PR darf mehrere Buildings enthalten, wenn er **eine
  logische Änderung** ist: ein Nachweis (dasselbe Dokument, dieselbe Edition)
  und eine identisch angewendete Regel, innerhalb eines Meshs und einer
  Attributfamilie. Es gibt keine Obergrenze — der Betreiber liest jedes Building.
- Alles, was ein Skript aus einer Quelle oder einem externen Datensatz erzeugt
  hat, ist unabhängig von der Anzahl eine **Sammel-Einreichung** (§4.4:
  Herkunfts-Manifest mit Materialien, Zuordnungstabelle und erzeugendem
  Befehl; Annahme durch Reproduktion) — dieselbe Grenze, der große
  werkzeuggetriebene Änderungen auch anderswo folgen.
- Scheitert ein Building, wird es in einen eigenen PR abgetrennt und der Rest
  per Force-Push aktualisiert. Die übrigen Patches sind unverändert, was
  GitHubs Force-Push-Vergleich zeigt; die Wiederfreigabe ist ein Klick. Eine
  Teil-Zusammenführung gibt es nicht (Grundsatz 1-9).

Beispiele: 12 Buildings eines Meshs aus der Notunterkunftsliste der Stadt von
Hand kennzeichnen → ein PR; dieselbe Liste per Skript für 3 Buildings →
Sammel-Einreichung; Geschosszahlen von 5 Buildings aus je einem anderen
Dokument → ein PR pro Building.

### 4.2 `lifecycle`

```text
[ ] Alt-/Neu-Building-Beziehungen sind geklärt; keine ungelösten Kandidaten vermischt
[ ] Der PR enthält genau ein echtes Ereignis
[ ] Change-Type: lifecycle wird aufgezeichnet
[ ] Building-Deleted: / Building-Added: entsprechen jedem aktuell geänderten ID
[ ] Beziehungen, Ereignis-/Bestätigungsdatum, Nachweis und Entscheidungsträger sind im Manifest
[ ] Das Lifecycle-Label und die Genehmigung der Stadt sind vorhanden
```

Falls die Alt-/Neu-Beziehung unklar ist, springen Sie nicht zu "abgerissen" oder "neu gebaut" — parken Sie es in einem Issue oder `lifecycle-review`.

### 4.3 `identity-correction`

Selbst wenn eine fehlverbundene Identität in veröffentlichter Historie gefunden wird, werden frühere Commits und Tags niemals umgeschrieben. Ein neuer PR zeichnet die Vorher-/Nachher-IDs, den Beweis des Fehlers und die betroffene Historie auf.

```text
[ ] Identifiziert die buildingIDs vor und nach der Korrektur
[ ] Es gibt Beweis, dass dies ein Fehlverbindungs-Fix ist, nicht ein Lifecycle-Ereignis
[ ] Aufgezeichnet, welcher Zeitraum der früheren Historie betroffen ist
[ ] Die dedizierte Identity-Correction-CI (Commit-Umfang + Reproduktion) und die Genehmigung der Stadt erfolgreich
```

Das Commit-Umfang-Gate akzeptiert buildingID-Ersetzung nur als `identity-baseline` / `identity-correction` Commit mit Herkunfts-Manifest (siehe unten); das `reproduction`-Gate regeneriert das Manifest aus seinen deklarierten Materialien. Markieren Sie solche PRs nicht als bereit zur Überprüfung, bis diese Gates auf echtem Repository im privaten Piloten verifiziert wurden.

Identity-PRs sind Massen-Einreichungen: sie werden durch **Reproduktion** akzeptiert, nicht durch Lesen jedes Commit. Das Einreichungspaket (Plan-Issue, Herkunfts-Manifest mit pro-Building-Beweis und pro-Grenze-ID-Regime, Commit-Trailer, Maschinenkonto, Stichproben-Audit) und das Gate sind angegeben in [Bulk submissions: provenance, verification, and merge policy](https://github.com/4dcitygml/tools/blob/main/docs/bulk-submission-provenance.md).
Gemessen an den Tokio 2020–2025-Ausgaben, bricht die `uro:buildingID`-Kontinuität völlig, wo die Produkt-Abstammung sich ändert (die 2022→2023-Grenze nummerierte jeden Building neu, und IDs, die diese Grenze teilen, gehörten zu *verschiedenen* Buildings), also ist eine identische ID niemals ausreichend Beweis auf sich selbst; jede Verknüpfung benötigt geometrischen Beweis.

### 4.4 Jährliches `source-update`

Jährliche Updates erfolgen als separate PRs in dieser Reihenfolge (geplant von einem Betreiber; Massen-Teile werden vom Maschinenkonto eingereicht):

1. `schema-update` — die Artefakte der neuen Edition (Code-Listen unter `codelists/<edition>/`, Schema-Profil), keine GML-Änderung
2. wenn sich die Edition ändert — entweder die neue offizielle Edition als frische `source-baseline`, gefolgt von `carry-forward` (Dreiwege-Vergleich pro Building und Attribut), oder, wenn das Repository die Master-Kopie ist und keine offizielle neue-Edition-Datei existiert, `schema-migration` (Registry-gesteuerte Neuserialisierung des i-UR-Subtree, verifiziert durch semantische Gleichheit pro Registry-Schlüssel)
3. ein Single-Building-Pilot pro Attribut-Familie
4. Multi-Building-PRs pro Attribut-Familie
5. dedizierte PRs für Geometrie, LOD und Quelle `gml:id`
6. `lifecycle` für bestätigte Ereignisse
7. Vollständigkeits-Prüfungen pro Mesh und über die Stadt
8. das jährliche Release-Tag

```text
[ ] Vor-Update-Bewertung von Quelle, Schema, IDs, semantischen Regeln, Lifecycle und Größe durchgeführt
[ ] Jeder PR auf 1 Quelle-Übergabe × 1 Mesh × 1 Attribut-Familie / Regel begrenzt
[ ] Das Manifest heftet erlaubte Pfade, Alt-/Neu-Werte und jeden Ziel-buildingID fest
[ ] Ein repräsentatives Building pro Attribut-Familie bestanden First
[ ] Generiert vom aktuellen main, nachdem das früheren PR auf demselben Mesh zusammengeführt wurde
[ ] Auto-bestätigte Gruppen werden von mehrdeutigen / Lifecycle-Review-Gruppen getrennt
[ ] Die finale Pfad-Signatur entspricht der vorgefassten
```

Überschreiben Sie niemals eine ganze neue-Jahr-Quelle in einem PR. Jeder Attribut-PR wird aus der neue-Jahr-Kopie im Arbeitsbereich basierend auf dem nicht-angewendeten buildingID-Manifest generiert.

`source-update` PRs sind Massen-Einreichungen: versenden Sie das Herkunfts-Manifest und `Provenance-Manifest:` Trailer beschrieben in [Bulk submissions: provenance, verification, and merge policy](https://github.com/4dcitygml/tools/blob/main/docs/bulk-submission-provenance.md); Reviewer verifizieren den Plan, das Manifest und eine zufällige Stichprobe, und CI reproduziert die Konvertierung.

### 4.5 `schema-update` und Edition-Wechsel (`carry-forward`)

```text
[ ] schema-update ändert keine GML; nur Edition-Artefakte (codelists/<edition>/, schemas/, provenance/schema-update/)
[ ] Die Artefakte' Digests und ihre offizielle Quelle (ZIP-Mitglied) sind aufgezeichnet
[ ] Offline-XSD-Validierung der aktuellen Daten besteht unter dem neuen Profil
[ ] Ein Edition-Wechsel wird angewendet als: neue offizielle Edition = source-baseline, dann carry-forward (niemals eine strukturelle Konvertierung der alten Datei)
[ ] Das carry-forward-Manifest listet erneut angewendet / übernommen / Konflikte / nicht abbildbar / mit altem codeSpace übernommen pro Building
[ ] Konflikte und nicht abbildbare Attribute wurden von einem Reviewer entschieden; übernommene Codes werden für das Release-Gate gezählt
```

Zwei Wege existieren für einen Edition-Wechsel. Während offizielle Editionen unabhängig erzeugt werden, wird die neue offizielle Edition zur nächsten Baseline und die angesammelten Änderungen werden durch einen Dreiwege-Vergleich pro Building und semantisches Attribut erneut angewendet (`carry-forward`, siehe [Bulk submissions: provenance, verification, and merge policy](https://github.com/4dcitygml/tools/blob/main/docs/bulk-submission-provenance.md)).
Sobald das Repository die Master-Kopie ist und die offizielle Edition aus ihm exportiert wird, existiert keine externe neue-Edition-Datei: `schema-migration` generiert dann die Serialisierung der neuen Edition aus dem eigenem Inhalt — der CityGML-Kern bleibt innerhalb von 2.0 unverändert (ein 3.0-Übergang konvertiert den Kern durch 3DCityDB), und der i-UR-Subtree wird pro Building aus der semantischen Registry, der Code-Listen-Crosswalk (Codes ohne 1:1-Abbildung behalten ihren alten codeSpace) und der XSD-Reihenfolge der neuen Edition neu serialisiert. Sein Gate ist semantische Gleichheit pro Registry-Schlüssel (erhalten / abgebildet / übernommen / nicht abbildbar) und Reproduktion; es ist entworfen aber noch nicht implementiert. Entweder Weg wird durch denselben Registry-basierten Vergleich verifiziert. `schema-update` wird durch die Commit-Umfang-Prüfung gesichert (nur Artefakt-Pfade, keine CityGML-Änderung); `carry-forward` wird wie `source-update` plus das `reproduction`-Gate gesichert.

### 4.6 `layout`

```text
[ ] Bestätigt vor dem Update, dass ein gespeicherter GML 50 MiB oder mehr erreichen würde
[ ] Unterteilter nur der aktuelle Mesh auf Vor-Update-main um genau eine Ebene
[ ] Aufgezeichnet Change-Type: layout, ohne Building-ID-Trailer
[ ] Building-Anzahl, ID-Set, semantischer Hash, Appearance und XLink sind unverändert
[ ] Envelope, XSD und temporäre Wiederaggregations-Prüfungen bestehen
[ ] Alle Dateien nach Unterteilung sind unter 50 MiB, ohne verfolgter Datei bei 100 MiB oder mehr
```

Ein einmal unterteilter Mesh wird niemals zurück zu einem gröberen Mesh zusammengeführt, selbst wenn er in späteren Jahren schrumpft. Das aktuelle Werkzeug unterstützt einen Unterteilungs-Schritt; tiefere Ebenen werden nur nach Erweiterung und Verifizierung freigeschaltet.

### 4.7 `texture-gc`

```text
[ ] Jeder Löschungs-Kandidat wird von allen imageURIs auf main unreferenziert
[ ] Null neue hängende Referenzen
[ ] Die Löschungs-Liste, Anzahl und Byte-Größe sind im PR-Body aufgezeichnet
[ ] Keine Building-GML, Attribute oder Geometrie-Änderung im gleichen PR
```

### 4.8 `revert` und dringende Fixes

Veröffentlichte Fehler werden niemals durch Force-Push oder Tag-Ersetzung versteckt — sie werden durch einen neuen PR rückgängig gemacht.

```text
[ ] Entschieden, ob einen Building-Commit oder die ganze PR rückgängig gemacht wird
[ ] Aufgezeichnet der Ziel-Commit oder Merge-Commit-SHA
[ ] Geschrieben der Grund, wie er gefunden wurde und die betroffenen Buildings und Veröffentlichungen
[ ] Liefen die vollständige normale Prüfung auf den rückgängig gemachten CityGML
[ ] Entschieden, ob eine Patch-Veröffentlichung notwendig ist, falls eine veröffentlichte Veröffentlichung betroffen ist
```

Selbst unter Dringlichkeit werden erforderliche Prüfungen und die Genehmigung der Stadt niemals übersprungen. Antworten Sie durch Verengung des Umfangs und Erhöhung der Priorität.

### 4.9 `tooling` (Aktualisierung der gemeinsamen Werkzeuge)

Ein Client-Update der Reihe `hub-v` ändert `install/tools-release.json` (Tag, Asset und sha256). Ein Update der städtischen Verarbeitung aus `tools-v` ändert `CITYGML_TOOLS_REF` auf den unveränderlichen Release-Commit. Die Updates sind unabhängig; ihre Kombination wird vor der Übernahme geprüft. **Nichts ändert sich, bis die Stadt es zusammenführt** — die Stadt behält die Kontrolle.

```text
[ ] Die Änderung berührt nur install/tools-release.json und die Pins in .github/workflows/ — keine Daten, keine Dokumentation
[ ] Das neue Tag, Asset-Namen und sha256 entsprechen den Veröffentlichungs-Notizen von 4dcitygml/tools (verifiziert von einem Betreiber)
[ ] Die Erläuterung fasst die Veröffentlichungs-Notizen zusammen und beginnt mit "keine Datenänderung"
[ ] Ein Betreiber bestätigte auf einer Maschine, dass der Aktualisierungsmechanismus des Starters (.release-tag) die neue Veröffentlichung liefert
[ ] Nach der Genehmigung der Stadt per Squash zusammengeführt
```

## 5. Veröffentlichungen

Release-Arbeit wird von einem Betreiber durchgeführt; **ob das Ergebnis als offizielle Ausgabe übernommen wird, ist die Entscheidung der Stadt** (das Repository ist die Master-Kopie; die offizielle Ausgabe ist eine Ausgabe des zusammengeführten Inhalts).

### 5.1 Gewöhnliche tägliche Korrekturen

- Nach der Zusammenführung wird der Fix auf main und in der Building-Historie widergespiegelt.
- Zusammenführen eines PR allein bewegt eine existierende stabile Veröffentlichung niemals.
- Es ist in der nächsten geplanten Patch- oder jährlichen Veröffentlichung enthalten.
- Eine Patch-Veröffentlichung wird für ernsthafte Fehler, rechtliche / Personalinformations-Probleme oder Nutzungsgefahren durchgeführt.

Patch-Veröffentlichungs-Tag-Namensvergabe und Kadenz werden in einem separaten ADR vor der Betätigung festgelegt.

### 5.2 Jährliche Veröffentlichungen

```text
[ ] Alle Attribut-Familie-PRs für alle Ziel-Meshes sind abgeschlossen
[ ] Geometrie, LOD, Quelle gml:id und bestätigte Lifecycle-Gruppen sind abgeschlossen
[ ] Schema-Profil-Prüfung und, für einen Edition-Wechsel, Herkunfts-Manifest-Review sind abgeschlossen
[ ] Voll buildingID-Set, Duplikate, Referenzen, Appearance und XSD bestehen
[ ] Die finale Pfad-Signatur entspricht semantisch der offiziellen neue-Jahr-Edition
[ ] Ungelöste Gruppen bleiben unberührt, mit Hold-Liste und Auswirkung aufgezeichnet
[ ] Das Release-Plan ist Release-bereit
[ ] Veröffentlichungs-Notizen decken Quelle, Hashes, Verarbeitung, ID-Vereinheitlichung, Holds und Prüfungs-Ergebnisse
[ ] Tag, Pages, Downloads und Prüfungs-Ergebnisse weisen auf den gleichen Commit
[ ] Mit altem codeSpace übernommene Codes (codelists/<edition>/) sind mit carried_codespace_report.py gezählt und aufgelöst oder vom offiziellen Kanal akzeptiert
[ ] Die Entscheidung der Stadt, die Veröffentlichung als offiziell (Datum, Veröffentlichungs-Kanal) zu übernehmen, ist aufgezeichnet
```

Solange eine Release-bereit-Bedingung fehlt, wird main niemals als "die stabile neue-Jahr-Edition" dargestellt.

## 6. Bedingungen, unter denen nicht zusammengeführt wird

Genehmigen oder Zusammenführen Sie nicht, wenn eine der folgenden Bedingungen erfüllt ist:

- Der PR ist hinter dem aktuellen main
- Eine erforderliche Prüfung schlug fehl, lief nicht oder zielt auf einen alten Head-SHA
- Quelle, Nachweis, Lizenz oder Veröffentlichbarkeit können nicht bestätigt werden
- Der PR-Typ entspricht nicht der aktuellen Änderung
- Selbst ein buildingID, Pfad oder Alt-/Neu-Wert liegt außerhalb des Manifests
- Ein früherer PR auf demselben Mesh ist nicht zusammengeführt
- BuildingID-Identität, Lifecycle-Beziehungen oder Schema-Konversions-Semantik sind ungelöst
- Ein erforderliches Layout-PR für einen Mesh, der 50 MiB erreicht, ist nicht durchgeführt
- Churn bleibt, Out-of-Scope-Buildings oder Linien änderbar machend
- **Keine Betreiber-Erläuterung, oder ein Push nach der Erläuterung hat die Genehmigung abgelehnt**
- **Keine Genehmigung von der Stadt (ein Code-Besitzer) — eine Betreiber- oder Einreichender-Genehmigung zählt nicht**
- Erforderliche Lifecycle- / Identitäts- / Textur-Override-Genehmigungen fehlen
- Ein PR-Typ ohne dedizierte CI wird als Normal-Update durchgeleitet

## 7. Aktuelle Implementierung und verbleibende Arbeit

### 7.1 Was das aktuelle Repository überprüfen kann

- Die 1-buildingID-Einschränkung und Trailer-Entsprechung für normale Commits; Verbot doppelter buildingID-Commits innerhalb eines PR
- Commit-Umfangs-Ausnahmen für `lifecycle`, `layout`, `source-baseline` (nur erste Historie-Eintrag), `scope-extract`
- `identity-baseline` / `identity-correction` Commits: Trailer und Manifest-Referenz, Byte-erhaltender ID-Ersetzung, Tier-Regel, Repository-breite ID-Eindeutigkeit
- `source-update` Wert-Ersetzungen innerhalb einer Attribut-Familie: Manifest-gestützte `Building:` Commits, Byte-genaue Anwendung der Manifest-Änderungen, alle Ziele angewendet
- Das `reproduction`-Gate holt die Materialien eines Massen-Manifests neu und regeneriert es (Identity- und Source-Update-Arten)
- Pro-Building-Historie abgeleitet von git unabhängig von Commit-Granularität (`scripts/building_history.py` in tools: folgt dem Building über ID-Wechsel, Ganz-Datei-Baselines und Manifest-gestützte Commits, meldend Registry-Schlüssel-Änderungen pro Commit); der `history-index.yml`-Workflow veröffentlicht es als statische Pages-Site (`history/index.html` + `history/buildings/<id>.json`) bei jedem Push zu main
- Ziel-Gemeinde-Set und beibehaltene Building-Invarianz für `scope-extract`
- XML/XSD (i-UR 2.0–3.2 gebündelt), Struktur, Referenzen, Texturen, Geometrie-Prüfungen und Vergleichsansichten; PR-Kommentare auf großen PRs werden bei 60.000 Zeichen gekürzt mit Zeiger zu Artefakten
- Base-Aktualitäts-Leitlinie
- Der Hub: Geräte-Fluss-Anmeldung, Fork → PR, Checkpunkt-Liste in der Repository-Sprache, Genehmigen / Request changes und eine Warteschlange, die Entwurf / Überprüfung / Warten-auf-aktuellster-main / Warten-auf-Überprüfung trennt
- Das Starter-Kit (Veröffentlichung `starter-kit`) und sein Aktualisierungs-Mechanismus (`.release-tag`)

### 7.2 Zu implementieren vor dem Entsperren der entsprechenden PR-Typen

- Pro-Edition-Schema-Profile als Validierungs-Option (heute deckt ein Master-Schema i-UR 2.0–3.2 ab)
- Pilot-Verifizierung der implementierten `identity-baseline` / `identity-correction` Gates (Commit-Umfangs-Regeln + `identity` Reproduktion) auf echtem Repository
- Pilot-Verifizierung des `source-update` Wert-Ersetzungs-Gate (eine Attribut-Familie pro PR; Manifest-gestützte Commits, Reproduktion) auf echtem Repository
- Edition-Umstrukturierungen (Attribut-Container hinzugefügt oder entfernt durch neue Edition — der Großteil der gemessenen 2020→2025 Unterschiede) werden durch `carry-forward` (implementiert) behandelt, während offizielle Editionen existieren; die Registry-gesteuerte `schema-migration` für die Master-Kopie-Phase (Neuserialisierer, semantische-Gleichheit-Gate, i-UR 4.0 Registry) ist entworfen aber nicht implementiert
- Voll Abgleichung von Allowed-Paths, Alt-/Neu-Werten und Manifest-IDs für `source-update`
- Das Release-Gate für finale Pfad-Signatur und offizielle Quellen-Konsistenz
- Unterteilungs- / Wiederaggregations-Werkzeuge für tiefere Mesh-Ebenen falls nötig
- Erweiterung des Verlaufs-Index von buildingID → Commit → PR → Merge-Commit zur Veröffentlichung
- Automatische Anwendung der minimal-diff-Version für gleich-Repository- und Fork-PRs
- Der ADR für Patch-Veröffentlichungs-Tag-Namensvergabe, Kadenz und Dringlichkeits-Kriterien
- Ein pro-Thema `source-baseline` Gate (Hinzufügen von Transport, Überflutung, Terrain … später) und ein Gate für Stadt-breite semantische Korrektionen (zum Beispiel Umbenennung von `lod0FootPrint` zu `lod0RoofEdge` für jedes Building)
- Aufteilungs-Unterstützung für gebündelte PRs: eine Hub-Ansicht der Buildings, deren Patch seit dem letzten Review unverändert ist, und der entfernten Buildings (Wiederfreigabe mit einem Klick)
- Eine Art der Sammel-Einreichung mit beliebigem externem Datensatz als Material (zum Beispiel `external-update`): veröffentlichte Listen der Stadt, Liegenschaftskarten, nationale Geodaten, 3DCityDB … als `materials`, Zuordnungstabelle und Ersetzungslogik im Manifest, `reproduction` läuft über den Konnektor
- Ein zeitgesteuerter `tooling`-Workflow im Stadt-Repository, der Upstream-Releases prüft und den Update-PR selbst eröffnet (Dependabot-Muster) und PRs ersetzt, die 4dcitygml einreicht
- Bewertung der GitHub-Merge-Queue als Ersatz für die manuelle Regel, dass PRs auf demselben Mesh serialisiert werden (§3.1)
- Unterstützung für das zweistufige Review im Hub: ein "Post-Erläuterung"-Button, der das Template einfügt, öffnet PRs als Entwürfe und markiert sie bereit mit der Erläuterung, und respektiert `oauthClientId` aus `4dcitygml.json`

Unimplementierte dedizierte Gates werden niemals durch Dokumentation allein ersetzt.
Bestätigen Sie Ablehnung und Revert-Verhalten auf echtem Repository, bevor Sie es in öffentliche Betrieb bringen.

## 8. Periodische Prüfungen nach der Veröffentlichung (nach Sitz)

### Wöchentlich (Betreiber)

```text
[ ] Überprüfte PRs in Warten-auf-Genehmigung (erklärt) / Warten-auf-Erläuterung / Request changes / Warten-auf-aktuellster-main getrennt
[ ] Bearbeitete CI-Bruch getrennt von Datenfällen
[ ] Schrieb die nächste Aktion oder einen Schließungsgrund auf lange stillgelegte PRs
[ ] Keine konfliktreichen PRs auf demselben Mesh
[ ] Sendete der Stadt einen Digest von PRs, die auf Genehmigung warten, falls die Stadt Digests bevorzugt zu Pro-PR-Benachrichtigungen
```

### Monatlich / vor geplanten Veröffentlichungen (vorbereitet von Betreibern, bestätigt von der Stadt)

```text
[ ] Überprüfte Kandidaten für unreferenzierte Texturen
[ ] Aufgezeichnet neue offizielle Quellen / jährliche Ausgaben und das Überprüfungs-Datum
[ ] Inspiziert die Pins erforderlicher Workflows und gemeinsamer Werkzeuge (CITYGML_TOOLS_REF, tools-release.json); entschieden, ob eine Tooling-PR fällig ist
[ ] Bestätigt Quellen, Rechte und offene Fragen für den Release-Ziel-Commit
```

### Vierteljährlich (Eigentümer der Stadt)

```text
[ ] Organisations-Eigentümer, Maintainer und Betreiber passen der aktuellen Anordnung an; keine Vakanzen durch Abgänge, Transfers oder beendete Verträge
[ ] Zwei-Faktor-Authentifizierung für jedes Mitglied; Verfallsdatum und Speicherung des Tokens des Maschinenkontos
[ ] Die Liste genehmigter OAuth-Apps (nur der gemeinsame Hub)
[ ] Die Beschreibung im README der Anordnung (Eigentümer, Endfreigeber, Betreiber, Übergabe-Datum) entspricht der Wirklichkeit
[ ] Die Regelwerke für main und Baseline entsprechen §3.6
```

## 9. Sitzwechsel (ein Auftragnehmer tritt bei oder geht; 4dcitygml zieht sich zurück)

Laden Sie den neuen Betreiber zur Organisation ein und fügen Sie ihn zu `operators` hinzu; entfernen Sie den Vorgänger; geben Sie das Token des Maschinenkontos neu aus; aktualisieren Sie die Beschreibung im README der Anordnung. CODEOWNERS und Regelwerke werden nicht angetastet. Die gleichen Schritte gelten, ob der Betreiber ein Auftragnehmer ist oder 4dcitygml selbst.
