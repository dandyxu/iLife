<?php

namespace App\Http\Controllers;

use App\Article;
use App\Category;
use App\Comment;
use App\Image as HomeImage;
use App\User;
use DB;
use Input;
use Validator;
use Session;
use Image;
use Illuminate\Http\Request;
use App\Http\Requests;
use App\Http\Controllers\Controller;

class ArticlesController extends Controller
{
    /**
     *
     */
    public function __construct(){
        $this->middleware('manager', ['only' => ['create', 'edit']]);
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $loader = $this->loadCategory();
        return view('articles.index', $loader);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $loader = $this->loadCategory();
        return view('articles.create', $loader);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $new_article = new Article;
        $new_article->user_id = auth()->user()->id;
        $new_article->category_id = $request->select;
        $new_article->title = $request->title;
        $new_article->body = $request->body;
        $new_article->is_top = $request->is_top;
        $new_article->save();

        // Save article title image
        if(Input::file('title_img') != null)
            $this->uploadImage('title_img', $new_article->id, 'title', 1035, 300);
        // Save article body image
        if(Input::file('body_img') != null)
            $this->uploadImage('body_img', $new_article->id, 'body', 1035, 300);
        // Save article icon
        if(Input::file('article_icon_img') != null)
            $this->uploadImage('article_icon_img', $new_article->id, 'title_icon', 75, 75);

        $loader = $this->loadCategory();
        return view('articles.index', $loader);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $loader = $this->loadCategoryWithId($id);
        return view('articles.show', $loader);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $loader = $this->loadCategoryWithId($id);
        return view('articles.edit', $loader);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
//        dd($request->all());
        $article = Article::findOrFail($id);
        $article->update($request->all());
        return redirect('articles');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $article = Article::findOrFail($id);
        $article->delete();
        return redirect('articles');
    }

    /**
     * Save images and related url in the image table
     * @param $image_name
     * @param $article_id
     * @param $image_description
     * @param $image_width
     * @param $image_height
     * @return $this|\Illuminate\Http\RedirectResponse|\Illuminate\Routing\Redirector
     */
    public function uploadImage($image_name, $article_id, $image_description, $image_width, $image_height){

        // getting all of the post data
        $file = array('image' => Input::file($image_name));
        // setting up rules
        // Apache default upload_max_filesize = 2M (etc/php5/php.ini)
        $rules = array('image' => 'image'); //mimes:jpeg,bmp,png and for max size max:10000
        // doing the validation, passing post data, rules and the messages
        $validator = Validator::make($file, $rules);
        if ($validator->fails()) {
            // send back to the page with the input data and errors
            return redirect('articles/create')->withInput()->withErrors($validator);
        }
        else {
            // checking file is valid.
            if (Input::file($image_name)->isValid()) {
                $extension = Input::file($image_name)->getClientOriginalExtension(); // getting image extension
                $fileName = $article_id.$image_description.'.'.$extension; // rename image

                /**
                 * Image description manipulation using intervention image
                 */
                $img = Image::make(Input::file($image_name));
                $img->resize($image_width, null, function ($constraint) {
                    $constraint->aspectRatio();
                });
                $img->crop($image_width, $image_height, 0, 0);
                $img->save(base_path().'/public/images/articles/'.$fileName);// uploading file to given path

                /**
                 * Save article id and image url into the database
                 */
                $image_db = new HomeImage();
                $image_db->article_id = $article_id;
                $fileName = $article_id.$image_description.'.'.$extension; // rename image
                $image_db->image_url = 'images/articles/'.$fileName;
                $image_db->save();

                // sending back with message
                Session::flash('success', 'Upload successfully');
                return redirect('articles/create');
            }
            else {
                dd('here');
                // sending back with error message.
                Session::flash('error', 'uploaded file is not valid');
                return redirect('articles/create');
            }
        }
    }

    /**
     * @return array
     */
    public function loadCategory(){
        $categories = Category::all();
        $articles = Article::all();
        $category_list = Category::lists('name', 'id');
        // link the category id and the its related articles
        $articlesNumber = [];
        foreach($categories as $category){
            if(CategoriesController::getArticleNumber($category->id) != null)
                $articlesNumber[$category->id] = CategoriesController::getArticleNumber($category->id)[0]->article_number;
            else
                $articlesNumber[$category->id] = '0';
        }
        $images = HomeImage::all();
        if(User::getCurrentUser() != null)
            $is_manager = User::getCurrentUser()->is_manager;
        else
            $is_manager = false;
        return compact('categories', 'category_list', 'articles', 'articlesNumber', 'images', 'is_manager');
    }

    public function loadCategoryWithId($id){
        $categories = Category::all();
        $category_list = Category::lists('name', 'id');
        $article = Article::findOrFail($id);
        // link the category id and the its related articles
        $articlesNumber = [];
        foreach($categories as $category){
            if(CategoriesController::getArticleNumber($category->id) != null)
                $articlesNumber[$category->id] = CategoriesController::getArticleNumber($category->id)[0]->article_number;
            else
                $articlesNumber[$category->id] = '0';
        }
        if(User::getCurrentUser() != null)
            $is_manager = User::getCurrentUser()->is_manager;
        else
            $is_manager = false;
        //find image path
        $images = HomeImage::where('article_id', '=', $id)->get();
        $comments = CommentsController::show($id);
        return compact('categories', 'category_list', 'article', 'articlesNumber', 'is_manager', 'images', 'comments');
    }
}
