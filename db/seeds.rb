Post.create!([
  {id: 2, title: "節省開發時間，預防關節炎 guard live reload", content: "在做web開發的朋友們一定會碰到一個問題，那就是每次的修改一定要透過\n\n### 安裝GEM\n\n只給開發與測試環境\n\n``` ruby\ngroup :development, :test do\n  gem \"rack-livereload\"\n  gem 'guard-livereload', '~> 2.4', require: false\nend\n```\n\n接著，安裝GEM，如果有用POWDER的話記得將他restart\n\n```\nbundle install && powder restart\n```", created_at: "2015-05-17 15:32:51", updated_at: "2015-05-23 16:43:12"},
  {id: 5, title: "RAILS 將資料庫儲存到db seed裡面", content: "參考資料\n<https://github.com/rroblak/seed_dump>\n\n在Gemfile中加入\n\n\tgem 'seed_dump'\n\n或者是直接在終端機輸入\n\n    $ gem install seed_dump\n\n接著就可以使用\n\n    $ rake db:seed:dump\n    \n如果有用heroku的話會發現檔案系統沒辦法直接被存取\n    \n", created_at: "2015-05-17 15:32:51", updated_at: "2015-05-23 16:43:12"},
  {id: 1, title: "RAILS + ANGULARJS 製作BLOG", content: "### 環境設定\n\n產生一個新的rails專案\n\n```\nrails new blog\n```\n\n切換到專案的目錄\n\n```\ncd blog\n```\n\n接著利用powder快速建立rails的開發server （POWDER相關資料）待補\n\n```\npowder link && powder open\n```\n\n參考資料\n\n* [http://pow.cx/](http://pow.cx/)\n* [https://github.com/Rodreegez/powder]()\n\n### 建立系統需要的欄位\n\n產生 post model\n\n```\nrails g model post name:string content:text\n```\n\n執行migrate建立資料庫欄位\n\n```\nrake db:migrate\n```\n\n更改預設路由\n\nconfig/routes.rb\n\n```\n  # You can have the root of your site routed with \"root\"\n  # root 'welcome#index'\n  root 'posts#index'\n```\n\n建立 posts controller\n\n```\nrails g controller posts\n```\n\n設定路由表讓系統知道有post這個RESTFUL資源\n\nconfig/routes.rb\n\n```\n  # Example resource route (maps HTTP verbs to controller actions automatically):\n  #   resources :products\n  resources :posts\n```\n\n\n建立 index action取得文章列表\n\napp/controllers/posts_controller.rb\n\n```\nclass PostsController < ApplicationController\n  def index\n    render :json => Post.all\n  end\nend\n```\n\n建立 show action讀取單一文章內容\n\n``` ruby\n  def show\n    render :json => Post.find(params[:id])\n  end\n```\n\n\n\n\n\n\n\n\n", created_at: "2015-05-17 15:32:51", updated_at: "2015-05-23 16:43:12"},
  {id: 3, title: "jbuilder 如何自動展開所有欄位", content: "一開始使用jbuilder的時候並不知道有這個功能，想說要一個一個把欄位解開(extract!)來，GOOGLE了一下，找到下面這種作法\n\n\t  json.merge! p.attributes\n\n[參考連結](http://stackoverflow.com/questions/23027644/how-to-extract-all-attributes-with-rails-jbuilder)\n\n\n範例程式碼\n\n```\njson.array! @posts do |p|\n  json.merge! p.attributes\n  json.content p.content[0..50]\nend\n```", created_at: "2015-05-17 15:32:51", updated_at: "2015-05-23 16:43:12"},
  {id: 4, title: "使用 redcarpet 解析markdown時如何讓code部分自動產生區塊", content: "render時加上\n\n\tfenced_code_blocks: true\n\n參數即可\n\n```\nmarkdown = Redcarpet::Markdown.new(HTMLwithPygments, fenced_code_blocks: true)\n```", created_at: "2015-05-17 15:32:51", updated_at: "2015-05-23 16:43:12"},
  {id: 9, title: "防止程式碼在行動裝置被斷行", content: "```\npre {\n  overflow: auto;\n  word-wrap: normal;\n  white-space: pre;\n  code{\n    white-space: pre;\n  }\n}\n```\n\n\n使用Bootstrap的CSS時，會發現在內文貼上程式碼會被斷行，是因為行動裝置的寬度通常較一般大螢幕小很多，個人覺得這樣子非常不美觀，透過上敘的CSS可以讓程式碼不份不會被斷行，而且可以左右scroll。\n\n下圖為修改前後的示範。\n\n![](http://i.imgur.com/GO8IY67.gif)\n", created_at: "2015-05-21 09:49:43", updated_at: "2015-05-23 16:43:12"},
  {id: 10, title: "使用GITHUB HOSTING RAILS的ASSETS", content: "使用heroku時會發現，heroku並沒有提供亞洲的伺服器，先天上因為地理問題，伺服器的反應時間一定會比較慢。\n\nGITHUB有提供靜態網頁檔案HOSTING的服務，只要新增一個分支叫做**gh-pages**就可以了!，利用這個方法可以讓我們搭配寫好的bash指令在部屬heroku的同時將assets放到github上。\n\n###準備一個git repo來放置要部屬assets檔案\n\n在github上新增repo之後（ 假設專案名稱為zackexplosion )\n\n``` bash\nmkdir zackexplosion\ncd zackexplosion\n\ngit remote add origin https://github.com/cstony0917/zackexplosion.git\n```\n\n在*config/environments/production.rb*加上github-pages的連結\n\n```\nconfig.action_controller.asset_host = '//cstony0917.github.io/zackexplosion/'\n```\n\n接著增新一個部屬專用的shell檔案，例如**deploy**，內容如下\n\n```\n#!/bin/bash\nRAILS_ENV=production rake assets:precompile\nrm -rf ../zackexplosion/assets\nmv -vf public/assets/ ../zackexplosion/\nmkdir public/assets\ncp -v ../zackexplosion/assets/mani*.json public/assets/\ngit add .\ngit branch gh-pages\ngit commit -m 'update manifest'\n\ncd ../zackexplosion\ngit add .\ngit commit -m 'update assets'\ngit push origin gh-pages\n\ncd ../blog\ngit remote | xargs -L1 git push --all\n```\n\n其中**blog**是目前專案的資料夾名稱。接著要使用就可以直接\n\n```\nsh ./deploy\n```\n\n最後回到heroko上看，確定網頁是否正常!", created_at: "2015-05-23 12:02:51", updated_at: "2015-05-23 16:43:12"},
  {id: 11, title: "使用 TWITCH API 查看頻道是否實況中", content: "今天比較了一下livehouse.in與TWITCH，發現兩者的使用方式已經差不多了，但這邊有個需求，我需要知道我的頻道是否實況中，是的話才會在網站中嵌入實況的CODE。livehouse.in找了半天發現他們所有頻道的狀態跟事件都是靠websocket來廣播，官方網站上也沒有提到API的部份，相反，TWITCH就提供了許多API可以給開發者使用。\n\nTWITCH很大方地將他們的API放在GITHUB上\n\n*  <https://github.com/justintv/twitch-api>\n\n而我使用了其中一個streams的API，可以查看該頻道是否正在實況中。下面的CODE寫在**applicaton_controller.rb**中\n\n``` ruby\n  def streaming\n    require 'net/http'\n    uri = URI('https://api.twitch.tv/kraken/streams/cstony0917')\n    res = Net::HTTP.get(uri) # => String\n    res = JSON.parse(res)\n    \n    m = res['stream'] != nil\n    render :json => m\n  end\n```\n\n記得在**routes.rb**加上\n\n``` ruby\nget 'streaming' => 'application#streaming'\n```\n\n如果頻道不在live時，**stream**這個KEY的直就會給NULL\n\n參考資料\n\n*  <https://github.com/justintv/Twitch-API/blob/master/v3_resources/streams.md>\n\n而前端利用AJAX檢查是否為streaming的CODE\n\n``` javascript\n    $rootScope.streaming = false;\n\n    $rootScope.is_streaming = function(){\n        return $rootScope.streaming;\n    }\n\n    var iframe = '<iframe src=\"http://www.twitch.tv/cstony0917/embed\" frameborder=\"0\" scrolling=\"no\" height=\"378\" width=\"620\"></iframe><a href=\"http://www.twitch.tv/cstony0917?tt_medium=live_embed&tt_content=text_link\" style=\"padding:2px 0px 4px; display:block; width:345px; font-weight:normal; font-size:10px;text-decoration:underline;\">Watch live video from csTony0917 on www.twitch.tv</a>';\n    var wrapper = angular.element(document.querySelector('#livehouse .video-wrapper'))\n\n    $http.get('/streaming').success(function(res){\n        // wrapper.html(iframe);\n        $rootScope.changeLiveStatus(res);\n    });\n\n\n    $rootScope.changeLiveStatus = function(streaming){\n        if(typeof streaming === 'undefined'){\n            $rootScope.streaming = !$rootScope.streaming;\n        }else{\n            $rootScope.streaming = streaming;\n        }            \n\n        if(!$rootScope.streaming){\n            wrapper.html('');\n        }else{\n            wrapper.html(iframe);\n        }\n    }\n```\n\n前端template\n\n``` html\n  <div id=\"livehouse\" ng-class=\"{living : is_streaming()}\">\n    <div class=\"buttons\" ng-click=\"changeLiveStatus()\">\n      <button ng-show=\"is_streaming()\" class=\"btn\"><span class=\"glyphicon glyphicon-chevron-up\"></span></button>\n      <button ng-hide=\"is_streaming()\" class=\"btn\"><span class=\"glyphicon glyphicon-chevron-down\"></span></button>\n    </div>\n    <h3 ng-click=\"changeLiveStatus()\">現場直播</h3>\n    <div ng-show=\"is_streaming()\" class=\"video-wrapper\"></div>\n    <hr />\n  </div>\n```\n\n這樣就可以讓訪客進來時不會因為沒有在實況又看到實況的區塊了。\n", created_at: "2015-05-23 15:14:39", updated_at: "2015-05-23 17:25:29"}
])
