Mockery
=======

Mockeryはシンプルながら柔軟な、PHPモックオブジェクトフレームワークです。PHPUnitやPHPSpecなどのテストフレームワークと一緒にユニットテストで使用します。主なゴールは、可能性のある全てのオブジェクト操作を明確に定義できる簡潔なAPIと、人間が読み取れるDSL(Domain Specific Language)を使用した統合を提供することです。PHPUnitのphpunit-mock-objectsライブラリーの簡単に利用できる代替として設計しました。MockeryはPHPUnitと簡単に統合でき、難しさに絶望しなくともphpunit-mock-objectsと一緒に操作可能です。

モックオブジェクト
------------

モックオブジェクトはユニットテストで、実際のオブジェクトの振る舞いをシミュレートするものです。一般にテストの独立性を保つために使用され、まだ存在していないオブジェクトの代わりをさせたり、実装することなくクラスAPIの設計を探求したりするために使用します。

モックオブジェクトフレームワークの利点は、このようなモック（とスタブ）を柔軟に生成可能なことです。自然言語での説明にできるだけ近い方法で、実際のオブジェクトの振る舞い全ての可能性を捉えられる柔軟なAPIを使用し、期待するメソッドの呼び出しや、返される値を定義できます。

利用開始
---------------

Mockeryフレームワークへ飛び込む準備はできましたか？それでは、「利用開始」セクションを読めば、初められますよ。

* `インストール <installation.html>`_
* `アップグレード <upgrading.html>`_
* `シンプルな例 <simple_example.html>`_
* `クイックリファレンス <quick_reference.html>`_

リファレンス
---------

リファレンスセクションでは、Mockeryフレームワーク全機能の完全な概念を紹介します。

* `テストダブル作成 <creating_test_doubles.html>`_
* `エクスペクション <expectations.html>`_
* `引数のバリデーション <argument_validation.html>`_
* `shouldReceive別型 <alternative_should_receive_syntax.html>`_
* `スパイ <spies.html>`_
* `部分モック <partial_mocks.html>`_
* `Protectedメソッド <protected_methods.html>`_
* `Publicプロパティ <public_properties.html>`_
* `Public静的プロパティ <public_static_properties.html>`_
* `参照渡しの引数 <pass_by_reference_behaviours.html>`_
* `デメテルチェーン <demeter_chains.html>`_
* `Finalメソッドクラス <final_methods_classes.html>`_
* `Magicメソッド <magic_methods.html>`_
* `PHPUnitとの統合 <phpunit_integration.html>`_

Mockery
-------

Mockeryの設定、予約メソッド名、例外などを学びましょう。

* `設定 <configuration.html>`_
* `例外 <exceptions.html>`_
* `予約メソッド名 <reserved_method_names.html>`_
* `注意点 <gotchas.html>`_

クックブック
--------

簡単なヒントやトリックを学びたいのですか？クックブックのページをご覧ください。

* `既定エクスペクション <default_expectations.html>`_
* `モックオブジェクト判定 <detecting_mock_objects.html>`_
* `コンストラクタ非実行 <not_calling_the_constructor.html>`_
* `強い依存のモック <mocking_hard_dependencies.html>`_
* `クラス定数 <class_constants.html>`_
* `大きな親クラス <big_parent_class.html>`_
* `複雑な引数マッチ <mockery_on.html>`_
