.. index::
    single: 参照渡しメソッド引数の振る舞い

参照渡しメソッド引数の振る舞いの保持
==============================

PHPのクラスメソッドは参照私による引数を受け付けます。この場合、引数（メソッドに渡されたオリジナル変数への参照）に対する変化は、オリジナルの変数に反映されます。例をご覧ください。

.. code-block:: php

    class Foo
    {

        public function bar(&$a)
        {
            $a++;
        }

    }

    $baz = 1;
    $foo = new Foo;
    $foo->bar($baz);

    echo $baz; // 整数の２をechoする

上記の例の場合、``$baz``変数は参照渡し（引数の前の``&``文字に気が付きましたか？）で``Foo::bar()``メソッドに渡されています。``bar()``に変化が起きると、参照渡しではオリジナルの``$baz``に反映されます。

Mockeryは引数で参照の使用を分析できる箇所では、全てのメソッドを正しく処理します。（``Reflection``を使用）クラスメソッドにより、どのように参照が操作されるかをモックするには、たとえば``\Mockery::on()``でクロージャー引数マッチャーが利用できます。`複雑な引数のバリデーション<argument_validation.html#複雑な引数のバリデーション>`_章をご覧ください。

（PHPの制限により）``Reflection``を使用したメソッドパラメータの分析ができない、内部PHPクラスは例外です。これを解決するには、``\Mockery\Configuration::setInternalClassMethodParamMap()``を使用し、内部クラスのメソッドパラメータを明示的に宣言します。

``MongoCollection::insert()``を使用した例をご覧ください。``MongoCollection``はPECLのmongo拡張により提供される内部クラスです。``insert()``メソッドは最初の引数としてデータの配列を受け取り、オプショナルな配列を第２引数に受け取ります。（たとえば、参照渡しの引数が``insert()``されることにより）新しい``_id``フィールドを含むために、オリジナルデータ配列は更新されます。（Mockeryへ引数が参照渡しされることを指示することにより）この振る舞いを引数マップの設定を使用することでモックできます。そして更新されることを期待しているメソッド引数へ``Closure``をアタッチできます。

この参照渡しの動作が保持されていることを検査するPHPUnitのユニットテストをご覧ください。

.. code-block:: php

    public function testCanOverrideExpectedParametersOfInternalPHPClassesToPreserveRefs()
    {
        \Mockery::getConfiguration()->setInternalClassMethodParamMap(
            'MongoCollection',
            'insert',
            array('&$data', '$options = array()')
        );
        $m = \Mockery::mock('MongoCollection');
        $m->shouldReceive('insert')->with(
            \Mockery::on(function(&$data) {
                if (!is_array($data)) return false;
                $data['_id'] = 123;
                return true;
            }),
            \Mockery::any()
        );

        $data = array('a'=>1,'b'=>2);
        $m->insert($data);

        $this->assertTrue(isset($data['_id']));
        $this->assertEquals(123, $data['_id']);

        \Mockery::resetContainer();
    }

protectedメソッド
----------------

protectedメソッドを使用しており、参照渡しの振る舞いを保持しようとする場合は、異なったアプローチが必要です。

.. code-block:: php

    class Model
    {
        public function test(&$data)
        {
            return $this->doTest($data);
        }

        protected function doTest(&$data)
        {
            $data['something'] = 'wrong';
            return $this;
        }
    }

    class Test extends \PHPUnit\Framework\TestCase
    {
        public function testModel()
        {
            $mock = \Mockery::mock('Model[test]')->shouldAllowMockingProtectedMethods();

            $mock->shouldReceive('test')
                ->with(\Mockery::on(function(&$data) {
                    $data['something'] = 'wrong';
                    return true;
                }));

            $data = array('foo' => 'bar');

            $mock->test($data);
            $this->assertTrue(isset($data['something']));
            $this->assertEquals('wrong', $data['something']);
        }
    }

これは極めてまれなケースですので、オリジナルのコードを多少変更する必要があります。protectedメソッドを呼び出すpublicメソッドを作成しました。それから、protectedメソッドの代わりに、publicメソッドをモックしています。この新しいpublicメソッドはprotectedメソッドのプロキシとして動作します。
