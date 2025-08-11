## 概要

**script-kitty** は、Python・HCL・Dockerfile を用いて、論理に基づくロールの自動化や管理を目指すプロジェクトです。  
ロール定義や動作を論理で記述し、柔軟な運用を可能にします。

## 主な特徴

- **Python**: ロールの論理・制御処理を実装
- **HCL**: 設定ファイルやロールの定義を記述
- **Dockerfile**: コンテナ化による環境の再現性・展開の容易さ

## 始め方

### 必要な環境

- Python 3.8 以上
- Docker
- [Terraform](https://www.terraform.io/)（HCL 設定の利用時）

### インストール

リポジトリをクローンします。

```
git clone https://github.com/sakurasawamotoko/script-kitty.git
cd script-kitty
```

Python の依存パッケージをインストールします（必要に応じて）。

```
pip install -r requirements.txt
```

## 使い方

### Python スクリプトの実行

```
python main.py
```

### Docker の利用

Docker イメージのビルド：

```
docker build -t script-kitty .
```

コンテナの起動：

```
docker run --rm script-kitty
```

### HCL 設定

ロールや環境の定義は、`*.tf` や `.hcl` ファイルを参照してください。

## 設定例

```
role "example" {
  logic = "if condition then action"
}
```

## コントリビュートについて

プルリクエスト・Issue は歓迎します！  
詳細は [CONTRIBUTING.md](CONTRIBUTING.md) をご覧ください。

## ライセンス

このプロジェクトは MIT ライセンスのもとで公開されています。詳細は [LICENSE](LICENSE) を参照してください。

## 作者

[sakurasawamotoko](https://github.com/sakurasawamotoko)
