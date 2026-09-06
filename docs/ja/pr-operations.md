<!-- Copyright (c) 2026 4dcitygml -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

# 公開後のPull Request運用手順

- 状態: 公開後運用の採用手順（専用CI未実装のPR種別は解禁条件付き）
- 対象: 公開された都市データリポジトリ

English (canonical): [docs/pr-operations.md](../pr-operations.md) · Deutsch: [docs/de/pr-operations.md](../de/pr-operations.md)

この文書を、**公開後にPRをどう進めるか**の正本とする。他の文書は設計理由や
個別ツールの使い方を説明し、日々の着手、解説、承認、マージ、releaseの順序は本手順に揃える。

> この日本語版は改訂同期前です。職員向けの処理の流れと CI・承認の関係は、最新の [処理フロー解説](processing-flow.md) を参照してください。契約の最新記述は上記の英語版にあります。

## 1. 最初に固定する原則

1. **1 commit = 1 `uro:buildingID`** を通常更新の最小単位とする。
2. 同じ根拠、原典、変更規則で審査できる複数の建物commitは、1つのPRへ束ねてよい。編集ツールは**1建物1PR**で提案を作り、
   住民・職員の提案は通常この形になる。束ねるのは運用者が起こすPRで、1つの根拠資料が複数の建物を訂正する場合などに限る。
   期間でまとめる（週次ダイジェスト等）ことはしない。PRは意味審査と取消しの単位である（条件は§4.1.1）。
3. 同じbuildingIDを1つのPR内の複数commitに分けない。別のPRや年次属性系統で再度現れることは許容する。
4. 建物の統合・分割・建替えは、複数IDを扱う1つの `lifecycle` イベントとする。
5. 都市データPRは**squashせずmerge commit**で取り込み、個々の建物commitをmainへ残す。ruleset の許可マージ方式は `merge`（＋文書用に `squash`）とし、`squash` のみにしない。
6. コード・文書・道具の更新だけのPRは都市データと混ぜず、squash mergeしてよい。
7. PRの**解説**、**承認**、mainへの**マージ**、安定版の**release**は別の完了条件とする。
8. **最終承認者は常に自治体**（`maintainers` team）。運用者（委託先・4dcitygml）は解説とマージを担い、承認権限を持たない。
9. 一棟または一commitでもblocking検査に失敗したPRは、合格分だけを部分マージしない。
10. mainは作業中の途中状態を許容する。通常利用者には最新の安定releaseを案内する。公式版は「マージ後の出力」であり、公式版として採用するかは自治体が決める。

PR 文面の言語: 編集ツールは PR タイトル・本文をリポの作業言語（`4dcitygml.json` の `lang`）で生成する。コミット件名・`Building:` トレーラ・ブランチ接頭辞は
英語固定（履歴と機械契約は言語非依存）。都市データ PR は merge commit で入るので PR タイトルは main の履歴行にならない。
（練習リポは例外: auto-merge が squash するため、リポ言語の PR タイトルが練習履歴に入るが、練習履歴は定期的にリセットされる。）

```text
Issue / 公的原典 / 住民の提案
  → Draft PR（作業中、CI確認）
  → 自動検査（13ゲート）
  → Ready for review（code owner に自動 review request = 受付）
  → 運用者の解説レビュー（Comment。@maintainers に承認依頼）
  → 自治体の最終承認（Approve）
  → 運用者が merge commit で確定
  → Pages・履歴索引に反映
  → release gate 合格後に安定版化 → 自治体が公式版として採用
```

## 2. 席（役割）と完了責任

GitHub 上の実体は team と Org 役割で表し、**CODEOWNERS ファイルは書き換えない**（人の出入りは team のメンバー変更だけ）。

