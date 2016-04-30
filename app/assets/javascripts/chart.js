(function() {
    'use strict';

    $(document).on('ready turbolinks:load', function() {
        $('.regulars-chart').each(function() {
            var $chart = $(this);
            var labels = $chart.data('labels');
            var series = $chart.data('series');
            var options = $chart.data('options');
            new Chartist.Line(this, { labels: labels, series: series }, options);
        });
    });
})();
