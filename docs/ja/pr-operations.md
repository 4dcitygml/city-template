<!-- Copyright (c) 2026 4dcitygml -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

# 公開後のPull Request運用

- 状態: 公開後運用の採用手順（専用CI未実装のPR種別は解禁条件付き）。第三版: 契約のみ。運用者の個別手順は別文書へ移行。
- 対象: 公開された都市データリポジトリ

English (canonical): [docs/pr-operations.md](../pr-operations.md) · Deutsch: [docs/de/pr-operations.md](../de/pr-operations.md)

本文書は、**公開後にPRが守る契約**。原則、席、PR種別、マージ停止条件を定めたもの。各席がその作業をどう進めるかは別文書:

| 対象 | 参照先 |
|---|---|
| 編集ツールで提案を送る住民・職員 | [はじめかた](getting-started.md) — ツールがこの契約を満たします |
| 市町村の `maintainers` team（最終承認者） | [承認者の手引き](../approver-guide.md) — 1ページ |
| `operators` team の運用者（委託先、または4dcitygml） | [運用者ハンドブック](../operator-handbook.md) |
| ツール生成済み変更を投稿する機械アカウント | [一括投稿: 出典、検証、マージ方針](https://github.com/4dcitygml/tools/blob/main/docs/bulk-submission-provenance.md) |

## 1. 原則

1. **1 commit = 1 `uro:buildingID`** を通常更新の最小単位とする。
2. 通常の修正PRは**1棟**をカバー。再現可能な一括投稿は専用ルート（原則7）。建替え・分割・統合は**1つの建築イベント**ルート（原則4）で行う。無関係な手修正は各ルートに束ねない。
3. 同じbuildingIDをPR内の複数commitに分割しない。別PRや年次属性系統での再登場は許容。
4. 建物の統合・分割・建替えは1つの `lifecycle` イベントで複数IDを扱う。
5. 都市データPRは**squashせずmerge commit**で取り込み、建物commitはmainに残す。rulesetは `merge` 方式を許可（文書用に `squash` も可）。squash-onlyにしない。
6. コード・文書・道具の更新PRは都市データと分離。squash mergeしてよい。
7. 機械が原典や外部データから生成した変更は件数に関わらず**一括投稿**。手編集は通常PR。
8. **最終承認者は常に市町村** （ `maintainers` team）。運用者は生成レポートを確認しマージ。承認権限なし。Kubernetesの OWNERS 語彙では、運用者が *reviewers*、市町村 maintainers が *approvers*。
9. 1つの建物またはcommitでもblocking検査に失敗したPRは部分マージしない。blocking失敗はCI段階で浮上。運用者が生成レポートを確認するので、承認時に「失敗」するのはPRの設計不足。
10. mainは作業中の途中状態を許容。通常利用者には最新の安定releaseを案内。公式版は「マージ後の出力」。公式版として採用するか判断するのは市町村。

PR文面の言語: 編集ツールはPRタイトル・本文をリポの作業言語（`4dcitygml.json` の `lang`）で生成。commitサブジェクト、`Building:` トレーラ、ブランチ接頭辞は英語固定（履歴と機械契約は言語非依存）。都市データPRはmerge commitで入るのでPRタイトルはmainの履歴にならない。（練習リポは例外: auto-merge が squash するため、リポ言語のPRタイトルが練習履歴に入るが、定期的にリセット）

```text
Issue / 公的原典 / 住民の提案
  → 変更とその根拠（Draft は作業中に選択可）
  → 自動検査（14ゲート）
  → CIが共有レポートと指摘事項を生成
  → reviewers は GitHub Approve を使用。現行必須承認数は設定可能
  → 運用者がmerge commitで確定
  → Pages / 履歴索引更新
  → release gateを通ったら安定版化 → 市町村が公式版として採用
```

## 2. 席

review参加は市町村が設定可能。reviewer は市町村職員、委託先、複数責務を兼任する者。全員が同じCIレポートを読み GitHub **Approve** を使う。運用者専用のComment確認や固定のreview順序なし。

| 役割 | 責務 |
|---|---|
| 投稿者 | 変更と根拠を提出。自分のPRは承認できない |
| Reviewer（承認者） | 共有レポートと差分を読む。承認するか変更依頼 |
| リポジトリ管理者 | 権限、必須承認数などリポ設定を管理 |
| 運用スタッフ | ツールを保守。質問に答える。承認PRをマージ。release作成。tooling更新を検証する者も可能 |
| ツール提供者 | 共有ツール公開。tooling更新を提案 |

市町村は必須承認数をいつでも変更可。権限ある管理者が日時、変更前後の数、理由を記録。1アカウント = 最大1承認。作成者以外で実際に承認できる人数を計画。write権限総数は想定 review 対象者と異なる場合あり。メンバーシップと任意のCode Owner要件は数値から独立して適格性を定める。

hubは現行GitHub設定を読み込み個人別の残り承認数フィルタを提供。[review設定](../review-settings.md) を参照。設定はブラウザにアカウント・リポ単位で保存。職位判定やreview順序は強制しない。

## 3. PR種別

| PR種別 | 1PRの単位 | 建物commit | 必須の追加記録 | 席・指示箇所 |
|---|---|---|---|---|
| `correction` | 1棟 | 1commit、1buildingID | Issue、根拠、変更前後 | 投稿者、運用者・handbook §6.1 |
| `lifecycle` | 1建替え・分割・統合 | 1専用commit、複数ID可 | 旧新ID関係、理由、Lifecycle-Manifest、市町村判断 | 運用者・handbook §6.2 |
| `layout` | 1親メッシュの1段階細分化 | 1意味保存commit | 再集約検査、ID・参照・容量検査 | 運用者・handbook §6.3 |
| `texture-gc` | 1回の未参照画像回収 | 建物変更なし | 全imageURIの非参照証明、削除リスト | 運用者・handbook §6.4 |
| `revert` | 1建物commitまたは1PRの取消 | 元の単位を保つ | 対象、理由、影響するrelease | 運用者・handbook §6.5 |
| `tooling` | `CITYGML_TOOLS_REF` を新しい `tools-v` リリースに1つ更新（CI が tools タグに対して検証） | 建物変更なし | Release notes、「データ変更なし」、クライアント影響時の `min_hub` | 4dcitygml が提案、運用者が検証・handbook §6.6 |
| 文書・設定 | 1つの文書または設定変更（`docs/`、README、`4dcitygml.json`、テーマ、ロゴ）。都市リポジトリではコードは受け入れられません（Exchange Contract A11） | 建物変更なし | 文書リンク、影響範囲 | 運用者 |
| `identity-correction` | 1誤接続・ID訂正イベント | 専用gateに従う | 訂正前後ID、根拠、追加承認 | 一括投稿者・bulk-submission文書 |
| `source-update` | 1原典遷移 × 1メッシュ × 1属性系統 | buildingID 1つずつ | 出典manifest、許可path、件数、標本 | 一括投稿者・bulk-submission文書 |
| `carry-forward` | 1版遷移 × 1メッシュ | 新版 `source-baseline` 後の再適用建物ごとに1 `Building:` commit | 出典manifest（再適用・吸収・衝突・未対応・旧codeSpace引継） | 一括投稿者・bulk-submission文書 |
| `semantic-correction` | 1サポート済みレシピ × 1メッシュ | 対象ごとに1 `Building:` commit | 固定入力と根拠、正確な変換、再現。公開ツールとパイロット検証必須 | [Recipe scope](https://github.com/4dcitygml/tools/blob/main/docs/lod0-semantic-correction.md) |
| `schema-update` | 1schema bundle | GML変更なし | XSD・コードリスト digest、profile | 運用者・bulk-submission文書 |
| `schema-migration` | 1版遷移 × 1メッシュ（リポが正本） | 1生成 `source-baseline` | 出典manifest。レジストリキー単位の意味一致 — gate未実装 | 一括投稿者・bulk-submission文書 |

`source-baseline`、`scope-extract`、`identity-baseline` は公開履歴の初期構築のみ。日常PRでは繰り返さない。後から主題追加（transportation、flooding、terrain…）を単一 `source-baseline` で行うはgateなし。

## 4. マージしない条件

次のいずれかに当てはまるときはマージしない:

- PRが最新mainより遅れている
- 必須checkが失敗、未実行、または古いhead SHAを対象
- 原典、根拠、ライセンス、公開可否が確認できない
- PR種別と実変更が一致しない
- buildingID、path、旧新値のいずれかが1つでもmanifest外
- 同じメッシュの先行PRが未マージ
- buildingID同一性、lifecycle関係、schema変換の意味が未解決
- 50MiB以上になるメッシュの必須layout PRが未完了
- churnが残り対象外の建物や行まで変わって見える
- 成功した `analyze` と最新 `ci-report` checkがない
- GitHub現行必須承認数に達していない
- 稀度review方針で承認が却下された
- Code Owner、最新push、その他設定要件を満たさない
- 専用CIなしのPR種別を通常更新で迂回しようとしている

実装状況（CIが今検査するもの、未実装部分）は[実装状況](https://github.com/4dcitygml/tools/blob/main/docs/implementation-status.md)を参照。
