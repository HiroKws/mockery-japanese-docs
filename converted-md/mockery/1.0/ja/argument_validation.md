::: {.index}
single: 引数のバリデーション
:::

引数のバリデーション
====================

エクスペクションの準備時に、`with()`宣言へ渡された引数は、エクスペクションと一致するメソッドの基準として判定されます。それにより、期待する引数がそれぞれ異なる、多くのエクスペクションを一つのメソッドに指定できます。このような引数のマッチングは、「一番フィットする」を基本に行われます。これにより、曖昧なマッチャーより明確なマッチャーが優先されます。

明確なマッチとは、引数が期待され、実際の引数が（たとえば、`===`や`==`を使用し）簡単に同一視できることを単に示します。より曖昧なマッチャーは、正規表現やクラスヒント、一般的なマッチャー
などです。曖昧なマッチャーの目的は、明確でない場合の引数を定義することで、`with()`にその場所の
**どんな** 引数とも一致する`Mockery::any()`が一例です。

Mockeryの曖昧マッチャーは、可能性を全てカバーできませんが、マッチャーのHamcrestライブラリーをサポートしています。Hamcrestは同じ名前のJava（やPython、Erlangなど）のライブラリーをPHPへ移植したものです。Hamcrestを使用することで、MockeryはHamcrestが宣伝している自然な英語のDSLという印象深い利点を再開発せずに済んでいます。

以下の例では、Mocheryのマッチャーと、存在する場合はHamcrestの同じ働きのマッチャーを示します。Hamcrestは（名前空間なしの）関数を使用しています。

> {note}
> グローバルなHamcrest関数を使用したくない場合、静的メソドッドは全て`\Hamcrest\Matchers`クラスを通じて利用できます。たとえば、`identicalTo($arg)`は、`\Hamcrest\Matchers::identicalTo($arg)`とおなじです。

最も汎用されるマッチャーは、`with()`です。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->with(1):
```

これはMockeryに対し、引数に`1`を渡された`foo`メソッドの呼び出しを受け取ることを伝えています。このようなケースでは、Mockeryはまず引数の比較に`===`（厳密な比較）演算子を使用します。引数がプリミティブで、厳密な比較で不一致の場合、Mockeryは`==`（緩やかな比較）演算子をフォールバックとして使用します。

オブジェクトの引数のマッチングでは、Mockeryは厳密な`===`比較だけを行いますので、全く同じ`$object`のみ一致します。

``` {.php}
$object = new stdClass();
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive("foo")
    ->with($object);

// Hamcrestの同じ動作をするマッチャー
$mock->shouldReceive("foo")
    ->with(identicalTo($object));
```

別の`stdClass`インスタンスは、一致 **しません** 。

> {note} `Mockery\Matcher\MustBe`マッチャーは使用されなくなりました。

オブジェクトに対してゆるい比較が必要であれば、Hamcrestの`equalTo`マッチャーを使用します。

``` {.php}
$mock->shouldReceive("foo")
    ->with(equalTo(new stdClass));
```

引数のタイプや値は気にかけず、どんな引数でも構わない場合、`any()`を使用します。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive("foo")
    ->with(\Mockery::any());

// Hamcrestの同じ動作をするマッチャー
$mock->shouldReceive("foo")
    ->with(anything())
```

この引数の場所にはどんなものでも全て渡せ、制約はありません。

タイプとリソースのバリデーション
--------------------------------

`type()`マッチャーは文字列を引数に取り、
タイプチェックを検査する`is_`形式の関数でマッチングします。

PHPリソースであるかをマッチングするには、以下のように行なえます。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive("foo")
    ->with(\Mockery::type('resource'));

// Hamcrestの同じ動作をするマッチャー
$mock->shouldReceive("foo")
    ->with(resourceValue());
$mock->shouldReceive("foo")
    ->with(typeOf('resource'));
```

メソッドに指定した引数がPHPのリソースの場合、`is_resource()`を呼び出し、`true`が返ってきます。たとえば、`\Mockery::type('float')`やHamcrestの`floatValue()`、`typeOf('float')`チェックでは、`is_float()`が使用され、`\Mockery::type('callable')`やHamcrest`callable()`では、`is_callable()`を使用します。

`type()`マッチャーは、クラスやインターフェイス名も引数に取り、実際の引数を`instanceof`で評価するために使用します。Hamcrestでは、`anInstanceOf()`を使います。

タイプチェッカーの全リストは、[php.net](http://www.php.net/manual/ja/ref.var.php)を参照するか、Hamcrestの関数リスト、[the
Hamcrest
code](https://github.com/hamcrest/hamcrest-php/blob/master/hamcrest/Hamcrest.php)を閲覧してください。

複雑な引数のバリデーション
--------------------------

複雑な引数のバリデーションを行いたい場合は、`on()`マッチャーがとても役立ちます。これは実際の引数が渡されるクロージャ（無名関数）を引数に取ります。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive("foo")
    ->with(\Mockery::on(closure));
```

