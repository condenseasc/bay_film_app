angular.module('ui-templates', ['template/datepicker/datepicker.html', 'template/datepicker/day.html', 'template/datepicker/dayOriginal.html', 'template/datepicker/month.html', 'template/datepicker/popup.html', 'template/datepicker/year.html', 'template/main/index.html', 'template/oo-events-day-titles.html', 'template/ooWeeklyEventTitles.html']);

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
    "    <tr ng-repeat=\"row in rows track by $index\" class=\"week-number {{ weekNumbers[$index] }}\">\n" +
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

angular.module("template/main/index.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/main/index.html",
    "  <div id=\"wrapper\" oo-check-week-on-scroll>\n" +
    "\n" +
    "    \n" +
    "    <div id=\"sidebar-wrapper\">\n" +
    "\n" +
    "        <div class=\"calendar-nav\" >\n" +
    "          <datepicker oo-refresh-datepicker \n" +
    "          refresh-on=\"{{selected.month}}\" \n" +
    "          date-disabled=\"isDateDisabled(date, mode)\" \n" +
    "          ng-model=\"selected.day\">  \n" +
    "          </datepicker>\n" +
    "\n" +
    "        </div>\n" +
    "\n" +
    "\n" +
    "\n" +
    "\n" +
    "          <div class=\"titles-nav\" >\n" +
    "            <div>Currently on {{selected.day | date:'MMMM d'}} and {{selected.week}}</div>\n" +
    "            <div>on week {{selected.week}}</div>\n" +
    "\n" +
    "            <oo-weekly-event-titles></oo-weekly-event-titles>\n" +
    "\n" +
    "\n" +
    "<!--             <div ng-repeat=\"week in weeks\">\n" +
    "              <ul class=\"sidebar-title-in-list\" ng-repeat=\"day in week.days\">\n" +
    "              {{day.date | date:'MMMM d'}}\n" +
    "                <li ng-repeat=\"event in day.events\">\n" +
    "                  <a du-smooth-scroll ng-href=\"#{{day.date | date: 'd'}}\">\n" +
    "                    {{event.title}}\n" +
    "                  </a>\n" +
    "                </li>\n" +
    "              </ul>\n" +
    "            </div> -->\n" +
    "          </div>\n" +
    "    </div>\n" +
    "\n" +
    "\n" +
    "    <div id=\"page-content-wrapper\">\n" +
    "      <div class=\"content-header\">\n" +
    "<!--         <h1>Organizize</h1>\n" +
    " -->      </div>\n" +
    "\n" +
    "      <div class=\"page-content inset\">\n" +
    "\n" +
    "          <div class=\"event-feed\">\n" +
    "            <div ng-repeat='week in weeks'>\n" +
    "              <div class=\"week-container\" id=\"{{week.page}}\">\n" +
    "                <div class=\"day-container\" ng-repeat=\"day in week.days\">\n" +
    "                    <div id=\"{{day.date | date: 'd'}}\" class=\"event-feed-date\" >\n" +
    "                      // {{day.date | date:'EEEE, MMMM d'}} //\n" +
    "                    </div>\n" +
    "                  <div class=\"event-capsule\" ng-repeat=\"event in day.events\">\n" +
    "                    <div class=\"event-feed-title\">\n" +
    "                      {{event.title}} at {{event.venue.name}}, {{event.time|date:'h:mm a'}}\n" +
    "\n" +
    "                    </div>\n" +
    "                    <div class=\"event-feed-body\"\n" +
    "                      ng-bind-html=\"event.description\"></div>\n" +
    "                  </div>\n" +
    "                </div>\n" +
    "              </div>\n" +
    "            </div>\n" +
    "          </div>\n" +
    "\n" +
    "      </div>\n" +
    "    </div>\n" +
    "\n" +
    "\n" +
    "  </div>");
}]);

angular.module("template/oo-events-day-titles.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/oo-events-day-titles.html",
    "<input type=\"text\" ng-model=\"selected_day\">\n" +
    "<ul>\n" +
    "  <li ng-repeat=\"event in events | ooDay:day\">\n" +
    "    <span>{{event.title}}</span>\n" +
    "  </li>\n" +
    "</ul>");
}]);

angular.module("template/ooWeeklyEventTitles.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/ooWeeklyEventTitles.html",
    "\n" +
    "<div class=\"weekly-event-titles\">\n" +
    "  <ul ng-repeat=\"day in currentWeek.days\">\n" +
    "    <span class=\"sidebar-date-label\">{{ day.date | date:'EEEE, MMMM dd' }}</span>\n" +
    "    <li ng-repeat=\"event in day.events\">\n" +
    "      <span>{{event.title}} </span>\n" +
    "      <span>{{event.venue.name}} </span>\n" +
    "    </li>\n" +
    "  </ul>\n" +
    "</div>");
}]);
