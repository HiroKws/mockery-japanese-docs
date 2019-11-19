::: {.index}
single: Cookbook; デフォルトのモックエクスペクション
:::

デフォルトのモックエクスペクション
==================================

しばしば、同じオブジェクトに依存する一連のテストを何度も行うことになります。それぞれのユニットテストごとに、クラス／オブジェクトをモックする代わりに（山のようなコードの繰り返しが必要です）、再利用可能なデフォルトモックをテストケースの`setup()`メソッドで定義してください。これは同じ、もしくは似たようなモックオブジェクトでエクスペクションを確認するユニットテストでも使えます。

これが利用できるのは、デフォルトのエクスペクションを持つモックを定義できるからです。定義後、ユニットテスト内で特定のテストを行うためにエクスペクションを追加したり、調整したりできます。どんなエクスペクションも、`byDefault()`宣言を使い、デフォルトとして指定できます。