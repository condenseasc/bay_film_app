angular.module('ui-templates', ['template/calendar/directives/event_feed.html', 'template/calendar/directives/event_titles_by_week.html', 'template/calendar/index.html', 'template/datepicker/datepicker.html', 'template/datepicker/day.html', 'template/datepicker/dayOriginal.html', 'template/datepicker/month.html', 'template/datepicker/popup.html', 'template/datepicker/year.html']);

angular.module("template/calendar/directives/event_feed.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/calendar/directives/event_feed.html",
    "<div class=\"week-container\" ng-repeat='week in weeks' id=\"week-{{week.page}}\">\n" +
    "  <div smooth-scroll scroll-if=\"{{selected.day.getDate() === day.date.getDate()}}\" easing=\"easeOutQuart\" class=\"day-container\" ng-repeat=\"day in week.days\" id=\"day-{{day.date | date: 'd'}}\">\n" +
    "      <div class=\"event-feed-date\" >\n" +
    "        <div class=\"date-label-text\">{{day.date | date:'EEEE MMMM d' | uppercase}}</div>\n" +
    "      </div>\n" +
    "    <div class=\"event-container\" ng-repeat=\"event in day.events\" id=\"event-{{event.id}}\">\n" +
    "      <img class=\"event-still\" ng-src=\"{{event.still_url_medium}}\">\n" +
    "      <div class=\"event-title\">{{event.title}}</div>\n" +
    "      <div>\n" +
    "        <span class=\"event-venue\">{{event.venue.name}}</span>\n" +
    "        <span class=\"event-time\"> at {{event.time| ooSmallTime}}</span>\n" +
    "      </div>\n" +
    "      <div class=\"event-series\">In {{event.series[0].title}}</div>\n" +
    "      <div class=\"show-credits\">{{event.show_credits}}</div>\n" +
    "      <div class=\"show-notes\" ng-bind-html=\"event.show_notes\"></div>\n" +
    "      <div class=\"event-body\" ng-bind-html=\"event.description\"></div>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "</div>\n" +
    "");
}]);

angular.module("template/calendar/directives/event_titles_by_week.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/calendar/directives/event_titles_by_week.html",
    "<div ng-repeat=\"week in loadedWeeks\" class=\"week-list\" id=\"list-weeek-{{week.page}}\">\n" +
    "  <ul class=\"day-list\" ng-repeat=\"day in week.days\">\n" +
    "    <div class=\"list-date-label\">\n" +
    "      <a class=\"date-label-text\" href scroll-to=\"{{'day' + day.date.getDate()}}\">\n" +
    "        {{ day.date | date:'EEEE MMMM d' | uppercase }}</a>\n" +
    "    </div>\n" +
    "    <li ng-repeat=\"event in day.events\">\n" +
    "      <a class=\"event-container\" href scroll-to=\"{{'event-' + event.id}}\">\n" +
    "        <span class=\"list-event-time\">{{event.time | ooSmallTime }}</span>\n" +
    "        <span class=\"list-event-title\">{{event.title}} </span>\n" +
    "        <span class=\"list-venue-name\">{{event.venue.abbreviation}} </span>\n" +
    "      </a>\n" +
    "    </li>\n" +
    "  </ul>\n" +
    "</div>");
}]);

angular.module("template/calendar/index.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/calendar/index.html",
    "<div id=\"wrapper\" >\n" +
    "  <div id=\"sidebar-wrapper\">\n" +
    "    <div class=\"calendar-nav\" >\n" +
    "      <datepicker oo-refresh-datepicker oo-check-week-on-scroll oo-highlight-selected-week\n" +
    "      refresh-on=\"{{selected.month}}\" \n" +
    "      date-disabled=\"isDateDisabled(date, mode)\" \n" +
    "      ng-model=\"selected.day\">  \n" +
    "      </datepicker>\n" +
    "    </div>\n" +
    "\n" +
    "    <div class=\"titles-nav\" >\n" +
    "      <oo-event-titles-by-week selected-week-name=\"{{selected.week}}\" loaded-weeks=\"weeks\" nav-to=\"scrollTo(id)\">\n" +
    "    </oo-event-titles-by-week>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "\n" +
    "  <div id=\"page-content-wrapper\">\n" +
    "    <div class=\"content-header\"></div>\n" +
    "\n" +
    "    <div class=\"page-content\">\n" +
    "      <oo-event-feed class=\"event-feed\" weeks=\"weeks\" selected-day=\"selected.day\"></oo-event-feed>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "</div>");
}]);

