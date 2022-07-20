::: index
single: Mocking; protectedメソッド
:::

# protectedメソッドのモック

デフォルトでは、Mockeryはprotectedメソッドのモックを行えません。protectedメソッドのモックは推奨していませんが、他に手段がない場合があります。

そうしたケースのため、`shouldAllowMockingProtectedMethods()`メソッドがあります。これはMockeryへそのクラスだけprotectedメソッドのモックを特別に許すように指示します。

``` php
class MyClass
{
    protected function foo()
    {
    }
}

$mock = \Mockery::mock('MyClass')
    ->shouldAllowMockingProtectedMethods();
$mock->shouldReceive('foo');
```