| 席 | GitHub 上の実体 | 主な作業 | 完了の印 |
|---|---|---|---|
| **投稿者** | Org 外の一般アカウント（住民・職員・研究者）、または運用者 | 変更、根拠、commit、PR本文を用意（hub は fork → PR を自動化） | PRをReady for reviewにする |
| **CI** | `analyze`（required check）ほか | commit範囲、XML、参照、形式、幾何、manifestの機械検査。結果は PR コメント（リポ言語）と hub のチェックポイント一覧 | required checksが全て成功 |
| **運用者** | team **`operators`**（write。code owner ではない） | 解説レビュー（Comment）、不備の差し戻し（Request changes）、承認後のマージ、release 作業、年度版更新、道具の更新 PR の検証 | 解説が投稿され `city-review` ラベルが付く／merge commitがmainへ入る |
| **最終承認者** | team **`maintainers`**（自治体職員。CODEOWNERS `* @<org>/maintainers`） | 値、形状、出典、lifecycle理由等の意味判断。解説を読んで Approve または Request changes | Approve |
| **所有者** | Org owner（自治体） | 設定・請求・メンバー管理・admin bypass（理由を Issue に残す） | — |
| **一括投稿者** | machine account（`operators` の一員。自治体 owner が資格情報を管理） | 宣言した原典から来歴 manifest つきの変換 PR を生成。手編集はしない | reproduction ゲート緑、manifest 審査、標本監査の記録 |
| **道具の提供者** | 4dcitygml Org（`tools`・`city-template`・OAuth App） | Release、CI ロジック、更新 PR の提案。都市リポの権限は持たない | — |

同一人が複数の席を兼ねてもよいが、工程と記録は分ける（例: 運用者が投稿者になった PR でも解説は別コメントで残す）。
都市ごとのCODEOWNERSと最終承認権限を他都市と共有しない。運用者の席は委託先と 4dcitygml で同一であり、交代は team のメンバー変更で行う。

## 3. すべてのPRに共通する手順

### 3.1 着手前

```text
[ ] Issue、公的原典、住民の提案、定期保守のどれを起点にするか決めた
[ ] 対象都市、uro:buildingID、メッシュ、変更種別を特定した
[ ] 根拠資料を公開でき、ライセンス・個人情報・プライバシーに問題がない
[ ] 同じメッシュGMLを変更する先行PRがない
[ ] このPRと別PRに分ける意味の境界が決まっている
```

同じメッシュGMLを変更するPRは直列にする。先行PRがマージされた後のmainから次のPRを作り直す。
異なるメッシュは、共通schema migrationが完了し、共有テクスチャやXLinkへの変更がない場合だけ並行できる。

### 3.2 ブランチとcommit

```text
[ ] 着手時点の最新mainから作業ブランチ（または fork）を作った
[ ] PRの履歴は直線で、PRブランチ内にmerge commitを入れていない
[ ] 通常更新は1 commitで1 buildingIDだけを変更した
[ ] 同じbuildingIDをPR内の複数commitへ分けていない
[ ] 建物commitをuro:buildingIDの昇順に並べた
[ ] Building:、Building-Added:、Building-Deleted:等のtrailerが実変更と一致する
[ ] 変更対象外の整形差分を最小差分版で除いた
```

`Draft`は作業中の保存とCI確認に使う。**code owner への自動 review request は Ready for review にした時点で発生する**（Draft では発生しない）ので、
自動検査と投稿者確認を終えてから Ready にする。

### 3.3 PR本文

```text
[ ] PR種別を1つ選んだ
[ ] 何を、なぜ、どの根拠で変えるかを書いた
[ ] 対象となる全buildingID又はmanifestを指定した
[ ] 変更してよいpathと、変更してはいけない範囲を明示した
[ ] 関連Issueを Fixes #<番号> 又は Refs #<番号> で接続した
[ ] 根拠のURL、文書名、取得日、版、hash等を追記した
[ ] 形状、LOD、属性、ID、lifecycleを混ぜた場合、分離できない理由を書いた
```

年次 `source-update` では、さらに次を必須にする。

```text
Source-From, Source-To, Scope-Mesh, Attribute-Family, Allowed-Paths,
History-Manifest, Manifest-SHA256, Building-Count,
First-Building-ID, Last-Building-ID
```

### 3.4 自動検査と提案者確認

13 のゲートは push ごとに走り、編集ツールは §3.1〜§3.3 の項目を作りの上で満たす。この表は手で作った PR 向け。

```text
[ ] 最後のpush後のhead SHAで全required checksが緑である（base freshness を含む）
[ ] warning・noticeを読み、そのままにするものは理由をPRに書いた
[ ] churn通知がある場合、最小差分版を適用後に再検査した
```

