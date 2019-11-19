::: {.index}
single: 例外
:::

Mockeryの例外
=============

Mockeryはモックオブジェクトの確認に失敗した場合、３タイプの例外を投げます。

1.  `\Mockery\Exception\InvalidCountException`
2.  `\Mockery\Exception\InvalidOrderException`
3.  `\Mockery\Exception\NoMatchingExpectationException`

例外のメッセージとして渡される特定の情報を調べたり、ログしたり、出力を再フォーマットする場合に便利なゲッターで個別に情報を得るために、これらの例外をtry\...catchブロックで補足することができます。

MockeryExceptionInvalidCountException
-------------------------------------

この例外は、実行回数が多すぎる／少なすぎる場合に使用されます。以下のメソッドを提供しています。

-   `getMock()` - 実際のモックオブジェクトを返す
-   `getMockName()` - モックオブジェクトの名前を返す
-   `getMethodName()` - 失敗した例外が投げられたメソッドの名前を返す
-   `getExpectedCount()` - 期待していた呼び出し回数を返す
-   `getExpectedCountComparative()` - 文字列を返す、例 : `<=`
    実際の回数と比較するために使用する
-   `getActualCount()` -
    指定した引数の制約により、実際に呼び出された回数

MockeryExceptionInvalidOrderException
-------------------------------------

この例外クラスは、`ordered()`と`globally()`エクスペクションモディファイヤによる、期待している実行順序から、メソッドの呼び出し順が外れたときに使用されます。以下のメソッドを提供しています。

-   `getMock()` - 実際のモックオブジェクトを返す
-   `getMockName()` - モックオブジェクトの名前を返す
-   `getMethodName()` - 失敗した例外が投げられたメソッドの名前を返す
-   `getExpectedOrder()` -
    実行が期待されていたか呼び出しのインデックスを表す整数値を返す
-   `getActualOrder()` - 実行されたメソッド呼び出しのインデックスを返す

MockeryExceptionNoMatchingExpectationException
----------------------------------------------

この例外は、メソッドコールが既知のエクスペクションと一致しない場合に使用されます。全てのエクスペクションは、メソッド名と期待している引数のリストにより、一意に識別されます。この振る舞いをやめ、すでに説明したshouldIgnoreMissing()振る舞いモディファイヤを使用することにより、期待外のメソッドコール時にNULLを返すこともできます。この例外は以下のメソッドを提供します。

-   `getMock()` - 実際のモックオブジェクトを返す
-   `getMockName()` - モックオブジェクトの名前を返す
-   `getMethodName()` - 失敗した例外が投げられたメソッドの名前を返す
-   `getActualArguments()` -
    一致するエクスペクションを検索するために使用された、実際の引数を返す
