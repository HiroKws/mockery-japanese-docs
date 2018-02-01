.. index::
    single: シンプルな例

シンプルな例
==============

平均気温をレポートするために、ある地方の気温を測定する``Temperature``クラスがあるとイメージしてください。そのデーターはWebサービスから取得しても、他の情報源から取得してもかまいません。ですが現在手元にありません。しかし``Temperature``クラスとのやり取りに基づき、それらのクラスの基本的なやり取りを仮定することはできます。

.. code-block:: php

    class Temperature
    {
        private $service;

        public function __construct($service)
        {
            $this->service = $service;
        }

        public function average()
        {
            $total = 0;
            for ($i=0; $i<3; $i++) {
                $total += $this->service->readTemp();
            }
            return $total/3;
        }
    }

実際のサービスクラスが無くても、どのような操作が行われることが期待されるか理解できます。``Temperature``クラスに対するテストを書くには、実際に必要な具象サービスのインスタンスが存在しなくても、振る舞いをテストするため今のところは、本物のサービスをモックオブジェクトで置き換えておくことは可能です。

.. code-block:: php

    use \Mockery;

    class TemperatureTest extends PHPUnit_Framework_TestCase
    {
        public function tearDown()
        {
            Mockery::close();
        }

        public function testGetsAverageTemperatureFromThreeServiceReadings()
        {
            $service = Mockery::mock('service');
            $service->shouldReceive('readTemp')
                ->times(3)
                ->andReturn(10, 12, 14);

            $temperature = new Temperature($service);

            $this->assertEquals(12, $temperature->average());
        }
    }

``Temperature``クラスのモックオブジェクトを作成し、これを用いて``readTemp``メソッドを３回呼び出し、結果として10、12、14を返すというエクスペクション（期待）を設定しました。

  {note} PHPUnitの統合により、``tearDown()``メソッドが必要なくなります。「`PHPUnit統合 <phpunit_integration>`_」で詳細を確認してください。
