<!-- Copyright (c) 2026 4dcitygml -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

# Pull-Request-Operationen nach der Veröffentlichung

> Deutsche Übersetzung des englischen Originals: [../pr-operations.md](../pr-operations.md).
> Bei Abweichungen gilt das englische Original.

- Status: angenommenes Verfahren für Post-Publikationsbetrieb (PR-Typen ohne dedizierter CI bleiben gated, bis es existiert)
- Gilt für: veröffentlichte Stadt-Daten-Repositorys

日本語版: [docs/ja/pr-operations.md](../ja/pr-operations.md)

Dieses Dokument ist das **kanonische Verfahren, wie Pull Requests nach der Veröffentlichung ablaufen**. Andere Dokumente erklären Design-Rationale oder einzelne Werkzeuge;
die Reihenfolge der täglichen Arbeit — Start, Überprüfung, Zusammenführung, Veröffentlichung — folgt diesem.

## 1. Zunächst festgelegte Grundsätze

1. **1 Commit = 1 `uro:buildingID`** ist die minimale Einheit eines normalen Updates.
2. Building-Commits, die unter denselben Nachweis-, Quellen- und Änderungsregeln überprüft werden können, können in einem Pull Request gebündelt werden.
3. Teilen Sie niemals die gleiche buildingID über mehrere Commits eines Pull Requests auf. Sie kann in einem anderen Pull Request oder einer anderen jährlichen Attributfamilie erneut angezeigt werden.
4. Ein Building-Zusammenführung, -Aufspaltung oder -Neubau ist ein `lifecycle`-Ereignis, das mehrere IDs behandelt.
5. Stadt-Daten-Pull Requests werden mit einem **Merge-Commit zusammengeführt, niemals gequetscht**, wobei jeder Building-Commit auf main erhalten bleibt.
6. Nur Code/Dokumentation Pull Requests werden von Stadt-Daten getrennt gehalten und können gequetscht zusammengeführt werden.
7. Pull-Request **Genehmigung**, **Zusammenführung** zu main und stabile **Veröffentlichung** sind separate Abschluss-Zustände.
8. Ein Pull Request, bei dem selbst ein Building oder ein Commit einen blockierenden Check nicht besteht, wird nicht teilweise zusammengeführt.
9. Main kann In-Progress-Arbeit enthalten. Regelmäßige Benutzer werden auf die neueste stabile Veröffentlichung hingewiesen.

Sprache des PR-Textes: Die Bearbeitungswerkzeuge erzeugen PR-Titel und -Text in
der **Arbeitssprache des Repos** (`lang` in `4dcitygml.json`); Commit-Titel,
`Building:`-Trailer und Branch-Präfixe bleiben Englisch/Literale (Historie und
Maschinenverträge sind sprachunabhängig). Da Stadt-Daten-PRs per Merge-Commit
zusammengeführt werden (Regel 5), wird der PR-Titel nie zur Titelzeile der
Historie auf main. (Die Übungs-Repos weichen ab: ihr Auto-Merge quetscht, sodass
der PR-Titel in Repo-Sprache in der — periodisch zurückgesetzten —
Übungshistorie erscheint.)

```text
Issue / offizielle Quelle
  → Entwurf Pull Request
  → automatisierte Überprüfungen
  → Bereit zur Überprüfung
  → der Stadt's semantische Überprüfung
  → Maintainer führt mit einem Merge-Commit zusammen
  → Seiten / Verlaufsindex Aktualisierung
  → stabile Veröffentlichung nach dem Release-Gate wird bestanden
```

## 2. Rollen und Abschluss-Verantwortung

| Rolle | Hauptarbeit | Zeichen der Fertigstellung |
|---|---|---|
| Antragsteller | Bereitet die Änderung, Nachweis, Commits, Pull-Request-Body vor | Markiert den Pull Request Ready for review |
| CI | Mechanische Überprüfungen: Commit-Umfang, XML, Referenzen, Format, Geometrie, Manifest | Alle erforderlichen Überprüfungen grün |
| Stadt-Reviewer | Semantische Beurteilung: Werte, Formen, Quellen, Lifecycle-Gründe | Genehmigung oder Anforderung von Änderungen |
| Maintainer | Endkontrolle erforderlicher Überprüfungen, Genehmigungen, Merge-Methode, Aktualität | Merge-Commit landen auf main |
| Release-Manager | Quellkonsistenz, vollständige Überprüfungen, Release-Notizen, Tag | Stabiler Tag und Überprüfungsergebnisse veröffentlicht |

