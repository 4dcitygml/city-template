<!-- Copyright (c) 2026 4dcitygml -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

# Quellen-Regeln (Aufzeichnung von Quellen und Nachweisen)

> Deutsche Übersetzung des englischen Originals: [../provenance-rules.md](../provenance-rules.md).
> Bei Abweichungen gilt das englische Original.

Regeln für wo — und in welcher Granularität — die Quellen und Nachweise von Attributwerten, Geometrie und Texturen aufgezeichnet werden.

日本語版: [docs/ja/provenance-rules.md](../ja/provenance-rules.md)

> **Umfang-Hinweis.** Diese Regeln wurden für CityGML-Datensätze entwickelt, die die i-UR ADE (`uro:` — die Erweiterung von Japans PLATEAU-Programm) verwenden, das die Schicht-1-Mechanismen unten sind. Stadt-Repositorys basierend auf anderen Datensätzen (siehe `building_id` in `4dcitygml.json`) wenden das gleiche Dreilagen-Prinzip an, und ersetzen ihren Datensatz's eigenen Qualitäts-Metadaten-Mechanismus für Schicht 1, falls einer existiert.

## Position — i-UR (Urban ADE) plus ein kleines "α"

Diese Regeln fügen **kein neues Schema hinzu**. Pro-Element-Provenance wird mit Standard-Mechanismen allein erreicht (Regeln + Werkzeuge), auf zwei Standard-Grundlagen:

- **i-UR (uro = Urban Object ADE)** — die CityGML-Erweiterung von PLATEAU. Bietet `uro:DataQualityAttribute` (Erfassungsmethode, Genauigkeit, vorläufig/bestätigt) und `uro:thematicSrcDesc` (Quellen-Code-Liste für Attributive) **pro Building**. Das ist Schicht 1.
- **CityGML-Kern Generics** (`gen:genericAttributeSet`) — der generische Mechanismus für "wenn kein Standard-Attribut existiert". Es trägt **Pro-Element** Provenance, feiner als i-UR's Pro-Building-Granularität, während schemavalid bleibt. Das ist das "+α" von Schicht 2.

Die Gestaltung ist also: **die ADE-Qualitätsattribute (pro Building) sind das Rückgrat, und Generics fügen Pro-Element-Hinweise (+α) hinzu** — kein benutzerdefinierten ADE, kein Schema-Erweiterung (Interoperabilität wird niemals gebrochen; wir stehen auf den Schultern von Giganten). Schichten 1 und 2 **teilen die gleiche Code-Liste**, die sie zu einem kohärenten System "Building-Standard + seine Ausnahmen" macht (siehe die Auflösungsregel unten). Der Attribut-Editor implementiert diesen Arbeitsablauf (§5).

## 0. Prinzip — aufzeichnen in drei Schichten

| Schicht | Was wird aufgezeichnet | Wo | Granularität | Rolle |
|---|---|---|---|---|
| **1. Offizielle Qualitätsattribute** | Erfassungsmethode, Genauigkeit, vorläufig/bestätigt | `uro:DataQualityAttribute` | Building × (Achse × LOD) | **Primär** — der Standard steht an erster Stelle |
| **2. Gen "source" Set** | **Pro-Element** Attribut↔Quellen-Zuordnung, Nachweis-Links | `gen:genericAttributeSet name="出典"` | **pro Element (Attribut)** | **Ausnahme** — nur wenn erforderlich |
| **3. Git-Verlauf** | Wer, wann, warum (die ganze Geschichte) | Commit / Pull Request / `Building:` Trailer | pro Blatt-Wert (garantiert durch die minimal-diff-Rohrleitung) | **Immer, automatisch** |

Aufgabenteilung: Was überlebt, wenn die Daten zirkuliert, sind Schichten 1–2. Die vollständige Geschichte im Repository-Kontext (Blame, Pull-Request-Diskussion, Wiederherstellungs-Schritte) ist Schicht 3.

## 1. Schicht 1 — offizielle Qualitätsattribute (primär)

Die feinste Granularität, die das offizielle Schema ausdrücken kann (i-UR 3.1 / 3.2):

