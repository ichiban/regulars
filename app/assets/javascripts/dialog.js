(function() {
    'use strict';

    var $document = $(document);

    $document.on('click', '[data-dialog-close]', function() {
        $('dialog').get()[0].close();
    });
})();