angular.module("template/datepicker/datepicker.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/datepicker/datepicker.html",
    "<div ng-switch=\"datepickerMode\">\n" +
    "  <daypicker ng-switch-when=\"day\"></daypicker>\n" +
    "  <monthpicker ng-switch-when=\"month\"></monthpicker>\n" +
    "  <yearpicker ng-switch-when=\"year\"></yearpicker>\n" +
    "</div>");
}]);

angular.module("template/datepicker/day.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/datepicker/day.html",
    "<table>\n" +
    "  <thead>\n" +
    "    <tr>\n" +
    "      <th><button type=\"button\" class=\"btn btn-default btn-sm pull-left\" ng-click=\"move(-1)\"><i class=\"glyphicon glyphicon-chevron-left\"></i></button></th>\n" +
    "      <th colspan=\"5\"><button type=\"button\" class=\"btn btn-default btn-sm btn-block\" ng-click=\"toggleMode()\"><strong>{{title}}</strong></button></th>\n" +
    "      <th><button type=\"button\" class=\"btn btn-default btn-sm pull-right\" ng-click=\"move(1)\"><i class=\"glyphicon glyphicon-chevron-right\"></i></button></th>\n" +
    "    </tr>\n" +
    "    <tr>\n" +
    "      <th ng-repeat=\"label in labels track by $index\" class=\"text-center\"><small>{{label}}</small></th>\n" +
    "    </tr>\n" +
    "  </thead>\n" +
    "  <tbody>\n" +
    "    <tr ng-repeat=\"row in rows track by $index\" class=\"week-row\" id=\"week-{{ weekNumbers[$index] }}\">\n" +
    "      <td ng-repeat=\"dt in row track by dt.date\" class=\"text-center\">\n" +
    "        <button type=\"button\" style=\"width:100%;\" class=\"btn btn-default btn-sm\" ng-class=\"{'btn-info': dt.selected}\" ng-click=\"select(dt.date)\" ng-disabled=\"dt.disabled\"><span ng-class=\"{'text-muted': dt.secondary, 'text-info': dt.current}\">{{dt.label}}</span></button>\n" +
    "      </td>\n" +
    "    </tr>\n" +
    "  </tbody>\n" +
    "</table>\n" +
    "");
}]);

angular.module("template/datepicker/dayOriginal.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/datepicker/dayOriginal.html",
    "<table>\n" +
    "  <thead>\n" +
    "    <tr>\n" +
    "      <th><button type=\"button\" class=\"btn btn-default btn-sm pull-left\" ng-click=\"move(-1)\"><i class=\"glyphicon glyphicon-chevron-left\"></i></button></th>\n" +
    "      <th colspan=\"{{5 + showWeeks}}\"><button type=\"button\" class=\"btn btn-default btn-sm btn-block\" ng-click=\"toggleMode()\"><strong>{{title}}</strong></button></th>\n" +
    "      <th><button type=\"button\" class=\"btn btn-default btn-sm pull-right\" ng-click=\"move(1)\"><i class=\"glyphicon glyphicon-chevron-right\"></i></button></th>\n" +
    "    </tr>\n" +
    "    <tr>\n" +
    "      <th ng-show=\"showWeeks\" class=\"text-center\"></th>\n" +
    "      <th ng-repeat=\"label in labels track by $index\" class=\"text-center\"><small>{{label}}</small></th>\n" +
    "    </tr>\n" +
    "  </thead>\n" +
    "  <tbody>\n" +
    "    <tr ng-repeat=\"row in rows track by $index\">\n" +
    "      <td ng-show=\"showWeeks\" class=\"text-center\"><small><em>{{ weekNumbers[$index] }}</em></small></td>\n" +
    "      <td ng-repeat=\"dt in row track by dt.date\" class=\"text-center\">\n" +
    "        <button type=\"button\" style=\"width:100%;\" class=\"btn btn-default btn-sm\" ng-class=\"{'btn-info': dt.selected}\" ng-click=\"select(dt.date)\" ng-disabled=\"dt.disabled\"><span ng-class=\"{'text-muted': dt.secondary, 'text-info': dt.current}\">{{dt.label}}</span></button>\n" +
    "      </td>\n" +
    "    </tr>\n" +
    "  </tbody>\n" +
    "</table>\n" +
    "");
}]);