| Achse | Element | Granularität |
|---|---|---|
| Geometrie-Quelle | `geometrySrcDescLod0`–`Lod4` | Building × LOD |
| Appearance-Quelle | `appearanceSrcDescLod0`–`Lod4` | Building × LOD |
| Höhen-Erfassung | `lod1HeightType` | pro Building (gemessen 1-8,10 / vorläufig 0,9) |
| Genauigkeit | `srcScaleLod*` | Building × LOD |
| **Attributive (Attribut) Quellen** | `thematicSrcDesc` | **aufgelistet pro Building als Set** (kann nicht zu Attributnamen zugeordnet werden) |

Regeln:

- **R1-1 (gleichzeitige Aktualisierung)**: Ein Pull Request, der einen Wert ändert, aktualisiert den entsprechenden Qualitäts-Code **im gleichen Pull Request**. Beispiel: Ersetzen measuredHeight mit einem erhobenen Wert aktualisiert `lod1HeightType` von einem vorläufigen Code (0/9) zu einem gemessenen.
- **R1-2 (Addieren von Ursprungs-Codes)**: Wenn Attribute von einer neuen Quelle hinzugefügt oder aktualisiert werden, fügen Sie den Ursprungs-Code zur Building's `thematicSrcDesc` hinzu (pro Building; Codes kommen von der gebündelten Code-Liste).
- **R1-3 (Keine Wert-Kodierung)**: Kodieren Sie Quellen- oder Genauigkeitsinformation niemals in den Wert selbst (keine Ad-hoc-Kodierungen wie `10000100m`; die Lektion des -9999 Sentinels).

## 2. Schicht 2 — das Gen "source" Set (Ausnahme, pro Element)

### Wann man es verwenden sollte (nur wenn eines dieser gilt)

- Mehrere Quellen werden gemischt und das Pro-Building-Set kann nicht sagen "welches Attribut kam von welcher Quelle"
- Ein Wert, dessen einzelner Ursprung selbst wertvoll ist — z. B. eine Vor-Ort-Messung oder ein von einem Bürger bereitgestelltes Dokument
- Ein abgeleitetes Attribut, dessen Attribut↔Ableitungs-Zuordnung erhalten werden muss

### Wann man es nicht verwenden sollte

- Wenn Schicht 1 (der Standard-Mechanismus) ausreicht. Da die XSD-Anmerkung für Generics besagt, verwenden Sie es "nur wo kein Standard-Attribut existiert". Annotieren Sie nicht mechanisch jedes Attribut.

### Format (Regel)

```xml
<gen:genericAttributeSet name="出典">
    <gen:stringAttribute name="bldg:measuredHeight">
        <gen:value>801</gen:value>
    </gen:stringAttribute>
    <gen:stringAttribute name="bldg:storeysAboveGround">
        <gen:value>802</gen:value>
    </gen:stringAttribute>
    <gen:uriAttribute name="根拠資料:bldg:measuredHeight">
        <gen:value>https://github.com/4dcitygml/sample-tokyo-station/pull/2</gen:value>
    </gen:uriAttribute>
</gen:genericAttributeSet>
```

Bedeutung des Beispiels: measuredHeight kommt von Code `801` (Felduntersuchung), storeysAboveGround von `802` (Fotointerpretation).

- **R2-1 (Set-Name)**: Der Set-Name ist festgelegt (`name="出典"` — "Quelle"), **höchstens eine pro Building**.
- **R2-2 (Schlüssel)**: Das Kind `@name` ist der **QName des Ziel-Attributs** (z. B. `bldg:measuredHeight`, `uro:buildingStructureType`). Falls der gleiche QName mehr als einmal in einem Building auftreten kann, wird stattdessen die Blatt-Pfad-Notation der Diff-Rohrleitung verwendet.
  - Ob ein QName eindeutig ist, wird **mechanisch pro Building entschieden**: CityGML-Kern-Attribute sind `maxOccurs=1` nach Schema und immer eindeutig; ADE-Attribute können strukturell wiederholt werden (Schlüssel-Wert-Paare, Katastrophen-Risiko-Aufzeichnungen, …). Der Attribut-Editor implementiert diese dynamische Überprüfung und bietet nur QName-Hinweise für eindeutige Attribute.