Eine Person kann mehrere Rollen innehaben, aber die Schritte und Aufzeichnungen bleiben getrennt.
Jede Stadt führt seine eigenen CODEOWNERS und Genehmigungsbehörden; sie werden nicht über Städte geteilt.

## 3. Schritte gemeinsam für jeden Pull Request

### 3.1 Bevor Sie beginnen

```text
[ ] Entschieden Sie den Ausgangspunkt: ein Issue, eine offizielle Quelle oder geplante Wartung
[ ] Identifizierte die Zielstadt, uro:buildingID, Mesh und Änderungstyp
[ ] Der Nachweis kann veröffentlicht werden, ohne Lizenz-/Personalinformation-/Datenschutzprobleme
[ ] Kein früherer offener Pull Request ändert die gleiche Mesh-GML
[ ] Die Grenze zwischen diesem Pull Request und anderen Pull Requests ist entschieden
```

Pull Requests, die die gleiche Mesh-GML ändern, werden serialisiert: Erstellen Sie den nächsten Pull Request von main nach dem früheren Merge. Verschiedene Meshes können nur parallel fortgesetzt werden, wenn gemeinsame Schema-Migrationen durchgeführt werden und keine gemeinsamen Texturen oder XLinks berührt werden.

### 3.2 Branch und Commits

```text
[ ] Erstellter Working-Branch aus den neuesten main zum Start-Zeitpunkt
[ ] Die Pull-Request-Verlauf ist linear, ohne Merge-Commits innerhalb des Branches
[ ] Jeder normale Update-Commit ändert genau eine buildingID
[ ] Die gleiche buildingID wird nicht über Commits innerhalb des Pull Requests aufgeteilt
[ ] Building-Commits werden in aufsteigender uro:buildingID-Reihenfolge angeordnet
[ ] Building:, Building-Added:, Building-Deleted: Trailer entsprechen der aktuellen Änderung
[ ] Nur Differenzen außerhalb des Ziels werden mit der minimal-diff-Version entfernt
```

Verwenden Sie `Draft` zum Speichern von Arbeiten und zum Überprüfen von CI. Geben Sie die Überprüfer-Warteschlange nur ein
nach automatisierten Überprüfungen und Selbstüberprüfung und der Pull Request ist markiert
`Ready for review`.

### 3.3 Pull-Request-Body

```text
[ ] Genau einen Pull-Request-Typ ausgewählt
[ ] Geschrieben, was ändert, warum und auf welchem Nachweis
[ ] Aufgelistet jede Ziel-buildingID oder das Manifest
[ ] Angegeben erlaubten Pfade und was nicht geändert werden darf
[ ] Verlinkt verwandte Issues mit Fixes #<number> oder Refs #<number>
[ ] Hinzugefügt Nachweis-URLs, Dokumentnamen, Abrufdaten, Ausgaben, Hashes
[ ] Falls Form, LOD, Attribute, IDs und Lifecycle gemischt sind, erklärt, warum sie nicht getrennt werden können
```

Jährliche `source-update` Pull Requests benötigen zusätzlich:

```text
Source-From, Source-To, Scope-Mesh, Attribute-Family, Allowed-Paths,
History-Manifest, Manifest-SHA256, Building-Count,
First-Building-ID, Last-Building-ID
```

### 3.4 Automatisierte Überprüfungen und Antragsteller-Bestätigung

```text
[ ] Base-Aktualität zeigt kein ungelöstes "mit der neuesten Version zusammenführen"; head enthält neueste main
[ ] Alle Commits bestanden die Commit-Umfang-Überprüfung
[ ] XML/XSD, CityGML-Struktur und Konvention blockierende Überprüfungen erfolgreich
[ ] XLink, Appearance, imageURI und Textur-Referenzen auflösen
[ ] Die automatische Änderungszusammenfassung entspricht dem Pull-Request-Body
[ ] Buildings mit Geometrieänderungen wurden alt/neu in der 3D-Ansicht verglichen
[ ] Warnungen und Hinweise wurden nicht ignoriert; Gründe für Untätigkeit wurden beurteilt
[ ] Nach einer Churn-Benachrichtigung wurde die minimal-diff-Version angewendet und überprüft
[ ] Alle erforderlichen Überprüfungen sind grün auf der Head-SHA des finalen Push
```

