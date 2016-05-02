(function() {
    'use strict';

    $(document).on('ready turbolinks:load', function() {
        var alert = $('body').data('alert');
        if (!alert) { return; }
        var notification = document.querySelector('.mdl-js-snackbar');
        notification.MaterialSnackbar.showSnackbar({message: alert});
    });
})();