- **R2-3 (Werte sind Codes)**: Werte müssen von **der Datensatz's `codelists/…thematicSrcDesc….xml` Code-Liste allein stammen** (Kein freier Text). Das gleiche Vokabular wie Schicht 1's `thematicSrcDesc`, angewendet pro Element (z. B. `801` = Felduntersuchung, `802` = Fotointerpretation, `803` = GIS-Berechnung). Dies hält Maschinen-Validierung (Code-List-Lint) und Etikett-Auflösung funktionierend wie üblich.
  - Details wie Methode oder Datum gehen nicht in den Wert — sie gehen in den Nachweis-Link (R2-4) und den Pull-Request-Body (Schicht 3). Vorläufig/bestätigt Status geht zu Schicht-1-Qualitäts-Codes (widersprechen Sie ihnen niemals).
  - Eine Quelle nicht in der Code-Liste → verwenden Sie einen Catch-All-Code (z. B. `700` "anderes Dokument") **plus einen zwingenden Nachweis-Link**. Falls eine Quelle weiterhin auftritt, **schlagen Sie eine Erweiterung der Code-Liste selbst über einen Pull Request vor** (Code-Listen sind unter Git-Management und daher überprüfbar).
- **R2-4 (Nachweis-Links)**: `gen:uriAttribute` mit `@name` = `根拠資料` (ganzes Building) oder `根拠資料:<QName>` (pro Element). URLs zu Pull Requests, Fotos, Registern usw.
- **R2-5 (Platzierung)**: unmittelbar **nach `core:creationDate`**, passend wie echte Datensätze Generics platzieren.
- **R2-6 (keine Werte)**: Das Set zeichnet nur Quellen-Information auf. Der Wert selbst lebt im Standard-Attribut (keine Duplizierung).
- **R2-7 (gleichzeitige Aktualisierung)**: Wenn sich der Wert eines Ziel-Attributs ändert, wird sein Quellen-Code **im gleichen Pull Request** aktualisiert.

### Quellen-Auflösungs-Regel (Hinweis > Building-Standard)

Da Schichten 1 und 2 eine Code-Liste teilen, wird die Quelle jedes Attributs eindeutig aufgelöst:

1. **Hinweis existiert** — Falls das "source" Set einen Hinweis für das Attribut (QName) hat, ist dieser Code die Quelle (eindeutig).
2. **Kein Hinweis** — beziehen Sie sich auf die Building's `thematicSrcDesc` (Standard).
   - Ein Code → die Quelle ist eindeutig.
   - Mehrere Codes → die Quelle ist "eine von ihnen" (ein Kandidaten-Set). Nur auf die zu fixierenden Attribute Hinweise hinzufügen ermöglicht Eindeutigkeit **inkrementell zu verbessern, ohne das Building umzuschreiben**.
3. Weder noch → wird als "unbekannt" behandelt (Code `898` oder Äquivalent).

- **R2-8 (Hinweis ⊆ Standard-Invarianz)**: Ein Code, der in einem Hinweis verwendet wird, **muss auch in der Building's `thematicSrcDesc`** vorhanden sein. Eine neue Quelle über einen Hinweis einzuführen erfordert das Anfügen des gleichen Codes zum Standard (R1-2) im gleichen Pull Request. Der Standard ist dann immer "das komplette Set dieser Building's Attribut-Quellen" und Hinweise sind "die Zuordnung darin" — niemals widersprechend, und maschinell überprüfbar.

### Validierung und Rohrleitung (verifiziert)

- Das oben beschriebene Format ist **gültig gegen CityGML 2.0 + i-UR 3.2 XSD** (verifiziert mit Offline-Validierung).
- Die Diff-Rohrleitung erkennt Hinweise als **Blatt-Ebenen-Pfade** (`/genericAttributeSet[@name=出典]/stringAttribute[@name=…]/value`), daher Hinzufügen oder Aktualisierung von Provenance fährt die bestehende Überprüfungs-Rohrleitung
  (pro-Building Pull Requests, minimal diff) **ohne zusätzliche Implementierung**.
- Vorläufer: Offizielle PLATEAU-Verteilungen selbst versenden große Zahlen von Gemeinde-spezifischen Attributen als `gen:stringAttribute`, daher ist die Verwendung von Generics eine Erweiterung der offiziellen Praxis.