Die aktuelle Churn-Behandlung stoppt bei Benachrichtigung und Generierung der minimal-diff-Version; die automatische Anwendung auf dem Pull-Request-Head ist nicht implementiert. Bis es ist, wendet der Antragsteller oder ein Maintainer es an.

### 3.5 Überprüfer-Untersuchung

```text
[ ] Der Pull Request ist nicht Draft und befindet sich in der Überprüfungswarteschlange
[ ] Die unter Überprüfung stehende Head-SHA entspricht der, auf der die automatisierten Überprüfungen liefen
[ ] Alle erforderlichen Überprüfungen erfolgreich und neueste main ist enthalten
[ ] Änderungszusammenfassung, Nachweis, Form-Vergleich und Manifest wurden gegen das gleiche Ziel überprüft
[ ] Die Bedeutung von Werten, Formen, Quellen und alten/neuen ID-Beziehungen ist sinnvoll
[ ] Zusätzliche Genehmigungsbedingungen (Lifecycle, Identität, Textur-Überschreibung) sind erfüllt
[ ] Falls Pushes nach der Genehmigung stattfanden, überprüfen Sie erneut
```

- Behebbare Mängel → `Anforderung von Änderungen`, zeigend zu den zu behebenden Orten.
- Fragen oder Fakten-Suche → `Kommentar`; verwechseln Sie es niemals mit Genehmigung.
- `Genehmigen` Sie nur, wenn der Nachweis hält und alle semantische Beurteilung und erforderliche Überprüfungen durchgeführt wurden.
- Doppelte Pull Requests, Out-of-Scope-Änderungen, nicht veröffentlichbarer Nachweis oder unlösbare Rechtsprobleme → Schließen mit dem Grund aufgezeichnet.

### 3.6 Zusammenführung

```text
[ ] Alle erforderlichen Überprüfungen erfolgreich auf der finalen Head-SHA
[ ] Anforderung von Änderungen werden aufgelöst
[ ] Notwendige CODEOWNERS / zusätzliche Genehmigungen sind vorhanden
[ ] Base-Aktualität zeigt neueste main
[ ] "Erstellen Sie einen Merge-Commit" ist für Stadt-Daten-Pull Requests ausgewählt
[ ] Pull-Request-Typ, Ziel-Mesh und Manifest wurden direkt vor dem Zusammenführen bestätigt
```

Keine automatische Zusammenführung. Genehmigung ist eine Bedingung für Zusammenführungs-Berechtigung; eine Überprüfer-Aktion allein schreibt niemals main um.

### 3.7 Nach der Zusammenführung

```text
[ ] Der Merge-Commit und die einzelnen Building-Commits bleiben auf main
[ ] Überprüfungen und Pages-Generierung auf main erfolgreich
[ ] Issues, die mit Fixes verlinkt sind, wurden korrekt geschlossen
[ ] Der Building: Trailer behebt zurück zu dem Pull Request und Merge-Commit
[ ] Jährliche Release-Plan-Zustände (geplant / in Arbeit / abgeschlossen) wurden aktualisiert
[ ] Benutzeroberflächen unterscheiden "main in Arbeit" von "neuester stabiler Veröffentlichung"
[ ] Bei Anomalien wurde ein Revert-Pull Request geöffnet — Verlauf wird niemals umgeschrieben
```

Keine Follow-up-Commits, die zusammengefügte Pull-Request-Nummern oder SHAs in das Manifest selbst schreiben. Der Pages-Index wird aus Git-Verlauf und GitHub regeneriert.

## 4. Pull-Request-Typ wählen

