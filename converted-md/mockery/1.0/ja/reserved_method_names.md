::: {.index}
single: 予約メソッド名
:::

予約メソッド名
==============

お気づきでしょうが、Mockeryは全モックオブジェクトで直接呼び出す多くのメソッドを持っています。例えば、`shouldReceive()`です。こうしたメソッドはモックにエクスペクションを指定するために必要で、衝突が起きてしまうため、モックしようとしているクラスやオブジェクトで実装できません。（PHPのFatalエラーが発生します。）Mockeryで予約されているメソッドは、以下の通りです。

-   `shouldReceive()`
-   `shouldBeStrict()`

更に、全モックは追加のメソッドとプロテクトされたプロパティを使用しており、モックしようとしているクラスやオブジェクトでは使用できません。こちらは衝突する可能性は低いでしょう。全プロパティは`_mockery`、全メソッドは`mockery_`をプレフィックスとして名前につけています。