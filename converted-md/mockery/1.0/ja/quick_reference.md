::: {.index}
single: クイックリファレンス
:::

クイックリファレンス
====================

このページは、Mockeryの最も利用される機能を素早く理解してもらうために、短く概略を示すことを目的としています。

Mockeryの機能を全て学習するには、「[リファレンス](index.html#リファレンス)」を参照してください。

PHPUnitとMockeryを統合するか、`MockeryTestCase`を拡張してください。

``` {.php}
use \Mockery\Adapter\Phpunit\MockeryTestCase;

class MyTest extends MockeryTestCase
{
}
```

もしくは、`MockeryPHPUnitIntegration`トレイトを使用します。

``` {.php}
use \PHPUnit\Framework\TestCase;
use \Mockery\Adapter\Phpunit\MockeryPHPUnitIntegration;

class MyTest extends TestCase
{
    use MockeryPHPUnitIntegration;
}
```

テストダブル（代替物）を作成するには：

``` {.php}
$testDouble = \Mockery::mock('MyClass');
```

特定のインターフェイスを実装したテストダブルを作成するには：

``` {.php}
$testDouble = \Mockery::mock('MyClass, MyInterface');
```

テストダブルでメソッドが呼び出されるのを期待するには：

``` {.php}
$testDouble = \Mockery::mock('MyClass');
$testDouble->shouldReceive('foo');
```

テストダブルでメソッドが呼び出され **ない** のを期待するには：

``` {.php}
$testDouble = \Mockery::mock('MyClass');
$testDouble->shouldNotReceive('foo');
```

テストダブルでメソッドが一回(once)、特定の引数で呼び出され、ある値を返すのを期待するには：

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->once()
    ->with($arg)
    ->andReturn($returnValue);
```

テストダブルでメソッドが呼び出され、成功した呼び出しごとに異なった値が返されることを期待するには：

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->andReturn(1, 2, 3);

$mock->foo(); // int(1);
$mock->foo(); // int(2);
$mock->foo(); // int(3);
$mock->foo(); // int(3);
```

部分的なランタイムテストダブルを生成するには：

``` {.php}
$mock = \Mockery::mock('MyClass')->makePartial();
```

スパイを生成するには：

``` {.php}
$spy = \Mockery::spy('MyClass');
```

スパイでメソッドの呼び出しが必ず行われるのを期待するには：

``` {.php}
$spy = \Mockery::spy('MyClass');

$spy->foo();

$spy->shouldHaveReceived()->foo();
```

簡単ではない例
--------------

一連のメソッド呼び出しにより、連続した値が返されるモックオブジェクトを生成するには：

``` {.php}
use \Mockery\Adapter\Phpunit\MockeryTestCase;

class SimpleTest extends MockeryTestCase
{
    public function testSimpleMock()
    {
        $mock = \Mockery::mock(array('pi' => 3.1416, 'e' => 2.71));
        $this->assertEquals(3.1416, $mock->pi());
        $this->assertEquals(2.71, $mock->e());
    }
}
```

あるメソッドコールで自身にチェーンし、未定義(Undefined)のオブジェクトを返すモックオブジェクトを生成するには：

``` {.php}
use \Mockery\Adapter\Phpunit\MockeryTestCase;

class UndefinedTest extends MockeryTestCase
{
    public function testUndefinedValues()
    {
        $mock = \Mockery::mock('mymock');
        $mock->shouldReceive('divideBy')->with(0)->andReturnUndefined();
        $this->assertTrue($mock->divideBy(0) instanceof \Mockery\Undefined);
    }
}
```

複数のquery呼び出しと、一回のupdate呼び出しのモックオブジェクトを生成するには：

``` {.php}
use \Mockery\Adapter\Phpunit\MockeryTestCase;

class DbTest extends MockeryTestCase
{
    public function testDbAdapter()
    {
        $mock = \Mockery::mock('db');
        $mock->shouldReceive('query')->andReturn(1, 2, 3);
        $mock->shouldReceive('update')->with(5)->andReturn(NULL)->once();

        // ここにモックを使ったテストコード…
    }
}
```

updateの前に、全queryが実行されるのを期待するには：

``` {.php}
use \Mockery\Adapter\Phpunit\MockeryTestCase;

class DbTest extends MockeryTestCase
{
    public function testQueryAndUpdateOrder()
    {
        $mock = \Mockery::mock('db');
        $mock->shouldReceive('query')->andReturn(1, 2, 3)->ordered();
        $mock->shouldReceive('update')->andReturn(NULL)->once()->ordered();

        // ここにモックを使ったテストコード…
    }
}
```

startupの後に全queryが実行され、finishの前に多くの異なった引数でそれらのqueryが実行されることを期待するモックを作成するには：

``` {.php}
use \Mockery\Adapter\Phpunit\MockeryTestCase;

class DbTest extends MockeryTestCase
{
    public function testOrderedQueries()
    {
        $db = \Mockery::mock('db');
        $db->shouldReceive('startup')->once()->ordered();
        $db->shouldReceive('query')->with('CPWR')->andReturn(12.3)->once()->ordered('queries');
        $db->shouldReceive('query')->with('MSFT')->andReturn(10.0)->once()->ordered('queries');
        $db->shouldReceive('query')->with(\Mockery::pattern("/^....$/"))->andReturn(3.3)->atLeast()->once()->ordered('queries');
        $db->shouldReceive('finish')->once()->ordered();

        // ここにモックを使ったテストコード…
    }
}
```