| PR-Typ | Einheit von einem Pull Request | Building-Commits | Erforderliche zusätzliche Aufzeichnungen |
|---|---|---|---|
| `correction` | Ein Nachweis / Änderungsregel | Ein buildingID pro Commit | Issue, Nachweis, Vor/Nach |
| `lifecycle` | Ein Neubau / Aufspaltung / Zusammenführung | Ein dedizierten Commit, mehrere IDs erlaubt | Alt-/Neu-ID-Beziehungen, Grund, Manifest, zusätzliche Genehmigung |
| `identity-correction` | Ein fehlverbindung / ID-Korrektur-Ereignis | Folgt dem dedizierten Gate | Vor-/Nach-IDs, Beweis des Fehlers, zusätzliche Genehmigung |
| `source-update` | 1 Quelle-Übergang × 1 Mesh × 1 Attribut-Familie / Regel | Ein buildingID pro Commit | Quellen-/Änderungsmanifest, erlaubte Pfade, Anzahlen, Stichprobe-Überprüfung |
| `schema-update` | Ein Schema-Bundle | Keine GML-Änderung | Hashes von XSD / Code-Listen, Profil |
| `carry-forward` | 1 Editionswechsel × 1 Mesh (vorherige offizielle, Repository, neue offizielle) | Ein `Building:`-Commit je erneut angewendetem Gebäude, nach der `source-baseline` der neuen Edition | Provenienz-Manifest: erneut angewendet / übernommen / Konflikte / nicht abbildbar / mit altem codeSpace übernommen |
| `schema-migration` | 1 Editionswechsel × 1 Mesh ohne offizielle Datei der neuen Edition (das Repository ist die Masterkopie): registry-gesteuerte Neuserialisierung des i-UR-Teilbaums | Eine erzeugte `source-baseline` der neuen Edition | Provenienz-Manifest; semantische Gleichheit je Registry-Schlüssel (erhalten / abgebildet / übernommen / nicht abbildbar) — Gate noch nicht implementiert |
| `layout` | Einmalige Unterteilung eines Eltern-Mesh | Ein Semantik-erhaltender Commit | Wiederaggregation-Überprüfung, ID / Referenz / Größe-Überprüfungen |
| `texture-gc` | Eine Sammlung unrefferenzierter Bilder | Keine Building-Änderung | Beweis der Nicht-Referenzierung für alle imageURIs, Löschungsliste |
| `revert` | Rückgängigmachung eines Building-Commits oder eines Pull Requests | Behält die ursprüngliche Einheit | Ziel, Grund, betroffene Veröffentlichungen |
| Code / docs | Eine Werkzeug- oder Dokumentationsänderung | Keine Building-Änderung | Tests, Doc-Links, Auswirkung |

`source-baseline`, `scope-extract` und `identity-baseline` sind nur für die anfängliche Konstruktion des veröffentlichten Verlaufs; sie werden nicht als tägliche Pull Requests nach der Veröffentlichung wiederholt.

### 4.1 Täglich `correction`

```text
[ ] Es gibt eine Daten-Frage oder veröffentlichbare Nachweis
[ ] Buildings, die in den Pull Request gebündelt sind, können unter den gleichen Nachweis und Regel überprüft werden
[ ] Jeder Commit hat genau einen Building: <uro:buildingID>
[ ] Textur-Ersetzung wurde durch Hinzufügen neuer Bilder + Aktualisieren von imageURI durchgeführt
[ ] Nach Geometrieänderungen wurden abgeleitete Attribute (Höhe, Fläche, …) auf Konsistenz überprüft
```

Das Überschreiben einer bestehenden Textur unter dem gleichen Namen ist grundsätzlich verboten. Nur für legitime Ausnahmen (gemeinsame Atlanten usw.), nach Überprüfung jedes betroffenen Buildings, wendet ein Maintainer das Label `texture-override` an.

### 4.2 `lifecycle`

```text
[ ] Alt-/Neu-Building-Beziehungen sind geklärt; keine ungelösten Kandidaten vermischt
[ ] Der Pull Request enthält genau ein Echtzeit-Ereignis
[ ] Change-Type: lifecycle wird aufgezeichnet
[ ] Building-Deleted: / Building-Added: entsprechen jeder aktuell geänderten ID
[ ] Beziehungen, Ereignis-/Bestätigungsdatum, Nachweis und Entscheidungsträger sind im Manifest
[ ] Das Lifecycle-Label und zusätzliche CODEOWNERS-Genehmigung sind vorhanden
```

Falls die Alt-/Neu-Beziehung unklar ist, springen Sie nicht zu "abgerissen" oder "neugebaut" — parken Sie es in einem Issue oder `lifecycle-review`.

### 4.3 `identity-correction`