## 3. Schicht 3 — Git-Verlauf (immer, automatisch)

- Commits tragen einen `Building: <uro:buildingID>` Trailer (siehe `scripts/suggest_commit.py`). Das minimal-diff-Gate garantiert Blatt-Ebenen-Differenzen, daher **`git blame` funktioniert auf Attribut-Granularität**.
- Wenn ein Attribut durch Ableitungs- oder Konversions-Prozess hergestellt wird, zeichnen Sie die **Methode, Parameter und Wiederherstellungs-Schritte im Pull-Request-Body** auf (ein Dritter muss das Ergebnis reproduzieren können).
- Die Narrative ("warum dieser Wert") lebt in der Pull-Request-Beschreibung und Review-Diskussion — niemals innerhalb der Daten.

## 4. Regeln für quergerichtete Attribut-Aditions-Pull Requests

Ein Pull Request, der ein neues Attribut in Bulk hinzufügt:

1. Wenn ein Standard-Slot existiert → fügen Sie es als **Standard-Attribut** hinzu und fügen Sie den Ursprungs-Code zu `thematicSrcDesc` an (R1-2)
2. Falls die Attribut↔Quellen-Zuordnung wichtig ist (gemischte Ursprünge, abgeleitete Werte) → fügen Sie das "source" Set ebenfalls hinzu (Schicht 2)
3. Methode und Parameter der Ableitungs → zeichnen Sie im Pull-Request-Body auf (Schicht 3)

## 5. Wie der Attribut-Editor dies implementiert

Der Attribut-Editor implementiert diese Regeln als Benutzeroberfläche, daher zeichnen Beitragende konforme Provenance auf, nur durch Bildschirm-Operationen, ohne dieses Dokument zu lesen:

- **Der Building-Standard wird einmal angezeigt**: Direkt unter der Building-ID zeigt der Editor "Quellen (Standard für dieses Building)" = die Building's `thematicSrcDesc` (Code + Etikett) an, anstatt sie auf jeder Reihe zu wiederholen.
- **Nach einer Wertänderung ist die nächste Aktion Quellen-Auswahl**: Die Bestätigung eines Wertes erweitert ein zwingender Quellen-Selektor in der gleichen Reihe. "Senden Sie Änderungen" bleibt deaktiviert, bis jedes geänderte Attribut eine Quelle hat, und die Submit-API validiert die gleiche Bedingung erneut. "Unbekannt" und "nicht erstellt" können nicht als Beweis für eine neue Änderung gewählt werden.
- **Hinweise nur auf den Reihen, die sie brauchen**: Unveränderte Attribute zeigen einen Hinweis nur, wo ihre Quelle vom Standard abweicht.
- **Dropdowns zeigen Code + Etikett**, Werte sind auf Code-Auswahl (R2-3's gemeinsame Code-Liste) begrenzt; kein freier Text.
- **R2-8 ist automatisiert**: Falls ein gewählter Hinweis-Code im Standard fehlt, fügt der Editor ihn zum Standard im gleichen Pull Request hinzu und kündigt dies in der Benutzeroberfläche an.
- **Mehrdeutige Attribute erfordern trotzdem Auswahl**: Attribute, deren QName innerhalb eines Buildings wiederholt wird, können keinen Element-Hinweis erhalten, daher wird der ausgewählte Code zum Building-Standard synchronisiert und die Zuordnung wird im Auto-generierten Pull-Request-Body aufgezeichnet (Schicht 3).
- **Pull-Request-Text wird auto-generiert** von den ausgewählten Quellen und den Vor-/Nach-Werten; der Beitragende fügt nur optionale Hinweise und Nachweis-URLs hinzu. Der Haupttext vermeidet XML-Tag-Namen.
- **Byte-Bewahrung**: Hinweise werden direkt nach `core:creationDate` eingefügt (R2-5) unter Beibehaltung der ursprünglichen Einrückung, Zeilenumbrüche und BOM, und die Änderung fährt die Pro-Building-Pull-Request-Rohrleitung unverändert.

## Verwandt

- Beitrags-Lizenzierung und Aufzeichnung: [data-contribution-policy.md](data-contribution-policy.md)
- Alltags-Pull-Request-Ablauf: [pr-operations.md](pr-operations.md)
