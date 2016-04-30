(function() {
    'use strict';

    var $document = $(document);
    var uploaderSelector = '.regulars-js-uploader';
    var fileSelector = '.regulars-js-uploader-file';
    var buttonSelector = '.regulars-js-uploader-button';

    $document.on('click', buttonSelector, function(event) {
        event.stopPropagation();
        event.preventDefault();

        $(fileSelector).click().change();
    });

    $document.on('change', fileSelector, function() {
        var file = this.files[0];
        if (!file) { return; }

        var reader = new FileReader();
        reader.addEventListener('load', function() {
            var dataUrl = reader.result;
            $(uploaderSelector).css('background-image', ['url(', dataUrl, ')'].join(''));
        }, false);
        reader.readAsDataURL(file);
    });
})();