Selbst wenn eine fehlverbindete Identität im veröffentlichten Verlauf gefunden wird, werden frühere Commits und Tags niemals umgeschrieben. Ein neuer Pull Request zeichnet die Vor-/Nach-IDs, den Beweis des Fehlers und den betroffenen Verlauf auf.

```text
[ ] Identifizierte die buildingIDs vor und nach der Korrektur
[ ] Es gibt Beweis, dass dies ein Fehlverbindungs-Fix ist, kein Lifecycle-Ereignis
[ ] Aufgezeichnet, welche Zeit des früheren Verlaufs betroffen ist
[ ] Die dedizierte Identity-Correction-CI und zusätzliche Genehmigung erfolgreich
```

Das aktuelle Commit-Umfang-Gate erlaubt nicht die Ersetzung einer bestehenden buildingID als normales Update. Markieren Sie solche Pull Requests nicht Ready for review, bis das dedizierte Gate implementiert und im öffentlichen Piloten verifiziert ist.

### 4.4 Jährlich `source-update`

Jährliche Updates erfolgen als separate Pull Requests in dieser Reihenfolge:

1. `schema-update` — die Artefakte der neuen Edition (Code-Listen unter `codelists/<edition>/`, Schemaprofil), keine GML-Änderung
2. bei Editionswechsel: entweder die neue offizielle Edition als frische `source-baseline`, dann `carry-forward` (Dreiwege-Vergleich je Gebäude und Attribut), oder — wenn das Repository die Masterkopie ist und keine offizielle Datei der neuen Edition existiert — `schema-migration` (registry-gesteuerte Neuserialisierung des i-UR-Teilbaums, verifiziert durch semantische Gleichheit je Registry-Schlüssel)
3. ein Single-Building-Pilot pro Attribut-Familie
4. Multi-Building-Pull Requests pro Attribut-Familie
5. dedizierte Pull Requests für Geometrie, LOD und Quellen `gml:id`
6. `lifecycle` für bestätigte Ereignisse
7. Vollständigkeits-Überprüfungen pro Mesh und über die Stadt
8. den jährlichen Release-Tag

```text
[ ] Vor-Update-Bewertung von Quelle, Schema, IDs, Semantik-Regeln, Lifecycle und Größe durchgeführt
[ ] Jeder Pull Request auf 1 Quellen-Übergang × 1 Mesh × 1 Attribut-Familie / Regel begrenzt
[ ] Das Manifest pinnt erlaubte Pfade, alt-/neu Werte und jede Ziel-buildingID
[ ] Ein repräsentatives Building pro Attribut-Familie bestanden First
[ ] Generiert aus main nach dem früheren Pull Request auf dem gleichen Mesh zusammengeführt
[ ] Auto-bestätigte Gruppen werden von mehrdeutigen / Lifecycle-Review-Gruppen getrennt
[ ] Die finale Pfad-Signatur entspricht der vorberechneten
```

Überschreiben Sie niemals eine ganze neue Jahrs-Quelle in einem Pull Request. Jeder Attribut-Pull Request wird aus der neuen Jahrs-Kopie im Arbeitsbereich basierend auf dem nicht-angewendeten buildingID-Manifest generiert.

