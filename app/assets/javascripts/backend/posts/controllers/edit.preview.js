
angular
.module('blog')
.controller('PostPreviewCrtl', 
[        '$scope', 'POST', 'imgur',
function( $scope,   POST,   imgur){  
    // $scope.editorOptions = {
    //     lineWrapping : true,
    //     lineNumbers: true,
    //     mode: 'markdown'
    // };

    $scope.preview_url = '/p/' + POST.id;
}])