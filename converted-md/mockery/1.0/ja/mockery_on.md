::: {.index}
single: Cookbook; 複雑な引数マッチング(on)
:::

複雑な引数マッチング(on)
========================

メソッド呼び出しで期待される引数のマッチングを複雑にする必要がある場合は、`\Mockery::on()`マッチャーを使うととても簡単です。引数としてクロージャを受け付け、そのクロージャへメソッド呼び出し時の引数が渡されます。クロージャから`true`を返すと、Mockeryは引数がエクスペクションに一致したと取り扱い、「失敗した」値の場合は合致しなかったと考えます。

`\Mockery::on()`マッチャーは多くのシナリオで使用できます。複数のキー／値に基づいた配列の引数や、複雑な文字列のマッチングなどです。

たとえば、次のようなコードです。これは、さほど複雑ではありませんが、データベース上の`published`フラッグを`1`にセットすることで、あるポストを公開済みにし、`published_at`へ現日時をセットします。

``` {.php}
<?php
namespace Service;
class Post
{
    public function __construct($model)
    {
        $this->model = $model;
    }

    public function publishPost($id)
    {
        $saveData = [
            'post_id' => $id,
            'published' => 1,
            'published_at' => gmdate('Y-m-d H:i:s'),
        ];
        $this->model->save($saveData);
    }
}
```

テストでモデルをモックし、`save()`メソッドにエクスペクションを指定してみましょう。

``` {.php}
<?php
$postId = 42;

$modelMock = \Mockery::mock('Model');
$modelMock->shouldReceive('save')
    ->once()
    ->with(\Mockery::on(function ($argument) use ($postId) {
        $postIdIsSet = isset($argument['post_id']) && $argument['post_id'] === $postId;
        $publishedFlagIsSet = isset($argument['published']) && $argument['published'] === 1;
        $publishedAtIsSet = isset($argument['published_at']);

        return $postIdIsSet && $publishedFlagIsSet && $publishedAtIsSet;
    }));

$service = new \Service\Post($modelMock);
$service->publishPost($postId);

\Mockery::close();
```

この例で重要なのは、`\Mockery::on()`マッチャーへ渡したクロージャの内容です。
`$argument`は実際には、`save()`メソッドが呼び出されたときの引数である、`$saveData`です。この引数について、いくつかのことをチェックしています。

-   ポストIDがセットされており、`publishPost()`メソッドへ渡したポストIDと一致していること
-   `published`がセットされており、`1`であること
-   `published_at`キーが存在していること

どれかの要件を満たさない場合、クロージャは`false`を返し、メソッド呼び出しのエクスペクションは一致せず、Mockeryは`NoMatchingExpectationException`を投げます。

> {note}
> このクックブックのエントリーは、Robertによるブログ記事である、[\"Complex
> argument matching in
> Mockery\"](https://robertbasic.com/blog/complex-argument-matching-in-mockery/)を元に引用したものです。