`source-update` und `identity-baseline` / `identity-correction` sind **Massen-Einreichungen**: Sie werden durch
**Reproduktion** angenommen, nicht durch Lesen jedes Commits. Das Einreichungspaket (Plan-Issue, Provenienz-Manifest mit
Belegen je Gebäude und ID-Regime je Jahresgrenze, Commit-Trailer, dediziertes Konto, Stichprobenprüfung) und das Gate sind in
[Bulk submissions: provenance, verification, and merge policy (englisches Original ist maßgeblich)](https://github.com/4dcitygml/tools/blob/main/docs/bulk-submission-provenance.md) festgelegt.
Gemessen an den Tokio-Ausgaben 2020–2025 bricht die Kontinuität von `uro:buildingID` an der Grenze eines Produktwechsels
vollständig ab (2022→2023 wurden alle Gebäude neu nummeriert; über diese Grenze geteilte IDs gehörten zu *anderen* Gebäuden).
Eine identische ID ist daher nie allein ein ausreichender Beleg; jede Verknüpfung braucht geometrische Evidenz.

### 4.5 `schema-update` und Editionswechsel (`carry-forward`)

```text
[ ] schema-update ändert keine GML; nur Editionsartefakte (codelists/<edition>/, schemas/, provenance/schema-update/)
[ ] Digests der Artefakte und ihre offizielle Quelle (ZIP-Member) sind aufgezeichnet
[ ] Die Offline-XSD-Validierung der aktuellen Daten besteht unter dem neuen Profil
[ ] Ein Editionswechsel erfolgt als: neue offizielle Edition = source-baseline, dann carry-forward (nie eine Strukturkonvertierung der alten Datei)
[ ] Das carry-forward-Manifest listet je Gebäude: erneut angewendet / übernommen / Konflikte / nicht abbildbar / mit altem codeSpace übernommen
[ ] Konflikte und nicht abbildbare Attribute wurden von einem Reviewer entschieden; übernommene Codes sind für das Release-Gate gezählt
```

Für einen Editionswechsel gibt es zwei Wege. Solange offizielle Editionen unabhängig erzeugt werden, wird die neue offizielle Edition zur nächsten Baseline und die gesammelten Änderungen werden durch einen Dreiwege-Vergleich je Gebäude und semantischem Attribut erneut angewendet (`carry-forward`, siehe [Bulk submissions: provenance, verification, and merge policy (englisches Original ist maßgeblich)](https://github.com/4dcitygml/tools/blob/main/docs/bulk-submission-provenance.md)). Sobald das Repository die Masterkopie ist und die offizielle Edition daraus exportiert wird, existiert keine externe Datei der neuen Edition: `schema-migration` erzeugt dann die Serialisierung der neuen Edition aus dem Inhalt des Repositorys — der CityGML-Kern bleibt innerhalb von 2.0 unverändert (ein 3.0-Übergang konvertiert den Kern über 3DCityDB), der i-UR-Teilbaum wird je Gebäude aus der semantischen Registry, der Code-Listen-Crosswalk (Codes ohne 1:1-Abbildung behalten ihren alten codeSpace) und der XSD-Reihenfolge der neuen Edition neu serialisiert. Sein Gate ist semantische Gleichheit je Registry-Schlüssel (erhalten / abgebildet / übernommen / nicht abbildbar) plus Reproduktion; es ist entworfen, aber noch nicht implementiert. Beide Wege werden mit demselben registry-basierten Vergleich verifiziert. `schema-update` wird durch die Commit-Scope-Prüfung gesichert (nur Artefaktpfade, keine CityGML-Änderung); `carry-forward` wie `source-update` plus das `reproduction`-Gate.

### 4.6 `layout`

```text
[ ] Bestätigt vor dem Update, dass eine gespeicherte GML 50 MiB oder mehr erreichen würde
[ ] Unterteilte nur den aktuellen Mesh vor Update-main um genau eine Ebene
[ ] Aufgezeichnet Change-Type: layout, ohne Building-ID-Trailer
[ ] Building-Anzahl, ID-Set, Semantik-Hash, Appearance und XLink sind unverändert
[ ] Envelope, XSD und temporäre Wiederaggregation-Überprüfungen werden bestanden
[ ] Alle Dateien nach Unterteilung sind unter 50 MiB, ohne verfolgter Datei bei 100 MiB oder mehr
```

Ein Mal unterteilter Mesh wird niemals zurück zu einem gröberem Mesh zusammengeführt, selbst wenn er in späteren Jahren schrumpft. Das aktuelle Werkzeug unterstützt eine Unterteilungs-Schritt; tiefere Ebenen werden nur nach Erweiterung und Verifizierung freigeschaltet.

### 4.7 `texture-gc`

```text
[ ] Jeder Löschungs-Kandidat ist unreferenziert von allen imageURIs auf main
[ ] Null neue hängende Referenzen
[ ] Löschungsliste, Anzahl und Byte-Größe werden im Pull-Request-Body aufgezeichnet
[ ] Keine Building-GML, Attribute oder Geometrie-Änderung im gleichen Pull Request
```

### 4.8 `revert` und dringende Fixes

Veröffentlichte Fehler werden niemals durch Force-Push oder Tag-Ersetzung versteckt — sie werden rückgängig gemacht durch einen neuen Pull Request.

```text
[ ] Entschieden, ob ein Building-Commit oder der ganze Pull Request rückgängig gemacht wird
[ ] Aufgezeichnet das Ziel-Commit oder Merge-Commit-SHA
[ ] Geschrieben der Grund, wie er gefunden wurde und die betroffenen Buildings und Veröffentlichungen
[ ] Liefen die vollständige normale Überprüfung auf den rückgängig gemachten CityGML
[ ] Entschieden, ob eine Patch-Veröffentlichung erforderlich ist, falls eine veröffentlichte Veröffentlichung betroffen ist
```

Selbst unter Dringlichkeit werden erforderliche Überprüfungen und menschliche Genehmigung niemals übersprungen. Reagieren Sie durch Verengung des Umfangs und Erhöhung der Priorität.

## 5. Veröffentlichungen

### 5.1 Ordentliche tägliche Fixes

- Nach der Zusammenführung wird der Fix auf main und im Building-Verlauf widergespiegelt.
- Das Zusammenführen eines Pull Requests allein bewegt niemals eine bestehende stabile Veröffentlichung.
- Es ist in der nächsten geplanten Patch- oder jährlichen Veröffentlichung enthalten.
- Eine Patch-Veröffentlichung wird für ernsthafte Fehler, Rechts-/Personalinformation-Probleme oder Verwendungsgefahren durchgeführt.

Patch-Veröffentlichungs-Tag-Namensvergabe und Kadenz werden in einer separaten ADR vor der Veröffentlichung festgelegt.

### 5.2 Jährliche Veröffentlichungen

```text
[ ] Alle Attribut-Familie-Pull Requests für alle Ziel-Meshes sind abgeschlossen
[ ] Geometrie, LOD, Quellen gml:id und bestätigte Lifecycle-Gruppen sind abgeschlossen
[ ] Schema-Profil und Schema-Migration-Überprüfungen sind abgeschlossen
[ ] Vollständiges buildingID-Set, Duplikate, Referenzen, Appearance und XSD-Bestände
[ ] Die finale Pfad-Signatur entspricht semantisch der offiziellen neuen Jahrs-Edition
[ ] Ungelöste Gruppen bleiben unberührt, mit Halte-Liste und Auswirkung angegeben
[ ] Das Release-Plan ist Release-bereit
[ ] Release-Notizen behandeln Quelle, Hashes, Verarbeitung, ID-Vereinheitlichung, Halte-Zustände und Überprüfungsergebnisse
[ ] Tag, Seiten, Downloads und Überprüfungsergebnisse weisen auf den gleichen Commit
[ ] Mit altem codeSpace übernommene Codes (codelists/<edition>/) sind mit carried_codespace_report.py gezählt und aufgelöst oder vom offiziellen Kanal akzeptiert
```

Während jede Release-bereit-Bedingung fehlend ist, ist main niemals als "die stabile neue Jahrs-Edition" angezeigt.

## 6. Merge-Stopp-Bedingungen

Genehmigen oder Zusammenführen Sie nicht, wenn eine der folgenden Bedingungen erfüllt ist:

- Der Pull Request ist hinter der neuesten main
- Ein erforderlicher Check fehlgeschlagen, wurde nicht ausgeführt oder zielt auf eine alte Head-SHA
- Quelle, Nachweis, Lizenz oder Veröffentlichbarkeit kann nicht bestätigt werden
- Der Pull-Request-Typ entspricht nicht der aktuellen Änderung
- Selbst ein buildingID, Pfad oder alt-/neu Wert ist außerhalb des Manifests
- Ein früherer Pull Request auf dem gleichen Mesh ist ungefasst
- BuildingID-Identität, Lifecycle-Beziehungen oder Schema-Konversions-Semantik sind ungelöst
- Ein erforderliches Layout-Pull Request für einen Mesh, der 50 MiB erreicht, ist nicht durchgeführt
- Churn bleibt, Out-of-Scope-Buildings oder Linien änderbar machend
- Erforderliche CODEOWNERS / Lifecycle / Identität / Textur-Überschreibungs-Genehmigungen fehlen
- Ein Pull-Request-Typ ohne dedizierte CI wird als normales Update durchgeleitet

## 7. Aktuelle Implementierung und Restarbeit

### 7.1 Was das aktuelle Repository überprüfen kann

- Die 1-buildingID-Beschränkung und Trailer-Übereinstimmung für normale Commits
- Verbot doppelter buildingID-Commits innerhalb eines Pull Requests
- Commit-Umfangs-Ausnahmen für `lifecycle`, `layout`, `source-baseline`, `scope-extract`
- Ziel-Gemeinde-Set und beibehaltene Building-Invarianz für `scope-extract`
- XML/XSD, Struktur-, Referenzen-, Texturen-, Geometrie-Überprüfungen und Vergleichsansichten
- Base-Aktualitäts-Leitlinie
- Ein Überprüfer-Bildschirm, der Entwurf / Überprüfung / Warten-auf-Zusammenführung / Warten-auf-Überprüfung trennt

### 7.2 Zu implementieren vor dem Freischalten der entsprechenden Pull-Request-Typen

- Pro-Edition-Schema-Profile als Validierungsoption (heute deckt ein Master-Schema i-UR 2.0–3.2 ab)
- Real-Diff und zusätzliche Genehmigations-Gates für `identity-baseline` / `identity-correction`
- Vollständige Abgleichung von Allowed-Paths, alt-/neu Werten und Manifest-IDs für `source-update`
- Das Release-Gate für finale Pfad-Signatur und offizielle Quellen-Konsistenz
- Unterteilungs-/Wiederaggregations-Werkzeuge für tiefere Mesh-Ebenen, falls erforderlich
- Ein Pages-Index, der buildingID → Commit → Pull Request → Merge-Commit → Veröffentlichung aus Git-Verlauf generiert
- Automatische Anwendung der minimal-diff-Version für gleich-Repository- und Fork-Pull Requests
- Die ADR für Patch-Veröffentlichungs-Tag-Namensvergabe, Kadenz und Dringlichkeits-Kriterien

Unimplementierte dedizierte Gates werden niemals nur durch Dokumentation ersetzt.
Bestätigen Sie Ablehnung und Revert-Verhalten auf einem echten Repository, bevor Sie sie in öffentliche Betrieb setzen.

- Gebäudebezogene Historie aus git unabhängig von der Commit-Granularität (`scripts/building_history.py` in tools: folgt dem Gebäude über ID-Wechsel, Datei-Baselines und manifestgestützte Commits und meldet Registry-Änderungen je Commit) ist implementiert; der Workflow `history-index.yml` veröffentlicht sie als statische Pages-Site (`history/index.html` + `history/buildings/<id>.json`)
- Pilot-Verifikation der implementierten `identity-baseline` / `identity-correction`-Gates (Commit-Scope-Regeln + `identity`-Reproduktion) an einem realen Repository
- Pilot-Verifikation des `source-update`-Wertersetzungs-Gates (eine Attributfamilie je PR; manifestgestützte Commits, Reproduktion) an einem realen Repository
- Umstrukturierungen durch neue Ausgaben (hinzugefügte oder entfernte Attributcontainer — der Großteil der gemessenen Unterschiede 2020→2025) werden durch `carry-forward` (implementiert) behandelt, solange offizielle Editionen existieren; die registry-gesteuerte `schema-migration` für die Masterkopie-Phase (Neuserialisierer, Gate semantischer Gleichheit, i-UR-4.0-Registry) ist entworfen, aber nicht implementiert

## 8. Periodische Überprüfungen nach der Veröffentlichung

### Wöchentlich

```text
[ ] Überprüfte Pull Requests in Warten-auf-Überprüfung / Anforderung von Änderungen / Warten-auf-neueste-main getrennt
[ ] Bearbeitete CI-Bruch getrennt von Datenfällen
[ ] Schrieb die nächste Aktion oder einen Schließungsgrund auf lange stillgelegte Pull Requests
[ ] Keine konflikt-reichen Pull Requests auf dem gleichen Mesh
```

### Monatlich / vor geplanten Veröffentlichungen

```text
[ ] Überprüfte Kandidaten für unrefferenzierte Texturen
[ ] Aufgezeichnet neue offizielle Quellen / jährliche Ausgaben und das Überprüfungsdatum
[ ] Inspiziert Tag-Pins erforderlicher Workflows und gemeinsamer Werkzeuge
[ ] Überprüfte CODEOWNERS, Genehmigungsbehörde und Leerstellen durch Abgänge
[ ] Bestätigte Quellen, Rechte und offene Fragen für den Release-Ziel-Commit
```
