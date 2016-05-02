(function() {
    'use strict';

    var $document = $(document);

    window.fbAsyncInit = function() {
        FB.init({
            appId      : '1075847942471273',
            xfbml      : true,
            version    : 'v2.6'
        });
    };

    (function(d, s, id){
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) {return;}
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));

    // Deal with the #fb-root problem with Turbolinks
    // http://reed.github.io/turbolinks-compatibility/facebook.html
    var $fbRoot;
    var fbRootId = '#fb-root';

    $document.on('turbolinks:request-start', function() {
        var $root = $(fbRootId);
        if ($root.length) {
            $fbRoot = $root.detach();
        }
    });

    $document.on('turbolinks:load', function() {
        if (!$fbRoot) { return; }

        var $root = $(fbRootId);
        if ($root.length) {
            $root.replaceWith($fbRoot);
        } else {
            $('body').append($fbRoot);
        }
    });

    $document.on('click', '.regulars-login__button', function() {
        console.log('facebook login button clicked');
        FB.login(function(response) {
            console.log('facebook login');
            if ('connected' === response.status) {
                console.log('facebook logged in');
                login(response);
            } else if ('not_authorized' === response.status) {
                notify('Please log into this app.');
            } else {
                notify('Please log into Facebook.');
            }
        }, {
            scope: [
                'public_profile',
                'email',
                'read_insights',
                'manage_pages',
                'publish_pages'
            ].join(',')
        });
    });

    /**
     * Login to the app.
     * @param {{authResponse: {userID: string, accessToken: string}}} response
     */
    var login = function(response) {
        $('#user_facebook_id').val(response.authResponse.userID);
        $('#user_access_token').val(response.authResponse.accessToken);
        $('#new_user').submit();
    };

    /**
     * Shows a snackbar with the message.
     * @param {string} message
     */
    var notify = function(message) {
        var notification = document.querySelector('.mdl-js-snackbar');
        notification.MaterialSnackbar.showSnackbar({message: message});
    };
})();