現行のchurn処理は通知と最小差分版の生成までであり、PR headへの自動適用は未実装である。完了までは、投稿者又は運用者が適用する。

### 3.5 運用者の解説レビュー（一段目 — *reviewer*）

自治体に承認を求める前に、運用者が内容を確認し、**解説**を投稿する。review type は **Comment**（承認は自治体だけが行う）。
Kubernetes の OWNERS モデルの語彙では、運用者が *reviewer*、自治体の maintainers が *approver* である。

```text
[ ] 値・形状・出典・旧新ID関係の意味が通る。疑問点は投稿者と解消した
[ ] 根拠を公開できる（ライセンス・個人情報・肖像）
[ ] 解説を定型5行で投稿し、@<org>/maintainers を mention、ラベル city-review を付けた
[ ] 不備は Request changes で投稿者へ戻し、自治体には上げていない
```

解説の定型（リポ言語。hub のチェックポイントと同じ語彙を使う）:

```text
## 解説（運用者）
- 変更: <建物 ID> の <属性/形状> を <旧> → <新>。
- 根拠: <PR 本文の出典・sec:reason の要約>。
- 検査: 13 項目すべて合格。要注意: <あれば>。
- 影響: この建物のみ。公式版の出力には次回 release で反映。
- 推奨: 承認可。 @<org>/maintainers
```

- 修正可能な不備は `Request changes` で対応箇所を示す。
- 重複PR、対象外、公開不可の根拠、解消不能な権利問題は、理由を残してcloseする。
- 道具の更新 PR（§4.9）の解説は「データ変更なし」を先頭に書く。

### 3.6 自治体の最終承認（二段目 — *approver*）

approver は確認するのであって、再審査はしない。機械的な条件はすべて ruleset が保証する: required checks が緑であること、
承認後の push で承認が無効になること、code owner の承認だけが数えられること。

```text
[ ] 解説の「推奨」に同意できる（できなければ Request changes で運用者へ戻す）
[ ] ラベルが求める場合（lifecycle・identity-review・texture-override）、その追加条件を満たしている
```

承認は GitHub の PR 画面か hub（検査結果をリポ言語で表示）で行う。「最新 push の承認」は「最後に push した人以外の承認」の意味で、
自分が push した PR は自分では承認できない。職員が複数なら team の Code review assignment で PR ごとに 1 名へ絞る。

### 3.7 マージ

ruleset が検査の緑・code owner の有効な承認・会話の解決を保証する。運用者が確認するのは次の 2 点だけ。

```text
[ ] 都市データPRは Create a merge commit（文書・道具 PR は squash 可）
[ ] PR種別と対象メッシュが解説と一致する
```

マージは運用者（または自治体）が行う。自動mergeは行わない。緊急時の admin bypass は自治体 owner のみ、理由を Issue に残す。

### 3.8 マージ後

```text
[ ] main上の検査とPages（履歴索引）生成が成功した
[ ] 年次更新の場合、release-planの状態を更新した
[ ] 異常がある場合、履歴改変ではなくrevert PRを起票した
```

manifest自身にマージ後のPR番号やSHAを追記するための後追いcommitは作らない。Git履歴とGitHubからPages索引を再生成して接続する。

### 3.9 通知

- **受付**: Ready for review 時の code owner 自動 request（止められない。Draft で先送りできる）。
- **承認依頼**: 運用者の解説レビューの `@<org>/maintainers` mention。team notification を切ると mention は届かなくなるが、review request の通知は止まらない
  （GitHub Docs）。切る場合は個人 mention に替える。
- 職員 1 名なら PR ごとに 2 回。複数名なら Code review assignment で 1 名に。

## 4. PR種別の選び方

