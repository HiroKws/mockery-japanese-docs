::: {.index}
single: インストール
:::

インストール
============

MockeryはComposerを使用するか、GitHubリポジトリーをクローンすることでインストールできます。以下に２つの選択肢の概略を説明します。

Composer
--------

Composerについての詳細は、[getcomposer.org](https://getcomposer.org)で確認できます。ComposerでMockeryをインストールするには、最初に[Composer
download
page](https://getcomposer.org/download/)の説明に従い、プロジェクトで使用できるようにComposerをインストールします。次に、以下に示すパラメータを使用し、Mockeryを開発時の依存パッケージとして定義します。masterブランチを安定に保とうと努力をしていますが、お望みならば現在の安定バージョンを代わりに使用してください。`@stable`タグを指定します。

``` {.json}
{
    "require-dev": {
        "mockery/mockery": "dev-master"
    }
}
```

次にインストールするために実行します。

``` {.bash}
php composer.phar update
```

これにより、Mockeryは開発時の依存パッケージとしてインストールされます。つまり、プロダクション環境で`php composer.phar update --no-dev`を使用する場合は、インストールされません。

Git
---

Gitリポジトリのmasterブランチには、開発バージョンをホストしています。プロジェクトの`composer.json`ファイルに、前記のようにインストールしたいバージョンとして`dev-master`を指定すると、この開発版をインストールできます。
