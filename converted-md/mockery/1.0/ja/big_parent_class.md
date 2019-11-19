::: {.index}
single: Cookbook; 大きな親クラス
:::

大きな親クラス
==============

あるアプリケーションのコード、特に古いレガシーなコードで、「大きな親クラス」を拡張しているクラスに出会うことがあります。親クラスは知りすぎており、多くをやりすぎています。

``` {.php}
class BigParentClass
{
    public function doesEverything()
    {
        // データベース接続のセットアップ
        // ログファイルの書き込み
    }
}

class ChildClass extends BigParentClass
{
    public function doesOneThing()
    {
        // BigParentClassメソッドを呼び出すしかない
        $result = $this->doesEverything();
        // 何かが行われ、結果は$result
        return $result;
    }
}
```

`ChildClass`と`doesOneThing`メソッドをテストしたいわけですが、問題は`BigParentClass::doesEverything()`を呼び出していることです。これを処理す一つの方法は、依存している`BigParentClass`が持ち、必要としている
**すべて**
をモックし尽くして、それから`doesOneThing`メソッドを実際にテストすることです。これを行うのは、やたらに作業が大きくなります。

何かできること、それは何か...型破りなことをしましょう。`ChildClass`自身のランタイムパーシャルテストダブルを生成し、親の`doesEverything()`メソッドのみをモックします。

``` {.php}
$childClass = \Mockery::mock('ChildClass')->makePartial();
$childClass->shouldReceive('doesEverything')
    ->andReturn('some result from parent');

$childClass->doesOneThing(); // string("some result from parent");
```

このアプローチで、`doesEverything()`メソッドのみをモックでき、モックしないメソッドの呼び出しは、すべて実際の`ChildClass`インスタンスに対し行われます。
