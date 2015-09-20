@extends('app')
@section('content')
    <div class="col-lg-3">
        @include('.categories.list_group')
    </div>
    <div class="col-lg-8">
        {!! Html::image('images/articles/'.$article->id.'body_img.JPG', 'a picture')  !!}
        <h1>{!! $article->title  !!}</h1>
        <article>
            <hr />
            <h4>
                {!! nl2br($article->body) !!}
            </h4>
        </article>
        <hr />
        @include('comments.show')
        @include('comments.create')
    </div>
@stop