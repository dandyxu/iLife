<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

Route::get('/','CategoriesController@index');
Route::controllers([
    'auth'      => 'Auth\AuthController',
    'password'  => 'Auth\PasswordController'
]);
Route::resource('categories', 'CategoriesController');
Route::resource('articles', 'ArticlesController');
Route::resource('comments', 'CommentsController');
Route::resource('favorite_articles', 'FavoriteArticlesController');
Route::resource('article_images', 'ImagesController');
Route::get('privacy','FooterController@showPrivacy');
Route::get('about_us','FooterController@aboutUs');
Route::get('feedback', 'FooterController@feedback');
Route::post('feedback_email',['as'=>'feedback_email', 'uses' => 'FooterController@feedback_email']);

/**
 * These below routes are for mobiles
 */
Route::post('mobile_articles_get_article',
    ['as' => 'mobile_articles_get_article', 'uses' => 'MobileArticlesController@getArticle']);
Route::get('mobile_get_category_list',
    ['as' => 'mobile_get_category_list', 'uses' => 'MobileArticlesController@getCategoryList']);

/**
 * These below routes are for mobiles test
 */
Route::get('mobile_articles_show_article', 'MobileArticlesController@showArticle');