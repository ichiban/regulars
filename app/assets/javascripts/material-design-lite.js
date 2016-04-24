(function() {
    'use strict';

    $(document).on('turbolinks:load ajax:complete', function() {
        componentHandler.upgradeDom();
    });
})();
