<!-- Copyright (c) 2026 4dcitygml -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

# Pull-Request-Operationen nach der Veröffentlichung

- Status: angenommenes Verfahren für Post-Publikationsbetrieb (PR-Typen ohne dedizierte CI bleiben gated, bis es existiert). Dritte Auflage: nur die Vereinbarung; Operator-spezifische Verfahren sind in eigene Dokumente ausgelagert.
- Gilt für: veröffentlichte Stadt-Daten-Repositorys

English (canonical): [docs/pr-operations.md](../pr-operations.md) · 日本語版: [docs/ja/pr-operations.md](../ja/pr-operations.md)

Dieses Dokument ist die **Vereinbarung**, die jede Pull Request nach der Veröffentlichung befolgt: die Grundsätze, die Sitze, die PR-Typen und die Bedingungen, unter denen nichts zusammengeführt wird. Wie jeder Sitz seine Arbeit ausführt, steht in eigenen Dokumenten:

| Sie sind | Lesen Sie |
|---|---|
| Ein Einwohner oder Mitarbeitender, der einen Vorschlag mit Bearbeitungswerkzeugen einreicht | [Erste Schritte](getting-started.md) — die Werkzeuge erfüllen diese Vereinbarung für Sie |
| Ein Mitglied des `maintainers`-Teams der Stadt (der Freigebende) | [Genehmiger-Anleitung](../approver-guide.md) — eine Seite |
| Ein Mitglied des `operators`-Teams (ein Auftragnehmer, oder 4dcitygml als Betreiber) | [Operator-Handbuch](../operator-handbook.md) |
| Das Maschinenkonto, das toolgesteuerte Änderungen einreicht | [Bulk submissions: provenance, verification, and merge policy](https://github.com/4dcitygml/tools/blob/main/docs/bulk-submission-provenance.md) |

## 1. Grundsätze

1. **1 Commit = 1 `uro:buildingID`** ist die minimale Einheit eines normalen Updates.
2. Eine normale Korrektur-PR deckt **ein Gebäude**. Reproduzierbare Masseneinreichungen haben ihre eigene manifestgestützte Route (Grundsatz 7). Ein Umbau, Aufspaltung oder Zusammenlegung nutzt die dedizierte **ein Lifecycle-Ereignis**-Route (Grundsatz 4). Bündeln Sie nicht zusammengehörige manuelle Korrektionen in diese Routen.
3. Teilen Sie dieselbe buildingID nie auf mehrere Commits eines PR auf. Sie kann in einem anderen PR oder einer anderen jährlichen Attributfamilie erneut angezeigt werden.
4. Eine Gebäudezusammenlegung, -aufspaltung oder -neubau ist ein `lifecycle`-Ereignis, das mehrere IDs behandelt.
5. Stadt-Daten-PRs werden mit einem **Merge-Commit zusammengeführt, niemals gequetscht**, wobei jeder Gebäude-Commit auf main erhalten bleibt. Das Regelwerk erlaubt daher die `merge`-Methode (plus `squash` für Dokumentation); es ist nie nur squash.
6. Code-, Dokumentations- und Tooling-Update-PRs werden getrennt von Stadt-Daten gehalten und können squash-zusammengeführt werden.
7. Änderungen, die ein Skript aus einer Quelle oder einem externen Datensatz generiert hat, sind **Masseneinreichungen**, unabhängig von der Anzahl: ein manifestgestütztes Verfahren, das durch Reproduktion akzeptiert wird. Per Hand überprüfte und eingegebene Änderungen sind normale PRs, vollständig gelesen.
8. **Der endgültige Genehmiger ist immer die Stadt** (das `maintainers`-Team). Betreiber überprüfen generierte Berichte und führen zusammen; sie haben keine Genehmigungsbefugnis. Im Vokabular des Kubernetes-OWNERS-Modells: Betreiber sind *Reviewer*, die Stadtunterstützer sind *Genehmiger*.
9. Eine PR, bei der selbst ein Gebäude oder Commit eine blockierende Prüfung nicht besteht, wird nicht teilweise zusammengeführt. Blockierende Fehler erscheinen in CI vor jeder menschlichen Überprüfung, und der Betreiber überprüft den generierten Bericht und seine Aufmerksamkeitselemente, so dass ein Gebäude, das zum Genehmigungszeitpunkt „fehlschlägt", eine falsch ausgerichtete PR ist, nicht ein Fall für eine Aufteilung.
10. main kann Arbeit in Bearbeitung enthalten. Regelmäßige Benutzer werden auf die neueste stabile Veröffentlichung hingewiesen. Die offizielle Ausgabe ist *eine Ausgabe zusammengeführten Inhalts*; ob sie als offiziell übernommen wird, ist die Entscheidung der Stadt.

Sprache des PR-Textes: die Bearbeitungswerkzeuge generieren PR-Titel und -Text in der **Arbeitssprache des Repositorys** (`lang` in `4dcitygml.json`); Commit-Subjekte, `Building:`-Trailer und Branch-Präfixe bleiben Englisch/wörtlich (die Historie und Maschinenverträge sind sprachunabhängig). Da Stadt-Daten-PRs mit einem Merge-Commit zusammengeführt werden (Regel 5), wird der PR-Titel niemals zu einer Historienzeilentitel auf main. (Die Übungs-Repositorys weichen ab: ihr Auto-Merge quetscht, daher erscheint der Repo-Sprach-PR-Titel in der periodisch zurückgesetzten Übungshistorie.)

```text
Issue / offizielle Quelle / Vorschlag eines Einwohners
  → PR mit Änderungen und Beweis (Entwurf ist optional während laufende Arbeit)
  → automatisierte Prüfungen (14 Gates)
  → CI generiert den gemeinsamen Bericht und alle Korrekturanfragen
  → Prüfer verwenden GitHub-Genehmigung; aktuelle erforderliche Genehmigungsanzahl ist konfigurierbar
  → Betreiber führt mit einem Merge-Commit zusammen
  → Seiten / Verlaufsindex-Aktualisierung
  → stabile Veröffentlichung nach dem Release-Gate besteht → die Stadt übernimmt es als offiziell
```

## 2. Sitze

Review-Beteiligung ist durch die Stadt konfigurierbar. Ein Reviewer kann ein Stadtangestellter, ein Auftragnehmer oder jemand mit mehreren Verantwortungen sein. Jeder liest den gleichen CI-Bericht und verwendet GitHub **Genehmigen**. Es gibt keine erforderliche Operator-Kommentar-Bestätigung oder feste Reihenfolge der Reviewer.

| Rolle | Verantwortung |
|---|---|
| Antragsteller | Reicht die Änderung und Beweis ein; kann seinen eigenen PR nicht genehmigen |
| Reviewer (Genehmiger) | Liest den gemeinsamen Bericht und Vergleiche, dann Genehmigt oder fordert Änderungen an |
| Repository-Administrator | Verwaltet Berechtigungen, erforderliche Anzahlen und andere Repository-Regeln |
| Betriebspersonal | Wartet Werkzeuge, bearbeitet Fragen, führt genehmigte Vorschläge zusammen und bereitet Veröffentlichungen vor; kann auch ein Reviewer sein |
| Werkzeuganbieter | Veröffentlicht gemeinsame Werkzeuge und schlägt Tooling-Updates vor |

Die Stadt kann die erforderliche Anzahl jederzeit ändern, wenn sich die Anordnung ändert. Ein autorisierter Administrator zeichnet das Datum, die Vor-/Nach-Anzahl und den Grund auf. Ein Konto trägt höchstens eine Genehmigung bei. Planen Sie für die Personen, die tatsächlich jeden PR genehmigen können, ausgenommen seinen Autor; die Gesamtzahl der Konten mit Schreibzugriff ist nicht unbedingt die vorgesehene Review-Gruppe. Mitgliedschaft und optional Code-Owner-Anforderungen regeln die Berechtigung separat von der numerischen Anzahl.

Der Hub liest aktive GitHub-Regeln und bietet einen persönlichen verbleibenden-Anzahl-Filter. Siehe [Review-Einstellungen](../review-settings.md). Einstellungen werden pro Konto und Repository im Browser gespeichert; sie erzwingen keine Stellenbezeichnung oder Überprüfungsreihenfolge.

## 3. PR-Typen

| PR-Typ | Einheit eines PR | Gebäude-Commits | Erforderliche zusätzliche Aufzeichnungen | Sitz · wo angegeben |
|---|---|---|---|---|
| `correction` | Ein Gebäude | Ein Commit, eine buildingID | Issue, Beweis, vorher/nachher | Antragsteller, Betreiber · handbook §6.1 |
| `lifecycle` | Ein Umbau / Aufspaltung / Zusammenlegung | Ein dedizierter Commit, mehrere IDs erlaubt | Alt-/Neu-ID-Beziehungen, Grund, Lifecycle-Manifest, Stadtentscheidung | Betreiber · handbook §6.2 |
| `layout` | Eine einstufige Unterteilung einer übergeordneten Masche | Ein semantikbewahrter Commit | Wiederaggregationsprüfung, ID-/Referenz-/Größenprüfungen | Betreiber · handbook §6.3 |
| `texture-gc` | Eine Sammlung nicht referenzierter Bilder | Keine Gebäudeänderung | Nachweis der Nichtverweisrichtung für alle imageURIs, Löschliste | Betreiber · handbook §6.4 |
| `revert` | Rückgängigmachung eines Gebäude-Commit oder eines PR | Behält die ursprüngliche Einheit | Ziel, Grund, betroffene Veröffentlichungen | Betreiber · handbook §6.5 |
| `tooling` | Ein Update von `CITYGML_TOOLS_REF` auf eine neue `tools-v`-Version (CI prüft es gegen die Werkzeug-Tags) | Keine Gebäudeänderung | Veröffentlichungsnotizen, „keine Datenänderung", `min_hub` wenn Clients betroffen sind | 4dcitygml schlägt vor, Betreiber verifiziert · handbook §6.6 |
| Dokumentation / Konfiguration | Eine Dokumentations- oder Konfigurationsänderung (`docs/`, README, `4dcitygml.json`, Thema, Logo). Code wird in einem Stadt-Repository nicht akzeptiert (Exchange Contract A11) | Keine Gebäudeänderung | Doc-Links, Auswirkung | Betreiber |
| `identity-correction` | Ein Fehlverbindungs- / ID-Korrektur-Ereignis | Pro dediziertes Gate | Vorher-/Nachher-IDs, Beweis, zusätzliche Genehmigung | Massenantragsteller · Bulk-Submission-Dokument |
| `source-update` | 1 Quellübergang × 1 Masche × 1 Attributfamilie | Eine buildingID pro Commit | Herkunftsmanifest, erlaubte Pfade, Anzahl, Stichprobe | Massenantragsteller · Bulk-Submission-Dokument |
| `carry-forward` | 1 Ausgabenwechsel × 1 Masche | Ein `Building:`-Commit pro erneut angewendetem Gebäude nach der neuen Ausgabe `source-baseline` | Herkunftsmanifest (erneut angewendet / übernommen / Konflikte / nicht zugeordnet / mit altem codeSpace durchgeführt) | Massenantragsteller · Bulk-Submission-Dokument |
| `semantic-correction` | 1 unterstütztes Rezept × 1 Masche | Ein `Building:`-Commit pro Ziel | Fixierte Eingabe und Begründung, genaue Transformation, Reproduktion; freigegebenes Werkzeug und Pilotprüfung erforderlich | [Rezept-Umfang](https://github.com/4dcitygml/tools/blob/main/docs/lod0-semantic-correction.md) |
| `schema-update` | Ein Schema-Bundle | Keine GML-Änderung | Digests von XSD / Code-Listen, Profil | Betreiber · Bulk-Submission-Dokument |
| `schema-migration` | 1 Ausgabenwechsel × 1 Masche wenn das Repository der Hauptserver ist | Ein generierte `source-baseline` | Herkunftsmanifest; semantische Gleichheit pro Registerschlüssel — Gate noch nicht implementiert | Massenantragsteller · Bulk-Submission-Dokument |

`source-baseline`, `scope-extract` und `identity-baseline` sind nur für die anfängliche Konstruktion der veröffentlichten Historie; sie werden nicht als tägliche PRs nach Veröffentlichung wiederholt. Das Hinzufügen weiterer Themen später (Transportation, Überflutung, Gelände …) als Pro-Thema `source-baseline` hat noch kein Gate.

## 4. Nichts wird zusammengeführt, wenn

- Der PR hinter der neuesten main zurückliegt
- Eine erforderliche Prüfung fehlgeschlagen, nicht ausgeführt oder auf eine alte Head-SHA abzielt
- Quelle, Beweis, Lizenz oder Veröffentlichbarkeit können nicht bestätigt werden
- Der PR-Typ stimmt nicht mit der aktuellen Änderung überein
- Selbst eine buildingID, ein Pfad oder ein Alt-/Neu-Wert liegt außerhalb des Manifests
- Ein früherer PR auf derselben Masche ist nicht zusammengeführt
- BuildingID-Identität, Lifecycle-Beziehungen oder Schema-Konversions-Semantik sind ungelöst
- Ein erforderlicher Layout-PR für eine Masche, die 50 MiB erreicht, ist nicht durchgeführt
- Churn bleibt bestehen und macht Out-of-Scope-Gebäude oder Linien geändert aus
- Keine erfolgreiche `analyze`- und aktuelle `ci-report`-Prüfungen von GitHub Actions
- GitHubs derzeit erforderliche Anzahl berechtigter Genehmigungen ist nicht erfüllt
- Eine Genehmigung wurde gemäß der Richtlinie zur Überprüfung altbekannter Änderungen abgelehnt
- Code-Owner-, letzter-Push- oder andere konfigurierte Anforderungen sind nicht erfüllt
- Ein PR-Typ ohne dedizierte CI wird als normales Update durchgeleitet

Implementierungsstatus der Gates (was CI heute überprüft, was noch zu bauen ist) wird gepflegt mit den Werkzeugen: [Implementierungsstatus](https://github.com/4dcitygml/tools/blob/main/docs/implementation-status.md).
