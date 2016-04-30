(function() {
    'use strict';
    
    $(document).on('submit', 'form[data-remote-form-data]', function(event) {
        event.preventDefault();
        var $self = $(this);
        var formData = new FormData(this);
        $.ajax({
            url: $self.attr('action'),
            data: formData,
            contentType: false,
            processData: false,
            type: $self.attr('method') || 'POST'
        });
    });
})();