angular.module("template/datepicker/month.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/datepicker/month.html",
    "<table>\n" +
    "  <thead>\n" +
    "    <tr>\n" +
    "      <th><button type=\"button\" class=\"btn btn-default btn-sm pull-left\" ng-click=\"move(-1)\"><i class=\"glyphicon glyphicon-chevron-left\"></i></button></th>\n" +
    "      <th><button type=\"button\" class=\"btn btn-default btn-sm btn-block\" ng-click=\"toggleMode()\"><strong>{{title}}</strong></button></th>\n" +
    "      <th><button type=\"button\" class=\"btn btn-default btn-sm pull-right\" ng-click=\"move(1)\"><i class=\"glyphicon glyphicon-chevron-right\"></i></button></th>\n" +
    "    </tr>\n" +
    "  </thead>\n" +
    "  <tbody>\n" +
    "    <tr ng-repeat=\"row in rows track by $index\">\n" +
    "      <td ng-repeat=\"dt in row track by dt.date\" class=\"text-center\">\n" +
    "        <button type=\"button\" style=\"width:100%;\" class=\"btn btn-default\" ng-class=\"{'btn-info': dt.selected}\" ng-click=\"select(dt.date)\" ng-disabled=\"dt.disabled\"><span ng-class=\"{'text-info': dt.current}\">{{dt.label}}</span></button>\n" +
    "      </td>\n" +
    "    </tr>\n" +
    "  </tbody>\n" +
    "</table>\n" +
    "");
}]);

angular.module("template/datepicker/popup.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/datepicker/popup.html",
    "<ul class=\"dropdown-menu\" ng-style=\"{display: (isOpen && 'block') || 'none', top: position.top+'px', left: position.left+'px'}\">\n" +
    "	<li ng-transclude></li>\n" +
    "	<li ng-if=\"showButtonBar\" style=\"padding:10px 9px 2px\">\n" +
    "		<span class=\"btn-group\">\n" +
    "			<button type=\"button\" class=\"btn btn-sm btn-info\" ng-click=\"select('today')\">{{ getText('current') }}</button>\n" +
    "			<button type=\"button\" class=\"btn btn-sm btn-danger\" ng-click=\"select(null)\">{{ getText('clear') }}</button>\n" +
    "		</span>\n" +
    "		<button type=\"button\" class=\"btn btn-sm btn-success pull-right\" ng-click=\"$parent.isOpen = false\">{{ getText('close') }}</button>\n" +
    "	</li>\n" +
    "</ul>\n" +
    "");
}]);

angular.module("template/datepicker/year.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/datepicker/year.html",
    "<table>\n" +
    "  <thead>\n" +
    "    <tr>\n" +
    "      <th><button type=\"button\" class=\"btn btn-default btn-sm pull-left\" ng-click=\"move(-1)\"><i class=\"glyphicon glyphicon-chevron-left\"></i></button></th>\n" +
    "      <th colspan=\"3\"><button type=\"button\" class=\"btn btn-default btn-sm btn-block\" ng-click=\"toggleMode()\"><strong>{{title}}</strong></button></th>\n" +
    "      <th><button type=\"button\" class=\"btn btn-default btn-sm pull-right\" ng-click=\"move(1)\"><i class=\"glyphicon glyphicon-chevron-right\"></i></button></th>\n" +
    "    </tr>\n" +
    "  </thead>\n" +
    "  <tbody>\n" +
    "    <tr ng-repeat=\"row in rows track by $index\">\n" +
    "      <td ng-repeat=\"dt in row track by dt.date\" class=\"text-center\">\n" +
    "        <button type=\"button\" style=\"width:100%;\" class=\"btn btn-default\" ng-class=\"{'btn-info': dt.selected}\" ng-click=\"select(dt.date)\" ng-disabled=\"dt.disabled\"><span ng-class=\"{'text-info': dt.current}\">{{dt.label}}</span></button>\n" +
    "      </td>\n" +
    "    </tr>\n" +
    "  </tbody>\n" +
    "</table>\n" +
    "");
}]);
