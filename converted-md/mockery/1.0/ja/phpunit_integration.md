::: index
single: PHPUnitとの統合
:::

# PHPUnitとの統合

Mockeryは簡単に利用できる **スタンドアローン**
モックオブジェクトフレームワークとして設計されていますので、テストフレームワークとの統合は完全に任意です。Mockeryを統合するには、テストへ以下のように`tearDown()`メソッドを定義する必要があります。（Mockeryに、より短い名前空間のエイリアスを使えます。）

``` php
public function tearDown() {
    \Mockery::close();
}
```

この静的呼び出しは、現在のテストで使用したMockeryコンテナをクリーンアップし、エクスペクションで必要な確認のタスクを実行します。

簡潔にMockeryを使用したい場合、より短いエイリアスをMockeryの名前空間に使用することもできます。

``` php
use \Mockery as m;

class SimpleTest extends \PHPUnit\Framework\TestCase
{
    public function testSimpleMock() {
        $mock = m::mock('simplemock');
        $mock->shouldReceive('foo')->with(5, m::any())->once()->andReturn(10);

        $this->assertEquals(10, $mock->foo(5));
    }

    public function tearDown() {
        m::close();
    }
}
```

Mockeryにはオートローダーが含まれていますので、
`require_once()`をテストで呼び出す必要はありません。これを利用するには、Mockeryを確実に`include_path`へ置き、テストスーツの`Bootstrap.php`や`TestHelper.php`ファイルへ以下のコードを追加してください。

``` php
require_once 'Mockery/Loader.php';
require_once 'Hamcrest/Hamcrest.php';

$loader = new \Mockery\Loader;
$loader->register();
```

Composerを使用している場合は、Composerが生成したオートローダーファイルを読み込むだけです。

``` php
require __DIR__ . '/../vendor/autoload.php'; // vendorディレクトリーが一段上の階層と仮定
```

 

> 注意：Hamcrest1.0.0より前のバージョンでは、`Hamcrest.php`ファイル名は小文字の\"h\"（たとえば`hamcrest.php`）でした。Hamcrestを1.0.0へアップグレードする場合は、全プロジェクトのファイル名を確認するのを忘れないでください。

MockeryをPHPUnitと統合し、closeメソッドの呼び出しと、コードカバレージメソッドからMockery自身を削除するには、
テストケースで`\Mockery\Adapter\Phpunit\MockeryTestCase`を拡張してください。

``` php
class MyTest extends \Mockery\Adapter\Phpunit\MockeryTestCase
{

}
```

提供しているトレイトを使用し、別の書き方もできます。

``` php
class MyTest extends \PHPUnit\Framework\TestCase
{
    use \Mockery\Adapter\Phpunit\MockeryPHPUnitIntegration;
}
```

`MockeryTestCase`を拡張するか、`MockeryPHPUnitIntegration`を使用するのは、Mockery1.0.0からMockeryとPHPUnitを統合するため、
**推奨している方法** です。

## PHPUnitリスナー

1.0.0より前のリリースでMockeryは、テストの最後で`Mockery::close()`を呼び出すためのPHPUnitリスナーを提供していました。

現在、`Mockery::close()`が呼び出されない場合にテストを失敗にするために、PHPUnitリスナーを提供しています。トレイトを使い忘れたり、`MockeryTestCase`を拡張し忘れたりしたケースを見分けるのに役立つでしょう。

PHPUnitのXML設定を使うアプローチの場合は、`TestListener`をロードするために、以下のコードを読み込んでください。

``` xml
<listeners>
    <listener class="\Mockery\Adapter\Phpunit\TestListener"></listener>
</listeners>
```

ComposerかMockeryのオートローダーをブートストラップファイルへ確実に用意するか、もしくは\"file\"属性が`TestListener`クラスを指すようにする必要があります。

> 注意：`TestListener`はPHPUnitバージョン６以降で動作します。
>
> PHPUnitのバージョン５以前では、テストリスナーは動作しません。

テストスーツをプログラマティックに生成している場合は、リスナーを以下のように追加できます。

``` php
// テストスーツの生成
$suite = new PHPUnit\Framework\TestSuite();

// リスナーを生成し、スーツへ追加する
$result = new PHPUnit\Framework\TestResult();
$result->addListener(new \Mockery\Adapter\Phpunit\TestListener());

// テストの実行
$suite->run($result);
```

 

> より独立性を高めるため、PHPUnitは[テストを個別のPHPプロセスで実行する](https://phpunit.de/manual/current/ja/appendixes.annotations.html#appendixes.annotations.runInSeparateProcess)機能を提供しています。Mockeryはモックのエクスペクションを`Mockery::close()`メソッドを使用し確認しており、各テストの終了時にこのメソッドを自動的に呼び出すために、PHPUnitリスナーを提供しています。
>
> しかしながら、このリスナーはPHPUnitのプロセスを個別で実行した場合、正しく呼び出されず、エクスペクションの結果は考慮されないため、`Mockery\Exception`は発生しません。これを防ぐには、Mockeryが提供するPHPUnitの`TestListener`は使用せず、明確に`Mockery::close`を呼び出す必要があります。簡単な解決策は、以前説明したとおりに、`tearDown()`メソッドの中でこれを呼び出します。