| PR種別 | 1 PRの単位 | 建物commit | 必須の追加記録 | 主な担い手 |
|---|---|---|---|---|
| `correction` | 1つの根拠・変更規則 | 1 buildingIDずつ | Issue、根拠、変更前後 | 投稿者、運用者 |
| `lifecycle` | 1つの建替え・分割・統合 | 専用1commitで複数ID可 | 旧新ID関係、理由、manifest、追加承認 | 運用者 |
| `identity-correction` | 1つの誤接続・ID訂正イベント | 専用ゲートに従う | 訂正前後ID、誤りの根拠、追加承認 | 一括投稿者 |
| `source-update` | 1原典遷移 × 1メッシュ × 1属性系統・規則 | 1 buildingIDずつ | source/change manifest、許可path、件数、標本確認 | 一括投稿者 |
| `schema-update` | 1schema bundle | GML変更なし | XSD・コードリスト等のhash、profile | 運用者 |
| `carry-forward` | 1版遷移 × 1メッシュ（旧公式・リポ・新公式の三方向） | 新版 `source-baseline` の後に再適用建物ごとに `Building:` commit | 来歴 manifest（再適用／吸収／衝突／未対応／旧codeSpace引き継ぎ） | 一括投稿者 |
| `schema-migration` | 1版遷移 × 1メッシュ（公式新版が無くリポが正本のとき）: レジストリ駆動でi-UR部分木を再直列化 | 新版の生成 `source-baseline` 1件 | 来歴 manifest；レジストリキー単位の意味一致（保持／写像／引き継ぎ／未対応） — ゲート未実装 | 一括投稿者 |
| `layout` | 1親メッシュの1段階細分化 | 意味不変の専用1commit | 再集約検査、ID・参照・容量検査 | 運用者 |
| `texture-gc` | 未参照画像の1回の回収 | 建物変更なし | 全imageURI非参照の証明、削除リスト | 運用者 |
| `revert` | 1建物commit又は1PRの取消し | 元の単位を保つ | 取消し対象、理由、影響するrelease | 運用者 |
| **`tooling`** | 1つの tools Release への追随 | 建物変更なし | 新旧 tag・asset・sha256、Release notes へのリンク、「データ変更なし」 | 4dcitygml が提案、運用者が検証 |
| コード・文書 | 1つのツール又は説明変更 | 建物変更なし | テスト、文書導線、影響範囲 | 運用者 |

`source-baseline`、`scope-extract`、`identity-baseline`は公開履歴を作る初期構築専用であり、公開後の日常PRとして繰り返さない。建物以外の主題（tran・fld・dem 等）を後から追加する「主題別 source-baseline」はゲート未実装（公開後課題）。実装までは追加しない。

### 4.1 日常の `correction`

```text
[ ] data-issue又は公開可能な根拠がある
[ ] 同じPRへ束ねた建物は、同じ根拠と判断規則で審査できる
[ ] 各commitはBuilding: <uro:buildingID>を1件持つ
[ ] テクスチャ差し替えは新規画像追加＋imageURI更新で行った
[ ] 幾何を変えた場合、高さ・面積等の派生属性との整合を確認した
```

既存テクスチャの同名上書きは原則禁止とする。共有アトラス等の正当な例外だけ、影響する全建物の確認後に運用者が `texture-override` ラベルを付け、自治体の承認を得る。

### 4.1.1 複数建物を1つのPRに束ねる条件

- 編集ツールは**1建物1PR**で作る。これが標準の形。
- 手で作ったPRは、**1つの論理的変更**なら複数建物を含んでよい。論理的変更とは、1つの根拠（同じ文書の同じ版）と1つの規則を
  同じに適用したもので、1メッシュ・1属性系統の中に収まるもの。件数の上限は置かない（運用者が全件を読む）。
- スクリプトが原典や外部データから生成したものは、件数にかかわらず**一括投稿**（§4.4: 材料・対照表・生成コマンドを持つ来歴manifest、
  再現で受理）。大規模な機械的変更を別経路で扱う一般的な線引きと同じ。
- 1棟が不合格なら、その棟を別PRに分け、残りをforce pushする。残りのpatchは不変で、GitHubのforce-push compareで確かめられるので
  再承認は1クリック。部分マージはしない（原則1-9）。

例: 市の避難所一覧から1メッシュ内の12棟を手で付ける → 1 PR。同じ一覧をスクリプトで突合して3棟 → 一括投稿。
5棟の階数を棟ごとに別資料で訂正 → 建物ごとに別PR。

