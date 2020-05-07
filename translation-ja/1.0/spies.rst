.. index::
    single: Reference; スパイ

スパイ
=====

スパイはテストダブルの一タイプですが、スタブやモックとは異なり、スパイはスパイとSUT(System Under Test)間のやり取りを記憶し、後ほどやり取りをアサートできるようにするものです。

スパイを生成することが意味するのは、そのダブルがテストの間に受け取るメソッドコールに対してエクスペクションを指定できないということです。エクスペクションのいくつかは、現在のテストとは関連がないことがあります。スパイはこのテストに対してのみ調べたい呼び出しをアサートでき、指定のしすぎになる機会を減らし、テストをより明確にできます。

スパイはテストにおける、よりわかりやすいArrange-Act-Assertや、Given-When-Thenスタイルにより適しています。モックではわかりやすいスタイルが薄れ、Arrange-Expect-Act-Assertの長い行になり、SUTに対し行動を起こす前に何を期待しているのかモックへ指示し、それからエクスペクションが一致したことをアサートする必要があります。

.. code-block:: php

    // arrange（準備）
    $mock = \Mockery::mock('MyDependency');
    $sut = new MyClass($mock);

    // expect（期待）
    $mock->shouldReceive('foo')
        ->once()
        ->with('bar');

    // act（実行）
    $sut->callFoo();

    // assert（アサート）
    \Mockery::close();

スパイでは期待(expect）の部分を飛ばせ、SUTに対して実行した後にアサートへ移動でき、通常テストがより読みやすくなります。

.. code-block:: php

    // arrange（準備）
    $spy = \Mockery::spy('MyDependency');
    $sut = new MyClass($spy);

    // act（実行）
    $sut->callFoo();

    // assert（アサート）
    $spy->shouldHaveReceived()
        ->foo()
        ->with('bar');

逆に言えば、スパイはモックより非常に限定的です。つまりテストは通常さほど精密ではなく、スパイは複雑になることを防いでくれます。これは通常は良いことで、必要に応じて精密に行うべきなのです。スパイはテストの意図を明確にする一方で、SUTの設計の明確さを少し隠す傾向があります。多くの異なったテストで、モックに多くのエクスペクションを指定していたら、テストは私達に何かを伝えようとしています。SUTはやりすぎていて、多分リファクタリングが必要だということを。スパイでは、これはわかりません。なぜなら、関連ない呼び出しをシンプルに無視するからです。

スパイの良くないもう一つの面は、デバッグです。期待しない呼び出しを受けると、モックはすぐに例外を投げ、きれいなスタックトレースか、デバッガーを起動することさえあります。（素早く失敗します。）スパイの場合、実行後にシンプルに呼び出しをアサートするので、間違った呼び出しが行われても、モックのようにその時点で同じような手助けの情報を得られません。

最後に、テストダブルに返り値を定義する必要がある場合、スパイでは行えません。モックオブジェクトだけで行えます。

    {note} このドキュメンページは、Dave Marshallのブログ、タイトルは`"Mockery Spies" <https://davedevelopment.co.uk/2014/10/09/mockery-spies.html>`_,から取ったものです。Dave MarshallはMockeryのスパイの初めの作者です。

スパイリファレンス
---------------

スパイでメソッドコールを確認する場合、``shouldHaveReceived()``メソッドを使用します。

.. code-block:: php

    $spy->shouldHaveReceived('foo');

スパイでメソッドが呼び出され **ない** ことを確認するには、``shouldNotHaveReceived()``メソッドを使用します。

.. code-block:: php

    $spy->shouldNotHaveReceived('foo');

スパイでも、引数のマッチングが行なえます。

.. code-block:: php

    $spy->shouldHaveReceived('foo')
        ->with('bar');

引数のマッチングは、マッチさせる引数の配列を渡すことでも可能です。

.. code-block:: php

    $spy->shouldHaveReceived('foo', ['bar']);

メソッドが呼び出されないことを検査する場合でも、``shouldNotHaveReceived()``メソッドの第２引数に引数の配列を指定することで、検査できます。

.. code-block:: php

    $spy->shouldNotHaveReceived('foo', ['bar']);

これはMockeryの内部構造によります。

最後に、呼び出しの受け取りを期待する時、実行回数を調べることもできます。

.. code-block:: php

    $spy->shouldHaveReceived('foo')
        ->with('bar')
        ->twice();

shouldReceiveの別型
^^^^^^^^^^^^^^^^^^

Mockerのshould*メソッドのように文字列ではなく、Mockery1.0.0よりPHPメソッドを呼び出すような指定方法をサポートします。

スパイの場合、これは``shouldHaveReceived()``メソッドだけに適用されます。

.. code-block:: php

    $spy->shouldHaveReceived()
        ->foo('bar');

同様に、呼び出し回数のエクスペクションをセットできます。

.. code-block:: php

    $spy->shouldHaveReceived()
        ->foo('bar')
        ->twice();

残念ながら制限により、``shouldNotHaveReceived()``メソッドに対して同様なサポートはできません。
