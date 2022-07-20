::: index
single: Cookbook; モックオブジェクトの判定
:::

# モックオブジェクトの判定

与えられたオブジェクトが本当のオブジェクトなのか、それともそれをシミュレートするモックオブジェクトなのかをチェックできると便利です。Mockeryの全オブジェクトは
`\Mockery\MockInterface`インターフェイスを実装しており、タイプチェックに利用できます。

``` php
assert($mightBeMocked instanceof \Mockery\MockInterface);
```