### 4.2 `lifecycle`

```text
[ ] 旧新建物の関係を確定し、未解決候補を混ぜていない
[ ] 1つの実世界イベントだけをPRに入れた
[ ] Change-Type: lifecycle を記録した
[ ] Building-Deleted:、Building-Added:を実変更ID全件と一致させた
[ ] 旧新関係、発生日又は確認日、根拠、判断者をmanifestに残した
[ ] lifecycleラベルと自治体の承認がある
```

旧新関係が不明なら、消滅や建替えと即断せずIssue又は `lifecycle-review`へ保留する。

### 4.3 `identity-correction`

公開済み履歴で同一性の誤接続が判明しても、過去のcommitやtagを書き換えない。訂正前後ID、誤りの根拠、影響する履歴を新しいPRで残す。

```text
[ ] 訂正前と訂正後のbuildingIDを特定した
[ ] lifecycleではなく誤接続の訂正である根拠がある
[ ] 過去履歴のどの期間へ影響するかを記録した
[ ] identity-correction専用CI（commit scope＋reproduction）と自治体の承認が成功した
```

commit scope gate は buildingID の置換を `identity-baseline` / `identity-correction` commit としてのみ受理し（来歴 manifest に裏付けられた）、`reproduction` gate が manifest を材料から再生成する。実リポの private パイロットで検証するまで Ready for review にしない。

