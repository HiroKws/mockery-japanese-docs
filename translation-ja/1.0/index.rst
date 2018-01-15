Mockery
=======

Mockery is a simple yet flexible PHP mock object framework for use in unit
testing with PHPUnit, PHPSpec or any other testing framework. Its core goal is
to offer a test double framework with a succinct API capable of clearly
defining all possible object operations and interactions using a human
readable Domain Specific Language (DSL). Designed as a drop in alternative to
PHPUnit's phpunit-mock-objects library, Mockery is easy to integrate with
PHPUnit and can operate alongside phpunit-mock-objects without the World
ending.

Mock Objects
------------

In unit tests, mock objects simulate the behaviour of real objects. They are
commonly utilised to offer test isolation, to stand in for objects which do
not yet exist, or to allow for the exploratory design of class APIs without
requiring actual implementation up front.

The benefits of a mock object framework are to allow for the flexible
generation of such mock objects (and stubs). They allow the setting of
expected method calls and return values using a flexible API which is capable
of capturing every possible real object behaviour in way that is stated as
close as possible to a natural language description.

Getting Started
---------------

Ready to dive into the Mockery framework? Then you can get started by reading
the "Getting Started" section!

* `インストール <installation.html>`_
* `アップグレード <upgrading.html>`_
* `シンプルな例 <simple_example.html>`_
* `クイックリファレンス <quick_reference.html>`_

Reference
---------

The reference contains a complete overview of all features of the Mockery
framework.

* `テストダブル作成 <creating_test_doubles.html>`_
* `エクスペクション <expectations.html>`_
* `引数のバリデーション <argument_validation.html>`_
* `shouldReceive別型 <alternative_should_receive_syntax.html>`_
* `スパイ <spies.html>`_
* `部分モック <partial_mocks.html>`_
* `Protectedメソッド <protected_methods.html>`_
* `Publicプロパティ <public_properties.html>`_
* `Public静的プロパティ <public_static_properties.html>`_
* `参照動作により渡す <pass_by_reference_behaviours.html>`_
* `デメテルチェーン <demeter_chains.html>`_
* `Finalメソッドクラス <final_methods_classes.html>`_
* `Magicメソッド <magic_methods.html>`_
* `PHPUnitとの統合 <phpunit_integration.html>`_

Mockery
-------

Learn about Mockery's configuration, reserved method names, exceptions...

* `設定 <configuration.html>`_
* `例外 <exceptions.html>`_
* `予約メソッド名 <reserved_method_names.html>`_
* `Gotchas <gotchas.html>`_

Cookbook
--------

Want to learn some easy tips and tricks? Take a look at the cookbook articles!

* `既定エクスペクション <default_expectations.html>`_
* `モックオブジェクト判定 <detecting_mock_objects.html>`_
* `コンストラクタ非実行 <not_calling_the_constructor.html>`_
* `強い依存のモック <mocking_hard_dependencies.html>`_
* `クラス定数 <class_constants.html>`_
* `大きなParentクラス <big_parent_class.html>`_
* `複雑な引数マッチ <mockery_on.html>`_
