// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require highlightjs
// require angular
//= require zackexplosion-ngLoading
//= require zackexplosion-ng-infinite-scroll

//= require angular-resource
//= require angular-sanitize
//= require angularytics
//= require ui-router
//= require_self
//= require_tree .

angular
.module('blog', [
    'zackexplosion-ngLoading',
    'zackexplosion-ng-infinite-scroll',
    'angularytics',
    'ngSanitize',
    'ui.router',
    'ngResource'
])
.config(
[       '$locationProvider',
function($locationProvider) {
    // enable html5 mode
    $locationProvider.html5Mode(true);
}])
.config(['AngularyticsProvider', function(AngularyticsProvider) {
    AngularyticsProvider.setEventHandlers(['Console', 'GoogleUniversal']);
}])
.run(['Angularytics', function(Angularytics) {
    Angularytics.init();
}])
.run(
[        '$rootScope', '$http',
function( $rootScope,   $http){
    $rootScope.window = {
        width  : Math.max(document.documentElement.clientWidth, window.innerWidth || 0),
        height : Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
    };

    // if( $rootScope.window.width >= 768){

    $rootScope.streaming = false;

    $rootScope.is_streaming = function(){
        return $rootScope.streaming;
    }

    $rootScope.current_url = window.host;

    var iframe = '<iframe src="http://www.twitch.tv/cstony0917/embed" frameborder="0" scrolling="no" height="378" width="620"></iframe><a href="http://www.twitch.tv/cstony0917?tt_medium=live_embed&tt_content=text_link" style="padding:2px 0px 4px; display:block; width:345px; font-weight:normal; font-size:10px;text-decoration:underline;">Watch live video from csTony0917 on www.twitch.tv</a>';    
    var wrapper = angular.element(document.querySelector('#livehouse .video-wrapper'))

    var chat_iframe = '<iframe src="http://www.twitch.tv/cstony0917/chat?popout=" frameborder="0" height="700" scrolling="no"></iframe>';
    var chat_wrapper = angular.element(document.querySelector('#livehouse .chat-wrapper'))



    $http.jsonp('https://api.twitch.tv/kraken/streams/cstony0917?callback=JSON_CALLBACK').success(function(res){        
        var streaming = !(res.stream === null);
        $rootScope.changeLiveStatus(streaming);
    });


    $rootScope.changeLiveStatus = function(streaming){
        if(typeof streaming === 'undefined'){
            $rootScope.streaming = !$rootScope.streaming;
        }else{
            $rootScope.streaming = streaming;
        }            

        if(!$rootScope.streaming){
            wrapper.html('');
            chat_wrapper.html('');
        }else{
            wrapper.html(iframe);
            chat_wrapper.html(chat_iframe);
        }
    }
    // }
    
    
    // debugger;
}])
.constant('Path', {
    'template': '/templates?t=front'
})
.factory('SetTitle',[function(){
    var default_title = "Zack's Blog";
    var _title = angular.element( document.querySelector('title') );

    return function(title){
        if(typeof title === 'undefined'){
            _title.html(default_title);    
        }else{
            _title.html(title + ' | ' + default_title);
        }
        
    }
}])
.factory('LoadDisqus', 
[function(){
return function(){
    /* * * CONFIGURATION VARIABLES * * */
    var disqus_shortname = 'zackexplosion';
    
    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
}
}])

.config(
[       '$stateProvider', '$urlRouterProvider', 'Path',
function($stateProvider,   $urlRouterProvider,   Path) {
//
// For any unmatched url, redirect to /state1
$urlRouterProvider
.when('/p/show/:id', '/p/:id')
.when('/users/sign_in', function(){
    return;
})
.otherwise('/')

// .when('/p/show/:id', 
// [         '$state', 
// function ( $state ){
//     debugger;
// }]);


    // $urlRouterProvider
    //   .when('/app/list', ['$state', 'myService', function ($state, myService) {
    //         $state.go('app.list.detail', {id: myService.Params.id});
    // }])
// .otherwise("");
//
// Now set up the states
$stateProvider
.state('index', {
    url: '/',
    templateUrl: Path.template + "/posts/list.html",
    controller: 'PostListCrtl'
})
.state('posts', {
    abstract : true,
    url: '/p',
    template: '<ui-view></ui-view>'
})
.state('posts.list', {
    url: "/list",
    templateUrl : Path.template + "/posts/list.html",
    controller  : 'PostListCrtl'
})
.state('posts.show', {
    url: "/:id",
    templateUrl: Path.template + "/posts/show.html",
    resolve   : {
        POST : ['POSTS', '$stateParams', function(POSTS, $stateParams){
            var id = $stateParams.id;
            return POSTS.get({postId:id}).$promise;
        }]
    },
    controller: 'PostShowCrtl'    
})

}])