identity PR は一括投稿：提出物（計画 Issue、来歴 manifest（建物ごとの根拠と境界ごとの ID 体系を含む）、commit trailer、machine account、標本監査）と gate は
[Bulk submissions: provenance, verification, and merge policy](https://github.com/4dcitygml/tools/blob/main/docs/bulk-submission-provenance.md)。
東京 2020–2025 の実測では製品系列が変わる境界で `uro:buildingID` 連続性が完全に切れる（2022→2023 で全棟振り直し、境界をまたぎ同一 ID は別建物）ので、
ID 一致だけでは根拠にならず、全リンクに幾何的根拠が要る。

### 4.4 年次 `source-update`

年次更新は、次の順に別PRとして進める（運用者が計画し、一括分は machine account が投稿する）。

1. `schema-update` — 新版の依存物（`codelists/<edition>/`、schema profile）。GML 変更なし
2. 版が変わる場合 — 新公式版を新たな `source-baseline` として記録し `carry-forward`（建物×属性の三方向比較）。公式新版が無くリポが正本なら `schema-migration`
3. 属性系統ごとの単棟パイロット
4. 属性系統ごとの複数棟PR
5. 幾何、LOD、原典`gml:id`の専用PR
6. 確定済みイベントの `lifecycle`
7. 各メッシュと全都市の完了検査
8. 年度release tag

```text
[ ] 更新開始前のsource、schema、ID、意味規則、lifecycle、容量判定が完了した
[ ] PRを1原典遷移 × 1メッシュ × 1属性系統・変更規則に限定した
[ ] manifestに許可path、旧新値、対象buildingIDを全件固定した
[ ] 各Attribute-Familyの代表一棟が先に合格した
[ ] 同じメッシュの先行PRマージ後のmainから生成した
[ ] 自動確定群と曖昧・lifecycle要確認群を分けた
[ ] 事前の最終path signatureと完了後の結果が一致した
```

新年度原本を1PRで丸ごと上書きしない。各属性PRは作業領域の新年度版から、未反映buildingID manifestに基づいて毎回生成する。

`source-update` PR は一括投稿：来歴 manifest と `Provenance-Manifest:` trailer を付ける。審査は計画・manifest・無作為標本、CI は変換を再現する。詳細は
[Bulk submissions: provenance, verification, and merge policy](https://github.com/4dcitygml/tools/blob/main/docs/bulk-submission-provenance.md)。

### 4.5 `schema-update` と版の変更（`carry-forward`）

```text
[ ] schema-updateはGMLを変更せず、版別依存物だけを追加した（codelists/<edition>/、schemas/、provenance/schema-update/）
[ ] 依存物のdigestと公式原典（ZIP member）を記録した
[ ] 新profileで現行データのoffline XSD検証に合格した
[ ] 版の変更は「新公式版 = source-baseline → carry-forward」で適用した（旧ファイルの構造変換はしない）
[ ] carry-forward manifestに建物ごとの再適用／吸収／衝突／未対応／旧codeSpace引き継ぎがある
[ ] 衝突と未対応は審査者が判断し、引き継ぎコードは release gate で集計した
```

版の変更には 2 経路がある。公式版が独立に作られる間は、新公式版を次の baseline とし、蓄積した変更を建物×意味属性の三方向比較で再適用する（`carry-forward`、詳細は
[Bulk submissions: provenance, verification, and merge policy](https://github.com/4dcitygml/tools/blob/main/docs/bulk-submission-provenance.md)）。
リポが正本になり公式版がリポから出力されるようになると外部の新版ファイルは無く、`schema-migration` がリポ自身の内容から新版の直列化を生成する
（CityGML コアは 2.0 内で不変、3.0 移行は 3DCityDB 経由。i-UR 部分木はレジストリ・コードリスト crosswalk（1:1 対応の無いコードは旧 codeSpace を保持）・新版 XSD 順で建物ごとに再直列化）。gate はレジストリキー単位の意味一致（kept / mapped / carried / unmappable）と再現で、設計済み・未実装。どちらの経路もレジストリに基づく同じ比較で検証する。`schema-update` は commit scope 検査（依存物パスのみ、CityGML 変更なし）；`carry-forward` は `source-update` と同じ規則＋`reproduction` gate で検査する。

### 4.6 `layout`

```text
[ ] source-update後の保存GMLが50 MiB以上になることを更新前に確認した
[ ] 更新前のmainの現行メッシュだけを1段階細分化した
[ ] Change-Type: layout を記録し、建物ID trailerを付けていない
[ ] 建物件数、ID集合、意味hash、Appearance、XLinkが不変である
[ ] Envelope、XSD、一時再集約の検査に合格した
[ ] 細分化後の全ファイルが50 MiB未満で、100 MiB以上の登録ファイルがない
```

一度細分化したメッシュは、後年度で小さくなっても粗いメッシュへ戻さない。現行ツールは1段階の細分化までであり、より深い分割は拡張と検証後に解禁する。

### 4.7 `texture-gc`

```text
[ ] 削除候補の全画像がmainの全imageURIから非参照である
[ ] 新たなdangling参照が0件である
[ ] 削除画像の一覧、件数、バイト数をPR本文に記録した
[ ] 建物GML、属性、幾何を同じPRで変更していない
```

### 4.8 `revert` と緊急訂正

公開後の誤りはforce pushやtagの差し替えで隠さない。新しいPRとして取り消す。

```text
[ ] 1建物commitだけを戻すか、PR全体を戻すかを決めた
[ ] 取消し対象のcommit又はmerge commit SHAを記録した
[ ] 取り消す理由、発見経路、影響する建物とreleaseを書いた
[ ] 取消し後のCityGMLに通常と同じ全検査を行った
[ ] 公開済みreleaseへ影響する場合、パッチreleaseの要否を決めた
```

緊急性が高くてもrequired checksと自治体の承認は省略しない。影響範囲を小さくし、優先度を上げることで対応する。

### 4.9 `tooling`（道具の更新）

クライアントの `hub-v` 更新では `install/tools-release.json`（tag・asset・sha256）、都市向け処理の `tools-v` 更新では `CITYGML_TOOLS_REF`（公開版の不変 SHA）を更新するPRを提案する。二つは独立した更新であり、採用する組合せを検証する。**マージされなければ何も変わらない** — 自治体が主導権を持つ。

```text
[ ] 変更は install/tools-release.json と .github/workflows/ の pin だけで、データ・文書に触れていない
[ ] 新 tag・asset・sha256 が 4dcitygml/tools の Release notes と一致する（運用者が照合）
[ ] Release notes の変更点を解説に要約し、先頭に「データ変更なし」と書いた
[ ] スターターの更新機構（.release-tag）で新 release が届くことを運用者が 1 台で確認した
[ ] 自治体の承認後に squash merge した
```

## 5. Release

Release 作業は運用者が行い、**公式版として採用するかは自治体が決める**（リポが正本、公式版はマージ後の出力）。

### 5.1 通常の日常修正

- マージ後、修正はmainと建物履歴へ反映される。
- 各PRのマージだけで既存の安定releaseを動かさない。
- 次の定期パッチ又は年度releaseで安定版へ含める。
- 重大な誤り、法的・個人情報問題、利用上の危険がある場合はパッチreleaseを行う。

Patch-release tag 命名と定期発行頻度は、運用開始前に別 ADR で固定する。

### 5.2 年次release

```text
[ ] 対象全メッシュの全属性系統PRが完了した
[ ] 幾何、LOD、原典gml:id、lifecycleの確定群が完了した
[ ] schema profile 検査と、版の変更がある場合は carry-forward manifest 審査が完了した
[ ] 全buildingID集合、重複、参照、Appearance、XSDが合格した
[ ] 最終path signatureと公式新年度版との意味一致を確認した
[ ] 未解決群を勝手に更新せず、保留一覧と影響を明記した
[ ] release-planがrelease-readyである
[ ] release notesに原典、hash、加工、ID統一、保留、検査結果を記載した
[ ] tag、Pages、ダウンロード、検査結果が同じcommitを指している
[ ] 旧codeSpace引き継ぎ値（codelists/<edition>/）を carried_codespace_report.py で集計し、解消または公式経路で受容した
[ ] 自治体が公式版として採用するか（採用日・公表方法）を記録した
```

release-ready の条件が一つでも欠ける間は、main を「新年度の安定版」と表示しない。

## 6. マージ停止条件

次のいずれかに当てはまる場合は、Approve又はmergeをしない。

- PRが最新mainより遅れている
- required checkが失敗、未実行、又は古いhead SHAを対象にしている
- 原典、根拠、ライセンス、公開可否が確認できない
- PR種別と変更内容が一致しない
- manifest外のbuildingID、path、旧新値が一件でもある
- 同じメッシュの先行PRが未マージである
- buildingIDの同一性、lifecycle関係、schema変換の意味が未解決である
- 更新後に50 MiB以上になるメッシュのlayout PRが未完了である
- churnが残り、対象外の建物や行まで変わって見える
- **運用者の解説が無い、または解説後に push があって承認が無効化されている**
- **自治体（code owner）の Approve が無い**（運用者や投稿者の Approve では条件を満たさない）
- 必要なlifecycle、identity、texture-overrideの追加承認がない
- 専用CIが未実装のPR種別を、通常更新として迂回しようとしている

## 7. 現行実装と残作業

### 7.1 現行リポジトリで検査できるもの

- 通常commitの1 buildingID制約とtrailer一致、PR内の同一buildingID重複commitの禁止
- `lifecycle`、`layout`、`source-baseline`（初回のみ）、`scope-extract` のcommit scope例外
- `identity-baseline` / `identity-correction` commit: trailer と manifest 参照、byte 保存の ID 置換、tier 規則、リポ全体の ID 一意性
- `source-update` の 1 属性系統内の値置換: manifest 裏付けの `Building:` commit、manifest の変更の byte 一致適用、全対象の適用
- `reproduction` gate: 一括 manifest の材料を再取得し再生成（identity・source-update）
- `scope-extract` の対象自治体集合と保持建物不変
- XML/XSD（i-UR 2.0〜3.2 同梱）、構造、参照、テクスチャ、幾何の検査と比較表示。多棟 PR のコメントは 60,000 字で切り詰め＋成果物案内
- Base-freshness 案内
- 建物別履歴（`building_history.py` in tools: ID 変更・丸ごと baseline・manifest 付きコミットをまたいで建物を追い、commit ごとのレジストリ鍵の変更を出す）；`history-index.yml` workflow が静的な Pages サイト（`history/index.html` + `history/buildings/<id>.json`）として公開（main へのすべての push で自動実行）
- Hub: Device Flow サインイン、fork → PR、チェックポイント表示（リポ言語）、Approve / Request changes 送信、Draft・検査中・最新版待ち・承認待ちの一覧
- Starter kit（release `starter-kit`）と `.release-tag` による更新追随

### 7.2 対象PRを解禁する前に実装するもの

- 版別 schema profile を検証オプションに（現在は 1 つの master schema が i-UR 2.0〜3.2 を包含）
- 実装済み `identity-baseline` / `identity-correction` gate（commit scope 規則＋`identity` 再現）の実リポジトリでのパイロット検証
- 実装済み `source-update` 値置換 gate（1 PR = 1 属性系統、manifest 裏付けコミット、再現）の実リポジトリでのパイロット検証
- 版仕様の変更（属性コンテナの追加・削除。2020→2025 の実測差分の大半）は公式版がある間は `carry-forward`（実装済み）で扱う。リポが正本の段階の `schema-migration`（再直列化器・意味同一性 gate・i-UR 4.0 レジストリ）は設計済み・未実装
- `source-update` のAllowed-Paths、旧新値、manifest対象IDの全件照合
- 最終path signatureと公式原典一致のrelease gate
- 5次・6次メッシュが必要な場合の分割・再集約ツール
- 建物ID → commit → PR → merge commit → release の索引（現行の履歴索引を release まで延長）
- same-repo と fork の最小差分版自動適用
- パッチreleaseのtag命名、発行頻度、緊急性判定のADR
- **主題別 `source-baseline` gate**（tran・fld・dem 等の後追い追加）、**全棟一括の意味修正 gate**（例: lod0FootPrint→lod0RoofEdge）
- **束ねたPRの分割支援**: hub に「前回の審査から patch が不変の建物」と「外された建物」を表示（再承認を 1 クリックに）
- **外部データを材料にする一括投稿の種別**（例 `external-update`）: 市の公開一覧・法務局地図・国土数値情報・3DCityDB 等を `materials` に、対照表と置換ロジックを manifest に持ち、`reproduction` がコネクタ経由で再実行する
- **都市リポ内の定期 `tooling` workflow**: 上流 Release を定期確認して更新 PR を自ら開く（Dependabot 型）。4dcitygml が PR を出しに行く形を置き換える
- **Merge Queue の評価**: 「同じメッシュの PR は直列」（§3.1）の人手ルールを GitHub の merge queue で置き換えられるか
- **二段レビューの補助**: hub の「解説を投稿」ボタン（定型挿入）、hub が PR を Draft で開き解説時に Ready にする経路、`4dcitygml.json` の `oauthClientId` を hub が優先

未実装の専用ゲートは、文書上の注意だけで代替しない。実機でrejectとrevertを確認してから公開運用へ入れる。

## 8. 公開後の定期点検（席ごと）

### 毎週（運用者）

```text
[ ] 承認待ち（解説済み）、解説待ち、Request changes、最新main待ちのPRを分けて確認した
[ ] CI故障とデータ不合格を分けて対応した
[ ] 長期停滞PRへ次の行動又はclose理由を書いた
[ ] 同じメッシュの競合PRがない
[ ] 自治体へ承認依頼中の PR の一覧を（必要なら）まとめて送った
```

### 毎月・定期release前（運用者が準備、自治体が確認）

```text
[ ] 未参照テクスチャ候補を確認した
[ ] 新規の公的原典・年次版の有無と確認日を記録した
[ ] required workflowと共通ツールのpin（CITYGML_TOOLS_REF・tools-release.json）を点検し、未追随の tools Release があれば tooling PR の要否を決めた
[ ] release対象commitの出典、権利、未解決事項を確認した
```

### 四半期（自治体 owner）

```text
[ ] Org owner・maintainers・operators のメンバーが現在の体制と一致し、退職・異動・契約終了の欠員が無い
[ ] 全メンバーの 2FA、machine account のトークン有効期限と保管
[ ] OAuth App の承認一覧（4dcitygml hub のみ）
[ ] README の運用体制記述（所有者・最終承認者・運用者・引き継ぎ日）が実態と一致する
[ ] ruleset（main・baseline）の設定が §3.6 と一致する
```

## 9. 席の変更（委託先の参加・交代、4dcitygml の退出）

新しい運用者を Org に招待して `operators` へ、前任を外し、machine account のトークンを再発行し、README の体制記述を更新する。CODEOWNERS と ruleset は触らない。同じ手順が委託先と 4dcitygml 間の交代に適用される。
