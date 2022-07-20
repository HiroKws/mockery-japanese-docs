::: index
single: Cookbook; 強い依存のモック
:::

# 強い依存のモック

強い依存をモックする場合の前提の一つは、テストを行うコードがオートローディングを使用していることです。

例として、以下のコードを見てみましょう。

``` php
<?php
namespace App;
class Service
{
    function callExternalService($param)
    {
        $externalService = new Service\External();
        $externalService->sendSomething($param);
        return $externalService->getSomething();
    }
}
```

コードに手を加えることなく、これをテストできる方法は、[インスタンスモック](instance_mocking.html)へ`overload`プレフィックスを付け、生成することです。

``` php
<?php
namespace AppTest;
use Mockery as m;
class ServiceTest extends \PHPUnit_Framework_TestCase
{
    public function testCallingExternalService()
    {
        $param = 'Testing';

        $externalMock = m::mock('overload:App\Service\External');
        $externalMock->shouldReceive('sendSomething')
            ->once()
            ->with($param);
        $externalMock->shouldReceive('getSomething')
            ->once()
            ->andReturn('Tested!');

        $service = new \App\Service();

        $result = $service->callExternalService($param);

        $this->assertSame('Tested!', $result);
    }
}
```

これでこのテストを実行すれば、パスするでしょう。Mockeryは自身の仕事を行い、さらに本当のexternalサービスの代わりに、`App\Service`を使ったexternalをモックします。

これが問題となるのは、たとえば`App\Service\External`自身をテストしているか、このクラスを他のテストで使用したい場合です。

Mockeryがあるクラスをオーバーロードする場合、PHPのファイルの取り扱いにより、元のオーバーロードされるクラスを読み込んではいけません。そうしないと、\"class
already
exists\"例外が投げられます。これがオートローディングが取り入れられている理由であり、私達の負担を軽くしているのです。

クラスをオーバーロードするテストを可能にするには、PHPUnitへ別々のプロセスでテストを行い、グローバルステイトを防ぐ指示を行います。この方法により、クラスファイルを何度もオーバーロードするのを防げます。もちろん、副作用があり、テストの実行が遅くなることです。

上のテスト例は、次のようになります。

``` php
<?php
namespace AppTest;
use Mockery as m;
/**
 * @runTestsInSeparateProcesses
 * @preserveGlobalState disabled
 */
class ServiceTest extends \PHPUnit_Framework_TestCase
{
    public function testCallingExternalService()
    {
        $param = 'Testing';

        $externalMock = m::mock('overload:App\Service\External');
        $externalMock->shouldReceive('sendSomething')
            ->once()
            ->with($param);
        $externalMock->shouldReceive('getSomething')
            ->once()
            ->andReturn('Tested!');

        $service = new \App\Service();

        $result = $service->callExternalService($param);

        $this->assertSame('Tested!', $result);
    }
}
```

 

> {note}
> このクックブックエントリは、Robertにより書かれたブログ、[\"Mocking
> hard dependencies with
> Mockery\"](https://robertbasic.com/blog/mocking-hard-dependencies-with-mockery/)の基本部分を引用したものです。