クロージャの評価（例えば返却値）が、論理型の`true`であれば、その引数はエクスペクションと一致すると判断されます。

``` {.php}
$mock = \Mockery::mock('MyClass');

$mock->shouldReceive('foo')
    ->with(\Mockery::on(function ($argument) {
        if ($argument % 2 == 0) {
            return true;
        }
        return false;
    }));

$mock->foo(4); // エクスペクションと一致
$mock->foo(3); // NoMatchingExpectationExceptionを投げる
```

 

> {note} `on()`にあたる、Hamcrestバージョンのマッチャーは存在しません。

渡されたクロージャで、引数のバリデーションを実行する`withArgs()`メソッドも使用できます。クロージャは期待されているメソッドに渡された全引数を受け取り、その評価（例えば返却値）が論理型の`true`の場合、引数のリストはエクスペクションと一致したと判断します。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive("foo")
    ->withArgs(closure);
```

クロージャはオプショナルな引数も処理でき、期待しているメソッド呼び出しでオプショナルな引数が指定されない場合でも、引数のリストがエクスペクションと一致しないと判定されるのを防ぐことができます。

``` {.php}
$closure = function ($odd, $even, $sum = null) {
    $result = ($odd % 2 != 0) && ($even % 2 == 0);
    if (!is_null($sum)) {
        return $result && ($odd + $even == $sum);
    }
    return $result;
};

$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')->withArgs($closure);

$mock->foo(1, 2); // オプショナル引数は必須ではない、エクスペクションと一致する
$mock->foo(1, 2, 3); // オプショナル引数はバリデーションに成功、エクスペクションと一致する
$mock->foo(1, 2, 4); // オプショナル引数がバリデーションに失敗、エクスペクションと一致しない
```

 

> {note}
> 以前のバージョンのMockeryで、`with()`は引数に対するパターンマッチングを試みました。引数は正規表現だと仮定していました。これは何度も素晴らしいアイデアではないと証明されたため、この機能は削除し、代わりに`Mockery::pattern()`を導入しました。

引数が正規表現と一致するかを調べたい場合は、`\Mockery::pattern()`を使います。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->with(\Mockery::pattern('/^foo/'));

// Hamcrestの同じ動作をするマッチャー
$mock->shouldReceive('foo')
    with(matchesPattern('/^foo/'));
```

`ducktype()`マッチャーは、クラスタイプのマッチングの別型です。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->with(\Mockery::ducktype('foo', 'bar'));
```

呼び出すリスト上のメソッドを含んでいるオブジェクトと一致します。

> {note}
> Hamcrestバージョンには、`ducktype()`に当たるマッチャーは存在しません。

追加の引数マッチャー
--------------------

`not()`マッチャーは、引数と等しくない、もしくは異なる引数であればマッチします。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->with(\Mockery::not(2));

// Hamcrestの同じ動作をするマッチャー
$mock->shouldReceive('foo')
    ->with(not(2));
```

`anyOf()`マッチャーは、指定した引数のどれかと一致する場合にマッチします。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->with(\Mockery::anyOf(1, 2));

// Hamcrestの同じ動作をするマッチャー
$mock->shouldReceive('foo')
    ->with(anyOf(1,2));
```

`notAnyOf()`マッチャーは、指定した引数のどれとも一致しない、もしくは同じでない場合にマッチします。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->with(\Mockery::notAnyOf(1, 2));
```

 

> {note} Hamcrestバージョンの`notAnyOf()`マッチャーはありません。

`subset()`は指定した配列のサブセットを含んでいる、引数の配列と一致します。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->with(\Mockery::subset(array(0 => 'foo')));
```

これは、キーと値の両方の一致を強要します。例えば、実際の引数で各要素のキーと値を比較します。

> {note}
> この機能はHamcrestバージョンがありません。しかし、Hamcrestでは`hasEntry()`か`hasKeyValuePair()`で、一つの要素をチェックできます。

`contains()`マッチャーはリストした値を含んでいる配列と一致します。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->with(\Mockery::contains(value1, value2));
```

キーは無視されます。

`hasKey()`マッチャーは、指定したキー値を含んでいる配列と一致します。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->with(\Mockery::hasKey(key));
```

`hasValue()`マッチャーは、指定した値を含んでいる配列と一致します。

``` {.php}
$mock = \Mockery::mock('MyClass');
$mock->shouldReceive('foo')
    ->with(\Mockery::hasValue(value));
```
