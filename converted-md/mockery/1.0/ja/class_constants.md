::: {.index}
single: Cookbook; クラス定数
:::

クラス定数
==========

クラスのテストダブルを生成するとき、Mockeryはモックするクラスの定数定義をスタブしません。そのため時々、クラス定数が存在しないため、テストのセットアップやアプリケーションのコード自身で望んでいない振る舞いを引き起こす可能性があります。`PHP Fatal error:  Uncaught Error: Undefined class constant 'FOO' in ...`のPHPエラーさえ起きる可能性があります。

Mockeryでクラス定数をサポートするのは可能ですが、非常に多くの作業が必要なのに対し、使用されるケースはまれです。

それでも、Mockeryで現在サポートされている方法の、[名前付きモック](creating_test_doubles.html#名前付きモック)により、定数を取り扱うことはできます。

名前付きモックはモックしたいクラス名を持つテストダブルですか、固定のレスポンスを含めた代理クラスを本当のクラスの代わりに裏でモックします。

次に、仮想ですが起こり得るシナリオをご覧ください。

``` {.php}
class Fetcher
{
    const SUCCESS = 0;
    const FAILURE = 1;

    public static function fetch()
    {
        // Fetcherは何かをどこかから私達のために取得する…
        return self::SUCCESS;
    }
}

class MyClass
{
    public function doFetching()
    {
        $response = Fetcher::fetch();

        if ($response == Fetcher::SUCCESS) {
            echo "Thanks!" . PHP_EOL;
        } else {
            echo "Try again!" . PHP_EOL;
        }
    }
}
```

`MyClass`は、どこかにある、何かのリソース、たぶんリモートのWebサービスからファイルをダウンロードする`Fetcher`を呼び出します。`MyClass`は`Fetcher::fetch()`の呼び出しのレスポンスに基づいてメッセージを出力します。

`MyClass`をテストする場合、テストスーツを実行するたびに、インターネットから何かがダウンロードされる`Fetcher`を動かすのは、本当に好ましくありません。
ですから、モックしましょう。

``` {.php}
// fetchは静的呼び出しなため、alias:を使う
\Mockery::mock('alias:Fetcher')
    ->shouldReceive('fetch')
    ->andReturn(0);

$myClass = new MyClass();
$myClass->doFetching();
```

これを実行すると、残念ながらテストは次のエラーになります。`PHP Fatal error:  Uncaught Error: Undefined class constant 'SUCCESS' in ..`

この状況で、`namedMock()`が役立てられます。

`Fetcher`クラスのスタブを組んで、クラス定数をスタブします。それから`namedMock()`を使用し、作成したスタブを元に`Fetcher`という名前のモックを生成します。（訳注：実際にはmockメソッドの引数で指定しており、メソッドは呼び出されていません。）

``` {.php}
class FetcherStub
{
    const SUCCESS = 0;
    const FAILURE = 1;
}

\Mockery::mock('Fetcher', 'FetcherStub')
    ->shouldReceive('fetch')
    ->andReturn(0);

$myClass = new MyClass();
$myClass->doFetching();
```

Mockeryは`FetcherStub`を拡張し、`Fetcher`という名前のクラスを生成するため、これはうまく行きます。

`Fetcher::fetch()`が静的メソッドない場合でも、同じアプローチが取れます。

``` {.php}
class Fetcher
{
    const SUCCESS = 0;
    const FAILURE = 1;

    public function fetch()
    {
        // Fetcherは何かをどこかから私達のために取得する…
        return self::SUCCESS;
    }
}

class MyClass
{
    public function doFetching($fetcher)
    {
        $response = $fetcher->fetch();

        if ($response == Fetcher::SUCCESS) {
            echo "Thanks!" . PHP_EOL;
        } else {
            echo "Try again!" . PHP_EOL;
        }
    }
}
```

テストは、次のようになります。

``` {.php}
class FetcherStub
{
    const SUCCESS = 0;
    const FAILURE = 1;
}

$mock = \Mockery::mock('Fetcher', 'FetcherStub')
$mock->shouldReceive('fetch')
    ->andReturn(0);

$myClass = new MyClass();
$myClass->doFetching($mock);
```
