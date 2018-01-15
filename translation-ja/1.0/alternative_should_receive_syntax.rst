.. index::
    single: shouldReceiveのバリエーション

shouldReceiveのバリエーション
================================

Mockerの``should*``メソッドのように文字列ではなく、Mockery1.0.0よりPHPメソッドを呼び出すような指定方法をサポートします。

``allows()``と``expects()``、２つのMockeryメソッドが利用できます。

Allows
------

あらかじめメソッドの戻り値を定義できるが、何回呼び出されるか、もしくは呼び出されないかを問わないスタブを作成する場合は、``allows()``を使用します。

.. code-block:: php

    $mock = \Mockery::mock('MyClass');
    $mock->allows([
        'name_of_method_1' => 'return value',
        'name_of_method_2' => 'return value',
    ]);

これは次の``shouldReceive``と同じ動作をします。

.. code-block:: php

    $mock = \Mockery::mock('MyClass');
    $mock->shouldReceive([
        'name_of_method_1' => 'return value',
        'name_of_method_2' => 'return value',
    ]);

この形式では、Mockeryに対しスタブメソッドの引数は、何でもかまわないと指示していることに注目してください。

引数を指定する場合は次のようになります。

.. code-block:: php

    $mock = \Mockery::mock('MyClass');
    $mock->allows()
        ->name_of_method_1($arg1)
        ->andReturn('return value');

これは次の``shouldReceive``と同じ動作をします。

.. code-block:: php

    $mock = \Mockery::mock('MyClass');
    $mock->shouldReceive('name_of_method_1')
        ->with($arg1)
        ->andReturn('return value');

Expects
-------

特定のメソッドが呼び出されるのを確認したい場合は、``expects()``を使います。

.. code-block:: php

    $mock = \Mockery::mock('MyClass');
    $mock->expects()
        ->name_of_method_1($arg1)
        ->andReturn('return value');

これは次の``shouldReceive``と同じ動作をします。

.. code-block:: php

    $mock = \Mockery::mock('MyClass');
    $mock->shouldReceive('name_of_method_1')
        ->once()
        ->with($arg1)
        ->andReturn('return value');

``expects()``はデフォルトで、そのメソッドを一回のみ呼び出すエクスペクションを設定します。２回以上メソッドが呼び出されるのを期待する場合は、エクスペクションを変更できます。

.. code-block:: php

    $mock = \Mockery::mock('MyClass');
    $mock->expects()
        ->name_of_method_1($arg1)
        ->twice()
        ->andReturn('return value');

